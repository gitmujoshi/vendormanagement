export interface InspectionData {
  stationId: string;
  status: 'checked' | 'repair_needed';
  gpsCoordinates: {
    latitude: number;
    longitude: number;
  } | null;
  timestamp: string;
} 