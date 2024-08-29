/**
 * The data included with the "onUnprovisionResponse" event.
 *
 * Invoked when {@link unprovision} is complete. The unprovision may be triggered by a call to `unprovision` in the SDK, but also if the SDK detects that the active user is not allowed to be provisioned, for example if the same user using the same credential provisioned the SDK on another device.
 *
 * The `reasonCode` and the `reasonDescription` objects returned in the message payload clarify the reason for this unprovision.
 *
 * In cases where the request to unprovision was to unprovision all the user provisioned in the device the `userOpal` value will be `null`
 *
 * @event onUnprovisionResponse
 * @see {@link OpenpathEvent}
 */
export interface UnprovisionResponse {
  userOpal?: string;
  reasonCode: number;
  reasonDescription: string;
}
