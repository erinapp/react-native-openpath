/**
 * The data included with the "onBluetoothStatusChanged" event.
 *
 * Invoked when bluetooth status has changed.
 *
 * @event onBluetoothStatusChanged
 * @see {@link OpenpathEvent}
 */
export interface BluetoothStatusChanged {
    isBluetoothOn?: Boolean;
    bluetoothPermissionSetting?: 'ios_allowedAlways' | 'ios_restricted' | 'ios_notDetermined' | 'ios_denied' | 'android_unavailable' | 'android_allowed' | 'android_notAllowed';
    isBluetoothRestarting?: Boolean;
}
