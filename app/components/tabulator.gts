import {
  TabulatorFull as Tabulator,
  type ColumnDefinition,
} from 'tabulator-tables';
import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';

interface Signature<T> {
  Args: {
    tableData: T[];
    columns: ColumnDefinition[];
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}
export default class TabulatorComponent<T> extends Component<Signature<T>> {
  table: Tabulator | undefined;
  ele: HTMLElement | undefined;

  tableMe = modifier(async (e: HTMLElement) => {
    console.log('MODIIFER');
    this.ele = e;

    // force-disconnect from auto-tracking
    await Promise.resolve();

    this.table = new Tabulator(e, {
      // height: '100%', // set height of table (in CSS or here), this enables the Virtual DOM and improves render speed dramatically (can be any valid css height value)
      maxHeight: '100%',
      data: this.args.tableData, //assign data to table
      layout: 'fitColumns', //fit columns to width of table (optional)
      columns: this.args.columns,
      // reactiveData: true,
      // columns: [
      //   //Define Table Columns
      //   { title: 'Name', field: 'name', width: 150 },
      //   { title: 'Age', field: 'age' },
      //   { title: 'Favourite Color', field: 'col' },
      //   {
      //     title: 'Date Of Birth',
      //     field: 'dob',
      //     sorter: 'date',
      //     hozAlign: 'center',
      //   },
      // ],
    });

    this.table?.setData;
  });

  get data() {
    const d = this.args.tableData;
    this.table?.setData(d);
    return d;
  }

  <template>
    {{!prettier-ignore}}
    <style>
      .my-tabulator {
        overflow: hidden;
      }
    </style>
    <div ...attributes>
      <span>{{this.data.length}}</span>
      <div class="my-tabulator" {{this.tableMe}}>
      </div>

    </div>
    Sup
  </template>
}
