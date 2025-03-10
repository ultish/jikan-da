import Route from '@ember/routing/route';
import type RouterService from '@ember/routing/router-service';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import config from 'jikan-da/config/environment';

export default class ChargeCodesRoute extends Route {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  async beforeModel() {
    if (!this.auth.isAuthenticated && !config.ignoreSecurity) {
      console.log('not authenticated');
      this.router.transitionTo('application');
    }
  }
}
