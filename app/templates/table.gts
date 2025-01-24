import { pageTitle } from 'ember-page-title';
import { RouteTemplate } from 'jikan-da/utils/ember-route-template';
import Component from '@glimmer/component';
import Tabulator from 'jikan-da/components/tabulator';
import Gridjs from 'jikan-da/components/gridjs';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { modifier } from 'ember-modifier';
import { useQuery } from 'glimmer-apollo';
import type {
  TrackedDayChangedSubscription,
  TrackedDayChangedSubscriptionVariables,
  TrackedDaysQuery,
} from 'jikan-da/graphql/types/graphql';
import {
  GET_TRACKED_DAYS,
  SUBSCRIBE_TRACKED_DAY_CHANGES,
} from 'jikan-da/graphql/tracked-days';

@RouteTemplate
export default class TableTemplate extends Component {
  @tracked
  store: any[] = [];

  #unsubscribe: (() => void) | undefined;

  trackedDaysQuery = useQuery<TrackedDaysQuery>(this, () => [GET_TRACKED_DAYS]);

  subscribeToTrackedDays = modifier((element) => {
    this.#unsubscribe = this.trackedDaysQuery.subscribeToMore<
      TrackedDayChangedSubscription,
      TrackedDayChangedSubscriptionVariables
    >({
      document: SUBSCRIBE_TRACKED_DAY_CHANGES,
      updateQuery: (prevQueryResult, { subscriptionData }) => {
        if (!subscriptionData.data.trackedDayChanged) {
          return prevQueryResult;
        }

        const newDay = subscriptionData.data.trackedDayChanged;
        const prevResults = prevQueryResult.trackedDays || [];

        console.log('tracked days sub', newDay);

        const found = prevResults.find((d) => d.id === newDay.id);

        if (found) {
          // dont need to do anything
          return prevQueryResult;
        } else {
          return {
            trackedDays: [newDay, ...prevResults],
          };
        }
      },
      onError: (error: Error) => {
        console.error('💥 goes the subscription', error);
      },
      context: this,
    });

    return () => {
      this.#unsubscribe?.();
    };
  });

  get days() {
    console.log('days', this);
    if (this.trackedDaysQuery.loading) {
      return [];
    } else if (this.trackedDaysQuery.error) {
      console.log(this.trackedDaysQuery.error);
      return [];
    } else {
      const cached = this.trackedDaysQuery.data?.trackedDays ?? [];

      // either proxy, or clone. not sure what is ideal. apollo query will
      // Object.freeze your data so you don't modify cache by accident.

      // proxying data (urgh changesets) requires more complexity becos
      // we'll need to deal with nested objects, hence nested proxies.
      // this is complex, changeset-tree hell!
      // return cached.map((c) => {
      //   // Creating a proxy to allow mutability
      //   return this.createWritableProxy(c);
      // });

      // structuredClone is a modern deep clone. this works but would
      // need to test performance when we have many objects
      return structuredClone(cached);
    }
  }

  /**
   * this does not nest proxies, so won't work when the query object has more than 1 level
   */
  createWritableProxy(data) {
    // This will store the modified values
    const modifiedData = new Map();

    return new Proxy(data, {
      // Intercept setting a property
      set(target, prop, value) {
        console.log(`Setting ${prop} to ${value}`);
        modifiedData.set(prop, value); // Store the modified value
        // target[prop] = value; // Update the original object
        return true; // Indicate success
      },

      // Intercept getting a property
      get(target, prop) {
        // If the property has been modified, return the modified value
        if (modifiedData.has(prop)) {
          console.log(`Getting modified ${prop}`);
          return modifiedData.get(prop);
        }

        // Otherwise, return the original value
        console.log(`Getting original ${prop}`);
        return target[prop];
      },
    });
  }

  get data() {
    console.log('data');
    for (let i = 0; i < 300000; i++) {
      let sub: any[] = [];
      for (let j = 0; j < Math.random() * 100; j++) {
        sub.push({
          id: `sub-${j}`,
          name: `sub-name-${j}`,
        });
      }

      let x = {
        id: i,
        name: `hello ${i}`,
        age: Math.random() * 100,
        col: 'yellow',
        dob: '31/01/1999',
        nest1: {
          name: 'sub1',
          nest2: {
            name: 'sub2',
            nest3: {
              name: 'sub3',
              items: sub,
              length: sub.length,
            },
          },
        },
      };
      this.store.push(Object.freeze(x));
    }
    console.time('myFunctionTimer');
    const cloned = structuredClone(this.store);
    console.timeEnd('myFunctionTimer');

    return cloned;
  }

  @action
  add() {
    const i = this.store.length + 1;
    this.store = [
      ...this.store,
      {
        id: i,
        name: `sup ${i}`,
        age: Math.random() * 100,
        col: 'yellow',
        dob: '31/01/1999',
      },
    ];
  }

  columns = [
    {
      title: 'Date',
      field: 'date',
    },
    {
      title: 'Week',
      field: 'week',
    },
    {
      title: 'Year',
      field: 'year',
    },
  ];

  columns2 = [
    //Define Table Columns
    { title: 'Name', field: 'name', width: 150 },
    { title: 'Age', field: 'age' },
    { title: 'Favourite Color', field: 'col' },
    {
      title: 'Date Of Birth',
      field: 'dob',
      sorter: 'date',
      hozAlign: 'center',
    },
    {
      title: 'Sub3 Length',
      field: 'nest1.nest2.nest3.length',
    },
    {
      title: 'Subs',
      field: 'nest1.nest2.nest3.items',
    },
  ];

  <template>
    {{pageTitle "table"}}

    {{outlet}}

    {{!prettier-ignore}}
    <style>
      .test-table {
        height: 400px
      }
    </style>

    <button
      class="btn btn-primary btn-sm"
      {{on "click" this.add}}
      type="button"
    >
      Add
    </button>

    <h1 class="text-3xl font-bold underline" {{this.subscribeToTrackedDays}}>
      Table
    </h1>

    <Gridjs />

    <Tabulator
      @tableData={{this.data}}
      @columns={{this.columns2}}
      class="test-table"
    />

    <Tabulator
      @tableData={{this.days}}
      @columns={{this.columns}}
      class="test-table"
    />
  </template>
}
