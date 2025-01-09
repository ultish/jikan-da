import Component from '@glimmer/component';
import type {
  ChargeCodesQuery,
  CreateQuickActionMutation,
  MutationCreateQuickActionArgs,
  QueryChargeCodesArgs,
  QueryQuickActionsArgs,
  QuickActionsQuery,
  TrackedDay,
} from 'jikan-da/graphql/types/graphql';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { useMutation, useQuery } from 'glimmer-apollo';
import { GET_CHARGE_CODES } from 'jikan-da/graphql/chargecodes';
import TooManyChoices from 'jikan-da/components/choices';
import {
  CREATE_QUICK_ACTION,
  GET_QUICK_ACTIONS,
} from 'jikan-da/graphql/quick-actions';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class QuickActionsNew extends Component<Signature> {
  @tracked chargeCodeIds: string[] = [];
  @tracked name = '';
  @tracked desc = '';
  @tracked start = '';
  @tracked end = '';

  chargeCodesQuery = useQuery<ChargeCodesQuery, QueryChargeCodesArgs>(
    this,
    () => [GET_CHARGE_CODES]
  );

  get chargeCodes() {
    return (this.chargeCodesQuery.data?.chargeCodes ?? []).map((cc) => {
      return {
        chargeCode: cc,
        selected: this.chargeCodeIds.includes(cc.id),
      };
    });
  }

  @action
  async addCC(detail: any) {
    const id = detail.value;
    if (!this.chargeCodeIds.includes(id)) {
      this.chargeCodeIds.push(id);
    }
    this.chargeCodeIds = [...this.chargeCodeIds];
  }

  @action
  async removeCC(detail: any) {
    this.chargeCodeIds = this.chargeCodeIds.filter((id) => id !== detail.value);
  }

  @action
  close() {
    const ele = document.getElementById('qa-drawer');
    if (ele) {
      (ele as HTMLInputElement).checked = false;
    }
  }

  createQuickActionMutation = useMutation<
    CreateQuickActionMutation,
    MutationCreateQuickActionArgs
  >(this, () => [
    CREATE_QUICK_ACTION,
    {
      update: (cache, result) => {
        if (result?.data?.createQuickAction) {
          const previous = cache.readQuery<
            QuickActionsQuery,
            QueryQuickActionsArgs
          >({
            query: GET_QUICK_ACTIONS,
          });

          const existingItems = previous?.quickActions ?? [];
          const found = existingItems.find(
            (qa) => qa.id === result?.data?.createQuickAction.id
          );
          if (!found) {
            cache.writeQuery<QuickActionsQuery>({
              query: GET_QUICK_ACTIONS,
              data: {
                quickActions: [...existingItems, result.data.createQuickAction],
              },
            });
          }
        }
      },
    },
  ]);

  @action
  async save() {
    if (this.name && this.chargeCodeIds.length) {
      await this.createQuickActionMutation.mutate({
        name: this.name,
        description: this.desc,
        chargeCodeIds: this.chargeCodeIds,
        timeSlots: this.timeSlots,
      });

      this.close();
    }
  }

  @action
  nameInput(event: any) {
    if (event.target) {
      this.name = event.target.value;
    }
  }

  @action
  descInput(event: any) {
    if (event.target) {
      this.desc = event.target.value;
    }
  }
  @action
  startInput(event: any) {
    if (event.target) {
      this.start = event.target.value;
    }
  }
  @action
  endInput(event: any) {
    if (event.target) {
      this.end = event.target.value;
    }
  }

  get timeSlots() {
    const [shr, smin] = this.start?.split(':');
    const [ehr, emin] = this.end?.split(':');
    const result = [];

    if (shr && smin && ehr && emin) {
      const startHr = Number.parseInt(shr) * 10;
      const startMin = Number.parseInt(smin) / 6;

      const endHr = Number.parseInt(ehr) * 10;
      const endMin = Number.parseInt(emin) / 6;

      const startBlock = startHr + startMin;
      const endBlock = endHr + endMin;

      for (let i = startBlock; i < endBlock; i++) {
        result.push(i);
      }
    }
    return result;
  }

  <template>
    <form>
      <div
        class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      >
        <div class="prose">
          <h3 class="">
            Quick Action
          </h3>
          <p class="text-sm mt-1 text-base-content/50">
            Name your Quick Action eg "Stand-Up 立って"
          </p>
        </div>
        <div class="col-span-2 grid grid-cols-6 gap-4">
          <label class="form-control col-span-4">
            <div class="label">
              <span class="label-text">Name*</span>
            </div>
            <input
              type="text"
              placeholder="Type here"
              class="input input-bordered input-sm"
              {{on "input" this.nameInput}}
            />
          </label>
          <label class="form-control col-span-6">
            <div class="label">
              <span class="label-text">Description</span>
            </div>
            <textarea
              class="textarea textarea-bordered h-24"
              placeholder="Optionally describe your Quick Action"
              {{on "input" this.descInput}}
            ></textarea>
          </label>
        </div>

      </div>

      <div
        class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      >
        <div class="prose">
          <h3 class="">
            Details
          </h3>
          <p class="text-sm mt-1 text-base-content/50">
            The Charge Codes selected here will be added to your Task when you
            activate a Quick Action. You can optionally set a Start Time and End
            Time to pre-allocate charging.
          </p>
          <p class="text-sm mt-1 text-base-content/50">
            The Start Time and End Time must be in intervals of 6 minutes. You
            can choose to.
          </p>
        </div>

        <div class="col-span-2 grid grid-cols-6 gap-4">
          <label class="form-control col-span-6">
            <div class="label">
              <span class="label-text">Charge Codes*</span>
            </div>
            <TooManyChoices
              @choices={{this.chargeCodes}}
              @onAdd={{this.addCC}}
              @onRemove={{this.removeCC}}
              as |cc|
            >
              <option
                selected={{if cc.selected "selected"}}
                value={{cc.chargeCode.id}}
              >{{cc.chargeCode.name}}</option>
            </TooManyChoices>
          </label>
          <label class="form-control col-span-3">
            <div class="label">
              <span class="label-text">Start Time</span>
            </div>
            <input
              type="text"
              placeholder="eg 13:00"
              class="input input-bordered input-sm"
              {{on "input" this.startInput}}
            />
          </label>
          <label class="form-control col-span-3">
            <div class="label">
              <span class="label-text">End Time</span>
            </div>
            <input
              type="text"
              placeholder="eg 13:36"
              class="input input-bordered input-sm"
              {{on "input" this.endInput}}
            />
          </label>
          <span class="text-[7px] col-span-full">
            {{#each this.timeSlots as |s|}}
              {{s}}
            {{/each}}
          </span>
        </div>
      </div>

      <div class="mt-6 flex items-center justify-end gap-2">
        <button
          type="button"
          class="btn btn-sm btn-ghost"
          {{on "click" this.close}}
        >
          Cancel
        </button>
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
