import Route from '@ember/routing/route';
import { GET_TRACKED_DAY_BY_ID } from 'jikan-da/graphql/tracked-days';
import type {
  TrackedDayQuery,
  QueryTrackedDayArgs,
} from 'jikan-da/graphql/types/graphql';
import { useQuery } from 'glimmer-apollo';

import type RouterService from '@ember/routing/router-service';
import { inject as service } from '@ember/service';
import type AuthService from 'jikan-da/services/auth';

export default class TimeTrackingDayRoute extends Route {
  @service declare auth: AuthService;
  @service declare router: RouterService;

  async beforeModel() {
    if (!this.auth.isAuthenticated) {
      console.log('not authenticated');
      this.router.transitionTo('application');
    }
  }

  async model(params: { id: string }) {
    // can still use glimmer-apollo in routes if you so choose. May not make
    // total sense as glimmer-apollo is deisgned around reactivity
    const q = useQuery<TrackedDayQuery, QueryTrackedDayArgs>(this, () => [
      GET_TRACKED_DAY_BY_ID,
      {
        variables: { id: params.id },
      },
    ]);

    await q.promise;
    return q;
  }
}
