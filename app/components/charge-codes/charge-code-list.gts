import Component from '@glimmer/component';
import type {
  ChargeCode,
  ChargeCodesQuery,
  QueryChargeCodesArgs,
} from 'jikan-da/graphql/types/graphql';

import { useQuery } from 'glimmer-apollo';

import TooManyChoices from 'jikan-da/components/choices';
import { GET_CHARGE_CODES } from 'jikan-da/graphql/chargecodes';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import ChargeCodeEdit from './edit';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}

export default class ChargeCodeList extends Component<Signature> {
  chargeCodesQuery = useQuery<ChargeCodesQuery, QueryChargeCodesArgs>(
    this,
    () => [GET_CHARGE_CODES]
  );

  get chargeCodes() {
    return this.chargeCodesQuery.data?.chargeCodes ?? [];
  }

  @tracked name = '';
  @tracked desc = '';
  @tracked expired = false;
  @tracked group = '';
  @tracked sortOrder = Infinity;

  @action
  onInput(event: any, target: any) {
    if (event.target) {
      target = event.target.value;
    }
  }

  eq(a: any, b: any) {
    return a == b;
  }

  <template>
    {{!prettier-ignore}}
    <style>
    </style>

    <div role="tablist" class="tabs tabs-bordered">
      {{#each this.chargeCodes key="id" as |cc index|}}
        <input
          type="radio"
          name="my_tabs_1"
          role="tab"
          class="tab"
          aria-label={{cc.name}}
          checked={{if (this.eq index 0) "true"}}
        />
        <div
          role="tabpanel"
          class="tab-content p-10 bg-base-100 border-base-30 w-full"
        >
          <ChargeCodeEdit @chargeCode={{cc}} />
        </div>
      {{/each}}

      <input
        type="radio"
        name="my_tabs_1"
        role="tab"
        class="tab"
        aria-label="New"
      />
      <div
        role="tabpanel"
        class="tab-content p-10 bg-base-100 border-base-30 w-full"
      >
        <ChargeCodeEdit />
      </div>
    </div>
  </template>
}
