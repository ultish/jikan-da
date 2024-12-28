import Component from '@glimmer/component';

import PhFastForward from 'ember-phosphor-icons/components/ph-fast-forward';
import PhFilePlus from 'ember-phosphor-icons/components/ph-file-plus';
import { useMutation, useQuery } from 'glimmer-apollo';
import {
  DELETE_QUICK_ACTION,
  GET_QUICK_ACTIONS,
} from 'jikan-da/graphql/quick-actions';
import PhTrash from 'ember-phosphor-icons/components/ph-trash';
import PhHandEye from 'ember-phosphor-icons/components/ph-hand-eye';
import type {
  CreateTrackedTaskMutation,
  DeleteQuickActionMutation,
  MutationCreateTrackedTaskArgs,
  MutationDeleteQuickActionArgs,
  QueryQuickActionsArgs,
  QuickAction,
  QuickActionsQuery,
  TrackedDay,
  TrackedTasksQuery,
  TrackedTasksQueryVariables,
} from 'jikan-da/graphql/types/graphql';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { fn } from '@ember/helper';
import {
  CREATE_TRACKED_TASK,
  GET_TRACKED_TASKS,
} from 'jikan-da/graphql/tracked-tasks';

export type QuickActionPartial = NonNullable<
  QuickActionsQuery['quickActions']
>[number];

interface Signature {
  Args: {
    trackedDay: TrackedDay;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLElement;
}
export default class QuickActions extends Component<Signature> {
  quickActionsQuery = useQuery<QuickActionsQuery, QueryQuickActionsArgs>(
    this,
    () => [GET_QUICK_ACTIONS]
  );

  get quickActions() {
    return this.quickActionsQuery.data?.quickActions ?? [];
  }

  deleteQuickActionMutation = useMutation<
    DeleteQuickActionMutation,
    MutationDeleteQuickActionArgs
  >(this, () => [
    DELETE_QUICK_ACTION,
    {
      // this isn't re-fetching with last known variables, maybe because i
      // destroy the query from unloading the component?
      refetchQueries: [
        // {
        //   query: GET_TIME_CHARGE_TOTALS,
        // },
      ],
      update: (cache, result) => {
        // have to manage the cache in apollo. wonder if there's an easier way...
        if (result.data?.deleteQuickAction) {
          // can also use this to remove from the cache but will remove all
          // references to this object it seems! much cleaner?
          const normalizedId = cache.identify({
            id: result.data.deleteQuickAction,
            __typename: 'QuickAction',
          });
          if (normalizedId) {
            cache.evict({ id: normalizedId });
            // removes unreachable results
            cache.gc();
          }
        }
      },
    },
  ]);

  @action
  deleteQuickAction(qa: QuickActionPartial) {
    this.deleteQuickActionMutation.mutate({
      id: qa.id,
    });
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
            data: { trackedTasks: [newTask, ...existingTasks] },
          });
        }
      },
    },
  ]);

  @action
  async apply(qa: QuickActionPartial) {
    // TODO: really should fire an event for task-list to handle it, but lazy now

    await this.createTaskMutation.mutate({
      trackedDayId: this.args.trackedDay.id,
      notes: qa.description,
      timeSlots: qa.timeSlots,
      chargeCodeIds: qa.chargeCodes?.map((cc) => cc.id),
    });
  }

  <template>
    <main class="prose" ...attributes>
      <h4 class="flex items-center gap-2">
        <span class="grow">
          <PhFastForward class="inline" />
          Quick Actions
        </span>
        <label for="qa-drawer" class="drawer-button btn btn-ghost btn-sm">
          <PhFilePlus class="inline" />
          Add...
        </label>
      </h4>

      {{#each this.quickActions key="id" as |qa|}}
        <div class="flex gap-2 items-center">
          <div
            class="badge grow hover:bg-accent hover:text-accent-content cursor-pointer"
            role="button"
            {{on "click" (fn this.apply qa)}}
          >

            <PhHandEye @color="oklch(var(--s))" class="inline-block" />
            {{qa.name}}
          </div>

          <button
            type="button"
            class="btn btn-circle btn-sm btn-ghost"
            {{on "dblclick" (fn this.deleteQuickAction qa)}}
          >
            <PhTrash @color="oklch(var(--er))" />
          </button>

        </div>
      {{/each}}
      {{yield}}
    </main>
  </template>
}
