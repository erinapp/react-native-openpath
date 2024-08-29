import { User } from '../Models/User';
import { Credential } from '../Models/Credential';

/**
 * The data included with the "onSyncUserResponse" event.
 *
 * Invoked when {@link syncUser} is complete.
 *
 * @event
 * @see {@link OpenpathEvent}
 * @see syncUser
 */
export interface SyncUserResponse {
  credential: Credential;
  user: User;
  appVersion?: {
    deprecatedBuild: number;
    deprecatedSdkVersion: string;
    deprecatedVersion: string;
    id: number;
    isUpdateRequired: Boolean;
    latestBuild: number;
    latestSdkVersion: string;
    latestVersion: string;
    os: string;
  };
}
