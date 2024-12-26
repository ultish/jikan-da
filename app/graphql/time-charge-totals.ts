import { gql } from 'glimmer-apollo';

export const GET_TIME_CHARGE_TOTALS = gql`
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
`;

/**
 * so a DGS subscription does not support data loaders, if you
 * want sub-objects in the subscription you'll need to eagerly
 * load it in DGS
 */
export const SUBSCRIBE_TIME_CHARGE_TOTALS_CHANGES = gql`
  subscription timeChargeTotalsChanged {
    timeChargeTotalsChanged {
      id
      value
    }
  }
`;
