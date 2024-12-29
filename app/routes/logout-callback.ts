// app/routes/logout-callback.js
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import type RouterService from '@ember/routing/router-service';

export default class LogoutCallbackRoute extends Route {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  async beforeModel() {
    await this.auth.handleLogoutCallback();
    this.router.transitionTo('application');
  }
}
