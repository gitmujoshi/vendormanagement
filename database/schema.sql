/*
 * @file schema.sql
 * @description Database schema for Irrigation Monitoring System
 * @author [Your Company Name]
 * @version 1.0.0
 * @lastModified 2024-03-21
 *
 * This file contains the complete database schema including:
 * - User management
 * - Property and station tracking
 * - Inspection records
 * - Repair documentation
 */

-- Users Table: Stores all user information including engineers and administrators
CREATE TABLE Users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL, -- Possible values: 'admin', 'engineer', 'vendor'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Properties Table: Main properties/locations being serviced
CREATE TABLE Properties (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stations Table: Individual irrigation stations within properties
CREATE TABLE Stations (
    id UUID PRIMARY KEY,
    property_id UUID REFERENCES Properties(id),
    station_number VARCHAR(50) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    controller_details JSON, -- Stores controller specifications and settings
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inspections Table: Records of all station inspections
CREATE TABLE Inspections (
    id UUID PRIMARY KEY,
    station_id UUID REFERENCES Stations(id),
    engineer_id UUID REFERENCES Users(id),
    status VARCHAR(50) NOT NULL, -- 'checked' or 'repair_needed'
    gps_coordinates POINT, -- Validates location of inspection
    inspection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_locked BOOLEAN DEFAULT false -- Prevents modifications after submission
);

-- Repairs Table: Detailed repair records
CREATE TABLE Repairs (
    id UUID PRIMARY KEY,
    inspection_id UUID REFERENCES Inspections(id),
    part_id UUID REFERENCES Parts(id),
    workorder_number VARCHAR(50),
    invoice_url TEXT, -- Stores link to uploaded invoice document
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 