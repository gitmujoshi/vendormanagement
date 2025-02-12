# API Documentation

## Base URL
`http://localhost:3000/api` (Development)
`https://api.irrigation-system.com` (Production)

## Authentication

### POST /auth/login
Login with email and password.

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response:**
```json
{
  "user": {
    "id": "uuid",
    "email": "string",
    "role": "string"
  },
  "token": "string"
}
```

### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "email": "string",
  "password": "string",
  "role": "admin|engineer|vendor"
}
```

**Response:**
```json
{
  "user": {
    "id": "uuid",
    "email": "string",
    "role": "string"
  },
  "token": "string"
}
```

## Properties

### GET /properties
Get all properties.

**Query Parameters:**
- `page`: number (default: 1)
- `limit`: number (default: 10)
- `search`: string
- `status`: string

**Response:**
```json
{
  "data": [{
    "id": "uuid",
    "name": "string",
    "address": "string",
    "created_at": "datetime",
    "stations_count": "number"
  }],
  "pagination": {
    "total": "number",
    "page": "number",
    "limit": "number",
    "pages": "number"
  }
}
```

### POST /properties
Create a new property.

**Request Body:**
```json
{
  "name": "string",
  "address": "string",
  "metadata": {
    "size": "number",
    "type": "string",
    "zone": "string"
  }
}
```

## Stations

### GET /properties/:propertyId/stations
Get all stations for a property.

**Path Parameters:**
- `propertyId`: uuid

**Query Parameters:**
- `status`: active|inactive|maintenance
- `page`: number
- `limit`: number

**Response:**
```json
{
  "data": [{
    "id": "uuid",
    "station_number": "string",
    "status": "string",
    "controller_details": "object",
    "last_inspection": "datetime"
  }],
  "pagination": {
    "total": "number",
    "page": "number",
    "limit": "number"
  }
}
```

### POST /properties/:propertyId/stations
Create a new station.

**Request Body:**
```json
{
  "station_number": "string",
  "address": "string",
  "controller_details": {
    "model": "string",
    "serial_number": "string",
    "configuration": "object"
  }
}
```

## Inspections

### GET /stations/:stationId/inspections
Get inspections for a station.

**Path Parameters:**
- `stationId`: uuid

**Query Parameters:**
- `status`: checked|repair_needed
- `from_date`: date
- `to_date`: date

**Response:**
```json
{
  "data": [{
    "id": "uuid",
    "status": "string",
    "engineer": {
      "id": "uuid",
      "name": "string"
    },
    "inspection_date": "datetime",
    "findings": "object"
  }]
}
```

### POST /stations/:stationId/inspections
Create a new inspection.

**Request Body:**
```json
{
  "status": "checked|repair_needed",
  "findings": {
    "notes": "string",
    "issues": ["string"],
    "recommendations": ["string"]
  },
  "gps_coordinates": {
    "latitude": "number",
    "longitude": "number"
  }
}
```

## Error Responses

### 400 Bad Request
```json
{
  "error": "Validation error",
  "details": [{
    "field": "string",
    "message": "string"
  }]
}
```

### 401 Unauthorized
```json
{
  "error": "Authentication required"
}
```

### 403 Forbidden
```json
{
  "error": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found"
}
```

### 500 Server Error
```json
{
  "error": "Internal server error"
}
```

## Rate Limiting
- Rate limit: 100 requests per 15 minutes
- Rate limit headers included in response:
  - `X-RateLimit-Limit`
  - `X-RateLimit-Remaining`
  - `X-RateLimit-Reset`

## WebSocket Events

### Connection
```javascript
const ws = new WebSocket('ws://localhost:3000/ws');
ws.onopen = () => {
  ws.send(JSON.stringify({
    type: 'auth',
    token: 'jwt_token'
  }));
};
```

### Station Updates
```javascript
// Receive station updates
ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  switch(data.type) {
    case 'station_status':
      // Handle station status update
      break;
    case 'inspection_created':
      // Handle new inspection
      break;
  }
};
```

## File Upload

### POST /upload
Upload files (multipart/form-data).

**Request:**
```
Content-Type: multipart/form-data
Authorization: Bearer <token>

file: File
type: "inspection_photo|property_document"
```

**Response:**
```json
{
  "url": "string",
  "filename": "string",
  "size": "number",
  "mime_type": "string"
}
``` 