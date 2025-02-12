# API Integration Documentation

## Overview
This document describes the API integration patterns used in the Irrigation Monitoring System.

## Base Configuration
The base API configuration is in `api.ts` and includes:
- Axios instance setup
- Request/response interceptors
- Authentication handling
- Error handling

## Available Services

### Inspection Service
```typescript
// Get all inspections
const inspections = await inspectionService.getAll();

// Get single inspection
const inspection = await inspectionService.getById(id);

// Create inspection
const newInspection = await inspectionService.create(data);

// Update inspection
const updated = await inspectionService.update(id, data);

// Delete inspection
await inspectionService.delete(id);
```

### Property Service
```typescript
// Get all properties
const properties = await propertyService.getAll();

// Get single property
const property = await propertyService.getById(id);
```

### Station Service
```typescript
// Get all stations
const stations = await stationService.getAll();

// Get stations by property
const propertyStations = await stationService.getByProperty(propertyId);
```

## Error Handling
All services implement standard error handling:
- Network errors
- Authentication errors
- Validation errors
- Server errors

## Authentication
JWT-based authentication with automatic token refresh.