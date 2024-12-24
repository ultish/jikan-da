import { pageTitle } from 'ember-page-title';
// import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import RoutableComponentRoute from 'ember-routable-component';

import Component from '@glimmer/component';
import Hello from 'jikan-da/components/hello';

@RoutableComponentRoute
export default class ApplicationTemplate extends Component {
  <template>
    {{pageTitle "Login"}}

    {{outlet}}

    <h1 class="text-3xl font-bold underline">
      Login
    </h1>

    <Hello />
  </template>
}
