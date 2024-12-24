import { on } from '@ember/modifier';
import { action } from '@ember/object';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import StepDays from 'jikan-da/components/time-tracking/step-days';

export default class TimeTrackingLayout extends Component {
  @tracked year = new Date().getFullYear();
  @tracked month = new Date().getMonth() + 1;

  @action
  prevMonth() {
    if (this.month === 1) {
      this.month = 12;
      this.year = this.year - 1;
    } else {
      this.month = this.month - 1;
    }
  }

  @action
  nextMonth() {
    if (this.month === 12) {
      this.month = 1;
      this.year = this.year + 1;
    } else {
      this.month = this.month + 1;
    }
  }

  <template>
    <h1>Time Tracking</h1>
    <div class="flex w-full">

      <button
        class="btn btn-primary btn-sm"
        {{on "click" this.prevMonth}}
        type="button"
      >
        Prev Month
      </button>
      <StepDays
        @month={{this.month}}
        @year={{this.year}}
        class="overflow-x-auto"
      />
      <button
        class="btn btn-primary btn-sm"
        {{on "click" this.nextMonth}}
        type="button"
      >
        Next Month
      </button>
    </div>
  </template>
}
