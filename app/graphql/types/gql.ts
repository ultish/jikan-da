/* eslint-disable */
import * as types from './graphql';



/**
 * Map of all GraphQL operations in the project.
 *
 * This map has several performance disadvantages:
 * 1. It is not tree-shakeable, so it will include all operations in the project.
 * 2. It is not minifiable, so the string of a GraphQL query will be multiple times inside the bundle.
 * 3. It does not support dead code elimination, so it will add unused operations.
 *
 * Therefore it is highly recommended to use the babel or swc plugin for production.
 * Learn more about it here: https://the-guild.dev/graphql/codegen/plugins/presets/preset-client#reducing-bundle-size
 */
const documents = {
    "\n  mutation createTrackedDay($date: Float!, $mode: String) {\n    createTrackedDay(date: $date, mode: $mode) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.CreateTrackedDayDocument,
    "\n  query users {\n    users {\n      id\n      username\n    }\n  }\n": types.UsersDocument,
    "\n  query trackedDay($id: ID!) {\n    trackedDay(id: $id) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.TrackedDayDocument,
    "\n  query trackedDaysForMonthYear($month: Int, $year: Int) {\n    trackedDaysForMonthYear(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.TrackedDaysForMonthYearDocument,
    "\n  subscription trackedDayChanged($month: Int, $year: Int) {\n    trackedDayChanged(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.TrackedDayChangedDocument,
};

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation createTrackedDay($date: Float!, $mode: String) {\n    createTrackedDay(date: $date, mode: $mode) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n"): typeof import('./graphql').CreateTrackedDayDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query users {\n    users {\n      id\n      username\n    }\n  }\n"): typeof import('./graphql').UsersDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query trackedDay($id: ID!) {\n    trackedDay(id: $id) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n"): typeof import('./graphql').TrackedDayDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query trackedDaysForMonthYear($month: Int, $year: Int) {\n    trackedDaysForMonthYear(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n"): typeof import('./graphql').TrackedDaysForMonthYearDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  subscription trackedDayChanged($month: Int, $year: Int) {\n    trackedDayChanged(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n"): typeof import('./graphql').TrackedDayChangedDocument;


export function graphql(source: string) {
  return (documents as any)[source] ?? {};
}
