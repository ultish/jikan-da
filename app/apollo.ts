// needed for Vite + glimmer-apollo, see https://github.com/josemarluedke/glimmer-apollo/issues/97
import 'glimmer-apollo/environment-ember';

import { setClient } from 'glimmer-apollo';
import {
  ApolloClient,
  InMemoryCache,
  split,
  HttpLink,
} from '@apollo/client/core';
import { getMainDefinition } from '@apollo/client/utilities';
import { GraphQLWsLink } from '@apollo/client/link/subscriptions';
import { createClient } from 'graphql-ws';

export default function setupApolloClient(context: object): void {
  // WebSocket connection to the API
  const wsLink = new GraphQLWsLink(
    createClient({
      url: 'ws://localhost:8080/graphql',

      // this is used to add user-id to the websocket header on init
      connectionParams: () => {
        return {
          headers: {
            'user-id': '6768f8e49ce0e819a8f73dfb',
          },
        };
      },
    })
  );

  // HTTP connection to the API
  const httpLink = new HttpLink({
    uri: 'http://localhost:8080/graphql',
    headers: {
      'user-id': '6768f8e49ce0e819a8f73dfb',
    },
  });

  // Cache implementation
  const cache = new InMemoryCache();

  // Split HTTP link and WebSockete link
  const splitLink = split(
    ({ query }) => {
      const definition = getMainDefinition(query);
      return (
        definition.kind === 'OperationDefinition' &&
        definition.operation === 'subscription'
      );
    },
    wsLink,
    httpLink
  );

  // Create the apollo client
  const apolloClient = new ApolloClient({
    link: splitLink,
    cache,
  });

  // Set default apollo client for Glimmer Apollo
  setClient(context, apolloClient);
}
