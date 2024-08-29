import { ItemType } from '../Models/ItemType';

export interface ItemState {
  isScheduledRemoteUnlockAllowed: Boolean;
  isScheduledAvailableRevert: Boolean;
  itemType: ItemType;
  itemId: number;
  isScheduledNoAccess: Boolean;
  isScheduledTouchAllowed: Boolean;
  isScheduledUnlocked: Boolean;
  isScheduledOverrideAllowed: Boolean;
}

/**
 * The data included with the "onItemStatesUpdated" event.
 *
 * Invoked in response to {@link refreshItemState}.
 *
 * @event onItemStatesUpdated
 * @see {@link OpenpathEvent}
 */
export interface ItemStatesUpdated {
  itemStates: {[key: string]: ItemState};
}
