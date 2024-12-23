import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import TimeTrackingLayout from 'jikan-da/components/time-tracking/layout';

@RouteTemplate
export default class TimeTrackingRoute extends Component {
  <template>
    {{pageTitle "Time Tracking"}}

    <TimeTrackingLayout />

    {{outlet}}
  </template>
}
