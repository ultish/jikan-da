import { pageTitle } from 'ember-page-title';
// import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import RoutableComponentRoute from 'ember-routable-component';

import Component from '@glimmer/component';
import TimeTrackingLayout from 'jikan-da/components/time-tracking/layout';

@RoutableComponentRoute
export default class TimeTrackingRoute extends Component {
  <template>
    {{pageTitle "Time Tracking"}}

    <TimeTrackingLayout />

    {{outlet}}
  </template>
}
