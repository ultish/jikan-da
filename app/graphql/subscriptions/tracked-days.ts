import { gql } from 'glimmer-apollo';

export const SUBSCRIBE_TRACKED_DAY_CHANGES = gql`
  subscription trackedDayChanged($month: Int, $year: Int) {
    trackedDayChanged(month: $month, year: $year) {
      id
      date
      mode
      week
      year
    }
  }
`;
