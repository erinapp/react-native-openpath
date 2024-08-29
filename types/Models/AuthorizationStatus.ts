export type AuthType =
  | 'location'
  | 'motion'
  | 'bluetooth'
  | 'notification'
  | 'microphone';

export enum AuthorizationStatusType {
  notDetermined = -1,
  denied,
  granted,
}

export interface AuthorizationStatus {
  authType: AuthType;
  status: AuthorizationStatusType;
}
