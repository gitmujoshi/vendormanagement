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

/**
 * API Routes Definition
 */
export const routes = {
  auth: {
    login: '/api/auth/login',         // Authenticate user and return JWT
    register: '/api/auth/register',   // Create new user account (admin only)
  },
  properties: {
    list: '/api/properties',          // List all properties (paginated)
    create: '/api/properties',        // Create new property (admin only)
    getById: '/api/properties/:id',   // Get property details
  },
  stations: {
    list: '/api/stations',           // List all stations
    create: '/api/stations',         // Create new station
    getById: '/api/stations/:id',    // Get station details
    assign: '/api/stations/:id/assign', // Assign engineer
  },
  inspections: {
    list: '/api/inspections',        // List inspections (filtered by date/engineer)
    create: '/api/inspections',       // Create new inspection
    getById: '/api/inspections/:id',    // Get inspection details
    lock: '/api/inspections/:id/lock'    // Lock inspection after completion
  },
  repairs: {
    create: '/api/repairs',           // Create new repair record
    getById: '/api/repairs/:id',        // Get repair details
    update: '/api/repairs/:id/workorder'  // Update work order details
  }
}; 