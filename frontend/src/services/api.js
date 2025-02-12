import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000/api';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add request interceptor for authentication
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Add response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth endpoints
export const login = (credentials) => api.post('/auth/login', credentials);
export const register = (userData) => api.post('/auth/register', userData);
export const logout = () => {
  localStorage.removeItem('token');
  window.location.href = '/login';
};

// Dashboard endpoints
export const fetchDashboardData = () => api.get('/dashboard');

// Properties endpoints
export const fetchProperties = () => api.get('/properties');
export const createProperty = (propertyData) => api.post('/properties', propertyData);
export const updateProperty = (id, propertyData) => api.put(`/properties/${id}`, propertyData);
export const deleteProperty = (id) => api.delete(`/properties/${id}`);

// Stations endpoints
export const fetchStations = (propertyId) => api.get(`/properties/${propertyId}/stations`);
export const createStation = (propertyId, stationData) => api.post(`/properties/${propertyId}/stations`, stationData);
export const updateStation = (propertyId, stationId, stationData) => api.put(`/properties/${propertyId}/stations/${stationId}`, stationData);
export const deleteStation = (propertyId, stationId) => api.delete(`/properties/${propertyId}/stations/${stationId}`);

// Inspections endpoints
export const fetchInspections = (stationId) => api.get(`/stations/${stationId}/inspections`);
export const createInspection = (stationId, inspectionData) => api.post(`/stations/${stationId}/inspections`, inspectionData);
export const updateInspection = (inspectionId, inspectionData) => api.put(`/inspections/${inspectionId}`, inspectionData);

export default api; 