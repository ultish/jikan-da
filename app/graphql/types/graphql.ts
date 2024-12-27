/* eslint-disable */
import type { DocumentTypeDecoration } from '@graphql-typed-document-node/core';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
  _FieldSet: { input: any; output: any; }
};

export type ChargeCode = {
  __typename?: 'ChargeCode';
  code: Scalars['String']['output'];
  description?: Maybe<Scalars['String']['output']>;
  expired: Scalars['Boolean']['output'];
  group?: Maybe<Scalars['String']['output']>;
  id: Scalars['ID']['output'];
  name: Scalars['String']['output'];
  sortOrder?: Maybe<Scalars['Int']['output']>;
};

export enum DayMode {
  HolAnnual = 'HOL_ANNUAL',
  HolPersonal = 'HOL_PERSONAL',
  HolPublic = 'HOL_PUBLIC',
  HolRdo = 'HOL_RDO',
  Normal = 'NORMAL'
}

export enum ErrorDetail {
  /**
   * The deadline expired before the operation could complete.
   *
   * For operations that change the state of the system, this error
   * may be returned even if the operation has completed successfully.
   * For example, a successful response from a server could have been
   * delayed long enough for the deadline to expire.
   *
   * HTTP Mapping: 504 Gateway Timeout
   * Error Type: UNAVAILABLE
   */
  DeadlineExceeded = 'DEADLINE_EXCEEDED',
  /**
   * The server detected that the client is exhibiting a behavior that
   * might be generating excessive load.
   *
   * HTTP Mapping: 429 Too Many Requests or 420 Enhance Your Calm
   * Error Type: UNAVAILABLE
   */
  EnhanceYourCalm = 'ENHANCE_YOUR_CALM',
  /**
   * The requested field is not found in the schema.
   *
   * This differs from `NOT_FOUND` in that `NOT_FOUND` should be used when a
   * query is valid, but is unable to return a result (if, for example, a
   * specific video id doesn't exist). `FIELD_NOT_FOUND` is intended to be
   * returned by the server to signify that the requested field is not known to exist.
   * This may be returned in lieu of failing the entire query.
   * See also `PERMISSION_DENIED` for cases where the
   * requested field is invalid only for the given user or class of users.
   *
   * HTTP Mapping: 404 Not Found
   * Error Type: BAD_REQUEST
   */
  FieldNotFound = 'FIELD_NOT_FOUND',
  /**
   * The client specified an invalid argument.
   *
   * Note that this differs from `FAILED_PRECONDITION`.
   * `INVALID_ARGUMENT` indicates arguments that are problematic
   * regardless of the state of the system (e.g., a malformed file name).
   *
   * HTTP Mapping: 400 Bad Request
   * Error Type: BAD_REQUEST
   */
  InvalidArgument = 'INVALID_ARGUMENT',
  /**
   * The provided cursor is not valid.
   *
   * The most common usage for this error is when a client is paginating
   * through a list that uses stateful cursors. In that case, the provided
   * cursor may be expired.
   *
   * HTTP Mapping: 404 Not Found
   * Error Type: NOT_FOUND
   */
  InvalidCursor = 'INVALID_CURSOR',
  /**
   * Unable to perform operation because a required resource is missing.
   *
   * Example: Client is attempting to refresh a list, but the specified
   * list is expired. This requires an action by the client to get a new list.
   *
   * If the user is simply trying GET a resource that is not found,
   * use the NOT_FOUND error type. FAILED_PRECONDITION.MISSING_RESOURCE
   * is to be used particularly when the user is performing an operation
   * that requires a particular resource to exist.
   *
   * HTTP Mapping: 400 Bad Request or 500 Internal Server Error
   * Error Type: FAILED_PRECONDITION
   */
  MissingResource = 'MISSING_RESOURCE',
  /**
   * Service Error.
   *
   * There is a problem with an upstream service.
   *
   * This may be returned if a gateway receives an unknown error from a service
   * or if a service is unreachable.
   * If a request times out which waiting on a response from a service,
   * `DEADLINE_EXCEEDED` may be returned instead.
   * If a service returns a more specific error Type, the specific error Type may
   * be returned instead.
   *
   * HTTP Mapping: 502 Bad Gateway
   * Error Type: UNAVAILABLE
   */
  ServiceError = 'SERVICE_ERROR',
  /**
   * Request failed due to network errors.
   *
   * HTTP Mapping: 503 Unavailable
   * Error Type: UNAVAILABLE
   */
  TcpFailure = 'TCP_FAILURE',
  /**
   * Request throttled based on server concurrency limits.
   *
   * HTTP Mapping: 503 Unavailable
   * Error Type: UNAVAILABLE
   */
  ThrottledConcurrency = 'THROTTLED_CONCURRENCY',
  /**
   * Request throttled based on server CPU limits
   *
   * HTTP Mapping: 503 Unavailable.
   * Error Type: UNAVAILABLE
   */
  ThrottledCpu = 'THROTTLED_CPU',
  /**
   * The operation is not implemented or is not currently supported/enabled.
   *
   * HTTP Mapping: 501 Not Implemented
   * Error Type: BAD_REQUEST
   */
  Unimplemented = 'UNIMPLEMENTED',
  /**
   * Unknown error.
   *
   * This error should only be returned when no other error detail applies.
   * If a client sees an unknown errorDetail, it will be interpreted as UNKNOWN.
   *
   * HTTP Mapping: 500 Internal Server Error
   */
  Unknown = 'UNKNOWN'
}

export enum ErrorType {
  /**
   * Bad Request.
   *
   * There is a problem with the request.
   * Retrying the same request is not likely to succeed.
   * An example would be a query or argument that cannot be deserialized.
   *
   * HTTP Mapping: 400 Bad Request
   */
  BadRequest = 'BAD_REQUEST',
  /**
   * The operation was rejected because the system is not in a state
   * required for the operation's execution.  For example, the directory
   * to be deleted is non-empty, an rmdir operation is applied to
   * a non-directory, etc.
   *
   * Service implementers can use the following guidelines to decide
   * between `FAILED_PRECONDITION` and `UNAVAILABLE`:
   *
   * - Use `UNAVAILABLE` if the client can retry just the failing call.
   * - Use `FAILED_PRECONDITION` if the client should not retry until
   * the system state has been explicitly fixed.  E.g., if an "rmdir"
   *      fails because the directory is non-empty, `FAILED_PRECONDITION`
   * should be returned since the client should not retry unless
   * the files are deleted from the directory.
   *
   * HTTP Mapping: 400 Bad Request or 500 Internal Server Error
   */
  FailedPrecondition = 'FAILED_PRECONDITION',
  /**
   * Internal error.
   *
   * An unexpected internal error was encountered. This means that some
   * invariants expected by the underlying system have been broken.
   * This error code is reserved for serious errors.
   *
   * HTTP Mapping: 500 Internal Server Error
   */
  Internal = 'INTERNAL',
  /**
   * The requested entity was not found.
   *
   * This could apply to a resource that has never existed (e.g. bad resource id),
   * or a resource that no longer exists (e.g. cache expired.)
   *
   * Note to server developers: if a request is denied for an entire class
   * of users, such as gradual feature rollout or undocumented allowlist,
   * `NOT_FOUND` may be used. If a request is denied for some users within
   * a class of users, such as user-based access control, `PERMISSION_DENIED`
   * must be used.
   *
   * HTTP Mapping: 404 Not Found
   */
  NotFound = 'NOT_FOUND',
  /**
   * The caller does not have permission to execute the specified
   * operation.
   *
   * `PERMISSION_DENIED` must not be used for rejections
   * caused by exhausting some resource or quota.
   * `PERMISSION_DENIED` must not be used if the caller
   * cannot be identified (use `UNAUTHENTICATED`
   * instead for those errors).
   *
   * This error Type does not imply the
   * request is valid or the requested entity exists or satisfies
   * other pre-conditions.
   *
   * HTTP Mapping: 403 Forbidden
   */
  PermissionDenied = 'PERMISSION_DENIED',
  /**
   * The request does not have valid authentication credentials.
   *
   * This is intended to be returned only for routes that require
   * authentication.
   *
   * HTTP Mapping: 401 Unauthorized
   */
  Unauthenticated = 'UNAUTHENTICATED',
  /**
   * Currently Unavailable.
   *
   * The service is currently unavailable.  This is most likely a
   * transient condition, which can be corrected by retrying with
   * a backoff.
   *
   * HTTP Mapping: 503 Unavailable
   */
  Unavailable = 'UNAVAILABLE',
  /**
   * Unknown error.
   *
   * For example, this error may be returned when
   * an error code received from another address space belongs to
   * an error space that is not known in this address space.  Also
   * errors raised by APIs that do not return enough error information
   * may be converted to this error.
   *
   * If a client sees an unknown errorType, it will be interpreted as UNKNOWN.
   * Unknown errors MUST NOT trigger any special behavior. These MAY be treated
   * by an implementation as being equivalent to INTERNAL.
   *
   * When possible, a more specific error should be provided.
   *
   * HTTP Mapping: 520 Unknown Error
   */
  Unknown = 'UNKNOWN'
}

export type Mutation = {
  __typename?: 'Mutation';
  createChargeCode?: Maybe<ChargeCode>;
  createTrackedDay?: Maybe<TrackedDay>;
  createTrackedTask: TrackedTask;
  createUser?: Maybe<User>;
  deleteChargeCode?: Maybe<Scalars['Boolean']['output']>;
  deleteTrackedDay?: Maybe<Scalars['Boolean']['output']>;
  deleteTrackedTask?: Maybe<Scalars['Boolean']['output']>;
  deleteUser?: Maybe<Scalars['Boolean']['output']>;
  updateChargeCode?: Maybe<ChargeCode>;
  updateTrackedDay?: Maybe<TrackedDay>;
  updateTrackedTask: TrackedTask;
  updateUser?: Maybe<User>;
};


export type MutationCreateChargeCodeArgs = {
  code: Scalars['String']['input'];
  description?: InputMaybe<Scalars['String']['input']>;
  expired?: InputMaybe<Scalars['Boolean']['input']>;
  group?: InputMaybe<Scalars['String']['input']>;
  name: Scalars['String']['input'];
  sortOrder?: InputMaybe<Scalars['Int']['input']>;
};


export type MutationCreateTrackedDayArgs = {
  date: Scalars['Float']['input'];
  mode?: InputMaybe<Scalars['String']['input']>;
};


export type MutationCreateTrackedTaskArgs = {
  notes?: InputMaybe<Scalars['String']['input']>;
  trackedDayId: Scalars['ID']['input'];
};


export type MutationCreateUserArgs = {
  password: Scalars['String']['input'];
  username: Scalars['String']['input'];
};


export type MutationDeleteChargeCodeArgs = {
  id: Scalars['ID']['input'];
};


export type MutationDeleteTrackedDayArgs = {
  id: Scalars['ID']['input'];
};


export type MutationDeleteTrackedTaskArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type MutationDeleteUserArgs = {
  username: Scalars['String']['input'];
};


export type MutationUpdateChargeCodeArgs = {
  code?: InputMaybe<Scalars['String']['input']>;
  description?: InputMaybe<Scalars['String']['input']>;
  expired?: InputMaybe<Scalars['Boolean']['input']>;
  group?: InputMaybe<Scalars['String']['input']>;
  id: Scalars['ID']['input'];
  name?: InputMaybe<Scalars['String']['input']>;
  sortOrder?: InputMaybe<Scalars['Int']['input']>;
};


export type MutationUpdateTrackedDayArgs = {
  date?: InputMaybe<Scalars['Float']['input']>;
  id: Scalars['ID']['input'];
  mode?: InputMaybe<DayMode>;
  trackedTaskIds?: InputMaybe<Array<Scalars['String']['input']>>;
};


export type MutationUpdateTrackedTaskArgs = {
  chargeCodeIds?: InputMaybe<Array<Scalars['ID']['input']>>;
  id: Scalars['ID']['input'];
  notes?: InputMaybe<Scalars['String']['input']>;
  timeSlots?: InputMaybe<Array<Scalars['Int']['input']>>;
};


export type MutationUpdateUserArgs = {
  trackedDayIds?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  userId: Scalars['ID']['input'];
};

export type PageInfo = {
  __typename?: 'PageInfo';
  endCursor?: Maybe<Scalars['String']['output']>;
  hasNextPage: Scalars['Boolean']['output'];
  hasPreviousPage: Scalars['Boolean']['output'];
  startCursor?: Maybe<Scalars['String']['output']>;
};

export type Query = {
  __typename?: 'Query';
  _service: _Service;
  chargeCodes?: Maybe<Array<ChargeCode>>;
  timeChargeTotals?: Maybe<Array<TimeChargeTotal>>;
  timeCharges?: Maybe<Array<TimeCharge>>;
  trackedDay?: Maybe<TrackedDay>;
  trackedDaysForMonthYear?: Maybe<Array<TrackedDay>>;
  trackedDaysPaginated?: Maybe<TrackedDayConnection>;
  trackedTask?: Maybe<TrackedTask>;
  trackedTasks?: Maybe<Array<TrackedTask>>;
  users?: Maybe<Array<User>>;
};


export type QueryChargeCodesArgs = {
  code?: InputMaybe<Scalars['String']['input']>;
  description?: InputMaybe<Scalars['String']['input']>;
  expired?: InputMaybe<Scalars['Boolean']['input']>;
  ids?: InputMaybe<Array<Scalars['ID']['input']>>;
  name?: InputMaybe<Scalars['String']['input']>;
};


export type QueryTimeChargeTotalsArgs = {
  weekOfYear?: InputMaybe<WeekOfYear>;
};


export type QueryTimeChargesArgs = {
  chargeCodeId?: InputMaybe<Scalars['ID']['input']>;
  timeSlot?: InputMaybe<Scalars['Int']['input']>;
  trackedDayId?: InputMaybe<Scalars['String']['input']>;
};


export type QueryTrackedDayArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};


export type QueryTrackedDaysForMonthYearArgs = {
  month?: InputMaybe<Scalars['Int']['input']>;
  year?: InputMaybe<Scalars['Int']['input']>;
};


export type QueryTrackedDaysPaginatedArgs = {
  after?: InputMaybe<Scalars['String']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
};


export type QueryTrackedTaskArgs = {
  trackedTaskId: Scalars['ID']['input'];
};


export type QueryTrackedTasksArgs = {
  trackedDayId?: InputMaybe<Scalars['ID']['input']>;
};


export type QueryUsersArgs = {
  username?: InputMaybe<Scalars['String']['input']>;
};

export type Subscription = {
  __typename?: 'Subscription';
  timeChargeTotalsChanged?: Maybe<TimeChargeTotal>;
  trackedDayChanged?: Maybe<TrackedDay>;
};


export type SubscriptionTrackedDayChangedArgs = {
  month?: InputMaybe<Scalars['Int']['input']>;
  year?: InputMaybe<Scalars['Int']['input']>;
};

/**
 *     updateTimeCharge(
 *         id: ID!,
 *         chargeCodeAppearance: Int,
 *         totalChargeCodesForSlot: Int
 *     ): TimeCharge!
 * }
 */
export type TimeCharge = {
  __typename?: 'TimeCharge';
  chargeCode?: Maybe<ChargeCode>;
  /** The number of times this charge code appears at this timeslot */
  chargeCodeAppearance?: Maybe<Scalars['Int']['output']>;
  id: Scalars['ID']['output'];
  timeSlot?: Maybe<Scalars['Int']['output']>;
  /** The number of chargecodes that appear across all tracked tasks at this timeslot */
  totalChargeCodesForSlot?: Maybe<Scalars['Int']['output']>;
  trackedDay?: Maybe<TrackedDay>;
};

/** This represents a single ChargeCode for a Tracked Day and the value for the timesheet */
export type TimeChargeTotal = {
  __typename?: 'TimeChargeTotal';
  chargeCode?: Maybe<ChargeCode>;
  id: Scalars['ID']['output'];
  trackedDay?: Maybe<TrackedDay>;
  user?: Maybe<User>;
  value?: Maybe<Scalars['Float']['output']>;
};

/**  each tracked day will have a max of 240 timeslots (if you work 24hrs!) */
export type TrackedDay = {
  __typename?: 'TrackedDay';
  date: Scalars['Float']['output'];
  id: Scalars['ID']['output'];
  mode: DayMode;
  timeChargeTotals?: Maybe<Array<TimeChargeTotal>>;
  timeCharges?: Maybe<Array<TimeCharge>>;
  trackedTasks?: Maybe<Array<TrackedTask>>;
  user?: Maybe<User>;
  week: Scalars['Int']['output'];
  year: Scalars['Int']['output'];
};

/**
 *  the @connection directive is meant to work but it clashes with dgs-codegen plugin (not supported yet, but there's
 *   an untouched PR...). For now, implementing the types manually here
 */
export type TrackedDayConnection = {
  __typename?: 'TrackedDayConnection';
  edges?: Maybe<Array<TrackedDayEdge>>;
  pageInfo: PageInfo;
};

export type TrackedDayEdge = {
  __typename?: 'TrackedDayEdge';
  cursor: Scalars['String']['output'];
  node?: Maybe<TrackedDay>;
};

export type TrackedTask = {
  __typename?: 'TrackedTask';
  chargeCodes?: Maybe<Array<ChargeCode>>;
  id: Scalars['ID']['output'];
  notes?: Maybe<Scalars['String']['output']>;
  timeSlots?: Maybe<Array<Scalars['Int']['output']>>;
  trackedDay?: Maybe<TrackedDay>;
};

export type User = {
  __typename?: 'User';
  id: Scalars['ID']['output'];
  trackedDays?: Maybe<Array<TrackedDay>>;
  username: Scalars['String']['output'];
};

export type WeekOfYear = {
  week?: InputMaybe<Scalars['Int']['input']>;
  year: Scalars['Int']['input'];
};

export type _Service = {
  __typename?: '_Service';
  sdl: Scalars['String']['output'];
};

export type ChargeCodesQueryVariables = Exact<{ [key: string]: never; }>;


export type ChargeCodesQuery = { __typename?: 'Query', chargeCodes?: Array<{ __typename?: 'ChargeCode', id: string, name: string, code: string, description?: string | null, expired: boolean, group?: string | null, sortOrder?: number | null }> | null };

export type CreateChargeCodeMutationVariables = Exact<{
  name: Scalars['String']['input'];
  code: Scalars['String']['input'];
  description?: InputMaybe<Scalars['String']['input']>;
  expired?: InputMaybe<Scalars['Boolean']['input']>;
  group?: InputMaybe<Scalars['String']['input']>;
  sortOrder?: InputMaybe<Scalars['Int']['input']>;
}>;


export type CreateChargeCodeMutation = { __typename?: 'Mutation', createChargeCode?: { __typename?: 'ChargeCode', id: string, name: string, code: string, description?: string | null, expired: boolean, group?: string | null, sortOrder?: number | null } | null };

export type UpdateChargeCodeMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  name?: InputMaybe<Scalars['String']['input']>;
  code?: InputMaybe<Scalars['String']['input']>;
  description?: InputMaybe<Scalars['String']['input']>;
  expired?: InputMaybe<Scalars['Boolean']['input']>;
  group?: InputMaybe<Scalars['String']['input']>;
  sortOrder?: InputMaybe<Scalars['Int']['input']>;
}>;


export type UpdateChargeCodeMutation = { __typename?: 'Mutation', updateChargeCode?: { __typename?: 'ChargeCode', id: string, name: string, code: string, description?: string | null, expired: boolean, group?: string | null, sortOrder?: number | null } | null };

export type TimeChargeTotalsQueryVariables = Exact<{
  weekOfYear?: InputMaybe<WeekOfYear>;
}>;


export type TimeChargeTotalsQuery = { __typename?: 'Query', timeChargeTotals?: Array<{ __typename?: 'TimeChargeTotal', id: string, value?: number | null, chargeCode?: { __typename?: 'ChargeCode', id: string, name: string, sortOrder?: number | null } | null, trackedDay?: { __typename?: 'TrackedDay', id: string, date: number, week: number } | null }> | null };

export type TimeChargeTotalsChangedSubscriptionVariables = Exact<{ [key: string]: never; }>;


export type TimeChargeTotalsChangedSubscription = { __typename?: 'Subscription', timeChargeTotalsChanged?: { __typename?: 'TimeChargeTotal', id: string, value?: number | null } | null };

export type TrackedDayQueryVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type TrackedDayQuery = { __typename?: 'Query', trackedDay?: { __typename?: 'TrackedDay', id: string, date: number, mode: DayMode, week: number, year: number } | null };

export type TrackedDaysForMonthYearQueryVariables = Exact<{
  month?: InputMaybe<Scalars['Int']['input']>;
  year?: InputMaybe<Scalars['Int']['input']>;
}>;


export type TrackedDaysForMonthYearQuery = { __typename?: 'Query', trackedDaysForMonthYear?: Array<{ __typename?: 'TrackedDay', id: string, date: number, mode: DayMode, week: number, year: number }> | null };

export type CreateTrackedDayMutationVariables = Exact<{
  date: Scalars['Float']['input'];
  mode?: InputMaybe<Scalars['String']['input']>;
}>;


export type CreateTrackedDayMutation = { __typename?: 'Mutation', createTrackedDay?: { __typename?: 'TrackedDay', id: string, date: number, mode: DayMode, week: number, year: number } | null };

export type DeleteTrackedDayMutationVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type DeleteTrackedDayMutation = { __typename?: 'Mutation', deleteTrackedDay?: boolean | null };

export type TrackedDayChangedSubscriptionVariables = Exact<{
  month?: InputMaybe<Scalars['Int']['input']>;
  year?: InputMaybe<Scalars['Int']['input']>;
}>;


export type TrackedDayChangedSubscription = { __typename?: 'Subscription', trackedDayChanged?: { __typename?: 'TrackedDay', id: string, date: number, mode: DayMode, week: number, year: number } | null };

export type TrackedTasksQueryVariables = Exact<{
  trackedDayId?: InputMaybe<Scalars['ID']['input']>;
}>;


export type TrackedTasksQuery = { __typename?: 'Query', trackedTasks?: Array<{ __typename?: 'TrackedTask', id: string, notes?: string | null, timeSlots?: Array<number> | null, chargeCodes?: Array<{ __typename?: 'ChargeCode', id: string, name: string }> | null }> | null };

export type CreateTrackedTaskMutationVariables = Exact<{
  trackedDayId: Scalars['ID']['input'];
}>;


export type CreateTrackedTaskMutation = { __typename?: 'Mutation', createTrackedTask: { __typename?: 'TrackedTask', id: string, notes?: string | null, timeSlots?: Array<number> | null, chargeCodes?: Array<{ __typename?: 'ChargeCode', id: string, name: string }> | null } };

export type UpdateTrackedTaskMutationVariables = Exact<{
  id: Scalars['ID']['input'];
  notes?: InputMaybe<Scalars['String']['input']>;
  chargeCodeIds?: InputMaybe<Array<Scalars['ID']['input']> | Scalars['ID']['input']>;
  timeSlots?: InputMaybe<Array<Scalars['Int']['input']> | Scalars['Int']['input']>;
}>;


export type UpdateTrackedTaskMutation = { __typename?: 'Mutation', updateTrackedTask: { __typename?: 'TrackedTask', id: string, notes?: string | null, timeSlots?: Array<number> | null, chargeCodes?: Array<{ __typename?: 'ChargeCode', id: string, name: string }> | null } };

export type DeleteTrackedTaskMutationVariables = Exact<{
  id: Scalars['ID']['input'];
}>;


export type DeleteTrackedTaskMutation = { __typename?: 'Mutation', deleteTrackedTask?: boolean | null };

export class TypedDocumentString<TResult, TVariables>
  extends String
  implements DocumentTypeDecoration<TResult, TVariables>
{
  __apiType?: DocumentTypeDecoration<TResult, TVariables>['__apiType'];

  constructor(private value: string, public __meta__?: Record<string, any> | undefined) {
    super(value);
  }

  toString(): string & DocumentTypeDecoration<TResult, TVariables> {
    return this.value;
  }
}

export const ChargeCodesDocument = new TypedDocumentString(`
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
    `) as unknown as TypedDocumentString<ChargeCodesQuery, ChargeCodesQueryVariables>;
export const CreateChargeCodeDocument = new TypedDocumentString(`
    mutation createChargeCode($name: String!, $code: String!, $description: String, $expired: Boolean, $group: String, $sortOrder: Int) {
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
    `) as unknown as TypedDocumentString<CreateChargeCodeMutation, CreateChargeCodeMutationVariables>;
export const UpdateChargeCodeDocument = new TypedDocumentString(`
    mutation updateChargeCode($id: ID!, $name: String, $code: String, $description: String, $expired: Boolean, $group: String, $sortOrder: Int) {
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
    `) as unknown as TypedDocumentString<UpdateChargeCodeMutation, UpdateChargeCodeMutationVariables>;
export const TimeChargeTotalsDocument = new TypedDocumentString(`
    query timeChargeTotals($weekOfYear: WeekOfYear) {
  timeChargeTotals(weekOfYear: $weekOfYear) {
    id
    value
    chargeCode {
      id
      name
      sortOrder
    }
    trackedDay {
      id
      date
      week
    }
  }
}
    `) as unknown as TypedDocumentString<TimeChargeTotalsQuery, TimeChargeTotalsQueryVariables>;
export const TimeChargeTotalsChangedDocument = new TypedDocumentString(`
    subscription timeChargeTotalsChanged {
  timeChargeTotalsChanged {
    id
    value
  }
}
    `) as unknown as TypedDocumentString<TimeChargeTotalsChangedSubscription, TimeChargeTotalsChangedSubscriptionVariables>;
export const TrackedDayDocument = new TypedDocumentString(`
    query trackedDay($id: ID!) {
  trackedDay(id: $id) {
    id
    date
    mode
    week
    year
  }
}
    `) as unknown as TypedDocumentString<TrackedDayQuery, TrackedDayQueryVariables>;
export const TrackedDaysForMonthYearDocument = new TypedDocumentString(`
    query trackedDaysForMonthYear($month: Int, $year: Int) {
  trackedDaysForMonthYear(month: $month, year: $year) {
    id
    date
    mode
    week
    year
  }
}
    `) as unknown as TypedDocumentString<TrackedDaysForMonthYearQuery, TrackedDaysForMonthYearQueryVariables>;
export const CreateTrackedDayDocument = new TypedDocumentString(`
    mutation createTrackedDay($date: Float!, $mode: String) {
  createTrackedDay(date: $date, mode: $mode) {
    id
    date
    mode
    week
    year
  }
}
    `) as unknown as TypedDocumentString<CreateTrackedDayMutation, CreateTrackedDayMutationVariables>;
export const DeleteTrackedDayDocument = new TypedDocumentString(`
    mutation deleteTrackedDay($id: ID!) {
  deleteTrackedDay(id: $id)
}
    `) as unknown as TypedDocumentString<DeleteTrackedDayMutation, DeleteTrackedDayMutationVariables>;
export const TrackedDayChangedDocument = new TypedDocumentString(`
    subscription trackedDayChanged($month: Int, $year: Int) {
  trackedDayChanged(month: $month, year: $year) {
    id
    date
    mode
    week
    year
  }
}
    `) as unknown as TypedDocumentString<TrackedDayChangedSubscription, TrackedDayChangedSubscriptionVariables>;
export const TrackedTasksDocument = new TypedDocumentString(`
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
    `) as unknown as TypedDocumentString<TrackedTasksQuery, TrackedTasksQueryVariables>;
export const CreateTrackedTaskDocument = new TypedDocumentString(`
    mutation createTrackedTask($trackedDayId: ID!) {
  createTrackedTask(trackedDayId: $trackedDayId) {
    id
    notes
    timeSlots
    chargeCodes {
      id
      name
    }
  }
}
    `) as unknown as TypedDocumentString<CreateTrackedTaskMutation, CreateTrackedTaskMutationVariables>;
export const UpdateTrackedTaskDocument = new TypedDocumentString(`
    mutation updateTrackedTask($id: ID!, $notes: String, $chargeCodeIds: [ID!], $timeSlots: [Int!]) {
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
    `) as unknown as TypedDocumentString<UpdateTrackedTaskMutation, UpdateTrackedTaskMutationVariables>;
export const DeleteTrackedTaskDocument = new TypedDocumentString(`
    mutation deleteTrackedTask($id: ID!) {
  deleteTrackedTask(id: $id)
}
    `) as unknown as TypedDocumentString<DeleteTrackedTaskMutation, DeleteTrackedTaskMutationVariables>;