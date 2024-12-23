import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';

export default class StepDays extends Component {
  centerToday = modifier((element) => {
    const today = element.querySelector('.step-accent');
    if (today) {
      // Get the position of the element
      const elementPosition = today.offsetLeft;
      const elementWidth = today.offsetWidth;
      const containerWidth = today.offsetWidth;

      // Calculate the scroll position to center the element
      const scrollPosition =
        elementPosition - containerWidth / 2 + elementWidth / 2;

      // Scroll the container to center the current day
      element.scrollTo({
        left: scrollPosition,
        behavior: 'smooth',
      });

      // today.scrollIntoView({ behavior: 'smooth', block: 'center' });
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

  get todaysDay() {
    // get the day of the month, eg 1-31
    return new Date().getDate();
  }

  get todaysMonthAsText() {
    return new Date().toLocaleString('default', { month: 'long' });
  }

  get steps() {
    const steps = [];
    for (let i = 1; i <= this.getDaysInCurrentMonth; i++) {
      steps.push({
        date: i,
        isToday: i === this.todaysDay,
        pastDate: i < this.todaysDay,
        firstDay: i === 1,
        lastDay: i === this.getDaysInCurrentMonth,
      });
    }
    return steps;
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
                {{if step.isToday 'step-accent'}}"
              data-day={{step.date}}
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
