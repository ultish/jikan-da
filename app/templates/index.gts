import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

import type RouterService from '@ember/routing/router-service';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { htmlSafe } from '@ember/template';
import { modifier } from 'ember-modifier';
import { TrackedObject } from 'tracked-built-ins';
import { tracked } from '@glimmer/tracking';

class Wow {
  @tracked x = 0;
  @tracked y = 0;
  @tracked r = 0;
  character = 'wow';
  constructor(x: number, y: number, r: number) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
}
@RouteTemplate
export default class ApplicationTemplate extends Component {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  @action
  login() {
    this.auth.login();
  }

  get bgImg() {
    let result = 'bg2.jpg';
    if (this.auth.isAuthenticated) {
      result =
        ['bg3.jpg', 'bg.jpg'][Math.floor(Math.random() * 2)] ?? 'bg3.jpg';
    }
    return htmlSafe(`background-image: url(${result});`);
  }

  doge = new Array(20)
    .fill(null)
    .map((_, i) => {
      return new Wow(
        Math.random() * 100,
        -20 - Math.random() * 100,
        0.1 + Math.random() * 1
      );
    })
    .sort((a, b) => a.r - b.r);

  // copied from https://share.glimdown.com/Imwo.1kYQuO2_DXyijIKyg
  animate = modifier((element) => {
    let frame: number;
    const loop = () => {
      frame = requestAnimationFrame(loop);
      this.doge.forEach((dog) => {
        dog.y += 0.3 * dog.r;
        if (dog.y > 110) dog.y = -20;
      });
    };
    frame = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(frame);
  });

  dogeStyle(c: Wow) {
    return htmlSafe(`left: ${c.x}%; top: ${c.y}%; transform: scale(${c.r});`);
  }

  <template>
    {{pageTitle (if this.auth.isAuthenticated "" "Login")}}

    <div class="hero min-h-screen relative" style={{this.bgImg}}>
      {{#if this.auth.isAuthenticated}}
        <div class="wow h-screen w-screen absolute" {{this.animate}}>
          {{#each this.doge as |c|}}
            <img
              alt="wow"
              class="w-10 h-10"
              src="/wow.svg"
              style={{this.dogeStyle c}}
            />
          {{/each}}
        </div>
        {{! prettier-ignore}}
        <style>
          .wow2{
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            right: 0;
          }
          .wow img {
            position: absolute;
            font-size: 5vw;
            user-select: none;
          }
        </style>
      {{/if}}
      <div class="hero-overlay bg-opacity-60"></div>
      <div class="hero-content text-neutral-content text-center">
        <div class="max-w-md">
          {{#if this.auth.isAuthenticated}}
            <h1 class="mb-5 text-5xl font-bold">Hello
              {{this.auth.username}}
              👋
            </h1>
            Roles:
            {{#each this.auth.roles as |role|}}
              {{role}}
              <br />
            {{/each}}
          {{else}}
            <h1 class="mb-5 text-5xl font-bold">Hello 👋</h1>
            <button
              type="button"
              class="btn btn-primary"
              {{on "click" this.login}}
            >
              Login
            </button>
          {{/if}}
        </div>
      </div>
    </div>
    {{outlet}}
  </template>
}
