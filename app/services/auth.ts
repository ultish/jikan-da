import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { UserManager, WebStorageStateStore } from 'oidc-client-ts';
import { action } from '@ember/object';

import config from 'jikan-da/config/environment';

export default class AuthService extends Service {
  @tracked
  declare currentUser: any | undefined;

  userManager;

  @tracked
  declare roles: string[] | undefined;
  @tracked
  declare name: string | undefined;

  constructor() {
    super(...arguments);

    this.userManager = new UserManager({
      authority: config.keycloakURL,
      client_id: 'jikan-da',
      redirect_uri: `${window.location.origin}/callback`,
      response_type: 'code',
      scope: 'openid roles',
      post_logout_redirect_uri: `${window.location.origin}/logout-callback`,
      userStore: new WebStorageStateStore({ store: window.localStorage }),
      loadUserInfo: true, // Ensure user info is loaded
    });

    this.userManager.events.addUserLoaded((user) => {
      this.currentUser = user;

      this.roles = this.getRoles(user);
      this.name = this.getSid(user);
    });

    this.userManager.events.addUserUnloaded(() => {
      this.currentUser = undefined;
      this.roles = undefined;
      this.name = undefined;
    });
  }

  async getUser() {
    const user = await this.userManager.getUser();
    if (user) {
      this.currentUser = user;
      this.roles = this.getRoles(user);
      this.name = this.getSid(user);
    }
    return user;
  }

  getSid(user: any) {
    const idToken = user?.id_token;

    if (idToken) {
      const idTokenPayload = JSON.parse(atob(idToken.split('.')[1]));
      return idTokenPayload.name;
    }
  }

  getRoles(user: any) {
    // Assuming roles are included in the ID token or access token
    const idToken = user?.id_token;
    const accessToken = user?.access_token;

    if (accessToken) {
      const accessTokenPayload = JSON.parse(atob(accessToken.split('.')[1]));
      return accessTokenPayload.roles || [];
    }
    if (idToken) {
      const idTokenPayload = JSON.parse(atob(idToken.split('.')[1]));
      return idTokenPayload.roles || [];
    }

    return [];
  }

  @action
  async login() {
    // rediect to the auth endpoint (ie keycloak)
    await this.userManager.signinRedirect();

    // this works, gets user immediately
    // const user = await this.userManager.signinPopup();

    // this call will use the redicect setup in the userManager object
    // (eg /callback) so no point doing anything after signinRedirect
    // call is made
  }

  @action
  async logout() {
    await this.userManager.signoutRedirect();
  }

  /**
   * Handle the callback after a user logs in
   *
   * @returns the authenticated user
   */
  @action
  async handleCallback() {
    return await this.userManager.signinCallback();
  }

  @action
  async handleLogoutCallback() {
    await this.userManager.signoutCallback();
  }

  get accessToken() {
    return this.currentUser?.access_token;
  }

  get isAuthenticated() {
    return !!this.currentUser && !this.currentUser.expired;
  }
}
