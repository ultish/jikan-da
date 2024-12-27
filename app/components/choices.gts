import Component from '@glimmer/component';
import Choices, { type InputChoice } from 'choices.js';
import { modifier } from 'ember-modifier';
import { runTask } from 'ember-lifeline';
import PhCube from 'ember-phosphor-icons/components/ph-cube';
import PhHeart from 'ember-phosphor-icons/components/ph-heart';

interface Signature<T> {
  Args: {
    choices: T[];
    items?: InputChoice[];
    onAdd?: (detail: any) => void;
    onRemove?: (detail: any) => void;
    outerClass?: string;
  };
  Blocks: {
    default: [T];
  };
}

const CHOICES_CLASS_NAMES = {
  containerOuter: ['choices', 'flex', 'items-center'],
  containerInner: ['choices__inner'],
  input: ['choices__input'],
  inputCloned: ['choices__input--cloned'],
  list: ['choices__list', 'bg-base-100'],
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

export default class TooManyChoices<T> extends Component<Signature<T>> {
  makeChoices = modifier(async (e) => {
    // force-disconnect from auto-tracking
    await Promise.resolve();

    const outerClass = {
      containerOuter: [
        ...(this.args.outerClass?.split(' ') ?? []),
        ...CHOICES_CLASS_NAMES.containerOuter,
      ],
    };

    this.instance = new Choices(e, {
      items: this.args.items,
      removeItemButton: true,
      classNames: Object.assign(CHOICES_CLASS_NAMES, outerClass),
    });

    e.addEventListener('addItem', ({ detail }) => {
      console.log('add', detail);
      this.args.onAdd?.(detail);
    });

    e.addEventListener('removeItem', ({ detail }) => {
      console.log('remove', detail);
      this.args.onRemove?.(detail);
    });

    return () => {
      console.log('destroy');
    };
  });

  instance: Choices | undefined;

  get choices() {
    runTask(this, () => this.instance?.refresh());

    return this.args.choices;
  }

  <template>
    {{! prettier-ignore }}
    <style scoped>
      .hide {
        display: none;
      }


      .choices__inner {
        background-color: inherit;
        border: 0px;
        padding: 0px;
        min-height: inherit;
      }
      .choices__input {
        margin-bottom: 0px;
        padding: 0px;
      }
      .choices__item.choices__item--selectable {
        margin-bottom: 0px;
      }
      .choices__list.choices__list--dropdown {
        margin-left: -1em;
        margin-right: -1em;
      }
      .choices__list.bg-base-100.choices__list--dropdown {
        border-radius: var(--rounded-btn, 0.5rem);
      }
      .input-sm .choices__inner .choices__list .choices__item.choices__item--selectable {
        line-height: initial;
        padding-top: 2px;
        padding-bottom: 2px;
      }
      .choices__item.custom_item:not(.has-no-choices) {
        background-color: var(--fallback-n,oklch(var(--n)/0.8));
        color: var(--fallback-nc, oklch(var(--nc)));
        border-color: oklch(var(--n) / 1);
      }
      .choices__item.choices__item--choice.choices__item--selectable {
        padding-left: 1rem;
      }
      .choices__item.choices__item--choice.choices__item--selectable.is-highlighted {
        background-color: var(--fallback-a ,oklch(var(--a)/.5));
        color: var(--fallback-ac, oklch(var(--ac)))
      }
      .choices__item.custom_item.choices__item--selectable.is-selected {
        background-color: var(--fallback-n,oklch(var(--n)/0.6));
      }
      /* no choices option*/
      .choices__item.custom_item.choices__item--choice.choices__notice.has-no-choices {
        {{!-- background-color: var(--fallback-n,oklch(var(--n)/0.8));
        color: var(--fallback-nc, oklch(var(--nc)));
        border-color: oklch(var(--n) / 1); --}}
      }
    </style>

    <select multiple="true" id="test" {{this.makeChoices}}>
      {{#each this.choices as |c|}}
        {{yield c}}
      {{/each}}
    </select>
  </template>
}
