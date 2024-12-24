import { gql } from 'glimmer-apollo';


export const CREATE_TRACKED_DAY = gql`
  mutation createTrackedDay($date: Float!, $mode: String) {
    createTrackedDay(date: $date, mode: $mode) {
      id
      date
      mode
      week
      year
    }
  }
`;
