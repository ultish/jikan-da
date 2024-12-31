import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import PhHamburger from 'ember-phosphor-icons/components/ph-hamburger';
import PhClockUser from 'ember-phosphor-icons/components/ph-clock-user';
import NavLinks from 'jikan-da/components/nav/links';
import ThemeButtons from 'jikan-da/components/theme-buttons';
import PhPaintRoller from 'ember-phosphor-icons/components/ph-paint-roller';
import PhPawPrint from 'ember-phosphor-icons/components/ph-paw-print';

import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import type RouterService from '@ember/routing/router-service';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

@RouteTemplate
export default class ApplicationTemplate extends Component {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  @action
  async login() {
    await this.auth.login();
  }

  get year() {
    return new Date().getFullYear();
  }

  @action
  async logout() {
    await this.auth.logout();
  }

  <template>
    {{! prettier-ignore}}
    <style>
      .navbar {
        color: oklch(var(--bc))
      }
      .container {
        perspective: 50px;
        width: 20px;
        height: 20px;
      }
      a.whoa:hover .container {
        perspective: 4px;
      }

      .cube {
        width: 100%;
        height: 100%;
        transform-style: preserve-3d;
        animation: rotate 4s infinite;
      }
      @keyframes rotate {
        0% { transform: rotateY(0deg); }
        5% { transform: rotateY(0deg); }
        45% { transform: rotateY(180deg); }
        50% { transform: rotateY(180deg); }
        100% { transform: rotateY(360deg); }
      }
    </style>
    {{pageTitle "時間だ"}}
    <div class="navbar bg-base-100">
      <div class="navbar-start">
        <div class="dropdown">
          <div tabindex="0" role="button" class="btn btn-ghost lg:hidden">
            <PhHamburger role="presentation" class="h-5 w-5" />
          </div>
          <NavLinks
            @burgerMenu={{true}}
            tabindex="0"
            class="menu-sm dropdown-content bg-base-100 rounded-box z-[1] mt-3 w-52 p-2 shadow"
          />
        </div>
        <a href="/" class="btn btn-ghost text-xl whoa">
          <div class="container">
            <PhClockUser class="cube" />
          </div>
          <div class="hidden lg:block">
            タイムシートやった？
          </div>
        </a>
      </div>
      <div class="navbar-center hidden lg:flex">
        <NavLinks class="menu-horizontal px-1" @burgerMenu={{false}} />
      </div>
      <div class="navbar-end">
        {{#if this.auth.isAuthenticated}}
          <button
            class="btn btn-ghost btn-sm"
            type="button"
            {{on "click" this.logout}}
          >
            Logout
          </button>
        {{/if}}
        <div class="dropdown dropdown-end">
          <div
            tabindex="0"
            role="button"
            class="btn btn-ghost btn-circle avatar"
          >
            <div class="w-10 rounded-full">
              <PhPaintRoller class="w-10 h-10" role="presentation" />
            </div>
          </div>
          <ThemeButtons />
        </div>
      </div>
    </div>

    {{outlet}}

    <footer
      class="footer bg-neutral text-neutral-content items-center p-4 overflow-visible"
    >
      <aside class="grid-flow-col items-center relative">

        <div class="relative hover:z-50 group">
          <span
            class="absolute -top-6 left-16 text-2xl font-bold text-yellow-400 rotate-[-30deg] opacity-0 group-hover:opacity-100 transition-opacity duration-300"
          >
            WOW!
          </span>
          <img
            src="/wow.svg"
            width="60"
            class="hover:scale-[10] transition-transform duration-300 origin-bottom-left"
            alt="wow"
          />
        </div>
        <p>much time</p>
      </aside>
      <nav class="grid-flow-col gap-4 md:place-self-center md:justify-self-end">
        <PhPawPrint class="w-6 h-6" />
      </nav>
    </footer>
  </template>
}
