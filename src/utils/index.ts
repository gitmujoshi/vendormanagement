/**
 * Utility functions for the application
 */

// Date formatting
export const formatDate = (date: string | Date): string => {
  return new Date(date).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  });
};

// Status color mapping
export const getStatusColor = (status: string): string => {
  const colors = {
    active: '#4caf50',
    inactive: '#f44336',
    pending: '#ff9800',
    'in-progress': '#2196f3',
    completed: '#4caf50',
    failed: '#f44336',
    maintenance: '#ff9800',
  };
  return colors[status] || '#757575';
};

// Error handling
export const handleApiError = (error: any): string => {
  if (error.response?.data?.message) {
    return error.response.data.message;
  }
  return 'An unexpected error occurred';
};

// Data validation
export const validateInspection = (data: any): boolean => {
  const required = ['stationId', 'date', 'assignedTo'];
  return required.every(field => Boolean(data[field]));
}; 