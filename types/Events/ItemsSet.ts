import { ItemType } from '../Models/ItemType';
import { Item } from '../Models/Item';

export interface ItemOrdering {
  itemId: number;
  itemType: ItemType;
}

/**
 * The data included with the "onItemsSet" event.
 *
 * Invoked when item information is set. Contains the full set of items and fields.
 *
 * This is the event that lists the entries the user has access to. It is called any time user access to entries changes (e.g., through updates in the portal).
 *
 * **items** is a dictionary where the keys are `entry-{entryId}` or `reader-{readerId}`.
 *
 * **itemOrdering** is an array that represents the ordering and hierarchy of `items`. Typically, in a non-elevator scenario, you will only see `entry` itemTypes and no subItems. In an elevator scenario however, you will see `reader` itemTypes (which normally represents the elevator), and `entry` subItems (which normally represents the floors that are tied to that reader).
 *
 * @event onItemsSet
 * @see {@link OpenpathEvent}
 */
export interface ItemsSet {
  items: {[key: string]: Item};
  itemOrdering: ItemOrdering[];
}
