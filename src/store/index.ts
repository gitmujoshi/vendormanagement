/**
 * Redux store configuration
 * Sets up the global state management for the application
 */
import { configureStore } from '@reduxjs/toolkit';
import propertiesReducer from './slices/propertiesSlice';
import stationsReducer from './slices/stationsSlice.ts';
import inspectionsReducer from './slices/inspectionsSlice.ts';
import authReducer from './slices/authSlice.ts';

export const store = configureStore({
  reducer: {
    properties: propertiesReducer,
    stations: stationsReducer,
    inspections: inspectionsReducer,
    auth: authReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch; 