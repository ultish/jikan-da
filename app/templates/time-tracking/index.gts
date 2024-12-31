import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import PhArrowBendRightUp from 'ember-phosphor-icons/components/ph-arrow-bend-right-up';

@RouteTemplate
export default class TimeTrackingIndexTemplate extends Component {
  <template>
    <main class="mx-auto max-w-full px-4 py-4 sm:px-6 lg:px-8 text-center">

      <i class="text-xs">
        Pick a date above...
        <PhArrowBendRightUp class="inline" />
      </i>
    </main>
  </template>
}
