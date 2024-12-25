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
  };
  Blocks: {
    default: [T];
  };
}
export default class TooManyChoices<T> extends Component<Signature<T>> {
  makeChoices = modifier(async (e) => {
    // force-disconnect from auto-tracking
    await Promise.resolve();

    this.instance = new Choices(e, {
      items: this.args.items,
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
      debugger;
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
    </style>

    <select multiple="true" id="test" {{this.makeChoices}}>
      {{#each this.choices as |c|}}
        {{yield c}}
      {{/each}}
    </select>
  </template>
}
