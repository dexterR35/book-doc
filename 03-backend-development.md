# Chapter 3: Backend Development

## Express Server Architecture

### Server Setup

 

## Express Server
- HTTP request handling
- Middleware pipeline
- Route management
- Error handling

## Middleware Stack
- **Helmet**: Security headers
- **CORS**: Cross-origin resource sharing
- **Auth**: JWT-based authentication
- **Rate Limiting**: Prevent abuse and throttling

## Route Handlers
- `/api/auth` : Authentication endpoints
- `/api/tasks` : Task CRUD operations
- `/api/users` : User management
- `/api/files` : File upload/download

## Service Layer
- Business logic implementation
- Data validation and sanitization
- External API integration
- File processing and storage

## Prisma ORM
- Database connection management
- Query building and optimization
- Transaction handling
- Migration management

## PostgreSQL Database
- ACID compliance
- Connection pooling
- Index optimization
- Backup and recovery


### Database Architecture & Query Flow


```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATABASE ARCHITECTURE                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │   CLIENT    │───►│   API       │───►│   SERVICE   │───►│   PRISMA    │   │
│  │   REQUEST   │    │   VALIDATION│    │   LAYER     │    │   ORM       │   │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘   │
│           │                   │                   │                   │     │
│           ▼                   ▼                   ▼                   ▼     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │   CACHE     │    │   QUERY     │    │   INDEX     │    │   DATABASE  │   │
│  │   LAYER     │    │   BUILDER   │    │   OPTIMIZER │    │   EXECUTION │   │
│  │             │    │             │    │             │    │             │   │
│  │ • Redis     │    │ • Dynamic   │    │ • Composite │    │ • Connection│   │
│  │ • Memory    │    │ • Filters   │    │ • Partial   │    │   Pooling   │   │
│  │ • CDN       │    │ • Sorting   │    │ • Full-text │    │ • Prepared  │   │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### API Endpoint Architecture Foundation

REST API with HTTP methods:

```
┌─────────────────────────────────────────────────────────────────────┐
│                           API ENDPOINT ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                           AUTHENTICATION ENDPOINTS             │ │
│  │  POST   /api/auth/login      - User login                      │ │
│  │  POST   /api/auth/register   - User registration               │ │
│  │  POST   /api/auth/logout     - User logout                     │ │
│  │  POST   /api/auth/refresh    - Token refresh                   │ │
│  │  POST   /api/auth/verify     - Token verification              │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                    │                                │
│                                    ▼                                │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                             TASK ENDPOINTS                     │ │
│  │  GET    /api/tasks           - List all tasks                  │ │
│  │  POST   /api/tasks           - Create new task                 │ │
│  │  GET    /api/tasks/:id       - Get task by ID                  │ │
│  │  PUT    /api/tasks/:id       - Update task                     │ │
│  │  DELETE /api/tasks/:id       - Delete task                     │ │
│  │  PATCH  /api/tasks/:id/status- Update task status              │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                    │                                │
│                                    ▼                                │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                             USER ENDPOINTS                     │ │
│  │  GET    /api/users           - List all users                  │ │
│  │  POST   /api/users           - Create new user                 │ │
│  │  GET    /api/users/:id       - Get user by ID                  │ │
│  │  PUT    /api/users/:id       - Update user                     │ │
│  │  DELETE /api/users/:id       - Delete user                     │ │
│  │  PATCH  /api/users/:id/role  - Update user role                │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                    │                                │
│                                    ▼                                │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                             FILE ENDPOINTS                     │ │
│  │  POST   /api/files/upload    - Upload file                     │ │
│  │  GET    /api/files/:id       - Download file                   │ │
│  │  DELETE /api/files/:id       - Delete file                     │ │
│  │  GET    /api/files/task/:id  - List files for task             │ │
│  └────────────────────────────────────────────────────────────────┘ │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Server Implementation

```javascript
// server/server.js
const app = express();
const PORT = process.env.PORT || 3000;
// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.CLIENT_URL,
  credentials: true
}));
app.use(compression());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(rateLimit);

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/tasks', taskRoutes);
app.use('/api/users', userRoutes);

// Error handling
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### Authentication Middleware

```javascript
// server/middleware/auth.js
const jwt = require('jsonwebtoken');

const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({ message: 'Access token required' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({ message: 'Invalid or expired token' });
  }
};

const requireRole = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ message: 'Authentication required' });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ message: 'Insufficient permissions' });
    }

    next();
  };
};
```

## Users Table
- **id (UUID)**: Primary key, unique identifier for each user
- **email (VARCHAR)**: Unique user email
- **password (HASHED)**: Securely stored user password
- **role (ENUM)**: User role (`ADMIN`, `USER`)
- **firstName (VARCHAR)**: User first name
- **lastName (VARCHAR)**: User last name
- **createdAt (TIMESTAMP)**: Record creation timestamp
- **updatedAt (TIMESTAMP)**: Record update timestamp
- **Relationships**:
  - 1:N → Tasks
  - 1:N → Projects

## Tasks Table
- **id (UUID)**: Primary key
- **title (VARCHAR)**: Task title
- **description (TEXT)**: Task details
- **status (ENUM)**: Task status (`TODO`, `IN_PROGRESS`, `DONE`)
- **priority (ENUM)**: Task priority (`LOW`, `MEDIUM`, `HIGH`, `URGENT`)
- **dueDate (TIMESTAMP)**: Optional due date
- **userId (UUID)**: Assignee (foreign key to Users)
- **projectId (UUID)**: Associated project (foreign key to Projects)
- **Relationships**:
  - 1:N → Attachments

## Attachments Table
- **id (UUID)**: Primary key
- **filename (VARCHAR)**: Stored filename
- **filePath (VARCHAR)**: Path or URL to the file
- **fileSize (BIGINT)**: File size in bytes
- **mimeType (VARCHAR)**: File type
- **taskId (UUID)**: Associated task (foreign key to Tasks)
- **uploadedBy (UUID)**: Uploader user ID
- **createdAt (TIMESTAMP)**: Upload timestamp

## Projects Table
- **id (UUID)**: Primary key
- **name (VARCHAR)**: Project name
- **description (TEXT)**: Optional project description
- **status (ENUM)**: Project status (`ACTIVE`, `ARCHIVED`, `COMPLETED`)
- **createdAt (TIMESTAMP)**: Creation timestamp
- **updatedAt (TIMESTAMP)**: Update timestamp
- **ownerId (UUID)**: Project owner (foreign key to Users)
- **team (ARRAY)**: List of team member IDs (foreign keys to Users)
- **Relationships**:
  - 1:N → Tasks

## Database Indexing Strategy

The indexing strategy ensures fast and efficient queries:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           QUERY OPTIMIZATION STRATEGY                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │                           PRIMARY INDEXES                              │ │
│  │  • users.id (PRIMARY KEY)                                              │ │
│  │  • tasks.id (PRIMARY KEY)                                              │ │
│  │  • attachments.id (PRIMARY KEY)                                        │ │
│  │  • projects.id (PRIMARY KEY)                                           │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                        │
│                                    ▼                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                         PERFORMANCE INDEXES                           │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │  │
│  │  │   Helmet    │ │   HSTS      │ │   CSP       │ │   X-Frame   │      │  │
│  │  │   Security  │ │   Headers   │ │   Headers   │ │   Options   │      │  │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘      │  │
│  │                                    │                                  │  │
│  │                                    ▼                                  │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │  │
│  │  │   CORS      │ │   Rate      │ │   Auth      │ │   Validation│      │  │
│  │  │   Policy    │ │   Limiting  │ │   JWT       │ │   Middleware│      │  │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘      │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│  ┌───────────────────────────────────────────────────────────────────────┐  │
│  │                           DATA VALIDATION                             │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │  │
│  │  │   INPUT     │ │   SANITIZE  │ │   VALIDATE  │ │   TRANSFORM │      │  │
│  │  │   PARSING   │ │   HTML      │ │   SCHEMA    │ │   DATA      │      │  │
│  │  │             │ │   ESCAPING  │ │   CHECKING  │ │   FORMAT    │      │  │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘      │  │
│  │                                    │                                  │  │
│  │                                    ▼                                  │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │  │
│  │  │   REGEX     │ │   TYPE      │ │   XSS       │ │   DATABASE  │      │  │
│  │  │   PATTERNS  │ │   CHECKING  │ │   PREVENTION│ │   SANITIZE  │      │  │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘      │  │
│  └───────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Prisma Client Configuration

```javascript
// server/models/index.js
const { PrismaClient } = require('@prisma/client');

const prisma = globalThis.__prisma || new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  errorFormat: 'pretty',
});

```

### Task Controller Implementation

```javascript
// server/controllers/taskController.js
const prisma = require('../models');
const { validateTaskInput } = require('../utils/validators');

const createTask = async (req, res) => {
  try {
    const { title, description, priority, dueDate, projectId } = req.body;
    const userId = req.user.id;

    // Validate input
    const validation = validateTaskInput(req.body);
    if (!validation.isValid) {
      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors: validation.errors
      });
    }

    // Create task
    const task = await prisma.task.create({
      data: {
        title,
        description,
        priority: priority || 'MEDIUM',
        dueDate: dueDate ? new Date(dueDate) : null,
        userId,
        projectId: projectId || null
      },
      include: {
        user: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true
          }
        },
        project: {
          select: {
            id: true,
            name: true
          }
        }
      }
    });

    res.status(201).json({
      success: true,
      data: task
    });

  } catch (error) {
    console.error('Task creation error:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to create task'
    });
  }
};

```

### Route Implementation

```javascript
// server/routes/tasks.js

const router = Router();

// Apply authentication to all task routes
router.use(authenticateToken);

// Task CRUD operations
router.post('/', validateTaskInput, taskController.createTask);
router.get('/', taskController.getTasks);
router.get('/:id', taskController.getTaskById);
router.put('/:id', validateTaskInput, taskController.updateTask);
router.delete('/:id', taskController.deleteTask);

// Task status updates
router.patch('/:id/status', taskController.updateTaskStatus);

// Export the router
```



*This chapter is a foundation for backend architecture with Express, Prisma, and PostgreSQL.*
