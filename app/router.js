import EmberRouter from '@ember/routing/router';
import config from 'jikan-da/config/environment';
import { properLinks } from 'ember-primitives/proper-links';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('time-tracking', function () {
    this.route('day', { path: '/day/:id' });
  });
  this.route('charge-codes');
  this.route('login');
});
