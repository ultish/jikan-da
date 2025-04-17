import { action } from '@ember/object';
import Component from '@glimmer/component';
import { useQuery } from 'glimmer-apollo';
import { GET_PETS, GET_PETS_FRAG } from 'jikan-da/graphql/pets';
import {
  type Cat,
  type Dog,
  type Pet,
  type PetsFragQuery,
  type PetsQuery,
} from 'jikan-da/graphql/types/graphql';

export default class Pets extends Component {
  pets = useQuery<PetsQuery>(this, () => [GET_PETS]);

  petsFrag = useQuery<PetsFragQuery>(this, () => [GET_PETS_FRAG]);

  get petsData() {
    return this.pets.data?.pets ?? [];
  }

  get petFragData() {
    return this.petsFrag.data?.pets ?? [];
  }

  get petsCount() {
    return this.pets.data?.pets?.length ?? 0;
  }

  get petsLoading() {
    return this.pets.loading;
  }
  get petsError() {
    return this.pets.error;
  }

  @action
  petData(pet: Pet) {
    console.log('petData', pet);
    if (pet.__typename == 'Cat') {
      return (pet as Cat).lives;
    } else if (pet.__typename == 'Dog') {
      return (pet as Dog).chicken;
    }
  }

  <template>
    <div class="prose prose:xl">
      <h1>
        Pets
      </h1>

      {{#if this.petsLoading}}
        <p>
          Loading...
        </p>
      {{else}}
        {{#each this.petsData key="id" as |pet|}}
          <div>
            <h4>
              {{pet.name}}
            </h4>

            {{this.petData pet}}
          </div>
        {{/each}}
      {{/if}}

      <h1>
        Fragment
      </h1>
      {{#each this.petFragData key="id" as |pet|}}
        <div>
          <h4>
            {{pet.name}}
          </h4>

          {{this.petData pet}}
        </div>
      {{/each}}
    </div>
  </template>
}
