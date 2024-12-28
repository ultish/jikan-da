import { gql } from 'glimmer-apollo';

export const GET_TRACKED_TASKS = gql`
  query trackedTasks($trackedDayId: ID) {
    trackedTasks(trackedDayId: $trackedDayId) {
      id
      notes
      timeSlots
      chargeCodes {
        id
        name
      }
    }
  }
`;

export const CREATE_TRACKED_TASK = gql`
  mutation createTrackedTask(
    $trackedDayId: ID!
    $notes: String
    $chargeCodeIds: [ID!]
    $timeSlots: [Int!]
  ) {
    createTrackedTask(
      trackedDayId: $trackedDayId
      notes: $notes
      chargeCodeIds: $chargeCodeIds
      timeSlots: $timeSlots
    ) {
      id
      notes
      timeSlots
      chargeCodes {
        id
        name
      }
    }
  }
`;

export const UPDATE_TRACKED_TASK = gql`
  mutation updateTrackedTask(
    $id: ID!
    $notes: String
    $chargeCodeIds: [ID!]
    $timeSlots: [Int!]
  ) {
    updateTrackedTask(
      id: $id
      notes: $notes
      chargeCodeIds: $chargeCodeIds
      timeSlots: $timeSlots
    ) {
      id
      notes
      timeSlots
      chargeCodes {
        id
        name
      }
    }
  }
`;

export const DELETE_TRACKED_TASK = gql`
  mutation deleteTrackedTask($id: ID!) {
    deleteTrackedTask(id: $id)
  }
`;
