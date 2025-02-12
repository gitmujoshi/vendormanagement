/**
 * Redux slice for managing inspections state
 */
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { inspectionService } from '../../services/inspectionService';
import { Inspection } from '../../types';

interface InspectionsState {
  items: Inspection[];
  loading: boolean;
  error: string | null;
}

const initialState: InspectionsState = {
  items: [],
  loading: false,
  error: null,
};

export const fetchInspections = createAsyncThunk(
  'inspections/fetchAll',
  async () => {
    const response = await inspectionService.getAll();
    return response;
  }
);

const inspectionsSlice = createSlice({
  name: 'inspections',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchInspections.pending, (state) => {
        state.loading = true;
        state.error = null;
      })
      .addCase(fetchInspections.fulfilled, (state, action) => {
        state.loading = false;
        state.items = action.payload;
      })
      .addCase(fetchInspections.rejected, (state, action) => {
        state.loading = false;
        state.error = action.error.message || 'Failed to fetch inspections';
      });
  },
});

export default inspectionsSlice.reducer; 