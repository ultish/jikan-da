import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

class ThemeClass {
  theme: string;
  @tracked currentTheme: string | null;

  get active() {
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
    if (event.key === 'theme') {
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
    return themes.map((theme) => {
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
      class="menu menu-sm dropdown-content bg-base-100 rounded-btn z-10 mt-3 w-64 p-2 shadow grid grid-cols-1 gap-2 overflow-y-auto max-h-[calc(100vh-10rem)]"
    >
      {{#each this.themeOptions key="theme" as |themeOption|}}
        <li>
          {{! template-lint-disable link-href-attributes }}
          <a
            role="button"
            class="justify-normal bg-base-100 hover:text-info-content hover:bg-info flex"
            data-theme={{themeOption.theme}}
            data-set-theme={{themeOption.theme}}
            {{on "click" (fn this.setTheme themeOption.theme)}}
          >

            <span class="flex-grow">
              {{themeOption.theme}}
            </span>
            {{#if themeOption.active}}
              <span class="badge">Active</span>
            {{/if}}
            <span class="flex h-full shrink-0 flex-wrap gap-1">
              <span class="bg-primary rounded-badge w-2"></span>
              <span class="bg-secondary rounded-badge w-2"></span>
              <span class="bg-accent rounded-badge w-2"></span>
              <span class="bg-neutral rounded-badge w-2"></span>
            </span>
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
  'acid',
  'aqua',
  'autumn',
  'black',
  'bumblebee',
  'business',
  'cmyk',
  'coffee',
  'corporate',
  'cupcake',
  'cyberpunk',
  'dim',
  'dracula',
  'emerald',
  'fantasy',
  'forest',
  'garden',
  'halloween',
  'lemonade',
  'lofi',
  'luxury',
  'night',
  'nord',
  'pastel',
  'retro',
  'sunset',
  'synthwave',
  'valentine',
  'winter',
  'wireframe',
];
