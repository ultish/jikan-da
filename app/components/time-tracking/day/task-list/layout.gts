import Component from '@glimmer/component';
import {
  type MutationCreateTrackedTaskArgs,
  type CreateTrackedTaskMutation,
  type QueryTrackedTasksArgs,
  type TrackedDay,
  type TrackedTasksQuery,
  type TrackedTasksQueryVariables,
} from 'jikan-da/graphql/types/graphql';

import PhKanban from 'ember-phosphor-icons/components/ph-kanban';
import PhListPlus from 'ember-phosphor-icons/components/ph-list-plus';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

import { useMutation, useQuery } from 'glimmer-apollo';
import {
  CREATE_TRACKED_TASK,
  GET_TRACKED_TASKS,
} from 'jikan-da/graphql/tracked-tasks/gql';

import { scaleTime } from 'd3-scale';
import { modifier } from 'ember-modifier';

import onResize from 'ember-on-resize-modifier/modifiers/on-resize';

import { inject as service } from '@ember/service';
import type Prefs from 'jikan-da/services/prefs';
import Task from './task';

const TRACKED_TASKS_WIDTH = 300;
const TIMEBLOCK_WIDTH = 100;

interface Signature {
  Args: {
    trackedDay: TrackedDay;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class TaskListLayout extends Component<Signature> {
  @service declare prefs: Prefs;
  @tracked containerWidth = 0;

  @action
  onResize({ contentRect: { width } }) {
    this.containerWidth = width ?? 0;
  }

  trackedTasksQuery = useQuery<TrackedTasksQuery, QueryTrackedTasksArgs>(
    this,
    () => [
      GET_TRACKED_TASKS,
      {
        variables: {
          trackedDayId: this.args.trackedDay.id,
        },
      },
    ]
  );

  get tasks() {
    if (this.trackedTasksQuery.loading) {
      return [];
    } else {
      console.log('fetch tasks', this.trackedTasksQuery.data?.trackedTasks);

      return (this.trackedTasksQuery.data?.trackedTasks ?? []).filter((x) => x);
    }
  }

  get numBlocks() {
    // only showing 18hrs max
    const maxWidth = 18 * TIMEBLOCK_WIDTH;
    const availableWidth = Math.min(
      this.containerWidth - TRACKED_TASKS_WIDTH,
      maxWidth
    );

    return Math.floor(availableWidth / TIMEBLOCK_WIDTH);
  }

  get startTime() {
    return dayjs().startOf('day').add(this.prefs.startTimeNum, 'hour');
  }

  get endTime() {
    return this.startTime.add(this.numBlocks, 'hour');
  }

  get scale() {
    return scaleTime()
      .domain([this.startTime.toDate(), this.endTime.toDate()])
      .range([0, this.numBlocks * TIMEBLOCK_WIDTH]);
  }

  get ticks() {
    return this.scale.ticks(this.numBlocks);
  }

  get formattedTicks() {
    return this.ticks.map((t: Date) => dayjs(t).format('HH:mm'));
  }

  createTaskMutation = useMutation<
    CreateTrackedTaskMutation,
    MutationCreateTrackedTaskArgs
  >(this, () => [
    CREATE_TRACKED_TASK,
    {
      update: (cache, result) => {
        const vars = {
          trackedDayId: this.args.trackedDay.id,
        };
        const data = cache.readQuery<
          TrackedTasksQuery,
          TrackedTasksQueryVariables
        >({
          query: GET_TRACKED_TASKS,
          variables: vars,
        });

        if (data && result?.data?.createTrackedTask) {
          const existingTasks = data.trackedTasks ?? [];
          const newTask = result.data.createTrackedTask;

          cache.writeQuery({
            query: GET_TRACKED_TASKS,
            variables: vars,
            data: { trackedTasks: [newTask, ...existingTasks] },
          });
        }
      },
    },
  ]);
  @action
  async createTask() {
    const newTask = await this.createTaskMutation.mutate({
      trackedDayId: this.args.trackedDay.id,
    });
    console.log(newTask);
  }

  @action
  deleteTask() {}

  <template>
    {{!prettier-ignore}}
    <style>
      #tick-container {
        position: absolute;
        top: 0;
        bottom: 0;
        right: 0;
        left: 300px;
        display: flex;
        flex-direction: row;

        .tick-hour {
          width: 100px;
          min-width: 100px;
          height: $containerHeight;
          display: inline-block;
          user-select: none;
          text-align: center;

        }
        .tick-hour:nth-child(odd) {
          background-color: oklch(var(--b2)/0.3)
        }
      }
      #time-container {
        position: absolute;
        left: 0;
        width: 300px;
      }
    </style>
    <div {{onResize this.onResize}}>
      <h2 class="text-lg font-semibold mb-4 flex items-center w-[300px] px-2">
        <PhKanban
          class="inline-block -rotate-90"
          @weight="duotone"
          @color="darkorchid"
        />
        <span class="grow">Tracked Tasks</span>
        <button
          type="button"
          class="btn btn-primary btn-sm"
          {{on "click" this.createTask}}
        >
          <PhListPlus class="inline-block" />
          Add Task
        </button>
      </h2>
      <div id="tick-container" class="">
        {{#each this.formattedTicks as |tick|}}
          <div class="tick-hour text-base">
            {{tick}}
          </div>
        {{/each}}
      </div>
      <div id="time-container">
        {{#each this.tasks as |task|}}
          <Task @trackedTask={{task}} @ticks={{this.ticks}} />

        {{/each}}
      </div>
      {{!-- {{#each this.items as |num|}}
        <div class="mb-4 p-4 bg-gray-50 rounded shadow">
          Top Section Content
          {{num}}
        </div>
      {{/each}} --}}
    </div>
  </template>
}
