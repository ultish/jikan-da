import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import Hello from 'jikan-da/components/hello';
import ChargeCodesLayout from 'jikan-da/components/charge-codes/layout';

@RouteTemplate
export default class ApplicationTemplate extends Component {
  <template>
    {{pageTitle "Charge Codes"}}

    <ChargeCodesLayout>
      {{outlet}}
    </ChargeCodesLayout>
  </template>
}
