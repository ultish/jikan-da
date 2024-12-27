import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

class ThemeClass {
  theme: string;
  @tracked currentTheme: string | null;

  get active() {
    console.log(this.currentTheme);
    return this.theme === this.currentTheme;
  }

  constructor(theme: string, currentTheme: string | null) {
    this.theme = theme;
    this.currentTheme = currentTheme;
  }
}
interface Signature {
  Args: {};
  Element: HTMLUListElement;
}
export default class ThemeButtons extends Component<Signature> {
  @tracked currentTheme: string = '';

  @action
  storageListener(event: any) {
    console.log('asd', event);
    if (event.key === 'theme') {
      console.log(`The key "${event.key}" was updated!`);
      console.log(`Old value: ${event.oldValue}`);
      console.log(`New value: ${event.newValue}`);

      this.setTheme(event.newValue);
    }
  }

  constructor(owner: unknown, args: Signature['Args']) {
    super(owner, args);
    this.currentTheme = localStorage.getItem('theme') ?? '';

    document.documentElement.setAttribute('data-theme', this.currentTheme);

    window.addEventListener('storage', this.storageListener);
  }

  willDestroy(): void {
    window.removeEventListener('storage', this.storageListener);
  }

  get themeOptions() {
    return themes.sort().map((theme) => {
      return new ThemeClass(theme, this.currentTheme);
    });
  }

  @action
  setTheme(theme: string) {
    this.currentTheme = theme;

    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('theme', theme);
  }

  <template>
    <ul
      tabindex="0"
      class="menu menu-sm dropdown-content bg-base-100 rounded-box z-10 mt-3 w-52 p-2 shadow"
    >
      {{#each this.themeOptions key="theme" as |themeOption|}}
        <li>
          {{! template-lint-disable link-href-attributes }}
          <a
            role="button"
            class="justify-between"
            data-set-theme={{themeOption.theme}}
            {{on "click" (fn this.setTheme themeOption.theme)}}
          >
            {{themeOption.theme}}
            {{#if themeOption.active}}
              <span class="badge">Active</span>
            {{/if}}
          </a>
        </li>
      {{/each}}
    </ul>
    <div>

    </div>
  </template>
}

const themes = [
  'light',
  'dark',
  'cupcake',
  'bumblebee',
  'emerald',
  'corporate',
  'synthwave',
  'retro',
  'cyberpunk',
  'valentine',
  'halloween',
  'garden',
  'forest',
  'aqua',
  'lofi',
  'pastel',
  'fantasy',
  'wireframe',
  'black',
  'luxury',
  'dracula',
  'cmyk',
  'autumn',
  'business',
  'acid',
  'lemonade',
  'night',
  'coffee',
  'winter',
  'dim',
  'nord',
  'sunset',
];
