import { gql } from 'glimmer-apollo';


export const GET_USERS = gql`
  query users {
    users {
      id
      username
    }
  }
`;

export const GET_TRACKED_DAYS_BY_MONTH = gql`
  query trackedDaysForMonth($month: Int) {
    trackedDaysForMonth(month: $month) {
      id
      date
    }
  }
`;
