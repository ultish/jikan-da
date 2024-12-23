import Component from '@glimmer/component';
import StepDays from 'jikan-da/components/time-tracking/step-days';

export default class TimeTrackingLayout extends Component {
  get message() {
    return 'Layout';
  }

  <template>
    <h1>{{this.message}}</h1>

    <StepDays />
  </template>
}
