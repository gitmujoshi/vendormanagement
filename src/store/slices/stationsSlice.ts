import { createSlice } from '@reduxjs/toolkit';

const stationsSlice = createSlice({
  name: 'stations',
  initialState: {
    stations: [],
    loading: false,
    error: null
  },
  reducers: {}
});

export default stationsSlice.reducer; 