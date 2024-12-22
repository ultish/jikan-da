import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import Hello from 'jikan-da/components/hello';
import PhHamburger from 'ember-phosphor-icons/components/ph-hamburger';
import PhClockUser from 'ember-phosphor-icons/components/ph-clock-user';
import NavLinks from 'jikan-da/components/nav/links';
import NavSubLink from 'jikan-da/components/nav/sub-link';

@RouteTemplate
export default class ApplicationTemplate extends Component {
  <template>
    {{! prettier-ignore}}
    <style>
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
    {{pageTitle "JikanDa"}}
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
            タイムシートやったの？
          </div>
        </a>
      </div>
      <div class="navbar-center hidden lg:flex">
        <NavLinks class="menu-horizontal px-1" @burgerMenu={{false}} />
      </div>
      <div class="navbar-end">
        <a class="btn" href="/">Button</a>
      </div>
    </div>

    {{outlet}}

    <h1 class="text-3xl font-bold underline">
      Hello world!
    </h1>

    <Hello />
  </template>
}
