#!/bin/bash
# @file init-database.sh
# @description Initialize database schema and seed data

set -e

# Load environment variables
source .env

# Get database connection string from Terraform output
cd terraform
DB_CONNECTION_STRING=$(terraform output -raw database_connection_string)
cd ..

# Run database migrations
echo "Running database migrations..."
psql "$DB_CONNECTION_STRING" -f database/schema.sql

# Seed initial data if needed
echo "Seeding initial data..."
psql "$DB_CONNECTION_STRING" -f database/seed.sql

echo "Database initialization completed!" 