import Component from '@glimmer/component';
import type { TrackedDay } from 'jikan-da/graphql/types/graphql';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class QuickActionsNew extends Component<Signature> {
  <template>
    <form>
      <div
        class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      >
        <div>
          <h3 class="text-base font-semibold">
            Quick Action
          </h3>
          <p class="text-sm mt-1 text-base-content/50">
            some description about quick QuickAction
          </p>
        </div>
        <div class="col-span-2 grid grid-cols-6 gap-4">
          <label class="form-control col-span-4">
            <div class="label">
              <span class="label-text">Name</span>
            </div>
            <input
              type="text"
              placeholder="Type here"
              class="input input-bordered input-sm"
            />
          </label>
          <label class="form-control col-span-6">
            <div class="label">
              <span class="label-text">Description</span>
            </div>
            <textarea
              class="textarea textarea-bordered h-24"
              placeholder="Bio"
            ></textarea>
          </label>
        </div>

      </div>

      <div
        class="border-b-[1px] pb-8 mb-8 border-neutral/10 grid grid-cols-3 gap-4"
      >
        <div>
          <h3 class="text-base font-semibold">
            Details
          </h3>
          <p class="text-sm mt-1 text-base-content/50">
            The meat of the action
          </p>
        </div>

        <div class="col-span-2 grid grid-cols-6 gap-4">
          <label class="form-control col-span-4">
            <div class="label">
              <span class="label-text">Charge Codes</span>
            </div>
            <input
              type="text"
              placeholder="Type here"
              class="input input-bordered input-sm"
            />
          </label>
          <label class="form-control col-span-full">
            <div class="label">
              <span class="label-text">Time Slots</span>
            </div>
            <input
              type="text"
              placeholder="Type here"
              class="input input-bordered input-sm"
            />
          </label>
        </div>
      </div>

      <div class="mt-6 flex items-center justify-end gap-2">
        <button type="button" class="btn btn-sm btn-ghost">Cancel</button>
        <button type="submit" class="btn btn-sm btn-primary">Save</button>
      </div>

    </form>
  </template>
}
