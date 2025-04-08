'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const { compatBuild } = require('@embroider/compat');

module.exports = async function (defaults) {
  const { buildOnce } = await import('@embroider/vite');
  let app = new EmberApp(defaults, {});

  // app.import('node_modules/choices.js/public/assets/styles/base.min.css');
  app.import('node_modules/choices.js/public/assets/styles/choices.min.css');

  app.import(
    'node_modules/tabulator-tables/dist/css/tabulator_materialize.min.css',
  );

  app.import('node_modules/gridjs/dist/theme/mermaid.css');
  return compatBuild(app, buildOnce);
};
