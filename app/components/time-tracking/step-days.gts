import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { useQuery } from 'glimmer-apollo';
import { GET_TRACKED_DAYS_BY_MONTH } from 'jikan-da/graphql/queries/tracked-days';
import type {
  QueryTrackedDaysForMonthArgs,
  TrackedDay,
  TrackedDaysForMonthQuery,
} from 'jikan-da/graphql/types/graphql';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

import { inject as service } from '@ember/service';
import type RouterService from '@ember/routing/router-service';

class Day {
  date;
  isToday;
  pastDate;
  firstDay;
  lastDay;
  trackedDay;

  constructor(
    date: number,
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
}

interface Signature {
  Element: HTMLDivElement;
}

export default class StepDays extends Component<Signature> {
  @service declare router: RouterService;

  trackedDaysQuery = useQuery<
    TrackedDaysForMonthQuery,
    QueryTrackedDaysForMonthArgs
  >(this, () => [
    GET_TRACKED_DAYS_BY_MONTH,
    {
      variables: {
        month: new Date().getMonth() + 1,
      },
    },
  ]);

  centerToday = modifier((element) => {
    const today = element.querySelector('.step-accent');
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

  get getDaysInCurrentMonth() {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth(); // 0 = January, 11 = December

    // Create a date for the first day of the next month
    const nextMonth = new Date(year, month + 1, 1);

    // Subtract one day to get the last day of the current month
    const lastDayOfCurrentMonth = new Date(nextMonth - 1);

    // Return the day of the month (which is the number of days in the month)
    return lastDayOfCurrentMonth.getDate();
  }

  get trackedDays() {
    if (this.trackedDaysQuery.loading) {
      return [];
    } else {
      return this.trackedDaysQuery.data?.trackedDaysForMonth ?? [];
    }
  }

  #trackedDaysMap = new Map<Number, TrackedDay>();

  get trackedDaysMap() {
    this.trackedDays.forEach((day) => {
      const date = new Date(day.date).getDate();
      this.#trackedDaysMap.set(date, day);
    });

    return this.#trackedDaysMap;
  }

  get todaysDay() {
    // get the day of the month, eg 1-31
    return new Date().getDate();
  }

  get todaysMonthAsText() {
    return new Date().toLocaleString('default', { month: 'long' });
  }

  get steps() {
    console.log('steps', this.trackedDaysMap);

    const steps = [];
    for (let i = 1; i <= this.getDaysInCurrentMonth; i++) {
      steps.push(
        new Day(
          i,
          i === this.todaysDay,
          i < this.todaysDay,
          i === 1,
          i === this.getDaysInCurrentMonth,
          this.trackedDaysMap.get(i)
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

  <template>
    <div class="flex flex-row" ...attributes>
      {{! prettier-ignore}}
      <style>
        .setpper {
          scroll-snap-type: x mandatory;
        }
      </style>
      <div class="overflow-x-auto stepper" {{this.centerToday}}>
        <ul class="steps">
          {{#each this.steps as |step|}}
            <li
              class="step
                {{if step.pastDate 'step-neutral'}}
                {{if step.isToday 'step-accent'}}
                {{if step.trackedDay 'step-primary'}}"
              data-day={{step.date}}
              role="button"
              {{on "click" (fn this.openDay step)}}
            >
              {{#if step.firstDay}}
                {{this.todaysMonthAsText}}
              {{else if step.lastDay}}
                {{this.todaysMonthAsText}}
              {{else}}
                {{step.date}}
              {{/if}}
            </li>
          {{/each}}
        </ul>
      </div>
    </div>
  </template>
}
