import Component from '@glimmer/component';

export default class HelloComponent extends Component {
  get message() {
    return 'Hello, Glimmer!';
  }

  <template>
    <h1>{{this.message}}</h1>
  </template>
}
