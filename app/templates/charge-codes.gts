import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import Hello from 'jikan-da/components/hello';

@RouteTemplate
export default class ApplicationTemplate extends Component {
  <template>
    {{pageTitle "Charge Codes"}}

    {{outlet}}

    <h1 class="text-3xl font-bold underline">
      Charge Codes
    </h1>

    <Hello />
  </template>
}
