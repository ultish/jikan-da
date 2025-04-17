import { gql } from 'glimmer-apollo';

export const GET_PETS = gql`
  query pets {
    pets {
      id
      name
      __typename
      ... on Cat {
        lives
      }
      ... on Dog {
        chicken
      }
    }
  }
`;

export const CatFragment = gql`
  fragment CatFragment on Cat {
    ... on Cat {
      id
      name
      lives
    }
  }
`;
export const DogFragment = gql`
  fragment DogFragment on Dog {
    ... on Dog {
      id
      name
      chicken
    }
  }
`;

export const GET_PETS_FRAG = gql`
  query petsFrag {
    pets {
      id
      name
      ... on Cat {
        ...CatFragment
      }
      ... on Dog {
        ...DogFragment
      }
    }
  }
  ${CatFragment}, ${DogFragment}
`;
