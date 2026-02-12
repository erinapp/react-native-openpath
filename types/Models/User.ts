export interface User {
  endDate?: string;
  id: number;
  identity: {
    id: number;
    opal: string;
    firstName?: string;
    middleName?: string;
    lastName?: string;
    email: string;
  };
  opal: string;
  org: {
    id: number;
    opal: string;
    name: string;
    pictureUrl?: string;
    adminSupportContactEmails: string[];
    adminSupportContactPhoneNumbers: string[];
  };
  pictureUrl?: string;
  startDate?: string;
  status?: string;
}
