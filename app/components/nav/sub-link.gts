import type { TOC } from '@ember/component/template-only';
import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';

interface Signature {
  Args: {
    burgerMenu: boolean;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLElement;
}
export default class NavSubLink extends Component<Signature> {
  detailModifier = modifier((element) => {
    const handleClick = (event) => {
      // Check if the clicked element is an <a> tag
      if (event.target.tagName === 'A') {
        // Remove the "open" attribute from the <details> tag
        element.removeAttribute('open');
      }
    };

    // Add a click event listener to the <details> element
    element.addEventListener('click', handleClick);

    // Cleanup when the modifier is removed
    return () => {
      element.removeEventListener('click', handleClick);
    };
  });

  <template>
    {{#if @burgerMenu}}
      {{! template-lint-disable link-href-attributes }}
      <a>Parent</a>
      <ul class="p-2">
        <li>
          {{! template-lint-disable no-nested-interactive }}
          <a href="/time-tracking">Time Tracking</a>
        </li>
        {{! template-lint-disable no-nested-interactive }}
        <li>
          <a href="/charge-codes">Charge Codes</a>
        </li>
      </ul>
    {{else}}
      <details {{this.detailModifier}}>
        <summary>Parent</summary>
        <ul class="p-2 z-50">
          <li>
            {{! template-lint-disable no-nested-interactive }}
            <a href="/time-tracking">Time Tracking</a>
          </li>
          {{! template-lint-disable no-nested-interactive }}
          <li>
            <a href="/charge-codes">Charge Codes</a>
          </li>
        </ul>
      </details>
    {{/if}}
  </template>
}
