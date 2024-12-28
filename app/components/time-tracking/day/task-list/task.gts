import Component from '@glimmer/component';
import type {
  ChargeCode,
  ChargeCodesQuery,
  DeleteTrackedTaskMutation,
  MutationDeleteTrackedTaskArgs,
  MutationUpdateTrackedTaskArgs,
  QueryChargeCodesArgs,
  TrackedTask,
  TrackedTasksQuery,
  TrackedTasksQueryVariables,
  UpdateTrackedTaskMutation,
} from 'jikan-da/graphql/types/graphql';
import PhLightning from 'ember-phosphor-icons/components/ph-lightning';
import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

import { useMutation, useQuery, type MutationResource } from 'glimmer-apollo';
import { UPDATE_TRACKED_TASK } from 'jikan-da/graphql/tracked-tasks';
import { fn } from '@ember/helper';
import { localCopy, trackedReset } from 'tracked-toolbox';
import TooManyChoices from 'jikan-da/components/choices';
import { GET_CHARGE_CODES } from 'jikan-da/graphql/chargecodes';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';
import PhTrash from 'ember-phosphor-icons/components/ph-trash';

import { clickOutside } from 'ember-click-outside-modifier';

import { task } from 'ember-concurrency';
import type { TrackedTasksPartial } from './layout';

interface Signature {
  Args: {
    trackedTask: TrackedTasksPartial;
    ticks: Date[];
    deleteTrackedTaskMutation: MutationResource<
      DeleteTrackedTaskMutation,
      MutationDeleteTrackedTaskArgs
    >;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}

class TimeBlock {
  @tracked selected = false;
  @tracked checked = false;
  @tracked timeBlock = -1;
  @tracked hover = false;

  #blockMin;

  mouseOver = false;
  mouseDown = false;

  constructor(timeBlock: number, checked: boolean, blockMin: number) {
    this.timeBlock = timeBlock;
    this.checked = checked;
    this.#blockMin = blockMin;
  }
  get blockMin() {
    return this.#blockMin * 6;
  }
}

export default class Task extends Component<Signature> {
  @tracked lastBlockClicked = -1;

  @localCopy('args.trackedTask.notes') declare notes: string;

  @tracked mouseModeChecked = true;
  @tracked startMouseGlide = false;

  @trackedReset('args.trackedTask.id')
  timeBlocksMap = new Map<number, TimeBlock>(); // this type matches what was fetched

  get squares() {
    if (!this.args.ticks) {
      return [];
    }

    // 00:00 = 0, 00:06 = 1, 00:12 = 2, 00:18 = 3, 00:24 = 4, 00:30 = 5
    // 00:36 = 6, 00:42 = 7, 00:48 = 8, 00:54 = 9
    // 01:00 = 10, 01:06 = 11

    // validate time block range
    const firstTick = this.args.ticks[0];
    const firstTime = dayjs(firstTick);
    const firstBlock = firstTime.hour() * 10;

    const lastTick = this.args.ticks[this.args.ticks.length - 1];
    const lastTime = dayjs(lastTick);
    const lastBlock = lastTime.hour() * 10 + 9;

    for (let i = 0; i < firstBlock; i++) {
      this.timeBlocksMap.delete(i);
    }
    let i = lastBlock + 1;
    while (this.timeBlocksMap.has(i)) {
      this.timeBlocksMap.delete(i);
      i++;
    }

    // the ticks are hourly
    for (let i = 0; i < this.args.ticks.length; i++) {
      const tick = this.args.ticks[i];
      const tickTime = dayjs(tick);
      const tickHour = tickTime.hour();

      // we want 10 blocks per hour
      for (let j = 0; j < 10; j++) {
        const timeBlock = tickHour * 10 + j;

        let tb = this.timeBlocksMap.get(timeBlock);

        const checked =
          this.args.trackedTask.timeSlots?.includes(timeBlock) || false;
        if (!tb) {
          tb = new TimeBlock(timeBlock, checked, j);
          this.timeBlocksMap.set(timeBlock, tb);
        } else {
          if (tb.checked !== checked) {
            // console.log('FOUND DIFF', tb.timeBlock, tb.checked, checked);
          }
        }
      }
    }

    return Array.from(this.timeBlocksMap.values()).sort(
      (a, b) => a.timeBlock - b.timeBlock
    );
  }

  updateTrackedTaskMutation = useMutation<
    UpdateTrackedTaskMutation,
    MutationUpdateTrackedTaskArgs
  >(this, () => [
    UPDATE_TRACKED_TASK,
    {
      update: (cache, result) => {
        console.log('update', cache, result);
      },
    },
  ]);

  async updateTimeBlocks() {
    const timeSlots = this.squares
      .filter((s) => s.checked)
      .map((s) => s.timeBlock);

    await this.updateTrackedTaskMutation.mutate({
      id: this.args.trackedTask.id,
      timeSlots: timeSlots,
    });
  }

  @action
  handleInput(event: any) {
    if (event.target) {
      this.notes = event.target.value;
    }
  }

  @action
  async updateNotes() {
    const up = await this.updateTrackedTaskMutation.mutate({
      id: this.args.trackedTask.id,
      notes: this.notes,
    });
  }

  chargeCodesQuery = useQuery<ChargeCodesQuery, QueryChargeCodesArgs>(
    this,
    () => [GET_CHARGE_CODES]
  );

  get chargeCodes() {
    const selected = this.selectedChargeCodes;

    return (this.chargeCodesQuery.data?.chargeCodes ?? []).map((cc) => {
      return {
        chargeCode: cc,
        selected: selected.has(cc.id),
      };
    });
  }

  get selectedChargeCodes() {
    const map = new Map<string, ChargeCode>();
    this.args.trackedTask?.chargeCodes?.forEach((cc) => {
      map.set(cc.id, cc);
    });
    return map;
  }

  get chargeCodeIds() {
    return this.args.trackedTask?.chargeCodes?.map((cc) => cc.id) ?? [];
  }

  /**
   * using a task here to make sure multiple quick adds/removes don't
   * override each other
   */
  updateChargeCodes = task({ enqueue: true }, async (chargeCodeIds) => {
    await this.updateTrackedTaskMutation.mutate({
      id: this.args.trackedTask.id,
      chargeCodeIds: chargeCodeIds,
    });
  });

  @action
  async addCC(detail: any) {
    const chargeCodeIds = [
      ...(this.args.trackedTask?.chargeCodes?.map((cc) => cc.id) ?? []),
    ];

    const id = detail.value;
    if (!chargeCodeIds.includes(id)) {
      chargeCodeIds.push(id);
    }

    await this.updateChargeCodes.perform(chargeCodeIds);
  }

  @action
  async removeCC(detail: any) {
    const chargeCodeIds = [
      ...(this.args.trackedTask?.chargeCodes?.map((cc) => cc.id) ?? []),
    ];

    const id = detail.value;
    const newChargeCodeIds = chargeCodeIds.filter((ccId) => ccId !== id);

    await this.updateChargeCodes.perform(newChargeCodeIds);
  }

  @action
  mouseDown(block: TimeBlock, e: MouseEvent) {
    if (e.buttons === 1) {
      this.startMouseGlide = true;
      block.checked = this.mouseModeChecked;
    }
  }
  @action
  async mouseUp(block: TimeBlock, e: MouseEvent) {
    // no mouse clicks and was gliding

    if (e.shiftKey && this.lastBlockClicked !== -1) {
      // if shift-clicking then select a range
      const start = Math.min(this.lastBlockClicked, block.timeBlock);
      const end = Math.max(this.lastBlockClicked, block.timeBlock);

      for (let i = start; i <= end; i++) {
        const block = this.squares.find((s) => s.timeBlock === i);
        if (block) {
          // block.checked = !block.checked;
          block.selected = true;
        }
      }

      // this.lastBlockClicked = -1;
    } else if (e.buttons === 0) {
      this.lastBlockClicked = block.timeBlock;

      if (this.startMouseGlide) {
        this.mouseModeChecked = true;
        this.startMouseGlide = false;
      }
      await this.updateTimeBlocks();
    }
  }

  @action
  mouseEnter(block: TimeBlock, e: MouseEvent) {
    if (!this.startMouseGlide) {
      this.mouseModeChecked = !block.checked;
    } else if (e.buttons === 1) {
      block.checked = this.mouseModeChecked;
    }
  }

  @action
  async keyUp(e: KeyboardEvent) {
    e.preventDefault;
    if (e.code === 'Enter') {
      const selected = this.squares.filter((s) => s.selected);
      // are any selected not checked?
      const hasNonChecked = selected.find((b) => !b.checked);

      // if there's non-checked we will check everything in selection
      // otherwise we'll un-check everything

      selected.forEach((s) => (s.checked = hasNonChecked ? true : false));

      await this.updateTimeBlocks();
    }
  }

  @action
  onClickOutside() {
    this.squares.forEach((block) => {
      block.selected = false;
    });
    this.lastBlockClicked = -1;
  }

  blockClass(block: TimeBlock) {
    const result = [];
    if (block.selected) {
      result.push('selected');
    }
    if (block.checked) {
      result.push('checked');
    }

    return result.join(' ');
  }

  @action
  async deleteTrackedTask() {
    await this.args.deleteTrackedTaskMutation.mutate({
      id: this.args.trackedTask.id,
    });
  }

  <template>
    {{!prettier-ignore}}
    <style>
      @keyframes shimmer {
        0% {
          background-color: rgba(64, 156, 255, 0.2);
          box-shadow: 0 0 5px rgba(64, 156, 255, 0.2);
        }
        50% {
          background-color: rgba(64, 156, 255, 0.4);
          box-shadow: 0 0 15px rgba(64, 156, 255, 0.4);
        }
        100% {
          background-color: rgba(64, 156, 255, 0.2);
          box-shadow: 0 0 5px rgba(64, 156, 255, 0.2);
        }
      }
      @keyframes glow {
        from {
          box-shadow: 0 0 10px -10px #aef4af;
        }
        to {
          box-shadow: 0 0 10px 10px #aef4af;
        }
      }
      .tracked-task {
        width: 300px;
      }
      .square {
        width: 10px;
        min-width: 10px;
        height: 90px;
        cursor: pointer;
        background-color: oklch(var(--b2) / 0.5 );
        color: oklch(var(--bc))
      }
      .square:nth-child(odd) {
        background-color: oklch(var(--b3) / 0.5);
      }
      .square.selected {
        transform: scaleY(1.1);
        opacity: 1;
        outline: 1px solid oklch(var(--a))
      }
      .square.checked {
        background-color: oklch(var(--p));
        color: oklch(var(--pc))
      }
      .square:hover {
        background-color: oklch(var(--a));
        color: oklch(var(--ac))
      }

      .tracked-time {
        position: absolute;
        top: 37px;
        left: 300px;
      }
      .tracked-task-details {
        width: 300px;
        {{!-- height: 150px; --}}
      }
    </style>
    <div class="tracked-task relative border-b-[1px]">
      <div class="tracked-task-details flex gap-2 px-2 pb-5">
        <div class="grow flex flex-col gap-2">
          <label class="form-control w-full max-w-xs">
            <div class="label">
              <span class="label-text">
                <PhLightning class="inline fill-amber-400" @weight="duotone" />
                Charge Codes
              </span>
            </div>
            <TooManyChoices
              @choices={{this.chargeCodes}}
              @onAdd={{this.addCC}}
              @onRemove={{this.removeCC}}
              @outerClass="input input-bordered input-sm w-full max-w-xs"
              as |cc|
            >
              <option
                selected={{if cc.selected "selected"}}
                disabled={{if cc.chargeCode.expired "true"}}
                value={{cc.chargeCode.id}}
              >{{cc.chargeCode.name}}</option>
            </TooManyChoices>
          </label>
          <label class="input input-bordered flex items-center gap-2 input-sm">
            <PhPencil
              @weight="duotone"
              class="h-4 w-4 opacity-70 inline-block"
            />
            <input
              type="text"
              placeholder="Notes"
              class="grow"
              aria-label="notes"
              value={{this.notes}}
              {{on "focusout" this.updateNotes}}
              {{on "input" this.handleInput}}
            />

          </label>
        </div>
        <button
          type="button"
          class="btn btn-circle btn-sm mt-9 btn-outline btn-error text-error-content"
          {{on "dblclick" this.deleteTrackedTask}}
        >
          <PhTrash />
        </button>
      </div>
      <div class="tracked-time flex" {{clickOutside this.onClickOutside}}>
        {{#each this.squares key="timeBlock" as |block|}}
          {{! template-lint-disable no-pointer-down-event-binding }}
          <div
            class="square text-center text-[5px] border-r-[1px] select-none border-base-300
              {{this.blockClass block}}"
            role="button"
            tabindex="0"
            {{on "keyup" this.keyUp}}
            {{on "mousedown" (fn this.mouseDown block)}}
            {{on "mouseup" (fn this.mouseUp block)}}
            {{on "mouseenter" (fn this.mouseEnter block)}}
          >
            {{block.blockMin}}

          </div>
        {{/each}}
      </div>
    </div>
  </template>
}
