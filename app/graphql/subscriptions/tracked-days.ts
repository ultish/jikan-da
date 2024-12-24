import { gql } from 'glimmer-apollo';

export const SUBSCRIBE_TRACKED_DAY_CHANGES = gql`
  subscription trackedDayChanged($month: Int, $year: Int, $userId: String!) {
    trackedDayChanged(month: $month, year: $year, userId: $userId) {
      id
      date
      mode
      week
      year
    }
  }
`;
