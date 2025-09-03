# Chapter 2: Project Setup & Folder Structure

## Development Example Setup

**System Requirements:**
- **Node.js**: Version 18.0.0 or higher (LTS recommended)
- **PostgreSQL**: Version 14.0 or higher
- **Git**: Version 2.30.0 or higher
- **Package Manager**: npm 8.0.0+ or yarn 1.22.0+

**Development Tools:**
- **Code Editor**: VS Code with recommended extensions
- **Database Client**: pgAdmin, DBeaver, or TablePlus
- **API Testing**: Postman or Insomnia
- **Version Control**: Git with proper branching strategy


### Example Folder Structure

```
task-manager-app/
├── 📁 client/                          # Frontend React Application
│   ├── 📁 public/                      # Static assets
│   │   ├── 📄 index.html              # Main HTML template
│   │   ├── 📄 favicon.ico             # Application icon
│   │   └── 📄 manifest.json           # PWA manifest
│   ├── 📁 src/                        # Source code
│   │   ├── 📁 components/             # Reusable UI components
│   │   │   ├── 📁 common/             # Shared components
│   │   │   │   ├── 📄 Button.jsx      # Custom button component
│   │   │   │   ├── 📄 Input.jsx       # Form input component
│   │   │   │   ├── 📄 Modal.jsx       # Modal dialog component
│   │   │   │   └── 📄 Loading.jsx     # Loading spinner
│   │   │   ├── 📁 layout/             # Layout components
│   │   │   │   ├── 📄 Header.jsx      # Application header
│   │   │   │   ├── 📄 Sidebar.jsx     # Navigation sidebar
│   │   │   │   └── 📄 Footer.jsx      # Application footer
│   │   │   ├── 📁 forms/              # Form components
│   │   │   │   ├── 📄 LoginForm.jsx   # Authentication form
│   │   │   │   ├── 📄 TaskForm.jsx    # Task creation/editing
│   │   │   │   └── 📄 UserForm.jsx    # User management
│   │   │   └── 📁 kanban/             # Kanban board components
│   │   │       ├── 📄 KanbanBoard.jsx # Main board component
│   │   │       ├── 📄 KanbanColumn.jsx# Individual columns
│   │   │       └── 📄 KanbanCard.jsx  # Task cards
│   │   ├── 📁 pages/                  # Page components
│   │   │   ├── 📄 Dashboard.jsx       # Main dashboard
│   │   │   ├── 📄 Login.jsx           # Login page
│   │   │   ├── 📄 Tasks.jsx           # Task management
│   │   │   ├── 📄 Projects.jsx        # Project overview
│   │   │   └── 📄 Users.jsx           # User management
│   │   ├── 📁 stores/                 # Zustand state management
│   │   │   ├── 📄 authStore.js        # Authentication state
│   │   │   ├── 📄 taskStore.js        # Task management state
│   │   │   ├── 📄 userStore.js        # User management state
│   │   │   └── 📄 uiStore.js          # UI state management
│   │   ├── 📁 services/               # API service layer
│   │   │   ├── 📄 api.js              # Base API configuration
│   │   │   ├── 📄 authService.js      # Authentication API calls
│   │   │   ├── 📄 taskService.js      # Task API calls
│   │   │   └── 📄 userService.js      # User API calls
│   │   ├── 📁 utils/                  # Utility functions
│   │   │   ├── 📄 constants.js        # Application constants
│   │   │   ├── 📄 helpers.js          # Helper functions
│   │   │   └── 📄 validation.js       # Form validation
│   │   ├── 📁 types/                  # JavaScript type definitions
│   │   │   ├── 📄 auth.types.js       # Authentication types
│   │   │   ├── 📄 task.types.js       # Task-related types
│   │   │   └── 📄 user.types.js       # User-related types
│   │   ├── 📄 App.jsx                 # Main application component
│   │   ├── 📄 main.jsx                # Application entry point
│   │   └── 📄 index.css               # Global styles
│   ├── 📄 package.json                # Frontend dependencies
│   ├── 📄 vite.config.js              # Vite configuration
│   ├── 📄 jsconfig.json               # JavaScript configuration
│   ├── 📄 tailwind.config.js          # TailwindCSS configuration
│   └── 📄 postcss.config.js           # PostCSS configuration
├── 📁 server/                          # Backend Node.js Application
│   ├── 📁 config/                      # Configuration files
│   │   ├── 📄 database.js              # Database configuration
│   │   ├── 📄 cors.js                  # CORS configuration
│   │   └── 📄 helmet.js                # Security headers
│   ├── 📁 controllers/                 # Route controllers
│   │   ├── 📄 authController.js        # Authentication logic
│   │   ├── 📄 taskController.js        # Task management logic
│   │   ├── 📄 userController.js        # User management logic
│   │   └── 📄 fileController.js        # File upload logic
│   ├── 📁 middleware/                  # Express middleware
│   │   ├── 📄 auth.js                  # JWT authentication
│   │   ├── 📄 validation.js            # Input validation
│   │   ├── 📄 rateLimit.js             # Rate limiting
│   │   ├── 📄 csrf.js                  # CSRF protection
│   │   └── 📄 errorHandler.js          # Error handling
│   ├── 📁 models/                      # Prisma schema and models
│   │   ├── 📄 schema.prisma            # Database schema
│   │   └── 📄 index.js                 # Prisma client export
│   ├── 📁 routes/                      # API route definitions
│   │   ├── 📄 auth.js                  # Authentication routes
│   │   ├── 📄 tasks.js                 # Task management routes
│   │   ├── 📄 users.js                 # User management routes
│   │   └── 📄 files.js                 # File upload routes
│   ├── 📁 services/                    # Business logic services
│   │   ├── 📄 emailService.js          # Email functionality
│   │   ├── 📄 fileService.js           # File handling logic
│   │   └── 📄 notificationService.js   # Notification system
│   ├── 📁 utils/                       # Utility functions
│   │   ├── 📄 logger.js                # Logging utility
│   │   ├── 📄 encryption.js            # Encryption helpers
│   │   └── 📄 validators.js            # Validation schemas
│   ├── 📄 server.js                    # Main server file
│   ├── 📄 package.json                 # Backend dependencies
│   ├── 📄 jsconfig.json                # JavaScript configuration
│   └── 📄 nodemon.json                 # Development configuration
├── 📁 shared/                          # Shared code between client/server
│   ├── 📁 types/                       # Common JavaScript types
│   │   ├── 📄 api.types.js             # API response types
│   │   └── 📄 common.types.js          # Shared types
│   └── 📁 constants/                   # Shared constants
│       └── 📄 app.constants.js         # Application constants
├── 📁 docs/                            # Documentation
│   ├── 📄 api.md                       # API documentation
│   ├── 📄 deployment.md                # Deployment guide
│   └── 📄 development.md               # Development guide
├── 📁 scripts/                         # Build and deployment scripts
│   ├── 📄 build.sh                     # Build script
│   ├── 📄 deploy.sh                    # Deployment script
│   └── 📄 setup.sh                     # Environment setup
├── 📄 .env.example                     # Environment variables template
├── 📄 .env                             # Environment variables (gitignored)
├── 📄 docker-compose.yml               # Docker development environment
├── 📄 Dockerfile                       # Production Docker image
├── 📄 package.json                     # Root package.json for scripts
├── 📄 README.md                        # Project documentation
└── 📄 .eslintrc.js                     # ESLint configuration
```

## Environment Configuration


### Client package.json

```json
{
  "name": "task-manager-client",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "test": "vitest",
    "test:ui": "vitest --ui",
    "lint": "eslint . --ext js,jsx --report-unused-disable-directives --max-warnings 0"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.8.0",
    "zustand": "^4.4.0",
    "formik": "^2.4.0",
    "yup": "^1.3.0",
    "axios": "^1.6.0",
    "react-beautiful-dnd": "^13.1.1",
    "date-fns": "^2.30.0",
    "react-hot-toast": "^2.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.0",
    "vite": "^5.0.0",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "vitest": "^1.0.0",
    "@testing-library/react": "^14.0.0",
    "@testing-library/jest-dom": "^6.0.0",
    "eslint": "^8.0.0",
    "eslint-plugin-react": "^7.33.0",
    "eslint-plugin-react-hooks": "^4.6.0",
    "eslint-plugin-jsx-a11y": "^6.7.0"
  }
}
```

### Server package.json

```json
{
  "name": "task-manager-server",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "nodemon",
    "start": "node server.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint . --ext .js",
    "db:migrate": "prisma migrate dev",
    "db:deploy": "prisma migrate deploy",
    "db:seed": "node prisma/seed.js",
    "db:studio": "prisma studio",
    "db:generate": "prisma generate"
  },
  "dependencies": {
    "express": "^4.18.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "express-rate-limit": "^7.1.0",
    "express-validator": "^7.0.0",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0",
    "cookie-parser": "^1.4.6",
    "multer": "^1.4.5",
    "prisma": "^5.0.0",
    "@prisma/client": "^5.0.0",
    "dotenv": "^16.3.0",
    "winston": "^3.11.0",
    "compression": "^1.7.4",
    "express-slow-down": "^1.6.0"
  },
  "devDependencies": {
    "nodemon": "^3.0.0",
    "jest": "^29.0.0",
    "supertest": "^6.3.0",
    "eslint": "^8.0.0",
    "eslint-plugin-node": "^11.1.0"
  }
}
```

## Development Setup Instructions

```bash
# Start PostgreSQL Docker
docker run --name postgres-task-manager \
  -e POSTGRES_DB=task_manager \
  -e POSTGRES_USER=task_manager_user \
  -e POSTGRES_PASSWORD=secure_password \
  -p 5432:5432 \
  -d postgres:15
```




*This chapter provides the base example for setting up a professional development environment that supports scalable, maintainable application development.*
