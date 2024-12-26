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

  get items() {
    return [
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
    ];
  }

  get mainContentHeight() {
    return `height: calc(100% - ${this.bottomHeight}px)`;
  }

  get bottomHeightStyle() {
    return `height: ${this.bottomHeight}px`;
  }

  <template>
    <header class="bg-base-200 shadow">
      <div class="mx-auto max-w-full px-4 py-6 sm:px-6 lg:px-8 prose">
        <h2>
          <PhCalendarDot class="inline" />
          Time for
          {{this.date}}
        </h2>
      </div>
    </header>

    {{!-- <main>
      <div class="mx-auto max-w-full px-4 py-6 sm:px-6 lg:px-8">
        Stuff

        {{! quick actions }}

        {{! list of tasks }}
      </div>
    </main> --}}

    <div class="h-screen w-full flex px-4 sm:px-6 lg:px-8">
      {{! Left Column }}

      <QuickActions class="w-56 overflow-y-auto pt-4" />
      {{!-- <div class="w-64 h-full border-rborder-gray-200 overflow-y-auto">
        <div class="pt-1">
          <h2 class="text-lg font-semibold mb-4">Left Column</h2>
          {{#each this.items as |num|}}
            <div class="mb-4 p-4 bg-white rounded shadow">
              Item
              {{num}}
            </div>
          {{/each}}
        </div>
      </div> --}}

      {{! Main Content Area }}
      <div id="main-content" class="flex-1 flex flex-col h-full relative">
        {{! Top Section }}
        <div
          class="flex-1 overflow-y-auto min-h-0 mt-4"
          style={{this.mainContentHeight}}
        >
          <TaskListLayout @trackedDay={{@day}} />
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
          {{!-- <div class="p-4">
            <h2 class="text-lg font-semibold mb-4">Bottom Section</h2>
            {{#each this.items as |num|}}
              <div class="mb-4 p-4 bg-gray-50 rounded shadow">
                Bottom Section Content
                {{num}}
              </div>
            {{/each}}
          </div> --}}
        </div>
      </div>
    </div>
  </template>
}
