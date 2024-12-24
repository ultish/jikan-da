import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { useQuery, useMutation } from 'glimmer-apollo';
import { GET_TRACKED_DAYS_BY_MONTH_YEAR } from 'jikan-da/graphql/queries/tracked-days';
import type {
  CreateTrackedDayMutation,
  MutationCreateTrackedDayArgs,
  QueryTrackedDaysForMonthYearArgs,
  SubscriptionTrackedDayChangedArgs,
  TrackedDay,
  TrackedDayChangedSubscription,
  TrackedDaysForMonthYearQuery,
  TrackedDaysForMonthYearQueryVariables,
} from 'jikan-da/graphql/types/graphql';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';
// import Velcro from 'ember-velcro/components/velcro/index';
// import { FloatingUI } from 'ember-primitives/floating-ui';
// import Tooltip from 'jikan-da/components/tooltip';

import dayjs, { Dayjs } from 'dayjs';
import { tracked } from '@glimmer/tracking';
import { CREATE_TRACKED_DAY } from 'jikan-da/graphql/mutations/tracked-days';
import { SUBSCRIBE_TRACKED_DAY_CHANGES } from 'jikan-da/graphql/subscriptions/tracked-days';
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

  get day() {
    return this.date.format('D');
  }
}

interface Signature {
  Args: {
    month: number;
    year: number;
  };
  Element: HTMLDivElement;
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

  centerToday = modifier((element) => {
    const today = element.querySelector('.step-info');
    if (today) {
      const todayEle = today as HTMLElement;
      // Get the position of the element
      const elementPosition = todayEle.offsetLeft;
      const elementWidth = todayEle.offsetWidth;
      const containerWidth = todayEle.offsetWidth;

      // Calculate the scroll position to center the element
      const scrollPosition =
        elementPosition - containerWidth / 2 + elementWidth / 2;

      // Scroll the container to center the current day
      element.scrollTo({
        left: scrollPosition,
        behavior: 'smooth',
      });
    }
  });

  #unsubscribe: (() => void) | undefined;

  subscribeToTrackedDays = modifier((element) => {
    console.log('SUBBBING');
    this.#unsubscribe = this.trackedDaysQuery.subscribeToMore<
      TrackedDayChangedSubscription,
      SubscriptionTrackedDayChangedArgs
    >({
      document: SUBSCRIBE_TRACKED_DAY_CHANGES,
      variables: {
        userId: '6768f8e49ce0e819a8f73dfb',
      },
    });

    return () => {
      // unsubscribe
      console.log('unsiub');
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

  #trackedDaysMap = new Map<String, TrackedDay>();

  get trackedDaysMap() {
    this.trackedDays.forEach((day) => {
      const date = dayjs(day.date).format('YYYY-MM-DD');
      // const date = new Date(day.date);
      // const key = `${date.}
      this.#trackedDaysMap.set(date, day);
    });

    return this.#trackedDaysMap;
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
  openDay(day: Day) {
    if (day.trackedDay) {
      // transition to route
      this.router.transitionTo('time-tracking.day', day.trackedDay.id);
    } else {
      // create day
      console.log('no tracked day', day);
    }
  }

  createTrackedDay = useMutation<
    CreateTrackedDayMutation,
    MutationCreateTrackedDayArgs
  >(this, () => [
    CREATE_TRACKED_DAY,
    {
      update: (cache, result) => {
        debugger;
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
      const newDay = result.data?.createTrackedDay;
      if (existingDays) {
        cache.writeQuery({
          query: GET_TRACKED_DAYS_BY_MONTH_YEAR,
          variables: vars,
          data: { trackedDaysForMonthYear: [newDay, ...existingDays] },
        });
      }
    }
  }

  //TODO this creates a new date, but it doesnt update the original query for steps so you never see the date change colour
  @action
  async createDayAndTransition(day: Day) {
    console.log('create');

    const newDate = await this.createTrackedDay.mutate({
      date: day.date.valueOf(),
    });

    console.log(newDate);

    if (newDate?.createTrackedDay?.id) {
      this.router.transitionTo(
        'time-tracking.day',
        newDate.createTrackedDay.id
      );
    }
  }

  <template>
    <div ...attributes {{this.centerToday}} {{this.subscribeToTrackedDays}}>
      <div>
        <ul class="steps">
          {{#each this.steps as |step|}}
            <li
              class="step
                {{if step.pastDate 'step-neutral'}}
                {{if step.isToday 'step-info'}}
                {{if step.trackedDay 'step-primary'}}"
              data-day={{step.date.day}}
              role="button"
              {{on "click" (fn this.openDay step)}}
              {{on "dblclick" (fn this.createDayAndTransition step)}}
              {{this.dayRouteActive step.trackedDay.id}}
            >

              {{#if step.firstDay}}
                {{this.todaysMonthAsText}}
              {{else if step.lastDay}}
                {{this.todaysMonthAsText}}
              {{else}}

                {{step.day}}
              {{/if}}

            </li>
          {{/each}}
        </ul>
      </div>

    </div>
  </template>
}
