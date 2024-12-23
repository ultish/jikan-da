import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';

@RouteTemplate
export default class TimeTrackingDayRoute extends Component {
  <template>
    {{pageTitle "Time Tracking Day"}}

    {{outlet}}
  </template>
}
