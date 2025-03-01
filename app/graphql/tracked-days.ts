import { gql } from 'glimmer-apollo';

// export const GET_USERS = gql`
//   query users {
//     users {
//       id
//       username
//     }
//   }
// `;

export const GET_TRACKED_DAYS = gql`
  query trackedDays {
    trackedDays {
      id
      date
      week
      year
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

export const DELETE_TRACKED_DAY = gql`
  mutation deleteTrackedDay($id: ID!) {
    deleteTrackedDay(id: $id)
  }
`;

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
