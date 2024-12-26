import Component from '@glimmer/component';
import {
  type MutationCreateTrackedTaskArgs,
  type CreateTrackedTaskMutation,
  type QueryTrackedTasksArgs,
  type TrackedDay,
  type TrackedTasksQuery,
  type TrackedTasksQueryVariables,
  type TrackedTask,
} from 'jikan-da/graphql/types/graphql';

import PhKanban from 'ember-phosphor-icons/components/ph-kanban';
import PhListPlus from 'ember-phosphor-icons/components/ph-list-plus';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { cached, trackedReset } from 'tracked-toolbox';
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

export type TrackedTasksPartial = NonNullable<
  TrackedTasksQuery['trackedTasks']
>[number];

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

  @tracked headerHeight = 0;

  setHeaderHeight = modifier((element) => {
    this.headerHeight = element.clientHeight;
  });

  //  return `height: calc(100% - ${this.bottomHeight}px)`;
  setMainHeight = modifier((element: HTMLElement) => {
    element.style.height = `calc(100% - ${this.headerHeight}px)`;
  });

  setTickHeight = modifier((element: HTMLElement) => {
    const mainEle = document.getElementById('container-main');
    if (mainEle) {
      element.style.height = `${mainEle.clientHeight}px`;
    }
  });

  @action
  onResize({ contentRect: { width } }) {
    this.containerWidth = (width ?? 0) - 300;
    console.log('containerWidth', this.containerWidth);
  }

  trackedTasksQuery = useQuery<TrackedTasksQuery, QueryTrackedTasksArgs>(
    this,
    () => [
      GET_TRACKED_TASKS,
      {
        variables: {
          trackedDayId: this.args.trackedDay.id,
        },
        onComplete: () => {
          debugger;
          console.log('tracked task query');
        },
      },
    ]
  );

  layoutTrack = 0;

  get track() {
    return this.layoutTrack;
  }

  increment(num: number) {
    this.layoutTrack = num + 1;
    console.log(this.layoutTrack);
  }

  // So important for not refreshing the display!
  @trackedReset('args.trackedDay')
  tasksMap = new Map<string, TrackedTasksPartial>(); // this type matches what was fetched

  /**
   * always be careful with getters, they are run each time. so if you return an
   * array and loop over it on the template then expect any components loaded in
   * that loop to re-init each time this getter fires. That's because a new
   * array is created each time this getter is called! So track it using the map
   * instead
   */
  get tasks() {
    if (this.trackedTasksQuery.loading) {
      return [];
    } else {
      console.log('fetch tasks', this.trackedTasksQuery.data?.trackedTasks);

      this.increment(this.layoutTrack);

      this.trackedTasksQuery.data?.trackedTasks?.forEach((t) => {
        if (!this.tasksMap.has(t.id)) {
          this.tasksMap.set(t.id, t);
        }
      });
      return this.tasksMap;
      // return (this.trackedTasksQuery.data?.trackedTasks ?? []).filter((x) => x);
    }
  }

  get numBlocks() {
    // only showing 18hrs max
    const maxWidth = 18 * TIMEBLOCK_WIDTH;
    const availableWidth = Math.min(this.containerWidth, maxWidth);

    const blocks = Math.floor(availableWidth / TIMEBLOCK_WIDTH) - 1;

    console.log('blocks', blocks);
    return blocks;
  }

  get startTime() {
    const start = dayjs().startOf('day').add(this.prefs.startTimeNum, 'hour');
    console.log(start);
    return start;
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
        {{!-- position: absolute;
        top: 0;
        bottom: 0;
        right: 0;
        left: 300px;
        display: flex;
        flex-direction: row; --}}

        .tick-hour {
          width: 100px;
          min-width: 100px;
          display: inline-block;
          user-select: none;
          text-align: center;

        }
        .tick-hour:nth-child(odd) {
          background-color: oklch(var(--b2)/0.3)
        }
      }
      #time-container {
        {{!-- position: absolute;
        left: 0;
        width: 300px; --}}
      }
    </style>
    <div {{onResize this.onResize}} class="h-full relative" ...attributes>
      <header {{this.setHeaderHeight}}>
        <h2 class="text-lg font-semibold flex items-center w-[300px] px-2">
          {{this.track}}
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
      </header>
      <main id="container-main" class="relative" {{this.setMainHeight}}>
        <div
          id="tick-container"
          class="absolute left-[300px] top-[-32px] flex pointer-events-none"
        >
          {{#each this.formattedTicks as |tick|}}
            <div class="tick-hour text-base" {{this.setTickHeight}}>
              {{tick}}
            </div>
          {{/each}}
        </div>
        <div id="time-container" class="overflow-y-auto h-full">
          {{#each-in this.tasks as |key task|}}
            <Task @trackedTask={{task}} @ticks={{this.ticks}} />
          {{/each-in}}
        </div>
      </main>
      {{!-- {{#each this.items as |num|}}
        <div class="mb-4 p-4 bg-gray-50 rounded shadow">
          Top Section Content
          {{num}}
        </div>
      {{/each}} --}}
    </div>
  </template>
}
