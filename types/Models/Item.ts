import { ItemType } from './ItemType';

export interface Item {
  itemId: number;
  itemType: ItemType;
  readerIds: [number];
  name: string;
  acuId: number;
  orgName: string;
  color: string;
  cameraIds: [number];
  isInRange: Boolean;
}
