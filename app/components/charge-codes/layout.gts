import Component from '@glimmer/component';
import ChargeCodeList from './charge-code-list';

import PhLightning from 'ember-phosphor-icons/components/ph-lightning';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class ChargeCodesLayout extends Component<Signature> {
  <template>
    <header class="bg-base-200 shadow">
      <div class="mx-auto max-w-full px-4 py-4 sm:px-6 lg:px-8 flex">
        <h2 class="text-xl font-semibold grow leading-[4rem]">
          <PhLightning class="inline fill-amber-400" @weight="duotone" />
          Charge Codes
        </h2>

      </div>
    </header>

    <main class="mx-auto max-w-full px-4 py-4 sm:px-6 lg:px-8">
      <div class="flex w-full gap-x-1">
        {{! list of chargecodes }}
        <ChargeCodeList />
      </div>
    </main>
  </template>
}
