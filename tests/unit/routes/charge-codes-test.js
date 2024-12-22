import { module, test } from 'qunit';
import { setupTest } from 'jikan-da/tests/helpers';

module('Unit | Route | charge-codes', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    let route = this.owner.lookup('route:charge-codes');
    assert.ok(route);
  });
});
