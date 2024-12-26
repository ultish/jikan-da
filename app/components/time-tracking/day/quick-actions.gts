import Component from '@glimmer/component';
import type { TrackedDay } from 'jikan-da/graphql/types/graphql';

import PhFastForward from 'ember-phosphor-icons/components/ph-fast-forward';
import dayjs from 'dayjs';

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
