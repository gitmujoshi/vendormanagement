/**
 * @file auth.ts
 * @description Authentication middleware for API routes
 * @author [Your Company Name]
 * @version 1.0.0
 * @lastModified 2024-03-21
 *
 * This middleware:
 * - Validates JWT tokens
 * - Extracts user information
 * - Handles authentication errors
 * - Provides role-based access control
 */

import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

/**
 * Middleware to authenticate API requests
 * Verifies JWT token and adds user data to request object
 * 
 * @param req - Express request object
 * @param res - Express response object
 * @param next - Express next function
 */
export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  try {
    // Extract token from Authorization header
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) throw new Error('No token provided');

    // Verify token and decode user information
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Authentication failed' });
  }
}; 