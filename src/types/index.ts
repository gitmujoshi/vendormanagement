/**
 * Core type definitions for the application
 */

export interface Property {
  id: string;
  name: string;
  address: string;
  stationCount: number;
  lastInspection: string;
  status: 'active' | 'inactive';
}

export interface Station {
  id: string;
  number: string;
  propertyId: string;
  propertyName: string;
  status: 'active' | 'inactive' | 'maintenance';
  lastInspection: string;
  nextInspection: string;
  location: {
    lat: number;
    lng: number;
  };
  controllerDetails: {
    model: string;
    zones: number;
  };
}

export interface Inspection {
  id: string;
  date: string;
  status: string;
  stationId: string;
  engineerId: string;
  notes?: string;
  gpsCoordinates?: {
    latitude: number;
    longitude: number;
  };
}

export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'engineer' | 'viewer';
} 