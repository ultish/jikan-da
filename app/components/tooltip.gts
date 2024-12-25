import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import {
  computePosition,
  autoPlacement,
  flip,
  shift,
  offset,
  arrow,
} from '@floating-ui/dom';
import { on } from '@ember/modifier';
import { modifier } from 'ember-modifier';

interface Signature {
  Args: {
    content?: string;
    placement?: 'top' | 'right' | 'bottom' | 'left';
  };
  Element: HTMLDivElement;
  Blocks: {
    default: {};
  };
}
export default class Tooltip extends Component<Signature> {
  @tracked isVisible = false;
  @tracked tooltipElement: HTMLElement | undefined;
  @tracked triggerElement: HTMLElement | undefined;

  get content() {
    return this.args.content || '';
  }

  get placement() {
    return this.args.placement || 'top';
  }

  setupElements = modifier((element: HTMLElement) => {
    this.tooltipElement = element;
  });

  setupTrigger = modifier((element: HTMLElement) => {
    this.triggerElement = element;
  });

  @action
  showTooltip() {
    this.isVisible = true;
    this.updatePosition();
  }

  @action
  hideTooltip() {
    this.isVisible = false;
  }

  @action
  async updatePosition() {
    if (!this.tooltipElement || !this.triggerElement) return;

    const { x, y } = await computePosition(
      this.triggerElement,
      this.tooltipElement,
      {
        strategy: 'absolute',
        middleware: [autoPlacement()],
        // middleware: [offset(6), flip(), shift()],
      }
    );
    console.log(this.triggerElement, this.tooltipElement);

    Object.assign(this.tooltipElement.style, {
      left: `${x}px`,
      top: `${y}px`,
    });
  }

  <template>
    {{! prettier-ignore }}
    <style>
      .tooltip {
        position: fixed;
        width: max-content;


        background-color: red;
        color: white;
        top: 0;
        left: 0;

        padding: 4px 8px;
        border-radius: 4px;
        font-size: 14px;
        z-index: 1000;
        pointer-events: none;
      }

      .tooltip-trigger {
        display: inline-block;
      }
    </style>
    <div
      class="tooltip-trigger"
      {{this.setupTrigger}}
      {{on "mouseenter" this.showTooltip}}
      {{on "mouseleave" this.hideTooltip}}
    >
      {{yield}}
    </div>

    {{!-- {{#if this.isVisible}} --}}
    <div
      class="tooltip {{if this.isVisible 'block' 'hidden'}}"
      {{this.setupElements}}
      role="tooltip"
    >
      {{this.content}}
    </div>
    {{!-- {{/if}} --}}
  </template>
}
