// app/routes/callback.js
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import type RouterService from '@ember/routing/router-service';

export default class CallbackRoute extends Route {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  async beforeModel() {
    await this.auth.handleCallback();

    this.router.transitionTo('application');
  }
}