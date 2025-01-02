// app/routes/callback.js
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import type RouterService from '@ember/routing/router-service';

import setupApolloClient from 'jikan-da/apollo';

export default class CallbackRoute extends Route {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  async beforeModel() {
    const user = await this.auth.handleCallback();
    if (user) {
      setupApolloClient(this, user.access_token);
    }
    this.router.transitionTo('application');
  }
}
