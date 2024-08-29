import { Item } from '../Models/Item';
import { Camera } from '../Models/Camera';

/**
 * The data included with the "onItemsUpdated" event.
 *
 * Invoked when item information is updated. Only contains items and fields that have been updated.
 *
 * This is called for any items whose information has changed (e.g., whether it became in or out of range, whether the schedule has changed, etc.).
 *
 * This is for changes to existing items only. If new items have been discovered or any items have been removed since the last update, this is not called, but `onItemsSet` is called instead.
 *
 * @event onItemsUpdated
 * @see {@link OpenpathEvent}
 * @see syncUser
 */
export interface ItemsUpdated {
  items?: {[key: string]: Item};
  cameras?: Camera[];
}
