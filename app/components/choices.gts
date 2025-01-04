import Component from '@glimmer/component';
import Choices, { type EventChoice, type InputChoice } from 'choices.js';
import { modifier } from 'ember-modifier';
import { runTask } from 'ember-lifeline';
import { Promise } from 'rsvp';

interface Signature<T> {
  Args: {
    choices: T[];
    items?: InputChoice[];
    onAdd?: (detail: any) => void;
    onRemove?: (detail: any) => void;
    outerClass?: string;
    placeholder?: string;
  };
  Blocks: {
    default: [T];
  };
}

export default class TooManyChoices<T> extends Component<Signature<T>> {
  CHOICES_CLASS_NAMES = {
    containerOuter: ['choices'],
    containerInner: ['choices__inner', 'custom_choices__inner'], // custom class
    input: ['choices__input'],
    inputCloned: ['choices__input--cloned'],
    list: ['choices__list', 'custom_choices__list'], // custom class, background
    listItems: ['choices__list--multiple'],
    listSingle: ['choices__list--single'],
    listDropdown: ['choices__list--dropdown'],
    item: ['choices__item', 'custom_item'],
    itemSelectable: ['choices__item--selectable'],
    itemDisabled: ['choices__item--disabled'],
    itemChoice: ['choices__item--choice'],
    description: ['choices__description'],
    placeholder: ['choices__placeholder'],
    group: ['choices__group'],
    groupHeading: ['choices__heading'],
    button: ['choices__button'],
    activeState: ['is-active'],
    focusState: ['is-focused'],
    openState: ['is-open'],
    disabledState: ['is-disabled'],
    highlightedState: ['is-highlighted'],
    selectedState: ['is-selected'],
    flippedState: ['is-flipped'],
    loadingState: ['is-loading'],
    notice: ['choices__notice'],
    addChoice: ['choices__item--selectable', 'add-choice'],
    noResults: ['has-no-results'],
    noChoices: ['has-no-choices'],
  };

  ele: HTMLElement | undefined;

  // get makeUUID() {
  //   return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
  //     var r = (Math.random() * 16) | 0,
  //       v = c == 'x' ? r : (r & 0x3) | 0x8;
  //     return v.toString(16);
  //   });
  // }

  makeChoices = modifier(async (e: HTMLElement) => {
    this.ele = e;

    // force-disconnect from auto-tracking
    await Promise.resolve();

    const outerClass = {
      containerOuter: [
        ...(this.args.outerClass?.split(' ') ?? []),
        ...this.CHOICES_CLASS_NAMES.containerOuter,
      ],
    };

    console.log(e, outerClass);
    this.instance = new Choices(e, {
      items: this.args.items,
      removeItemButton: true,
      classNames: Object.assign(this.CHOICES_CLASS_NAMES, outerClass),
    });

    const addListener = (p: CustomEvent<EventChoice>) => {
      const { detail } = p;
      this.args.onAdd?.(detail);
    };
    const removeListener = (p: CustomEvent<EventChoice | undefined>) => {
      const { detail } = p;
      this.args.onRemove?.(detail);
    };
    this.ele?.addEventListener('addItem', addListener);
    this.ele?.addEventListener('removeItem', removeListener);

    return () => {
      this.ele?.removeEventListener(addListener);
      this.ele?.removeEventListener(removeListener);
    };
  });

  instance: Choices | undefined;

  get choices() {
    const groups = this.args.choices.reduce((acc, c) => {
      const { chargeCode } = c;
      // Check if group already exists
      const group = chargeCode.group ?? 'Ungrouped';
      if (!acc[group]) {
        acc[group] = { name: group, choices: [] };
      }
      // Push the choice to the corresponding group
      acc[group].choices.push(c);

      return acc;
    }, {});

    runTask(this, () => this.instance?.refresh());
    const groupedChoices = Object.values(groups);
    // return this.args.choices;
    return groupedChoices;
  }

  <template>
    {{! prettier-ignore }}
    <style scoped>
      .is-open .choices__list--dropdown, .is-open .choices__list--dropdown[aria-expanded] {
        border-color: var(--fallback-bc, oklch(var(--bc)/0.2));
      }
      .is-focused  .custom_choices__inner{
        box-shadow: none;
        border-color: var(--fallback-bc, oklch(var(--bc)/0.2));
        outline-style: solid;
        outline-width: 2px;
        outline-offset: 2px;
        outline-color: var(--fallback-bc, oklch(var(--bc)/0.2));
      }
      .custom_choices__inner {
        padding: 2px 0.75rem 0px 0.75rem;
        min-height: 32px;
        border-radius: var(--rounded-btn, 0.5rem);
        border-color: var(--fallback-bc, oklch(var(--bc)/0.2));
        background: inherit;
      }
      .is-open .choices__inner.custom_choices__inner {
        border-radius: var(--rounded-btn, 0.5rem);
      }
      .choices__list.custom_choices__list.choices__list--dropdown {
        border-radius: var(--rounded-btn, 0.5rem);
      }
      .choices__input {
        background-color: inherit;
        margin-bottom: 0px;
        padding: 0px;
      }
      .choices__group {
        background-color: var(--fallback-b1, oklch(var(--b1)));
      }

      {{!-- multi-select chip styles --}}
      .custom_choices__list.choices__list--multiple .custom_item {
        padding: 0px 6px;
        margin-top: 3px;
        margin-bottom: 3px;
      }
      .choices__item.custom_item:not(.has-no-choices) {
        background-color: var(--fallback-b3, oklch(var(--b2) / 1));
        color: var(--fallback-bc, oklch(var(--bc)));
        border-color: var(--fallback-b3, oklch(var(--b2) / 1));
      }
      .custom_item.has-no-choices {
        background-color: var(--fallback-b3, oklch(var(--b2) / 1));
        color: var(--fallback-bc, oklch(var(--bc)));
        border-color: var(--fallback-b3, oklch(var(--b2) / 1));
      }
      .choices__item.custom_item.choices__item--selectable.is-selected {
        background-color: var(--fallback-b2, oklch(var(--b2)/0.6 ));
      }
      {{!-- the delete button on a chip --}}
      .custom_choices__list.choices__list--multiple .custom_item.choices__item--selectable button {
        filter: invert(50%) brightness(100%);
      }





      .input-sm .choices__inner .choices__list .choices__item.choices__item--selectable {
        line-height: initial;
        padding-top: 2px;
        padding-bottom: 2px;
      }
      .choices__item.choices__item--choice.choices__item--selectable {
        padding-left: 1rem;
      }
      .choices__item.choices__item--choice.choices__item--selectable.is-highlighted {
        background-color: var(--fallback-a ,oklch(var(--a)/.5));
        {{!-- background-color: var(--fallback-b2, oklch(var(--b2))); --}}
        color: var(--fallback-ac, oklch(var(--ac)))
      }
      /* no choices option*/
      .choices__item.custom_item.choices__item--choice.choices__notice.has-no-choices {
        {{!-- background-color: var(--fallback-n,oklch(var(--n)/0.8));
        color: var(--fallback-nc, oklch(var(--nc)));
        border-color: oklch(var(--n) / 1); --}}
      }
    </style>

    <select
      multiple
      class="form-control"
      {{this.makeChoices}}
      data-placeholder={{@placeholder}}
    >
      {{!-- <optgroup label="Dev">
        {{#each this.choices as |c|}}
          {{yield c}}
        {{/each}}
      </optgroup> --}}
      {{#each this.choices as |group|}}
        <optgroup label="{{group.name}}">
          {{#each group.choices as |c|}}
            {{yield c}}
          {{/each}}
        </optgroup>
      {{/each}}
    </select>
  </template>
}
