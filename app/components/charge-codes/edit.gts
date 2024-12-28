import Component from '@glimmer/component';
import type {
  ChargeCode,
  ChargeCodesQuery,
  CreateChargeCodeMutation,
  MutationCreateChargeCodeArgs,
  MutationUpdateChargeCodeArgs,
  QueryChargeCodesArgs,
  QuickAction,
  UpdateChargeCodeMutation,
} from 'jikan-da/graphql/types/graphql';

import { useMutation, useQuery } from 'glimmer-apollo';

import TooManyChoices from 'jikan-da/components/choices';
import {
  CREATE_CHARGE_CODE,
  GET_CHARGE_CODES,
  UPDATE_CHARGE_CODE,
} from 'jikan-da/graphql/chargecodes';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { localCopy } from 'tracked-toolbox';

interface Signature {
  Args: {
    chargeCode?: ChargeCode;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}

export default class ChargeCodeEdit extends Component<Signature> {
  @localCopy('args.chargeCode.name') declare name: string;
  @localCopy('args.chargeCode.description') declare desc: string;
  @localCopy('args.chargeCode.expired') declare expired: boolean;
  @localCopy('args.chargeCode.group') declare group: string;
  @localCopy('args.chargeCode.sortOrder') declare sortOrder: number;

  chargeCodesQuery = useQuery<ChargeCodesQuery, QueryChargeCodesArgs>(
    this,
    () => [GET_CHARGE_CODES]
  );

  get chargeCodes() {
    return this.chargeCodesQuery.data?.chargeCodes ?? [];
  }

  @action
  onInputName(event: any) {
    if (event.target) {
      this.name = event.target.value;
    }
  }
  @action
  onInputDesc(event: any) {
    if (event.target) {
      this.desc = event.target.value;
    }
  }
  @action
  onInputGrp(event: any) {
    if (event.target) {
      this.group = event.target.value;
    }
  }
  @action
  onInputSO(event: any) {
    if (event.target) {
      this.sortOrder = Number.parseInt(event.target.value);
    }
  }
  @action
  onInputExpired(event: any) {
    if (event.target) {
      this.expired = event.target.checked;
    }
  }

  eq(a: any, b: any) {
    return a == b;
  }

  updateChargeCodeMutation = useMutation<
    UpdateChargeCodeMutation,
    MutationUpdateChargeCodeArgs
  >(this, () => [
    UPDATE_CHARGE_CODE,
    {
      update: (cache, result) => {},
    },
  ]);

  createChargeCodeMutation = useMutation<
    CreateChargeCodeMutation,
    MutationCreateChargeCodeArgs
  >(this, () => [
    CREATE_CHARGE_CODE,
    {
      update: (cache, result) => {
        if (result?.data?.createChargeCode) {
          const previous = cache.readQuery<
            ChargeCodesQuery,
            QueryChargeCodesArgs
          >({
            query: GET_CHARGE_CODES,
          });

          const existingItems = previous?.chargeCodes ?? [];
          const found = existingItems.find(
            (qa) => qa.id === result?.data?.createChargeCode?.id
          );
          if (!found) {
            cache.writeQuery<ChargeCodesQuery>({
              query: GET_CHARGE_CODES,
              data: {
                chargeCodes: [...existingItems, result.data.createChargeCode],
              },
            });
          }
        }
      },
    },
  ]);

  get isNew() {
    return !!this.args.chargeCode;
  }

  @action
  async save() {
    if (this.args.chargeCode) {
      await this.updateChargeCodeMutation.mutate({
        id: this.args.chargeCode.id,
        name: this.name,
        code: this.name,
        description: this.desc,
        expired: this.expired,
        group: this.group,
        sortOrder: this.sortOrder,
      });
    } else {
      await this.createChargeCodeMutation.mutate({
        name: this.name,
        code: this.name,
        description: this.desc,
        expired: this.expired,
        group: this.group,
        sortOrder: this.sortOrder,
      });

      this.name = '';
      this.desc = '';
      this.expired = false;
      this.sortOrder = Infinity;
      this.group = '';
    }
  }
  <template>
    {{!prettier-ignore}}
    <style>
    </style>

    <form>
      <div
        class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      >
        <div class="prose">
          <h3 class="">
            Charge Codes
          </h3>
          <p class="text-sm mt-1 text-base-content/50">
            Details of the Charge Code
          </p>
        </div>
        <div class="col-span-2 grid grid-cols-6 gap-4">
          <label class="form-control col-span-4">
            <div class="label">
              <span class="label-text">Name*</span>
            </div>
            <input
              type="text"
              placeholder="eg AU Dev"
              value={{this.name}}
              class="input input-bordered input-sm"
              {{on "input" this.onInputName}}
            />
          </label>
          <label class="form-control col-span-6">
            <div class="label">
              <span class="label-text">Description</span>
            </div>
            <textarea
              value={{this.desc}}
              class="textarea textarea-bordered h-24"
              placeholder="Optionally describe the Charge Code"
              {{on "input" this.onInputDesc}}
            ></textarea>
          </label>
        </div>
      </div>
      <div
        class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      >
        <div class="prose">
          <h3 class="">
            Metadata
          </h3>
          <p class="text-sm mt-1 text-base-content/50">
            Optional metadata
          </p>
        </div>
        <div class="col-span-2 grid grid-cols-6 gap-4">
          <div class="form-control col-span-4">
            <label class="label cursor-pointer">
              <span class="label-text">Expired</span>
              <input
                type="checkbox"
                checked={{if this.expired "checked"}}
                class="checkbox"
                {{on "input" this.onInputExpired}}
              />
            </label>
          </div>

          <label class="form-control col-span-4">
            <div class="label">
              <span class="label-text">Group</span>
            </div>
            <input
              type="text"
              value={{this.group}}
              placeholder="eg AU Dev"
              class="input input-bordered input-sm"
              {{on "input" this.onInputGrp}}
            />
          </label>

          <label class="form-control col-span-4">
            <div class="label">
              <span class="label-text">Sort Order</span>
            </div>
            <input
              type="number"
              value={{this.sortOrder}}
              class="input input-bordered input-sm"
              {{on "input" this.onInputSO}}
            />
          </label>

        </div>
      </div>

      <div class="mt-6 flex items-center justify-end gap-2">

        <button
          type="button"
          class="btn btn-sm btn-primary"
          {{on "click" this.save}}
        >
          Save
        </button>
      </div>
    </form>
  </template>
}
