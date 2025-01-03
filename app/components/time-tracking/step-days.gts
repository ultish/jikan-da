import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { useQuery, useMutation } from 'glimmer-apollo';
import {
  GET_TRACKED_DAYS_BY_MONTH_YEAR,
  CREATE_TRACKED_DAY,
  SUBSCRIBE_TRACKED_DAY_CHANGES,
} from 'jikan-da/graphql/tracked-days';
import type {
  CreateTrackedDayMutation,
  MutationCreateTrackedDayArgs,
  QueryTrackedDaysForMonthYearArgs,
  TrackedDay,
  TrackedDayChangedSubscription,
  TrackedDayChangedSubscriptionVariables,
  TrackedDaysForMonthYearQuery,
  TrackedDaysForMonthYearQueryVariables,
} from 'jikan-da/graphql/types/graphql';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';

import dayjs, { Dayjs } from 'dayjs';

import { tracked } from '@glimmer/tracking';
import type { ApolloCache } from '@apollo/client/cache';
import type { FetchResult } from '@apollo/client/core';

class Day {
  @tracked date;
  isToday;
  pastDate;
  firstDay;
  lastDay;
  trackedDay;

  constructor(
    date: Dayjs,
    isToday: boolean,
    pastDate: boolean,
    firstDay: boolean,
    lastDay: boolean,
    trackedDay: TrackedDay | undefined
  ) {
    this.date = date;
    this.isToday = isToday;
    this.pastDate = pastDate;
    this.firstDay = firstDay;
    this.lastDay = lastDay;
    this.trackedDay = trackedDay;
  }

  get id() {
    return this.date.toISOString();
  }

  get day() {
    return this.date.format('D');
  }

  get dayOfWeek() {
    return this.date.format('ddd');
  }
}

interface Signature {
  Args: {
    month: number;
    year: number;
  };
  Element: HTMLUListElement;
}

export default class StepDays extends Component<Signature> {
  @service declare router: RouterService;

  // this query re-fires when this.args.month changes
  trackedDaysQuery = useQuery<
    TrackedDaysForMonthYearQuery,
    QueryTrackedDaysForMonthYearArgs
  >(this, () => [
    GET_TRACKED_DAYS_BY_MONTH_YEAR,
    {
      variables: {
        month: this.args.month,
        year: this.args.year,
      },
    },
  ]);

  dayRouteActive = modifier((element, [id], named) => {
    if (id && this.router.isActive('time-tracking.day', id)) {
      element.classList.add('step-accent');
    } else {
      element.classList.remove('step-accent');
    }
  });

  centerToday = modifier((element: HTMLElement) => {
    const today = element.querySelector('.step-info');
    if (today) {
      const todayEle = today as HTMLElement;
      // Get the position of the element (relative to the container)
      const elementPosition = todayEle.offsetLeft; // Position from the left of the container
      const elementWidth = todayEle.offsetWidth; // Width of the 'today' element
      const containerWidth = element.offsetWidth; // Width of the scrollable container

      // Get the container's position relative to the viewport (or the page)
      const containerRect = element.getBoundingClientRect();
      const containerOffsetLeft = containerRect.left; // Distance from the viewport's left edge

      // Calculate the scroll position to center the element within the container
      const scrollPosition = Math.max(
        0,
        elementPosition -
          containerOffsetLeft -
          containerWidth / 2 +
          elementWidth / 2
      );

      // Scroll the container to center the current day
      element.scrollTo({
        left: scrollPosition,
        behavior: 'smooth',
      });
    }
  });

  #unsubscribe: (() => void) | undefined;

  /**
   * this modifier will call subscribeToMore against the graphql query
   * using our subscription that notifies us when a new tracked day is
   * created.
   *
   * This will notify the app if you opened the app in 2 tabs for and
   * add to the cache in both tabs.
   *
   * Whereas the mutation function below modifies the cache, it only
   * works if the current tab is making that modification.
   */
  subscribeToTrackedDays = modifier((element) => {
    this.#unsubscribe = this.trackedDaysQuery.subscribeToMore<
      TrackedDayChangedSubscription,
      TrackedDayChangedSubscriptionVariables
    >({
      document: SUBSCRIBE_TRACKED_DAY_CHANGES,
      variables: {
        month: this.args.month,
        year: this.args.year,
      },
      updateQuery: (prevQueryResult, { subscriptionData, variables }) => {
        if (!subscriptionData.data.trackedDayChanged) {
          return prevQueryResult;
        }

        const newDay = subscriptionData.data.trackedDayChanged;
        const prevResults = prevQueryResult.trackedDaysForMonthYear || [];

        const found = prevResults.find((d) => d.id === newDay.id);

        if (found) {
          // dont need to do anything
          return prevQueryResult;
        } else {
          return {
            trackedDaysForMonthYear: [newDay, ...prevResults],
          };
        }
      },
      onError: (error: Error) => {
        console.error('💥 goes the subscription', error);
      },
      context: this,
    });

    return () => {
      this.#unsubscribe?.();
    };
  });

  get getDaysInCurrentMonth() {
    const days = dayjs(
      `${this.args.year}-${this.args.month}-01`,
      'YYYY-MM-DD'
    ).daysInMonth();
    return days;
  }

  get trackedDays() {
    if (this.trackedDaysQuery.loading) {
      return [];
    } else {
      return this.trackedDaysQuery.data?.trackedDaysForMonthYear ?? [];
    }
  }

  get trackedDaysMap() {
    const trackedDaysMap = new Map<string, TrackedDay>();
    this.trackedDays.forEach((day) => {
      const utcDate = dayjs.utc(day.date).local().format('YYYY-MM-DD');

      trackedDaysMap.set(utcDate, day);
    });

    return trackedDaysMap;
  }

  get today() {
    const today = dayjs().format('YYYY-MM-DD');

    // get the day of the month, eg 1-31
    return today;
  }

  get todaysMonthAsText() {
    const month = dayjs(
      `${this.args.year}-${this.args.month}-01`,
      'YYYY-MM-DD'
    ).format('MMM');
    return month;
  }

  get steps() {
    const steps = [];
    for (let i = 1; i <= this.getDaysInCurrentMonth; i++) {
      const dayInMonth = dayjs(
        `${this.args.year}-${this.args.month}-${i}`,
        'YYYY-MM-DD'
      );
      const dayInMonthStr = dayInMonth.format('YYYY-MM-DD');

      steps.push(
        new Day(
          dayInMonth,
          dayInMonthStr === this.today,
          dayInMonth.isBefore(dayjs()),
          i === 1, // first day of month
          i === this.getDaysInCurrentMonth, //last day of month
          this.trackedDaysMap.get(dayInMonthStr)
        )
      );
    }
    return steps;
  }

  @action
  async openDay(day: Day) {
    if (day.trackedDay) {
      // transition to route
      this.router.transitionTo('time-tracking.day', day.trackedDay.id);
    } else {
      // create day
      await this.createDayAndTransition(day);
    }
  }

  createTrackedDay = useMutation<
    CreateTrackedDayMutation,
    MutationCreateTrackedDayArgs
  >(this, () => [
    CREATE_TRACKED_DAY,
    {
      update: (cache, result) => {
        this.updateCache(cache, result);
      },
    },
  ]);

  /**
   * If it was updating an existing object in the cache then as long as an ID was returned
   * then it would update the cache for you. However, if it is creating or deleting
   * something then you need to update the apollo cache.
   *
   * This code is looking at the query GET_TRACKED_DAYS_BY_MONTH_YEAR and getting the
   * cached objects. Then appending the newly created object to it.
   */
  updateCache(
    cache: ApolloCache<any>,
    result: Omit<FetchResult<CreateTrackedDayMutation>, 'context'>
  ) {
    const vars = {
      month: this.args.month,
      year: this.args.year,
    };
    const data = cache.readQuery<
      TrackedDaysForMonthYearQuery,
      TrackedDaysForMonthYearQueryVariables
    >({
      query: GET_TRACKED_DAYS_BY_MONTH_YEAR,
      variables: vars,
    });

    if (data && result?.data?.createTrackedDay) {
      const existingDays = data.trackedDaysForMonthYear;
      const newDay = result.data.createTrackedDay;
      if (existingDays) {
        cache.writeQuery<TrackedDaysForMonthYearQuery>({
          query: GET_TRACKED_DAYS_BY_MONTH_YEAR,
          variables: vars,
          data: { trackedDaysForMonthYear: [newDay, ...existingDays] },
        });
      }
    }
  }

  @action
  async createDayAndTransition(day: Day) {
    const newDate = await this.createTrackedDay.mutate({
      date: day.date.valueOf(),
    });

    if (newDate?.createTrackedDay?.id) {
      this.router.transitionTo(
        'time-tracking.day',
        newDate.createTrackedDay.id
      );
    }
  }

  // normal functions have no context, so passing it in
  stepClass(context: StepDays, step: Day) {
    let result = '';
    if (
      step.trackedDay?.id &&
      context.router.isActive('time-tracking.day', step.trackedDay.id)
    ) {
      result = 'step-accent';
    } else if (step.isToday) {
      result = 'step-info';
    } else if (step.trackedDay) {
      result = 'step-success';
    } else if (step.pastDate) {
      result = 'step-neutral';
    }
    return result;
  }

  <template>
    <ul
      class="steps"
      ...attributes
      {{this.centerToday}}
      {{this.subscribeToTrackedDays}}
    >
      {{#each this.steps key="id" as |step|}}
        <li
          class="step {{this.stepClass this step}}"
          data-day={{step.date.day}}
          role="button"
          {{on "click" (fn this.openDay step)}}
          {{on "dblclick" (fn this.createDayAndTransition step)}}
        >
          {{#if step.firstDay}}
            {{this.todaysMonthAsText}}
          {{else if step.lastDay}}
            {{this.todaysMonthAsText}}
          {{else}}
            {{step.day}}
            <span class="text-[8px]">{{step.dayOfWeek}}</span>
          {{/if}}
        </li>
      {{/each}}
    </ul>
  </template>
}
