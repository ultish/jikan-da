import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';
import setupApolloClient from 'jikan-da/apollo';

export default class ApplicationRoute extends Route {
  @service declare auth: AuthService;

  async model() {
    const u = await this.auth.getUser();
    if (u) {
      setupApolloClient(this, this.auth.accessToken);
    }
  }
}
