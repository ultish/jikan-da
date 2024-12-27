import Component from '@glimmer/component';
import type {
  ChargeCodesQuery,
  QueryChargeCodesArgs,
} from 'jikan-da/graphql/types/graphql';

import { useQuery } from 'glimmer-apollo';

import TooManyChoices from 'jikan-da/components/choices';
import { GET_CHARGE_CODES } from 'jikan-da/graphql/chargecodes';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';

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

  <template>
    {{!prettier-ignore}}
    <style>
    </style>

    {{#each this.chargeCodes key="id" as |cc|}}
      {{cc.name}}
    {{/each}}
  </template>
}
