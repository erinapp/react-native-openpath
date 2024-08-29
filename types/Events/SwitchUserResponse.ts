/**
 * The data included with the "onSwitchUserResponse" event.
 *
 * Invoked when {@link switchUser} is complete.
 *
 * @event onSwitchUserResponse
 * @see {@link OpenpathEvent}
 * @see switchUser
 */
export interface SwitchUserResponse {
  userOpal: string;
}
