export interface Camera {
  id: number;
  idExt?: string; // the external id in the video provider system
  name: string;
  nameExt: string; // the external name in the video provider system
  supportsIntercom: Boolean;
  videoProviderId: number;
  timeZoneId?: string;
}
