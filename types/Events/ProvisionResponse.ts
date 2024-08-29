import { User } from '../Models/User';

/**
 * The data included with the "onProvisionResponse" event.
 *
 * Invoked when {@link provision} is complete.
 *
 * @event onProvisionResponse
 * @see {@link OpenpathEvent}
 */
export interface ProvisionResponse {
  userOpal: string;

  environment: {
    heliumEndpoint: string;
    opalEnv: string;
    opalRegion: string;
  };

  user: User;

  credential: {
    id: number;
    opal: String;

    credentialType: {
      modelName: string;
    };

    mobile: {
      id: null;
      name: string;
      provisionedAt: string;
    };
  };
}
