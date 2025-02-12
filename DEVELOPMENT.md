# Development Guidelines

## Code Style & Standards

### General
- Use TypeScript for all new code
- Follow ESLint and Prettier configurations
- Write self-documenting code with clear variable/function names
- Keep functions small and focused (max 20-30 lines)
- Use meaningful commit messages following conventional commits

### TypeScript
```typescript
// Use explicit types
const user: User = {
  id: string;
  email: string;
  role: UserRole;
};

// Use enums for fixed values
enum UserRole {
  ADMIN = 'admin',
  ENGINEER = 'engineer',
  VENDOR = 'vendor'
}

// Use interfaces for models
interface Property {
  id: string;
  name: string;
  address: string;
  metadata?: PropertyMetadata;
}

// Use type guards
function isAdmin(user: User): user is AdminUser {
  return user.role === UserRole.ADMIN;
}
```

### React Components
```typescript
// Use functional components
const PropertyCard: React.FC<PropertyCardProps> = ({ property }) => {
  return (
    <div>
      <h3>{property.name}</h3>
    </div>
  );
};

// Use proper prop types
interface PropertyCardProps {
  property: Property;
  onEdit?: (id: string) => void;
  className?: string;
}

// Use hooks correctly
const useProperty = (id: string) => {
  const [property, setProperty] = useState<Property | null>(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    // Effect logic here
  }, [id]);
  
  return { property, loading };
};
```

### API Routes
```typescript
// Use express router
const router = express.Router();

// Use async/await with proper error handling
router.get('/properties', async (req, res, next) => {
  try {
    // Route logic here
  } catch (error) {
    next(error);
  }
});

// Use proper validation
const createPropertySchema = {
  name: Joi.string().required(),
  address: Joi.string().required()
};
```

## Project Structure

### Frontend
```
src/
├── components/        # Reusable components
│   ├── common/       # Generic components
│   ├── forms/        # Form components
│   └── layout/       # Layout components
├── pages/            # Page components
├── hooks/            # Custom hooks
├── services/         # API services
├── store/            # Redux store
│   ├── slices/       # Redux slices
│   └── selectors/    # Redux selectors
├── types/            # TypeScript types
└── utils/            # Utility functions
```

### Backend
```
src/
├── controllers/      # Route controllers
├── middleware/       # Express middleware
├── models/          # Database models
├── routes/          # API routes
├── services/        # Business logic
├── utils/           # Utility functions
└── validation/      # Request validation
```

## Testing Standards

### Unit Tests
```typescript
describe('PropertyService', () => {
  it('should create a property', async () => {
    // Test setup
    const propertyData = {
      name: 'Test Property',
      address: '123 Test St'
    };
    
    // Test execution
    const result = await PropertyService.create(propertyData);
    
    // Assertions
    expect(result).toHaveProperty('id');
    expect(result.name).toBe(propertyData.name);
  });
});
```

### Integration Tests
```typescript
describe('Property API', () => {
  it('should create a property', async () => {
    const response = await request(app)
      .post('/api/properties')
      .send({
        name: 'Test Property',
        address: '123 Test St'
      })
      .set('Authorization', `Bearer ${token}`);
    
    expect(response.status).toBe(201);
    expect(response.body).toHaveProperty('id');
  });
});
```

## Git Workflow

### Branches
- `main`: Production code
- `develop`: Development code
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `release/*`: Release preparation

### Commit Messages
```
feat: add property creation
fix: resolve station status update issue
docs: update API documentation
style: format code according to guidelines
refactor: improve property service structure
test: add property creation tests
chore: update dependencies
```

## Code Review Guidelines

### What to Look For
1. Code Style
   - Follows project conventions
   - Proper naming
   - Clear organization

2. Functionality
   - Meets requirements
   - Handles edge cases
   - Proper error handling

3. Testing
   - Adequate test coverage
   - Meaningful test cases
   - Proper test organization

4. Performance
   - Efficient algorithms
   - Proper caching
   - Resource management

### Review Process
1. Create pull request
2. Run automated checks
3. Code review by peers
4. Address feedback
5. Final review
6. Merge

## Development Setup

### Prerequisites
1. Install Node.js (v16+)
2. Install PostgreSQL (v14+)
3. Install Redis
4. Install Docker

### Environment Setup
```bash
# Clone repository
git clone <repository-url>

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env

# Start development server
npm run dev
```

### IDE Setup
1. VS Code Extensions
   - ESLint
   - Prettier
   - TypeScript
   - Docker
   - GitLens

2. VS Code Settings
```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

## Deployment Process

### Development
1. Push to feature branch
2. Create pull request
3. Review and merge
4. Automatic deployment to dev environment

### Staging
1. Merge develop to staging
2. Run integration tests
3. Deploy to staging environment
4. Perform QA testing

### Production
1. Create release branch
2. Perform final testing
3. Create pull request to main
4. Deploy to production

## Performance Guidelines

### Frontend
1. Use React.memo for expensive components
2. Implement proper code splitting
3. Optimize images and assets
4. Use proper caching strategies

### Backend
1. Use database indexes properly
2. Implement caching where appropriate
3. Optimize database queries
4. Use connection pooling

### API
1. Implement pagination
2. Use proper error handling
3. Implement rate limiting
4. Use compression

## Security Guidelines

1. Authentication
   - Use JWT tokens
   - Implement proper password hashing
   - Use secure session management

2. Authorization
   - Implement role-based access
   - Use proper middleware
   - Validate user permissions

3. Data Security
   - Sanitize user input
   - Use parameterized queries
   - Implement proper encryption

4. API Security
   - Use HTTPS
   - Implement rate limiting
   - Use proper CORS settings 