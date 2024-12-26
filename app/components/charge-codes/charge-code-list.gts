import Component from '@glimmer/component';
import type {
  ChargeCode,
  ChargeCodesQuery,
  MutationUpdateTrackedTaskArgs,
  QueryChargeCodesArgs,
  QueryTrackedTasksArgs,
  TrackedDay,
  TrackedTask,
  TrackedTasksQuery,
  UpdateTrackedTaskMutation,
} from 'jikan-da/graphql/types/graphql';

import PhKanban from 'ember-phosphor-icons/components/ph-kanban';
import PhLightning from 'ember-phosphor-icons/components/ph-lightning';

import dayjs from 'dayjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

import { useMutation, useQuery } from 'glimmer-apollo';
import {
  GET_TRACKED_TASKS,
  UPDATE_TRACKED_TASK,
} from 'jikan-da/graphql/tracked-tasks/gql';

import { scaleTime } from 'd3-scale';
import { modifier } from 'ember-modifier';
import { inject as service } from '@ember/service';
import type Prefs from 'jikan-da/services/prefs';
import { fn } from '@ember/helper';

import { cached, localCopy } from 'tracked-toolbox';
import TooManyChoices from 'jikan-da/components/choices';
import { GET_CHARGE_CODES } from 'jikan-da/graphql/chargecodes';
import PhPencil from 'ember-phosphor-icons/components/ph-pencil';

interface Signature {
  Args: {};
  Blocks: {
    default: {};
  };
  Element: HTMLDivElement;
}

export default class ChargeCodeList extends Component<Signature> {
  chargeCodesQuery = useQuery<ChargeCodesQuery, QueryChargeCodesArgs>(
    this,
    () => [GET_CHARGE_CODES]
  );

  get chargeCodes() {
    return this.chargeCodesQuery.data?.chargeCodes ?? [];
  }

  <template>
    {{!prettier-ignore}}
    <style>
    </style>

    {{#each this.chargeCodes as |cc|}}
      {{cc.name}}
    {{/each}}
  </template>
}
