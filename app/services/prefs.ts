import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class Prefs extends Service {
  @tracked startTimeNum = 6;

  constructor() {
    super();

    this.startTimeNum = Number.parseInt(
      localStorage.getItem('jga-start-time') ?? '6'
    );

    addEventListener('storage', (e: StorageEvent) => {
      if (e.key === 'jga-start-time') {
        this.startTimeNum = Number.parseInt(e.newValue ?? '6');
      }
    });
  }

  setStartTimeNum(val: number) {
    this.startTimeNum = val;
    localStorage.setItem('jga-start-time', val.toString());
  }
}

// DO NOT DELETE: this is how TypeScript knows how to look up your services.
declare module '@ember/service' {
  interface Registry {
    prefs: Prefs;
  }
}
