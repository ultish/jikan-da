// needed for Vite + glimmer-apollo, see https://github.com/josemarluedke/glimmer-apollo/issues/97
import 'glimmer-apollo/environment-ember';
import config from 'jikan-da/config/environment';

import { setClient } from 'glimmer-apollo';
import {
  ApolloClient,
  InMemoryCache,
  split,
  HttpLink,
  type Operation,
  type FetchResult,
  ApolloLink,
} from '@apollo/client/core';

import { print } from '@apollo/client/utilities/index';
import { getMainDefinition, Observable } from '@apollo/client/utilities';
import { GraphQLWsLink } from '@apollo/client/link/subscriptions';
import { createClient } from 'graphql-ws';
import { createClient as createSseClient } from 'graphql-sse';
import type { ExecutionResult } from 'graphql';

export default function setupApolloClient(
  context: object,
  authToken: string
): void {
  const sseClient = createSseClient({
    url: config.sseURL,
    // optional parameters
    headers: {
      Accept: 'text/event-stream',
      Connection: 'keep-alive',
      'Cache-Control': 'no-cache',
      Authorization: `Bearer ${authToken}`,
    },
  });

  // WebSocket connection to the API
  // const wsLink = new GraphQLWsLink(
  //   createClient({
  //     url: config.websocketURL,

  //     // this is used to add user-id/Authorization to the websocket header on init as the websocket conn doesn't allow custom headers
  //     connectionParams: () => {
  //       return {
  //         headers: {
  //           // 'user-id': '6768f8e49ce0e819a8f73dfb',
  //         },
  //         Authorization: `Bearer ${authToken}`,
  //       };
  //     },
  //   })
  // );
  // HTTP connection to the API
  const httpLink = new HttpLink({
    uri: config.serverURL,
    headers: {
      // 'user-id': '6768f8e49ce0e819a8f73dfb',
      Authorization: `Bearer ${authToken}`,
    },
  });

  // Cache implementation
  const cache = new InMemoryCache();

  // Create a custom SSE link extending ApolloLink
  const sseLink = new ApolloLink((operation: Operation) => {
    return new Observable<FetchResult>((observer: any) => {
      const unsubscribe = sseClient.subscribe(
        {
          ...operation,
          query: print(operation.query),
        },
        {
          next: (data) => observer.next(data),
          error: (error) => observer.error(error),
          complete: () => observer.complete(),
        }
      );
      return () => unsubscribe();
    });
  });

  // Split HTTP link and WebSockete link
  const splitLink = split(
    ({ query }) => {
      const definition = getMainDefinition(query);
      return (
        definition.kind === 'OperationDefinition' &&
        definition.operation === 'subscription'
      );
    },
    sseLink,
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
