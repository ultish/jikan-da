import EmberRouter from '@ember/routing/router';
import config from 'jikan-da/config/environment';
import { properLinks } from 'ember-primitives/proper-links';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('time-tracking', { path: ':time' }, function () {
    this.route('day', { path: '/day/:id' });
  });
  this.route('charge-codes');
  this.route('login');
  this.route('authenticated');
  this.route('callback');
  this.route('logout-callback');
  this.route('table');
});
