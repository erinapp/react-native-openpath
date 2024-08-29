/**
 * Data for "onLocationStatusChanged" event.
 *
 * `locationPermissionSetting` options are:
 *
 * - *ios_authorizedAlways* `// User selected "Always Allow"`
 * - *ios_authorizedWhenInUse* `// User selected "Ask Next Time"`
 * - *ios_notDetermined* `// User has not answered the popup yet`
 * - *ios_restricted* `// User has not answered the popup yet`
 * - *ios_denied* `// User denied location request`
 * - *android_location_onWhenInUse* `// Only used for API 29 (Q) and newer`
 * - *android_location_on* `// Location permissions are enabled, On android API 29 (Q) and newer,
 *   this refers to the setting "Always allow." On previous versions this refers to the option "Allow"`
 * - *android_location_off `// Location permissions are disabled`
 *
 * @event onLocationStatusChanged
 * @see {@link OpenpathEvent}
 */
export interface LocationStatusChanged {
    isLocationOn: boolean,
    locationPermissionSetting:
        | 'ios_authorizedAlways'
        | 'ios_authorizedWhenInUse'
        | 'ios_notDetermined'
        | 'ios_restricted'
        | 'ios_denied'
        | 'android_location_onWhenInUse'
        | 'android_location_on'
        | 'android_location_off',
    isPreciseLocationOn: boolean,
}
