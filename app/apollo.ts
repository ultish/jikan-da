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

const token =
  'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJMVlBNelVIbW9IT0NMOWY0cm53d2diV0NYMk0wWlRoUExmc1l5TW5LVHc4In0.eyJleHAiOjE3NjEzNjgzOTMsImlhdCI6MTczNTQ0ODM5MywiYXV0aF90aW1lIjoxNzM1NDQ4MzkzLCJqdGkiOiIzOWQ3OWRjYS02ZWZjLTQ0ZDYtYWM4ZC1iN2ViZWY3MWE4MWMiLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDoxODQ0My9yZWFsbXMvanhodWkiLCJhdWQiOiJhY2NvdW50Iiwic3ViIjoiYTQ3YWY3NjgtYWMyOS00NmIzLTkzZTctZmJkOGNkYTA0ZjdkIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoianhodWkiLCJzaWQiOiI5YjNjOWZmZS1mMDUxLTQwNDMtOGE5NC1kMmQ5MDIwNjYxMTYiLCJhY3IiOiIxIiwiYWxsb3dlZC1vcmlnaW5zIjpbIioiXSwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJkZWZhdWx0LXJvbGVzLWppa2FuLWRhIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsianhodWkiOnsicm9sZXMiOlsiY2xpZW50LXRlc3RlciJdfSwiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwicm9sZXMiOlsiY2xpZW50LXRlc3RlciJdLCJuYW1lIjoiSmltbXkgSHVpIiwicHJlZmVycmVkX3VzZXJuYW1lIjoianhodWkiLCJnaXZlbl9uYW1lIjoiSmltbXkiLCJmYW1pbHlfbmFtZSI6Ikh1aSIsImVtYWlsIjoidWx0aXNoQGdtYWlsLmNvbSIsInVzZXJuYW1lIjoianhodWkiLCJ4NTA5X2RuIjoiQ049cm9vdCwgTz1qeGh1aSwgU1Q9U29tZS1TdGF0ZSwgQz1BVSJ9.kfKiGlue2WT35nfObOhASqTNY_rT31oBmuwH4NOw3jc9f3KlTK35pTZH7J65LwifHIMdKLMS0tNVOeCTIUEPpsrBNSaKk2mFpXFBK3w6_Y6MsdhzNJo6hVNnMC48es1yxvIboD-AAhE4srd2KpOh2nhDXbNuvTfYUCXHFezyoQRNWFoUGvMiU5qGe_KvwVJXB6x3gc7N7pba9jyiWQVdWUgAKJfvwsHrQrzrZMYDWQcfPshYMaPHckJygLr-iRXXOESsvSUEyoCJf0DnESzQvPkuBl9PtRVpcovvMmrW8gw8MzDRGAbmx8aqewRljLNbqytBrlNTNsIlE3uP658NMQ';

export default function setupApolloClient(
  context: object,
  authToken: string
): void {
  // WebSocket connection to the API
  const wsLink = new GraphQLWsLink(
    createClient({
      url: 'ws://localhost:8080/graphql',

      // this is used to add user-id/Authorization to the websocket header on init as the websocket conn doesn't allow custom headers
      connectionParams: () => {
        return {
          headers: {
            // 'user-id': '6768f8e49ce0e819a8f73dfb',
          },
          Authorization: `Bearer ${token}`,
        };
      },
    })
  );

  // HTTP connection to the API
  const httpLink = new HttpLink({
    uri: 'http://localhost:8080/graphql',
    headers: {
      // 'user-id': '6768f8e49ce0e819a8f73dfb',
      Authorization: `Bearer ${token}`,
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
