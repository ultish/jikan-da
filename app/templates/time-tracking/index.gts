import { pageTitle } from 'ember-page-title';
import {
  RouteTemplate,
  type RouteTemplateSignature,
} from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import type TimeTrackingDayRoute from 'jikan-da/routes/time-tracking/day';

import dayjs from 'dayjs';
import DayLayout from 'jikan-da/components/time-tracking/day/layout';

@RouteTemplate
export default class TimeTrackingIndexTemplate extends Component {
  <template>
    <main class="mx-auto max-w-full px-4 py-6 sm:px-6 lg:px-8">

      Pick a date above
    </main>
  </template>
}
