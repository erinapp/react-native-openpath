/**
 * The data included with the "onMotionStatusChanged" event.
 *
 * Invoked when Motion permission has changed. For this permission, Apple does not provide any real-time notifications via its SDK. Therefore, this delegate will be called whenever the app enters the foreground.
 *
 * **authorizationStatus** options are:
 *
 * - *ios_authorized*
 * - *ios_notDetermined* `// User has not answered the popup yet`
 * - *ios_restricted* `// User has not answered the popup yet`
 * - *ios_denied*
 *
 * @event onMotionStatusChanged
 * @see {@link OpenpathEvent}
 */
export interface MotionStatusChanged {
    authorizationStatus: 'ios_authorized' | 'ios_notDetermined' | 'ios_restricted' | 'ios_denied',
}
