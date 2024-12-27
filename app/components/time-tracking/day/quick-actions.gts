import Component from '@glimmer/component';

import PhFastForward from 'ember-phosphor-icons/components/ph-fast-forward';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class QuickActions extends Component<Signature> {
  <template>
    <main class="prose" ...attributes>
      <h4><PhFastForward class="inline" /> Quick Actions</h4>

    </main>
  </template>
}
