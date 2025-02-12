import { createSlice } from '@reduxjs/toolkit';

const propertiesSlice = createSlice({
  name: 'properties',
  initialState: {
    properties: [],
    loading: false,
    error: null
  },
  reducers: {}
});

export default propertiesSlice.reducer; 