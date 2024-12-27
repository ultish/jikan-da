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
    "\n  query chargeCodes {\n    chargeCodes {\n      id\n      name\n      code\n      description\n      expired\n      group\n      sortOrder\n    }\n  }\n": types.ChargeCodesDocument,
    "\n  mutation createChargeCode(\n    $name: String!\n    $code: String!\n    $description: String\n    $expired: Boolean\n    $group: String\n    $sortOrder: Int\n  ) {\n    createChargeCode(\n      name: $name\n      code: $code\n      description: $description\n      expired: $expired\n      group: $group\n      sortOrder: $sortOrder\n    ) {\n      id\n      name\n      code\n      description\n      expired\n      group\n      sortOrder\n    }\n  }\n": types.CreateChargeCodeDocument,
    "\n  mutation updateChargeCode(\n    $id: ID!\n    $name: String\n    $code: String\n    $description: String\n    $expired: Boolean\n    $group: String\n    $sortOrder: Int\n  ) {\n    updateChargeCode(\n      id: $id\n      name: $name\n      code: $code\n      description: $description\n      expired: $expired\n      group: $group\n      sortOrder: $sortOrder\n    ) {\n      id\n      name\n      code\n      description\n      expired\n      group\n      sortOrder\n    }\n  }\n": types.UpdateChargeCodeDocument,
    "\n  query timeChargeTotals($weekOfYear: WeekOfYear) {\n    timeChargeTotals(weekOfYear: $weekOfYear) {\n      id\n      value\n      chargeCode {\n        id\n        name\n        sortOrder\n      }\n      trackedDay {\n        id\n        date\n        week\n      }\n    }\n  }\n": types.TimeChargeTotalsDocument,
    "\n  subscription timeChargeTotalsChanged {\n    timeChargeTotalsChanged {\n      id\n      value\n    }\n  }\n": types.TimeChargeTotalsChangedDocument,
    "\n  query trackedDay($id: ID!) {\n    trackedDay(id: $id) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.TrackedDayDocument,
    "\n  query trackedDaysForMonthYear($month: Int, $year: Int) {\n    trackedDaysForMonthYear(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.TrackedDaysForMonthYearDocument,
    "\n  mutation createTrackedDay($date: Float!, $mode: String) {\n    createTrackedDay(date: $date, mode: $mode) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.CreateTrackedDayDocument,
    "\n  mutation deleteTrackedDay($id: ID!) {\n    deleteTrackedDay(id: $id)\n  }\n": types.DeleteTrackedDayDocument,
    "\n  subscription trackedDayChanged($month: Int, $year: Int) {\n    trackedDayChanged(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n": types.TrackedDayChangedDocument,
    "\n  query trackedTasks($trackedDayId: ID) {\n    trackedTasks(trackedDayId: $trackedDayId) {\n      id\n      notes\n      timeSlots\n      chargeCodes {\n        id\n        name\n      }\n    }\n  }\n": types.TrackedTasksDocument,
    "\n  mutation createTrackedTask($trackedDayId: ID!) {\n    createTrackedTask(trackedDayId: $trackedDayId) {\n      id\n      notes\n      timeSlots\n      chargeCodes {\n        id\n        name\n      }\n    }\n  }\n": types.CreateTrackedTaskDocument,
    "\n  mutation updateTrackedTask(\n    $id: ID!\n    $notes: String\n    $chargeCodeIds: [ID!]\n    $timeSlots: [Int!]\n  ) {\n    updateTrackedTask(\n      id: $id\n      notes: $notes\n      chargeCodeIds: $chargeCodeIds\n      timeSlots: $timeSlots\n    ) {\n      id\n      notes\n      timeSlots\n      chargeCodes {\n        id\n        name\n      }\n    }\n  }\n": types.UpdateTrackedTaskDocument,
    "\n  mutation deleteTrackedTask($id: ID!) {\n    deleteTrackedTask(id: $id)\n  }\n": types.DeleteTrackedTaskDocument,
};

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query chargeCodes {\n    chargeCodes {\n      id\n      name\n      code\n      description\n      expired\n      group\n      sortOrder\n    }\n  }\n"): typeof import('./graphql').ChargeCodesDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation createChargeCode(\n    $name: String!\n    $code: String!\n    $description: String\n    $expired: Boolean\n    $group: String\n    $sortOrder: Int\n  ) {\n    createChargeCode(\n      name: $name\n      code: $code\n      description: $description\n      expired: $expired\n      group: $group\n      sortOrder: $sortOrder\n    ) {\n      id\n      name\n      code\n      description\n      expired\n      group\n      sortOrder\n    }\n  }\n"): typeof import('./graphql').CreateChargeCodeDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation updateChargeCode(\n    $id: ID!\n    $name: String\n    $code: String\n    $description: String\n    $expired: Boolean\n    $group: String\n    $sortOrder: Int\n  ) {\n    updateChargeCode(\n      id: $id\n      name: $name\n      code: $code\n      description: $description\n      expired: $expired\n      group: $group\n      sortOrder: $sortOrder\n    ) {\n      id\n      name\n      code\n      description\n      expired\n      group\n      sortOrder\n    }\n  }\n"): typeof import('./graphql').UpdateChargeCodeDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query timeChargeTotals($weekOfYear: WeekOfYear) {\n    timeChargeTotals(weekOfYear: $weekOfYear) {\n      id\n      value\n      chargeCode {\n        id\n        name\n        sortOrder\n      }\n      trackedDay {\n        id\n        date\n        week\n      }\n    }\n  }\n"): typeof import('./graphql').TimeChargeTotalsDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  subscription timeChargeTotalsChanged {\n    timeChargeTotalsChanged {\n      id\n      value\n    }\n  }\n"): typeof import('./graphql').TimeChargeTotalsChangedDocument;
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
export function graphql(source: "\n  mutation createTrackedDay($date: Float!, $mode: String) {\n    createTrackedDay(date: $date, mode: $mode) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n"): typeof import('./graphql').CreateTrackedDayDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation deleteTrackedDay($id: ID!) {\n    deleteTrackedDay(id: $id)\n  }\n"): typeof import('./graphql').DeleteTrackedDayDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  subscription trackedDayChanged($month: Int, $year: Int) {\n    trackedDayChanged(month: $month, year: $year) {\n      id\n      date\n      mode\n      week\n      year\n    }\n  }\n"): typeof import('./graphql').TrackedDayChangedDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  query trackedTasks($trackedDayId: ID) {\n    trackedTasks(trackedDayId: $trackedDayId) {\n      id\n      notes\n      timeSlots\n      chargeCodes {\n        id\n        name\n      }\n    }\n  }\n"): typeof import('./graphql').TrackedTasksDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation createTrackedTask($trackedDayId: ID!) {\n    createTrackedTask(trackedDayId: $trackedDayId) {\n      id\n      notes\n      timeSlots\n      chargeCodes {\n        id\n        name\n      }\n    }\n  }\n"): typeof import('./graphql').CreateTrackedTaskDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation updateTrackedTask(\n    $id: ID!\n    $notes: String\n    $chargeCodeIds: [ID!]\n    $timeSlots: [Int!]\n  ) {\n    updateTrackedTask(\n      id: $id\n      notes: $notes\n      chargeCodeIds: $chargeCodeIds\n      timeSlots: $timeSlots\n    ) {\n      id\n      notes\n      timeSlots\n      chargeCodes {\n        id\n        name\n      }\n    }\n  }\n"): typeof import('./graphql').UpdateTrackedTaskDocument;
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "\n  mutation deleteTrackedTask($id: ID!) {\n    deleteTrackedTask(id: $id)\n  }\n"): typeof import('./graphql').DeleteTrackedTaskDocument;


export function graphql(source: string) {
  return (documents as any)[source] ?? {};
}
