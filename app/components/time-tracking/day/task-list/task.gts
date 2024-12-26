import Component from '@glimmer/component';
import type {
  ChargeCode,
  ChargeCodesQuery,
  MutationUpdateTrackedTaskArgs,
  QueryChargeCodesArgs,
  QueryTrackedTasksArgs,
  TrackedDay,
  TrackedTask,
  TrackedTasksQuery,
  UpdateTrackedTaskMutation,
} from 'jikan-da/graphql/types/graphql';

import PhKanban from 'ember-phosphor-icons/components/ph-kanban';
import PhLightning from 'ember-phosphor-icons/components/ph-lightning';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

import { useMutation, useQuery } from 'glimmer-apollo';
import {
  GET_TRACKED_TASKS,
  UPDATE_TRACKED_TASK,
} from 'jikan-da/graphql/tracked-tasks/gql';

import { scaleTime } from 'd3-scale';
import { modifier } from 'ember-modifier';
import { inject as service } from '@ember/service';
import type Prefs from 'jikan-da/services/prefs';
import { fn } from '@ember/helper';

import { cached, localCopy } from 'tracked-toolbox';
import TooManyChoices from 'jikan-da/components/choices';
import { GET_CHARGE_CODES } from 'jikan-da/graphql/chargecodes';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';
import type { TrackedTasksPartial } from './layout';

const TRACKED_TASKS_WIDTH = 300;
const TIMEBLOCK_WIDTH = 60;

interface Signature {
  Args: {
    trackedTask: TrackedTask;
    ticks: Date[];
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

  constructor(timeBlock: number, checked: boolean) {
    this.timeBlock = timeBlock;
    this.checked = checked;
  }
}

export default class Task extends Component<Signature> {
  @tracked lastBlockClicked = -1;

  @localCopy('args.trackedTask.notes') declare notes: string;

  @cached
  get squares() {
    if (!this.args.ticks) {
      return [];
    }

    // 00:00 = 0, 00:06 = 1, 00:12 = 2, 00:18 = 3, 00:24 = 4, 00:30 = 5
    // 00:36 = 6, 00:42 = 7, 00:48 = 8, 00:54 = 9
    // 01:00 = 10
    const squares = [];
    const trackedTask = this.args.trackedTask;

    // the ticks are hourly
    for (let i = 0; i < this.args.ticks.length; i++) {
      const tick = this.args.ticks[i];
      const tickTime = dayjs(tick);
      const tickHour = tickTime.hour();
      const tickMinute = tickTime.minute();

      // we want 10 blocks per hour
      for (let j = 0; j < 10; j++) {
        const timeBlock = tickHour * 10 + j;
        const checked = trackedTask.timeSlots?.includes(timeBlock) || false;

        squares.push(new TimeBlock(timeBlock, checked));
      }

      // const timeBlock = tickHour * 10 + Math.floor(tickMinute / 6);
      // const checked = trackedTask.timeSlots?.includes(timeBlock) || false;

      // squares.push(new TimeBlock(timeBlock, checked));
    }

    return squares;
  }

  @action
  clicked(timeBlock: TimeBlock) {
    if (this.lastBlockClicked === -1) {
      timeBlock.checked = !timeBlock.checked;
      this.lastBlockClicked = timeBlock.timeBlock;
    } else {
      const start = Math.min(this.lastBlockClicked, timeBlock.timeBlock);
      const end = Math.max(this.lastBlockClicked, timeBlock.timeBlock);

      for (let i = start; i <= end; i++) {
        const block = this.squares.find((s) => s.timeBlock === i);
        if (block) {
          block.checked = !block.checked;
        }
      }

      this.lastBlockClicked = -1;
    }

    this.updateTimeBlocks();
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

  @action
  async addCC(detail: any) {
    const chargeCodeIds =
      this.args.trackedTask?.chargeCodes?.map((cc) => cc.id) ?? [];

    const id = detail.value;
    if (!chargeCodeIds.includes(id)) {
      chargeCodeIds.push(id);
    }

    await this.updateTrackedTaskMutation.mutate({
      id: this.args.trackedTask.id,
      chargeCodeIds: chargeCodeIds,
    });
  }

  @action
  async removeCC(detail: any) {
    const chargeCodeIds =
      this.args.trackedTask?.chargeCodes?.map((cc) => cc.id) ?? [];

    const id = detail.value;
    const newChargeCodeIds = chargeCodeIds.filter((ccId) => ccId !== id);

    await this.updateTrackedTaskMutation.mutate({
      id: this.args.trackedTask.id,
      chargeCodeIds: newChargeCodeIds,
    });
  }

  <template>
    {{!prettier-ignore}}
    <style>

      .tracked-task {
        width: 300px;
      }
      .square {
        width: 10px;
        min-width: 10px;
        height: 40px;
        cursor: pointer;
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
      <div class="tracked-task-details flex flex-col gap-2 px-2 pb-5">
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
              value={{cc.chargeCode.id}}
            >{{cc.chargeCode.name}}</option>
          </TooManyChoices>
        </label>

        <label class="input input-bordered flex items-center gap-2 input-sm">
          <PhPencil @weight="duotone" class="h-4 w-4 opacity-70 inline-block" />
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
      <div class="tracked-time flex">
        {{#each this.squares as |block|}}
          <div
            class="square text-[4px] border-r-[1px] hover:bg-accent border-base-300
              {{if block.checked 'bg-primary' 'odd:bg-base-200 bg-base-100 '}}"
            role="button"
            {{on "click" (fn this.clicked block)}}
          >
            {{block.timeBlock}}

          </div>
        {{/each}}
      </div>
    </div>
  </template>
}
