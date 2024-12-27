import Component from '@glimmer/component';

import PhFastForward from 'ember-phosphor-icons/components/ph-fast-forward';
import PhFilePlus from 'ember-phosphor-icons/components/ph-file-plus';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLElement;
}
export default class QuickActions extends Component<Signature> {
  <template>
    <main class="prose" ...attributes>
      <h4 class="flex items-center gap-2">
        <span class="grow">
          <PhFastForward class="inline" />
          Quick Actions
        </span>
        <label for="my-drawer-4" class="drawer-button btn btn-ghost btn-sm">
          <PhFilePlus class="inline" />
          Add...
        </label>
      </h4>

      {{yield}}
    </main>
  </template>
}
