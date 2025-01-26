'use strict';

module.exports = function (environment) {
  const ENV = {
    modulePrefix: 'jikan-da',
    environment,
    rootURL: '/',
    locationType: 'history',

    serverURL: 'http://localhost/graphql',
    // serverURL: 'http://localhost:3002/graphql',
    websocketURL: 'ws://localhost/subscriptions',
    sseURL: 'http://localhost/graphql',
    keycloakURL: 'https://192.168.1.41:18443/realms/jxhui',

    EmberENV: {
      EXTEND_PROTOTYPES: false,
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. EMBER_NATIVE_DECORATOR_SUPPORT: true
      },
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    },
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    ENV.APP.autoboot = false;
  }

  if (environment === 'rancher') {
    // here you can enable a production-specific feature
    serverURL: 'https://192.168.1.41:8443/graphql';
    websocketURL: 'wss://192.168.1.41:8443/subscriptions';
    keycloakURL: 'https://192.168.1.41:18443/realms/jxhui';
  }

  return ENV;
};
