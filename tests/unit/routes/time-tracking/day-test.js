import { module, test } from 'qunit';
import { setupTest } from 'jikan-da/tests/helpers';

module('Unit | Route | time-tracking/day', function (hooks) {
  setupTest(hooks);

  test('it exists', function (assert) {
    let route = this.owner.lookup('route:time-tracking/day');
    assert.ok(route);
  });
});
