import { h, Grid } from 'gridjs';
import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';
import { action } from '@ember/object';

interface Signature<T> {
  Args: {
    tableData: T[];
    columns: any[];
  };
  Blocks: {
    default: [];
  };
  Element: HTMLDivElement;
}
export default class Gridjs<T> extends Component<Signature<T>> {
  @action
  test() {
    console.log('test me', this, this.args.tableData);
  }

  tableMe = modifier((e: HTMLElement) => {
    const grid = new Grid({
      columns: [
        {
          name: 'Name',
          formatter: (cell) => `Name: ${cell}`,
        },
        'Email',
        'Phone Number',
        {
          name: 'Actions',
          formatter: (cell, row) => {
            return h(
              'button',
              {
                className: 'btn btn-sm btn-secondary',
                onClick: () => {
                  console.log(cell, row);
                  // this is rendered using preact, but still have access to ember action
                  this.test();
                },
              },
              'Edit'
            );
          },
        },
      ],
      data: [
        ['John', 'john@example.com', '(353) 01 222 3333'],
        ['Mark', 'mark@gmail.com', '(01) 22 888 4444'],
      ],
      sort: true,
      search: true,
      resizable: true,
    });

    grid.render(e);
  });

  <template><div {{this.tableMe}} /></template>
}
