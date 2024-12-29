import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import { useSubscription } from 'glimmer-apollo';
import type {
  TrackedDayChangedSubscription,
  TrackedDayChangedSubscriptionVariables,
} from 'jikan-da/graphql/types/graphql';
import { SUBSCRIBE_TRACKED_DAY_CHANGES } from 'jikan-da/graphql/tracked-days';

import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import type RouterService from '@ember/routing/router-service';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

@RouteTemplate
export default class ApplicationTemplate extends Component {
  // testSub2 = useSubscription<
  //   TrackedDayChangedSubscription,
  //   TrackedDayChangedSubscriptionVariables
  // >(this, () => [
  //   SUBSCRIBE_TRACKED_DAY_CHANGES,
  //   {
  //     variables: {
  //       month: 12,
  //       year: 2024,
  //     },
  //   },
  // ]);

  @service declare auth: AuthService;
  @service declare router: RouterService;

  @action
  login() {
    this.auth.login();
  }

  <template>
    {{pageTitle "Login"}}

    {{outlet}}

    <h1 class="text-3xl font-bold underline">
      Login
    </h1>
    <button
      type="button"
      class="btn btn-sm btn-primary"
      {{on "click" this.login}}
    >
      Login
    </button>
    {{!-- {{#if this.testSub2.loading}}
      Connecting..
    {{else if this.testSub2.error}}
      Error!:
      {{this.testSub2.error.message}}
    {{else}}
      <div>
        New Message:
        {{this.testSub2.data.trackedDayChanged}}
      </div>
    {{/if}} --}}
  </template>
}
