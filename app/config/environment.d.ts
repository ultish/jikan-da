/**
 * Type declarations for
 *    import config from 'jikan-da/config/environment'
 */
declare const config: {
  environment: string;
  modulePrefix: string;
  podModulePrefix: string;
  locationType: 'history' | 'hash' | 'none';
  rootURL: string;
  APP: Record<string, unknown>;
  ignoreSecurity: boolean;
  serverURL: string;
  websocketURL: string;
  sseURL: string;
  keycloakURL: string;
};

export default config;
