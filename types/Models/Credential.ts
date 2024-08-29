import { CredentialMobile } from './CredentialMobile';

export interface Credential {
    credentialType: { modelName: string };
    endDate?: string;
    id: number;
    mobile: CredentialMobile;
    opal: String;
    startDate?: string;
}
