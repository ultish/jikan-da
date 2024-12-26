import Component from '@glimmer/component';
import type {
  ChargeCode,
  QueryTimeChargeTotalsArgs,
  TimeChargeTotalsChangedSubscription,
  TimeChargeTotalsChangedSubscriptionVariables,
  TimeChargeTotalsQuery,
  TrackedDay,
  TrackedDayChangedSubscription,
  TrackedDayChangedSubscriptionVariables,
} from 'jikan-da/graphql/types/graphql';

import PhClockCountdown from 'ember-phosphor-icons/components/ph-clock-countdown';
import dayjs from 'dayjs';
import { useQuery, useSubscription } from 'glimmer-apollo';
import {
  GET_TIME_CHARGE_TOTALS,
  SUBSCRIBE_TIME_CHARGE_TOTALS_CHANGES,
} from 'jikan-da/graphql/time-charge-totals';
import { modifier } from 'ember-modifier';
import { SUBSCRIBE_TRACKED_DAY_CHANGES } from 'jikan-da/graphql/subscriptions/tracked-days';
import PhLightning from 'ember-phosphor-icons/components/ph-lightning';
import { min } from '@ember/object/lib/computed/reduce_computed_macros';
import { tracked } from '@glimmer/tracking';

import PhHourglassHigh from 'ember-phosphor-icons/components/ph-hourglass-high';
import PhHourglassMedium from 'ember-phosphor-icons/components/ph-hourglass-medium';
import PhHourglassLow from 'ember-phosphor-icons/components/ph-hourglass-low';

class TimesheetRow {
  chargecode: ChargeCode | string;
  monday = 0;
  tuesday = 0;
  wednesday = 0;
  thursday = 0;
  friday = 0;
  saturday = 0;
  sunday = 0;
  total = 0;

  constructor(chargecode: ChargeCode | string) {
    this.chargecode = chargecode;
  }

  addMinutes(day: string, min: number) {
    (this as any)[day] += min;
    this.total += min;
  }
}
interface Signature {
  Args: {
    trackedDay: TrackedDay;
  };
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}
export default class TimeChargeTotal extends Component<Signature> {
  timeChargeTotals = useQuery<TimeChargeTotalsQuery, QueryTimeChargeTotalsArgs>(
    this,
    () => [
      GET_TIME_CHARGE_TOTALS,
      {
        variables: {
          weekOfYear: {
            year: this.args.trackedDay.year,
            week: this.args.trackedDay.week,
          },
        },
      },
    ]
  );

  testSub = useSubscription<
    TimeChargeTotalsChangedSubscription,
    TimeChargeTotalsChangedSubscriptionVariables
  >(this, () => [
    SUBSCRIBE_TIME_CHARGE_TOTALS_CHANGES,
    {
      variables: {},
    },
  ]);

  testSub2 = useSubscription<
    TrackedDayChangedSubscription,
    TrackedDayChangedSubscriptionVariables
  >(this, () => [
    SUBSCRIBE_TRACKED_DAY_CHANGES,
    {
      variables: {
        month: 12,
        year: 2024,
      },
    },
  ]);

  #unsubscribe: (() => void) | undefined;

  /**
   * this modifier will call subscribeToMore against the graphql query
   * using our subscription that notifies us when a new tracked day is
   * created.
   *
   * This will notify the app if you opened the app in 2 tabs for and
   * add to the cache in both tabs.
   *
   * Whereas the mutation function below modifies the cache, it only
   * works if the current tab is making that modification.
   */
  subscribeToTimeChargeTotals = modifier((element) => {
    this.#unsubscribe = this.timeChargeTotals.subscribeToMore<
      TimeChargeTotalsChangedSubscription,
      TimeChargeTotalsChangedSubscriptionVariables
    >({
      document: SUBSCRIBE_TIME_CHARGE_TOTALS_CHANGES,
      variables: {},
      updateQuery: (prevQueryResult, { subscriptionData }) => {
        debugger;
        if (!subscriptionData.data.timeChargeTotalsChanged) {
          return prevQueryResult;
        }

        const newTct = subscriptionData.data.timeChargeTotalsChanged;

        const prevResults = prevQueryResult.timeChargeTotals || [];

        const found = prevResults.find((d) => d.id === newTct.id);

        if (found) {
          // dont need to do anything
          return prevQueryResult;
        } else {
          // TODO bug adding newTct here as it doesnt contain chargecode
          // and trackedday. apollo cache spits an error
          return {
            timeChargeTotals: [newTct, ...prevResults],
          };
        }
      },
      onError: (error: Error) => {
        console.error('💥 goes the subscription', error);
      },
      context: this,
    });

    return () => {
      // unsubscribe
      this.#unsubscribe?.();
    };
  });

  get timesheet() {
    if (this.timeChargeTotals.loading) {
      return [];
    } else {
      const x = [...(this.timeChargeTotals.data?.timeChargeTotals ?? [])];
      return x.sort(
        (a, b) => (a.trackedDay?.date ?? -1) - (b.trackedDay?.date ?? -1)
      );
    }
  }

  get sortedChargeCodes() {
    const chargeCodes = [...this.timesheet.map((tct) => tct.chargeCode)];
    chargeCodes.sort((a, b) => (a?.sortOrder ?? 0) - (b?.sortOrder ?? 0));
    return chargeCodes;
  }

  get charges() {
    const charges = new Map<string, TimesheetRow>();
    this.timesheet.forEach((tct) => {
      if (tct.chargeCode) {
        const chargeCodeName = tct.chargeCode.name;

        const day = this.formatDate(tct.trackedDay?.date).toLocaleLowerCase();

        let timesheetRow = charges.get(chargeCodeName);
        if (!timesheetRow) {
          timesheetRow = new TimesheetRow({
            ...tct.chargeCode,
            code: '', // don't have all the chargecode data
            expired: false,
          });
          charges.set(chargeCodeName, timesheetRow);
        }

        timesheetRow.addMinutes(day, tct.value ?? 0);
      }
    });

    return charges;
  }

  get sortedCharges() {
    const result = [];
    for (const [key, value] of this.charges.entries()) {
      result.push({
        chargeCodeName: key,
        sortOrder: (value.chargecode as ChargeCode).sortOrder ?? Infinity,
        monday: value.monday,
        tuesday: value.tuesday,
        wednesday: value.wednesday,
        thursday: value.thursday,
        friday: value.friday,
        saturday: value.saturday,
        sunday: value.sunday,
        total: value.total,
      });
    }

    return result.sort((a, b) => a.sortOrder - b.sortOrder);
  }

  get chargesWithIndex() {
    return Object.entries(this.charges).map(([key, val], index) => ({
      key,
      val,
      index,
    }));
  }
  get dailyTotal() {
    const dailyTotals = new TimesheetRow('Total');

    for (const [key, value] of this.charges.entries()) {
      dailyTotals.monday += value.monday;
      dailyTotals.tuesday += value.tuesday;
      dailyTotals.wednesday += value.wednesday;
      dailyTotals.thursday += value.thursday;
      dailyTotals.friday += value.friday;
      dailyTotals.saturday += value.saturday;
      dailyTotals.sunday += value.sunday;

      dailyTotals.total += value.total;
    }

    return dailyTotals;
  }

  get currentDay() {
    return dayjs(this.args.trackedDay.date).format('dddd').toLowerCase();
  }

  formatDate(date: number | undefined) {
    return dayjs(date).format('dddd');
  }

  sixMinBlocks(min: number) {
    return (min / 60).toFixed(2);
  }

  dayActive(day: string, currentDay: string) {
    if (day === currentDay) {
      return 'bg-accent';
    }
  }

  get stats() {
    const good = ['やった！', 'もう帰られるよ', 'まだ働いてるの', '外行けな'];
    const start = ['これからね', '頑張れ', 'まだまだ'];
    const half = ['後ちょっと', 'もう少し', 'お腹空いた'];

    const left = ((2280 - this.dailyTotal.total) / 60).toFixed(1);
    if (this.dailyTotal.total > 2280) {
      return {
        left: left,
        msg: good[Math.floor(Math.random() * good.length)],
        icon: 'low',
      };
    } else if (this.dailyTotal.total > 1140) {
      return {
        left: left,
        msg: half[Math.floor(Math.random() * half.length)],
        icon: 'med',
      };
    } else {
      return {
        left: left,
        msg: start[Math.floor(Math.random() * start.length)],
        icon: 'high',
      };
    }
  }

  iconHigh(icon: string) {
    return icon === 'high';
  }
  iconMed(icon: string) {
    return icon === 'med';
  }
  iconLow(icon: string) {
    return icon === 'low';
  }

  get getTrackerHeaderEle() {
    return document.getElementById('time-tracker-header');
  }

  <template>
    <main class="" {{this.subscribeToTimeChargeTotals}}>
      <h2 class="text-lg font-semibold mb-4">
        <PhClockCountdown class="inline" />Timesheet</h2>
      <div class="flx gap-4 pr-4">
        <table class="table">
          <thead>
            <tr>
              <th class="flex items-center gap-1"><PhLightning
                  class="inline fill-amber-400"
                  @weight="duotone"
                />
                Charge Code
              </th>
              <th>Mon</th>
              <th>Tue</th>
              <th>Wed</th>
              <th>Thu</th>
              <th>Fri</th>
              <th>Sat</th>
              <th>Sun</th>
              <th>Total</th>
            </tr>
          </thead>
          <tbody>
            {{#each this.sortedCharges as |val|}}
              <tr class="hover">
                <td>{{val.chargeCodeName}}</td>
                <td class={{this.dayActive "monday" this.currentDay}}>
                  {{this.sixMinBlocks val.monday}}
                  <span class="text-[7px]">{{val.monday}}</span>
                </td>
                <td class={{this.dayActive "tuesday" this.currentDay}}>
                  {{this.sixMinBlocks val.tuesday}}
                  <span class="text-[7px]">{{val.tuesday}}</span>
                </td>
                <td class={{this.dayActive "wednesday" this.currentDay}}>
                  {{this.sixMinBlocks val.wednesday}}
                  <span class="text-[7px]">{{val.wednesday}}</span>
                </td>
                <td class={{this.dayActive "thursday" this.currentDay}}>
                  {{this.sixMinBlocks val.thursday}}
                  <span class="text-[7px]">{{val.thursday}}</span>
                </td>
                <td class={{this.dayActive "friday" this.currentDay}}>
                  {{this.sixMinBlocks val.friday}}
                  <span class="text-[7px]">{{val.friday}}</span>
                </td>
                <td class={{this.dayActive "saturday" this.currentDay}}>
                  {{this.sixMinBlocks val.saturday}}
                  <span class="text-[7px]">{{val.saturday}}</span>
                </td>
                <td class={{this.dayActive "sunday" this.currentDay}}>
                  {{this.sixMinBlocks val.sunday}}
                  <span class="text-[7px]">{{val.sunday}}</span>
                </td>
                <td>
                  {{this.sixMinBlocks val.total}}
                  <span class="text-[7px]">{{val.total}}</span>
                </td>
              </tr>
            {{/each}}
            <tr>
              <td>{{this.dailyTotal.chargecode}}</td>
              <td class={{this.dayActive "monday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.monday}}
                <span class="text-[7px]">{{this.dailyTotal.monday}}</span>
              </td>
              <td class={{this.dayActive "tuesday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.tuesday}}
                <span class="text-[7px]">{{this.dailyTotal.tuesday}}</span>
              </td>
              <td class={{this.dayActive "wednesday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.wednesday}}
                <span class="text-[7px]">{{this.dailyTotal.wednesday}}</span>
              </td>
              <td class={{this.dayActive "thursday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.thursday}}
                <span class="text-[7px]">{{this.dailyTotal.thursday}}</span>
              </td>
              <td class={{this.dayActive "friday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.friday}}
                <span class="text-[7px]">{{this.dailyTotal.friday}}</span>
              </td>
              <td class={{this.dayActive "saturday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.saturday}}
                <span class="text-[7px]">{{this.dailyTotal.saturday}}</span>
              </td>
              <td class={{this.dayActive "sunday" this.currentDay}}>
                {{this.sixMinBlocks this.dailyTotal.sunday}}
                <span class="text-[7px]">{{this.dailyTotal.sunday}}</span>
              </td>
              <td>
                {{this.sixMinBlocks this.dailyTotal.total}}
                <span class="text-[7px]">{{this.dailyTotal.total}}</span>
              </td>

            </tr>
          </tbody>
        </table>

        {{#if this.getTrackerHeaderEle}}
          {{#in-element this.getTrackerHeaderEle}}
            <div class="stats shadow">
              <div class="stat p-[0.5rem]">
                <div class="stat-figure text-secondary">
                  {{#if (this.iconHigh this.stats.icon)}}
                    <PhHourglassHigh class="inline h-8 w-8" @weight="duotone" />
                  {{else if (this.iconMed this.stats.icon)}}
                    <PhHourglassMedium
                      class="inline h-8 w-8"
                      @weight="duotone"
                    />
                  {{else}}
                    <PhHourglassLow class="inline h-8 w-8" @weight="duotone" />
                  {{/if}}
                </div>
                <div class="stat-title text-[0.7rem]">Hours Left</div>
                <div
                  class="stat-value text-[1.2rem] leading-[1.2rem]"
                >{{this.stats.left}}</div>
                <div class="stat-desc">{{this.stats.msg}}</div>
              </div>
            </div>
          {{/in-element}}
        {{/if}}
      </div>
    </main>
  </template>
}
