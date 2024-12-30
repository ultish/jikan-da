import '@glint/environment-ember-loose';
import type EmberConcurrencyRegistry from 'ember-concurrency/template-registry';

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry
    extends EmberConcurrencyRegistry /* other addon registries */ {
    // local entries
  }
}

// removes error for using @RouteTemplate annotation
declare module 'ember-route-template' {
  export default function RouteTemplate(Component: object): void;
}
