'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const { maybeEmbroider } = require('@embroider/test-setup');

module.exports = function (defaults) {
  let app = new EmberApp(defaults, {});

  // app.import('node_modules/choices.js/public/assets/styles/base.min.css');
  app.import('node_modules/choices.js/public/assets/styles/choices.min.css');

  app.import(
    'node_modules/tabulator-tables/dist/css/tabulator_materialize.min.css'
  );

  app.import('node_modules/gridjs/dist/theme/mermaid.css');

  return maybeEmbroider(app);
};
