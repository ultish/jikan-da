import Component from '@glimmer/component';
import type {
  DeleteTrackedDayMutation,
  DeleteTrackedTaskMutation,
  MutationDeleteTrackedDayArgs,
  MutationDeleteTrackedTaskArgs,
  QueryTrackedDaysForMonthYearArgs,
  TrackedDay,
  TrackedDaysForMonthYearQuery,
} from 'jikan-da/graphql/types/graphql';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import QuickActions from './quick-actions';
import TaskListLayout from './task-list/layout';

import PhCalendarDot from 'ember-phosphor-icons/components/ph-calendar-dot';
import TimeChargeTotal from './time-charge-total';
import { inject as service } from '@ember/service';
import type Prefs from 'jikan-da/services/prefs';

import { localCopy } from 'tracked-toolbox';
import { modifier } from 'ember-modifier';
import PhCube from 'ember-phosphor-icons/components/ph-cube';
import QuickActionsNew from './quick-actions/new';
import PhTrash from 'ember-phosphor-icons/components/ph-trash';
import {
  DELETE_TRACKED_DAY,
  GET_TRACKED_DAYS_BY_MONTH_YEAR,
} from 'jikan-da/graphql/tracked-days';
import { useMutation } from 'glimmer-apollo';
import {
  DELETE_TRACKED_TASK,
  GET_TRACKED_TASKS,
} from 'jikan-da/graphql/tracked-tasks';
import type RouterService from '@ember/routing/router-service';
import { GET_TIME_CHARGE_TOTALS } from 'jikan-da/graphql/time-charge-totals';

interface Signature {
  Args: {
    day: TrackedDay;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class DayLayout extends Component<Signature> {
  @tracked bottomHeight = 200; // Initial height in pixels
  @tracked isDragging = false;

  @service declare prefs: Prefs;
  @service declare router: RouterService;

  minBottomHeight = 30;
  minTopHeight = 200;

  setTimeTrackingHeight = modifier((element: HTMLElement) => {
    const top = element.getBoundingClientRect().top;
    element.style.height = `calc(100vh - ${top}px)`;
  });

  @action
  startDragging() {
    this.isDragging = true;
    document.addEventListener('mousemove', this.handleDrag);
    document.addEventListener('mouseup', this.stopDragging);
  }

  @action
  stopDragging() {
    this.isDragging = false;
    document.removeEventListener('mousemove', this.handleDrag);
    document.removeEventListener('mouseup', this.stopDragging);
  }

  @action
  handleDrag(event) {
    if (!this.isDragging) return;

    const container = document.getElementById('main-content');
    if (!container) return;

    const containerRect = container.getBoundingClientRect();
    const containerHeight = containerRect.height;
    const mouseY = event.clientY - containerRect.top;
    const newBottomHeight = containerHeight - mouseY;
    const topHeight = containerHeight - newBottomHeight;

    if (
      topHeight >= this.minTopHeight &&
      newBottomHeight >= this.minBottomHeight
    ) {
      this.bottomHeight = newBottomHeight;
    }
  }

  get date() {
    return dayjs(this.args.day.date).format('YYYY-MM-DD dddd');
  }

  get mainContentHeight() {
    return `height: calc(100% - ${this.bottomHeight}px)`;
  }

  get bottomHeightStyle() {
    return `height: ${this.bottomHeight}px`;
  }

  @localCopy('prefs.startTimeNum') declare startTime: string;

  @action
  handleInput(event: any) {
    if (event.target) {
      this.startTime = event.target.value;
      this.updateStartTime();
    }
  }

  @action
  updateStartTime() {
    const num = Number.parseInt(this.startTime);
    this.prefs.setStartTimeNum(num);
  }

  deleteTrackedDayMutation = useMutation<
    DeleteTrackedDayMutation,
    MutationDeleteTrackedDayArgs
  >(this, () => [
    DELETE_TRACKED_DAY,
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
        if (result.data?.deleteTrackedDay) {
          // using modify here to easily remove an object from the cache
          // it specifically targets a query to clean up from
          // cache.modify<TrackedDaysForMonthYearQuery>({
          //   fields: {
          //     trackedDaysForMonthYear(existingTaskRefs, { readField }) {
          //       return existingTaskRefs?.filter(
          //         (ref) =>
          //           readField('id', ref) !== result?.data?.deleteTrackedDay
          //       );
          //     },
          //   },
          // });

          // can also use this to remove from the cache but will remove all
          // references to this object it seems! much cleaner?
          const normalizedId = cache.identify({
            id: result.data.deleteTrackedDay,
            __typename: 'TrackedDay',
          });
          if (normalizedId) {
            cache.evict({ id: normalizedId });
            // removes unreachable results
            cache.gc();
          }

          // the alternative mess to remove an obejct from cache...
          // cache.modify({
          //   id: cache.identify(result.data.deleteTrackedDay),
          //   fields: {
          //     TrackedDay(existing, { readField }) {
          //       debugger;
          //       return existing;
          //     },
          //   },
          // });
          // const vars = {
          //   // month: this.args.month,
          //   // year: this.args.year,
          // };
          // // deleted
          // const data = cache.readQuery<
          //   TrackedDaysForMonthYearQuery,
          //   QueryTrackedDaysForMonthYearArgs
          // >({
          //   query: GET_TRACKED_DAYS_BY_MONTH_YEAR,
          //   variables: vars,
          // });
          // if (data) {
          //   const existingTasks = data.trackedDaysForMonthYear ?? [];
          //   cache.writeQuery<TrackedDaysForMonthYearQuery>({
          //     query: GET_TRACKED_DAYS_BY_MONTH_YEAR,
          //     variables: vars,
          //     data: {
          //       trackedDaysForMonthYear: existingTasks.filter(
          //         (t) => t.id !== result.data?.deleteTrackedDay
          //       ),
          //     },
          //   });
          // }
        }
      },
    },
  ]);

  @action
  async deleteTrackedDay() {
    await this.deleteTrackedDayMutation.mutate({
      id: this.args.day.id,
    });

    this.router.transitionTo('time-tracking');
  }

  <template>
    <header class="bg-base-200 shadow">
      <div
        class="mx-auto max-w-full px-4 py-4 sm:px-6 lg:px-8 flex gap-2 items-center"
      >
        <h2 class="text-xl font-semibold grow leading-[4rem]">
          <PhCalendarDot class="inline" />
          Time for
          {{this.date}}

          <button
            type="button"
            class="btn btn-circle btn-sm ml-3 btn-outline btn-error text-error-content"
            {{on "dblclick" this.deleteTrackedDay}}
          >
            <PhTrash />
          </button>
        </h2>
        <div class="flex gap-2 items-center">
          <div>
            <PhCube @color="darkorchid" @weight="duotone">
              <animate
                attributeName="opacity"
                values="0.1;1;0.1"
                dur="4s"
                repeatCount="indefinite"
              />
              <animateTransform
                attributeName="transform"
                attributeType="XML"
                type="rotate"
                dur="5s"
                from="0 0 0"
                to="360 0 0"
                repeatCount="indefinite"
              />
            </PhCube>
          </div>
          <div class="grow">
            <input
              type="range"
              min="5"
              max="11"
              value={{this.startTime}}
              {{on "input" this.handleInput}}
              class="range range-xs"
              step="1"
            />
            <div class="flex w-full justify-between text-xs">
              <span class="text-[10px] w-[10px] text-center">5</span>
              <span class="text-[10px] w-[10px] text-center">6</span>
              <span class="text-[10px] w-[10px] text-center">7</span>
              <span class="text-[10px] w-[10px] text-center">8</span>
              <span class="text-[10px] w-[10px] text-center">9</span>
              <span class="text-[10px] w-[10px] text-center">10</span>
              <span class="text-[10px] w-[10px] text-center">11</span>
            </div>
          </div>
        </div>

        <div id="time-tracker-header"></div>
      </div>
    </header>

    <div class="drawer drawer-end w-full relative--">
      <input
        id="qa-drawer"
        type="checkbox"
        class="drawer-toggle"
        tabindex="-1"
      />
      <div class="drawer-content">
        <!-- Page content here -->

        <div
          class="h-screen w-full flex px-4 sm:px-6 lg:px-8"
          {{this.setTimeTrackingHeight}}
        >
          {{! Left Column }}

          <QuickActions
            @trackedDay={{@day}}
            class="w-56 overflow-y-auto pt-4"
          />

          {{! Main Content Area }}
          <div id="main-content" class="flex-1 flex flex-col h-full relative">
            {{! Top Section }}
            <div
              class="flex-1 min-h-0 mt-4 overflow-y-scroll--- relative--"
              style={{this.mainContentHeight}}
            >
              <TaskListLayout @trackedDay={{@day}} class="" />
            </div>

            {{! Resize Handle }}
            <div
              class="h-2 bg-gray-200 hover:bg-blue-300 cursor-ns-resize relative"
              {{on "mousedown" this.startDragging}}
              draggable="true"
            >
              <div
                class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2"
              >
                <div class="w-8 h-1 bg-gray-400 rounded"></div>
              </div>
            </div>

            {{! Bottom Section }}
            <div
              class="overflow-y-auto border-t border-gray-200 z-[2] bg-base-100"
              style={{this.bottomHeightStyle}}
            >
              <TimeChargeTotal @trackedDay={{@day}} />
            </div>
          </div>
        </div>
      </div>
      <div class="drawer-side z-50">
        <label
          for="qa-drawer"
          aria-label="close sidebar"
          class="drawer-overlay"
        ></label>
        <div
          class="menu bg-base-100 text-base-content min-h-full w-[600px] p-8"
        >
          <QuickActionsNew />
        </div>
      </div>
    </div>
  </template>
}
