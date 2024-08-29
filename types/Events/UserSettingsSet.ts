/**
 * The data included with the "onUserSettingsSet" event.
 *
 * Invoked when user settings are set.
 *
 * @event onUserSettingsSet
 * @see {@link OpenpathEvent}
 */
export interface UserSettingsSet {
    userSettings: {
        hasRemoteUnlock: boolean,
        hasOverride: boolean,
        cloudKeys: Array<{
            startTs: number,
            id: number,
            name: string
        }>
    }
}
