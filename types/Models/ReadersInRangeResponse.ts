export interface ReaderInRange {
  id: number;
  name: string;
  avgBleRssi?: number;
}

/**
 * Returned from {@link getReadersInRange}
 */
export interface ReadersInRangeResponse {
  readersInRange: [ReaderInRange];
}
