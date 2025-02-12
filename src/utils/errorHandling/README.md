# Error Handling Guidelines

## Error Types

### API Errors
```typescript
export class ApiError extends Error {
  constructor(
    public status: number,
    public message: string,
    public data?: any
  ) {
    super(message);
    this.name = 'ApiError';
  }
}
```

### Validation Errors
```typescript
export class ValidationError extends Error {
  constructor(
    public field: string,
    public message: string
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

## Error Handling Patterns

### API Error Handling
```typescript
try {
  await api.get('/endpoint');
} catch (error) {
  if (error instanceof ApiError) {
    switch (error.status) {
      case 401:
        // Handle unauthorized
        break;
      case 404:
        // Handle not found
        break;
      default:
        // Handle other errors
    }
  }
}
```

### Form Validation
```typescript
const validateForm = (data: FormData): ValidationError[] => {
  const errors: ValidationError[] = [];
  
  if (!data.title) {
    errors.push(new ValidationError('title', 'Title is required'));
  }
  
  return errors;
};
``` 