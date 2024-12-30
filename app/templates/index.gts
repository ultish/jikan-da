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
  @service declare auth: AuthService;
  @service declare router: RouterService;

  @action
  login() {
    this.auth.login();
  }

  <template>
    {{pageTitle "Login"}}

    <div
      class="hero min-h-screen"
      style="background-image: url({{if
        this.auth.isAuthenticated
        'bg3.jpg'
        'bg2.jpg'
      }});"
    >
      <div class="hero-overlay bg-opacity-60"></div>
      <div class="hero-content text-neutral-content text-center">
        <div class="max-w-md">

          {{#if this.auth.isAuthenticated}}
            <h1 class="mb-5 text-5xl font-bold">Hello
              {{this.auth.username}}
              👋</h1>
          {{else}}
            <h1 class="mb-5 text-5xl font-bold">Hello 👋</h1>
            <button
              type="button"
              class="btn btn-primary"
              {{on "click" this.login}}
            >
              Login
            </button>
          {{/if}}
        </div>
      </div>
    </div>
    {{outlet}}
  </template>
}
