import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';
import setupApolloClient from 'jikan-da/apollo';

export default class ApplicationRoute extends Route {
  @service declare auth: AuthService;

  async model() {
    const u = await this.auth.getUser();
    if (u) {
      // this is here to ensure that the Apollo client is setup
      // with the access token on refresh of the application.
      // Since user's access token is stored in local storage
      // they don't need to login a 2nd time, so this catches
      // the case where callback route is not used
      setupApolloClient(this, this.auth.accessToken);
    }
  }
}
