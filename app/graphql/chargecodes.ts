import { gql } from 'glimmer-apollo';

export const GET_CHARGE_CODES = gql`
  query chargeCodes {
    chargeCodes {
      id
      name
      code
      description
      expired
      group
      sortOrder
    }
  }
`;

export const CREATE_CHARGE_CODE = gql`
  mutation createChargeCode(
    $name: String!
    $code: String!
    $description: String
    $expired: Boolean
    $group: String
    $sortOrder: Int
  ) {
    createChargeCode(
      name: $name
      code: $code
      description: $description
      expired: $expired
      group: $group
      sortOrder: $sortOrder
    ) {
      id
      name
      code
      description
      expired
      group
      sortOrder
    }
  }
`;

export const UPDATE_CHARGE_CODE = gql`
  mutation updateChargeCode(
    $id: ID!
    $name: String
    $code: String
    $description: String
    $expired: Boolean
    $group: String
    $sortOrder: Int
  ) {
    updateChargeCode(
      id: $id
      name: $name
      code: $code
      description: $description
      expired: $expired
      group: $group
      sortOrder: $sortOrder
    ) {
      id
      name
      code
      description
      expired
      group
      sortOrder
    }
  }
`;
