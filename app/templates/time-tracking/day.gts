import { pageTitle } from 'ember-page-title';
import {
  RouteTemplate,
  type RouteTemplateSignature,
} from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import type TimeTrackingDayRoute from 'jikan-da/routes/time-tracking/day';

import dayjs from 'dayjs';

type Signature = RouteTemplateSignature<TimeTrackingDayRoute>;

@RouteTemplate
export default class TimeTrackingDayTemplate extends Component<Signature> {
  get id() {
    return this.args.model.data?.trackedDay?.id;
  }
  get date() {
    return dayjs(this.args.model.data?.trackedDay?.date).format('YYYY-MM-DD');
    // return this.args.model.data?.trackedDay?.date;
  }
  <template>
    {{pageTitle "Time Tracking Day"}}

    A DAY

    {{this.id}}
    {{this.date}}
    {{outlet}}
  </template>
}
