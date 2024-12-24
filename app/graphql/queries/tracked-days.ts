import { gql } from 'glimmer-apollo';


export const GET_USERS = gql`
  query users {
    users {
      id
      username
    }
  }
`;

export const GET_TRACKED_DAY_BY_ID = gql`
  query trackedDay($id: ID!) {
    trackedDay(id: $id) {
      id
      date
      mode
      week
      year
    }
  }
`;

export const GET_TRACKED_DAYS_BY_MONTH_YEAR = gql`
  query trackedDaysForMonthYear($month: Int, $year: Int) {
    trackedDaysForMonthYear(month: $month, year: $year) {
      id
      date
      mode
      week
      year
    }
  }
`;
