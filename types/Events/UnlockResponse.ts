/**
 * The data included with the "onUnlockResponse" event.
 *
 * Invoked when {@link unlock} is complete.
 *
 * @event onUnlockResponse
 * @see {@link OpenpathEvent}
 */
export interface UnlockResponse {
  requestId: number;
  status: number;
  intCode?: number;
  result?: string;
  description?: string;
  tip?: string;
  moreInformationLink?: string;
  itemId: number;
  itemType: string;
}
