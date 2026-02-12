import { ItemType } from '../Models/ItemType';

export interface ItemState {
  isScheduledRemoteUnlockAllowed: Boolean;
  isScheduledAvailableRevert: Boolean;
  itemType: ItemType;
  itemId: number;
  isScheduledNoAccess: Boolean | null;
  isScheduledTouchAllowed: Boolean;
  isScheduledUnlocked: Boolean | null;
  isScheduledOverrideAllowed: Boolean;
}

/**
 * The data included with the "onItemStatesUpdated" event.
 * Offline wireless lock can have unknown item state and return null values for "Scheduled" parameters in response.
 * Invoked in response to {@link refreshItemState}.
 *
 * @event onItemStatesUpdated
 * @see {@link OpenpathEvent}
 */
export interface ItemStatesUpdated {
  itemStates: {[key: string]: ItemState};
}
