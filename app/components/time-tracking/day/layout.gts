import Component from '@glimmer/component';
import type { TrackedDay } from 'jikan-da/graphql/types/graphql';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import QuickActions from './quick-actions';
import TaskListLayout from './task-list/layout';

import PhCalendarDot from 'ember-phosphor-icons/components/ph-calendar-dot';
import TimeChargeTotal from './time-charge-total';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';
import { inject as service } from '@ember/service';
import type Prefs from 'jikan-da/services/prefs';

import { cached, localCopy } from 'tracked-toolbox';

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
  @tracked bottomHeight = 384; // Initial height in pixels
  @tracked isDragging = false;

  @service declare prefs: Prefs;

  minBottomHeight = 200;
  minTopHeight = 200;

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

  <template>
    <header class="bg-base-200 shadow">
      <div
        class="mx-auto max-w-full px-4 py-4 sm:px-6 lg:px-8 flex gap-2 items-center"
      >
        <h2 class="text-xl font-semibold grow leading-[4rem]">
          <PhCalendarDot class="inline" />
          Time for
          {{this.date}}
        </h2>
        <label class="input input-bordered flex items-center gap-2 w-[200px]">
          Starting Time
          <input
            type="number"
            placeholder="Notes"
            class="w-[50px]"
            aria-label="notes"
            value={{this.startTime}}
            {{on "focusout" this.updateStartTime}}
            {{on "input" this.handleInput}}
          />
        </label>
        <div id="time-tracker-header"></div>
      </div>
    </header>

    <div class="h-screen w-full flex px-4 sm:px-6 lg:px-8">
      {{! Left Column }}
      <QuickActions class="w-56 overflow-y-auto pt-4" />

      {{! Main Content Area }}
      <div id="main-content" class="flex-1 flex flex-col h-full relative">
        {{! Top Section }}
        <div
          class="flex-1 min-h-0 mt-4 overflow-y-scroll--- relative"
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
  </template>
}
