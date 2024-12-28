import { gql } from 'glimmer-apollo';

export const GET_QUICK_ACTIONS = gql`
  query quickActions {
    quickActions {
      id
      name
      description
      chargeCodes {
        id
        name
      }
      timeSlots
    }
  }
`;

export const CREATE_QUICK_ACTION = gql`
  mutation createQuickAction(
    $name: String!
    $description: String
    $chargeCodeIds: [ID!]
    $timeSlots: [Int!]
  ) {
    createQuickAction(
      name: $name
      description: $description
      chargeCodeIds: $chargeCodeIds
      timeSlots: $timeSlots
    ) {
      id
      name
      description
      chargeCodes {
        id
        name
      }
      timeSlots
    }
  }
`;

export const DELETE_QUICK_ACTION = gql`
  mutation deleteQuickAction($id: ID!) {
    deleteQuickAction(id: $id)
  }
`;
