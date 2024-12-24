import { pageTitle } from 'ember-page-title';
// import { RouteTemplate } from 'jikan-da/utils/ember-route-template';

import RoutableComponentRoute from 'ember-routable-component';
import Component from '@glimmer/component';

@RoutableComponentRoute
export default class TimeTrackingDayRoute extends Component {
  <template>
    {{pageTitle "Time Tracking Day"}}

    A DAY
    {{outlet}}
  </template>
}
