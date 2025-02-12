# State Management Documentation

## Store Configuration

### Root Store
```typescript
import { configureStore } from '@reduxjs/toolkit';
import rootReducer from './reducers';

export const store = configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware().concat(/* custom middleware */),
});
```

### Slices
Each feature has its own slice:
- properties
- stations
- inspections
- auth

## Usage Examples

### Dispatching Actions
```typescript
import { useDispatch } from 'react-redux';
import { fetchInspections } from './slices/inspectionsSlice';

const Component = () => {
  const dispatch = useDispatch();
  
  useEffect(() => {
    dispatch(fetchInspections());
  }, []);
};
```

### Selecting State
```typescript
import { useSelector } from 'react-redux';

const Component = () => {
  const inspections = useSelector(state => state.inspections.items);
  const loading = useSelector(state => state.inspections.loading);
};
```

## State Structure

### Properties Slice
```typescript
{
  items: Property[],
  loading: boolean,
  error: string | null,
  selected: Property | null
}
```

### Stations Slice
```typescript
{
  items: Station[],
  loading: boolean,
  error: string | null,
  filters: {
    propertyId: string | null,
    status: string | null
  }
}
```

### Inspections Slice
```typescript
{
  items: Inspection[],
  loading: boolean,
  error: string | null,
  currentInspection: Inspection | null,
  filters: {
    startDate: string | null,
    endDate: string | null,
    status: string | null
  }
}
```

## Async Actions
All async actions follow this pattern:
- pending
- fulfilled
- rejected

Example:
```typescript
export const fetchInspections = createAsyncThunk(
  'inspections/fetchAll',
  async (_, { rejectWithValue }) => {
    try {
      const response = await inspectionService.getAll();
      return response.data;
    } catch (error) {
      return rejectWithValue(error.response.data);
    }
  }
);
``` 