import Component from '@glimmer/component';
import {
  type MutationCreateTrackedTaskArgs,
  type CreateTrackedTaskMutation,
  type QueryTrackedTasksArgs,
  type TrackedDay,
  type TrackedTasksQuery,
  type TrackedTasksQueryVariables,
  type MutationDeleteTrackedTaskArgs,
  type DeleteTrackedTaskMutation,
} from 'jikan-da/graphql/types/graphql';
import PhKanban from 'ember-phosphor-icons/components/ph-kanban';
import PhListPlus from 'ember-phosphor-icons/components/ph-list-plus';
import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { trackedReset } from 'tracked-toolbox';
import { on } from '@ember/modifier';
import { useMutation, useQuery } from 'glimmer-apollo';
import {
  CREATE_TRACKED_TASK,
  DELETE_TRACKED_TASK,
  GET_TRACKED_TASKS,
} from 'jikan-da/graphql/tracked-tasks';
import { scaleTime } from 'd3-scale';
import { modifier } from 'ember-modifier';
import onResize from 'ember-on-resize-modifier/modifiers/on-resize';
import { inject as service } from '@ember/service';
import type Prefs from 'jikan-da/services/prefs';
import Task from './task';

export type TrackedTasksPartial = NonNullable<
  TrackedTasksQuery['trackedTasks']
>[number];

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
  onResize({ contentRect: { width } }: { contentRect: { width: number } }) {
    this.containerWidth = (width ?? 0) - 300;
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
          console.log('tracked task query');
        },
      },
    ]
  );

  // So important for not refreshing the display!
  @trackedReset('args.trackedDay')
  tasksMap = new Map<string, TrackedTasksPartial>(); // this type matches what was fetched

  /**
   * this uses a map to cache the tracked tasks for performance reasons but it causes
   * odd caching of the tracked Task object!
   *
   * instead you can just specify the key in a #each loop and ember won't re-init the
   * component
   */
  get tasks_using_map() {
    if (this.trackedTasksQuery.loading) {
      return [];
    } else {
      this.trackedTasksQuery.data?.trackedTasks?.forEach((t) => {
        if (!this.tasksMap.has(t.id)) {
          this.tasksMap.set(t.id, t);
        } else {
          const existing = this.tasksMap.get(t.id);
          console.log(existing, t);
        }
      });
      return this.tasksMap;
    }
  }

  get tasks() {
    if (this.trackedTasksQuery.loading) {
      return [];
    } else {
      return this.trackedTasksQuery?.data?.trackedTasks ?? [];
    }
  }

  get numBlocks() {
    // only showing 18hrs max
    const maxWidth = 18 * TIMEBLOCK_WIDTH;
    const availableWidth = Math.min(this.containerWidth, maxWidth);
    const blocks = Math.floor(availableWidth / TIMEBLOCK_WIDTH) - 1;

    return blocks;
  }

  get startTime() {
    const start = dayjs().startOf('day').add(this.prefs.startTimeNum, 'hour');

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

          cache.writeQuery<TrackedTasksQuery>({
            query: GET_TRACKED_TASKS,
            variables: vars,
            data: { trackedTasks: [...existingTasks, newTask] },
          });
        }
      },
    },
  ]);

  deleteTrackedTaskMutation = useMutation<
    DeleteTrackedTaskMutation,
    MutationDeleteTrackedTaskArgs
  >(this, () => [
    DELETE_TRACKED_TASK,
    {
      update: (cache, result) => {
        // have to manage the cache in apollo. wonder if there's an easier way...
        if (result.data?.deleteTrackedTask) {
          const vars = {
            trackedDayId: this.args.trackedDay.id,
          };
          // deleted
          const data = cache.readQuery<
            TrackedTasksQuery,
            TrackedTasksQueryVariables
          >({
            query: GET_TRACKED_TASKS,
            variables: vars,
          });

          if (data) {
            const existingTasks = data.trackedTasks ?? [];
            cache.writeQuery<TrackedTasksQuery>({
              query: GET_TRACKED_TASKS,
              variables: vars,
              data: {
                trackedTasks: existingTasks.filter(
                  (t) => t.id !== result.data?.deleteTrackedTask
                ),
              },
            });
          }
        }
      },
    },
  ]);

  @action
  async createTask() {
    const newTask = await this.createTaskMutation.mutate({
      trackedDayId: this.args.trackedDay.id,
    });
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
          class="absolute left-[300px] top-[-32px] h-full flex pointer-events-none"
        >
          {{#each this.formattedTicks as |tick|}}
            <div class="tick-hour text-base h-full relative">
              {{tick}}
              <div
                class="absolute top-0 left-1/2 w-[1px] h-full bg-base-200/70"
              ></div>
            </div>
          {{/each}}
        </div>
        <div id="time-container" class="overflow-y-auto h-full">
          {{#each this.tasks key="id" as |task|}}
            <Task
              @trackedTask={{task}}
              @ticks={{this.ticks}}
              @deleteTrackedTaskMutation={{this.deleteTrackedTaskMutation}}
            />
          {{/each}}
        </div>
      </main>
    </div>
  </template>
}
