import Route from '@ember/routing/route';
import { GET_TRACKED_DAY_BY_ID } from 'jikan-da/graphql/queries/tracked-days';
import type {
  TrackedDayQuery,
  QueryTrackedDayArgs,
} from 'jikan-da/graphql/types/graphql';
import { useQuery } from 'glimmer-apollo';

export default class TimeTrackingDayRoute extends Route {
  async model(params: { id: string }) {
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
