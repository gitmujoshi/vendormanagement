/**
 * @file routes.ts
 * @description API route definitions for the Irrigation Monitoring System
 * @author [Your Company Name]
 * @version 1.0.0
 * @lastModified 2024-03-21
 *
 * This file contains all API endpoint definitions.
 * Each endpoint includes authentication and authorization checks.
 */

// Authentication Endpoints
POST /api/auth/login         // Authenticate user and return JWT
POST /api/auth/register      // Create new user account (admin only)

// Properties Endpoints
GET /api/properties          // List all properties (paginated)
POST /api/properties         // Create new property (admin only)
GET /api/properties/:id      // Get property details

// Stations Endpoints
GET /api/stations            // List all stations (filtered by property)
POST /api/stations           // Create new station (admin only)
GET /api/stations/:id        // Get station details
PUT /api/stations/:id/assign // Assign engineer to station

// Inspections Endpoints
GET /api/inspections        // List inspections (filtered by date/engineer)
POST /api/inspections       // Create new inspection
GET /api/inspections/:id    // Get inspection details
PUT /api/inspections/:id/lock // Lock inspection after completion

// Repairs Endpoints
POST /api/repairs           // Create new repair record
GET /api/repairs/:id        // Get repair details
PUT /api/repairs/:id/workorder // Update work order details 