import { gql } from 'glimmer-apollo';

export const SUBSCRIBE_TRACKED_DAY_CHANGES = gql`
  subscription trackedDayChanged($userId: String!) {
    trackedDayChanged(userId: $userId) {
      id
      date
      mode
      week
      year
    }
  }
`;
