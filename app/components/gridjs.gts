import { Grid } from 'gridjs';
import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';

export default class Gridjs extends Component {
  tableMe = modifier((e: HTMLElement) => {
    const grid = new Grid({
      columns: [
        {
          name: 'Name',
          formatter: (cell) => `Name: ${cell}`,
        },
        'Email',
        'Phone Number',
      ],
      data: [
        ['John', 'john@example.com', '(353) 01 222 3333'],
        ['Mark', 'mark@gmail.com', '(01) 22 888 4444'],
      ],
    });

    grid.render(e);
  });

  <template><div {{this.tableMe}} /></template>
}
