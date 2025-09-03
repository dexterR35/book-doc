# Chapter 11: API Reference

## Overview

This chapter provides comprehensive API documentation for the Task Manager App, including detailed endpoint specifications, request/response examples, error handling, and authentication requirements. The API follows RESTful principles and includes comprehensive validation, rate limiting, and security measures.

## API Overview

### Base URL
```
Development: http://localhost:3000/api
Production: https://yourdomain.com/api
```

### Authentication
All API endpoints (except authentication endpoints) require a valid JWT token sent via HTTP-only cookies.

### Rate Limiting
- **Authentication endpoints**: 5 requests per 15 minutes
- **General API endpoints**: 100 requests per minute
- **File upload endpoints**: 10 requests per minute

### Response Format
All API responses follow a consistent format:

```json
{
  "success": true,
  "data": {},
  "message": "Operation completed successfully",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

### Error Response Format
```json
{
  "success": false,
  "error": "Error message",
  "details": [],
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

## Authentication Endpoints

### POST /api/auth/register

**Description**: Register a new user account

**Request Body**:
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "SecurePass123!",
  "confirmPassword": "SecurePass123!"
}
```

**Validation Rules**:
- `name`: 2-50 characters, letters and spaces only
- `email`: Valid email format, max 255 characters
- `password`: 8-128 characters, must contain uppercase, lowercase, number, and special character
- `confirmPassword`: Must match password

**Response**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-here",
      "name": "John Doe",
      "email": "john.doe@example.com",
      "role": "user",
      "createdAt": "2025-01-15T10:30:00.000Z"
    }
  },
  "message": "User registered successfully"
}
```

**Status Codes**:
- `201`: User created successfully
- `400`: Validation error
- `409`: Email already exists
- `500`: Server error

### POST /api/auth/login

**Description**: Authenticate user and receive JWT token

**Request Body**:
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePass123!"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-here",
      "name": "John Doe",
      "email": "john.doe@example.com",
      "role": "user"
    },
    "accessToken": "jwt-token-here"
  },
  "message": "Login successful"
}
```

**Cookies Set**:
- `token`: JWT access token (HTTP-only, secure)
- `refreshToken`: JWT refresh token (HTTP-only, secure)

**Status Codes**:
- `200`: Login successful
- `400`: Validation error
- `401`: Invalid credentials
- `500`: Server error

### POST /api/auth/refresh

**Description**: Refresh access token using refresh token

**Request**: No body required (uses refresh token from cookies)

**Response**:
```json
{
  "success": true,
  "data": {
    "accessToken": "new-jwt-token-here"
  },
  "message": "Token refreshed successfully"
}
```

**Status Codes**:
- `200`: Token refreshed successfully
- `401`: Invalid or expired refresh token
- `500`: Server error

### POST /api/auth/logout

**Description**: Logout user and invalidate tokens

**Request**: No body required

**Response**:
```json
{
  "success": true,
  "message": "Logout successful"
}
```

**Cookies Cleared**:
- `token`
- `refreshToken`

**Status Codes**:
- `200`: Logout successful
- `500`: Server error

### POST /api/auth/forgot-password

**Description**: Request password reset

**Request Body**:
```json
{
  "email": "john.doe@example.com"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Password reset email sent"
}
```

**Status Codes**:
- `200`: Reset email sent
- `400`: Validation error
- `404`: Email not found
- `500`: Server error

### POST /api/auth/reset-password

**Description**: Reset password using reset token

**Request Body**:
```json
{
  "token": "reset-token-here",
  "password": "NewSecurePass123!",
  "confirmPassword": "NewSecurePass123!"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

**Status Codes**:
- `200`: Password reset successful
- `400`: Validation error
- `401`: Invalid or expired token
- `500`: Server error

## User Management Endpoints

### GET /api/users/profile

**Description**: Get current user profile

**Authentication**: Required

**Response**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-here",
      "name": "John Doe",
      "email": "john.doe@example.com",
      "role": "user",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z"
    }
  }
}
```

**Status Codes**:
- `200`: Profile retrieved successfully
- `401`: Unauthorized
- `500`: Server error

### PUT /api/users/profile

**Description**: Update current user profile

**Authentication**: Required

**Request Body**:
```json
{
  "name": "John Smith",
  "email": "john.smith@example.com"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid-here",
      "name": "John Smith",
      "email": "john.smith@example.com",
      "role": "user",
      "updatedAt": "2025-01-15T10:30:00.000Z"
    }
  },
  "message": "Profile updated successfully"
}
```

**Status Codes**:
- `200`: Profile updated successfully
- `400`: Validation error
- `401`: Unauthorized
- `409`: Email already exists
- `500`: Server error

### PUT /api/users/change-password

**Description**: Change user password

**Authentication**: Required

**Request Body**:
```json
{
  "currentPassword": "SecurePass123!",
  "newPassword": "NewSecurePass123!",
  "confirmPassword": "NewSecurePass123!"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

**Status Codes**:
- `200`: Password changed successfully
- `400`: Validation error
- `401`: Unauthorized or incorrect current password
- `500`: Server error

### GET /api/users (Admin Only)

**Description**: Get all users (admin only)

**Authentication**: Required (Admin role)

**Query Parameters**:
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20, max: 100)
- `search` (optional): Search by name or email
- `role` (optional): Filter by role (user, admin)

**Response**:
```json
{
  "success": true,
  "data": {
    "users": [
      {
        "id": "uuid-here",
        "name": "John Doe",
        "email": "john.doe@example.com",
        "role": "user",
        "createdAt": "2025-01-15T10:30:00.000Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "pages": 3
    }
  }
}
```

**Headers**:
- `X-Total-Count`: Total number of users
- `X-Page-Count`: Total number of pages

**Status Codes**:
- `200`: Users retrieved successfully
- `401`: Unauthorized
- `403`: Insufficient permissions
- `500`: Server error

## Task Management Endpoints

### GET /api/tasks

**Description**: Get tasks for current user

**Authentication**: Required

**Query Parameters**:
- `status` (optional): Filter by status (todo, in-progress, done)
- `priority` (optional): Filter by priority (low, medium, high)
- `search` (optional): Search in title and description
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20, max: 100)
- `sortBy` (optional): Sort field (title, priority, dueDate, createdAt)
- `sortOrder` (optional): Sort order (asc, desc, default: desc)

**Response**:
```json
{
  "success": true,
  "data": {
    "tasks": [
      {
        "id": "uuid-here",
        "title": "Complete project documentation",
        "description": "Write comprehensive documentation for the new feature",
        "status": "in-progress",
        "priority": "high",
        "dueDate": "2025-01-20T00:00:00.000Z",
        "createdAt": "2025-01-15T10:30:00.000Z",
        "updatedAt": "2025-01-15T10:30:00.000Z",
        "attachments": [
          {
            "id": "attachment-uuid",
            "fileName": "screenshot.png",
            "fileUrl": "https://storage.googleapis.com/...",
            "mimeType": "image/png"
          }
        ]
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 25,
      "pages": 2
    }
  }
}
```

**Status Codes**:
- `200`: Tasks retrieved successfully
- `400`: Validation error
- `401`: Unauthorized
- `500`: Server error

### POST /api/tasks

**Description**: Create a new task

**Authentication**: Required

**Request Body**:
```json
{
  "title": "Complete project documentation",
  "description": "Write comprehensive documentation for the new feature",
  "priority": "high",
  "dueDate": "2025-01-20T00:00:00.000Z"
}
```

**Validation Rules**:
- `title`: Required, 3-200 characters
- `description`: Optional, max 2000 characters
- `priority`: Optional, one of: low, medium, high (default: medium)
- `dueDate`: Optional, must be future date

**Response**:
```json
{
  "success": true,
  "data": {
    "task": {
      "id": "uuid-here",
      "title": "Complete project documentation",
      "description": "Write comprehensive documentation for the new feature",
      "status": "todo",
      "priority": "high",
      "dueDate": "2025-01-20T00:00:00.000Z",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z"
    }
  },
  "message": "Task created successfully"
}
```

**Status Codes**:
- `201`: Task created successfully
- `400`: Validation error
- `401`: Unauthorized
- `500`: Server error

### GET /api/tasks/:id

**Description**: Get a specific task by ID

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Task UUID

**Response**:
```json
{
  "success": true,
  "data": {
    "task": {
      "id": "uuid-here",
      "title": "Complete project documentation",
      "description": "Write comprehensive documentation for the new feature",
      "status": "in-progress",
      "priority": "high",
      "dueDate": "2025-01-20T00:00:00.000Z",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "attachments": [
        {
          "id": "attachment-uuid",
          "fileName": "screenshot.png",
          "fileUrl": "https://storage.googleapis.com/...",
          "mimeType": "image/png",
          "fileSize": 1024000,
          "createdAt": "2025-01-15T10:30:00.000Z"
        }
      ]
    }
  }
}
```

**Status Codes**:
- `200`: Task retrieved successfully
- `400`: Invalid task ID
- `401`: Unauthorized
- `403`: Access denied
- `404`: Task not found
- `500`: Server error

### PUT /api/tasks/:id

**Description**: Update a specific task

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Task UUID

**Request Body**:
```json
{
  "title": "Updated task title",
  "description": "Updated description",
  "status": "done",
  "priority": "medium",
  "dueDate": "2025-01-25T00:00:00.000Z"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "task": {
      "id": "uuid-here",
      "title": "Updated task title",
      "description": "Updated description",
      "status": "done",
      "priority": "medium",
      "dueDate": "2025-01-25T00:00:00.000Z",
      "updatedAt": "2025-01-15T11:00:00.000Z"
    }
  },
  "message": "Task updated successfully"
}
```

**Status Codes**:
- `200`: Task updated successfully
- `400`: Validation error
- `401`: Unauthorized
- `403`: Access denied
- `404`: Task not found
- `500`: Server error

### DELETE /api/tasks/:id

**Description**: Delete a specific task

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Task UUID

**Response**:
```json
{
  "success": true,
  "message": "Task deleted successfully"
}
```

**Status Codes**:
- `200`: Task deleted successfully
- `400`: Invalid task ID
- `401`: Unauthorized
- `403`: Access denied
- `404`: Task not found
- `500`: Server error

### PATCH /api/tasks/:id/status

**Description**: Update task status (for drag and drop)

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Task UUID

**Request Body**:
```json
{
  "status": "done"
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "task": {
      "id": "uuid-here",
      "status": "done",
      "updatedAt": "2025-01-15T11:00:00.000Z"
    }
  },
  "message": "Task status updated successfully"
}
```

**Status Codes**:
- `200`: Status updated successfully
- `400`: Validation error
- `401`: Unauthorized
- `403`: Access denied
- `404`: Task not found
- `500`: Server error

## File Management Endpoints

### POST /api/tasks/:id/attachments

**Description**: Upload files for a specific task

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Task UUID

**Request**: Multipart form data
- `files`: Array of files (max 5 files)

**File Requirements**:
- **Types**: JPG, PNG, GIF, PDF, DOC, DOCX
- **Size**: Images max 5MB, documents max 10MB
- **Total**: Max 50MB per user

**Response**:
```json
{
  "success": true,
  "data": {
    "attachments": [
      {
        "id": "attachment-uuid",
        "fileName": "screenshot.png",
        "fileUrl": "https://storage.googleapis.com/...",
        "mimeType": "image/png",
        "fileSize": 1024000,
        "createdAt": "2025-01-15T10:30:00.000Z"
      }
    ]
  },
  "message": "Files uploaded successfully"
}
```

**Status Codes**:
- `201`: Files uploaded successfully
- `400`: Validation error
- `401`: Unauthorized
- `403`: Access denied
- `404`: Task not found
- `413`: File too large
- `500`: Server error

### GET /api/tasks/:id/attachments

**Description**: Get all attachments for a specific task

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Task UUID

**Response**:
```json
{
  "success": true,
  "data": {
    "attachments": [
      {
        "id": "attachment-uuid",
        "fileName": "screenshot.png",
        "fileUrl": "https://storage.googleapis.com/...",
        "mimeType": "image/png",
        "fileSize": 1024000,
        "createdAt": "2025-01-15T10:30:00.000Z"
      }
    ]
  }
}
```

**Status Codes**:
- `200`: Attachments retrieved successfully
- `400`: Invalid task ID
- `401`: Unauthorized
- `403`: Access denied
- `404`: Task not found
- `500`: Server error

### DELETE /api/attachments/:id

**Description**: Delete a specific attachment

**Authentication**: Required (Owner or Admin)

**Path Parameters**:
- `id`: Attachment UUID

**Response**:
```json
{
  "success": true,
  "message": "Attachment deleted successfully"
}
```

**Status Codes**:
- `200`: Attachment deleted successfully
- `400`: Invalid attachment ID
- `401`: Unauthorized
- `403`: Access denied
- `404`: Attachment not found
- `500`: Server error

## Project Management Endpoints

### GET /api/projects

**Description**: Get projects for current user

**Authentication**: Required

**Query Parameters**:
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20, max: 100)
- `search` (optional): Search in name and description

**Response**:
```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": "project-uuid",
        "name": "Website Redesign",
        "description": "Complete redesign of company website",
        "status": "active",
        "createdAt": "2025-01-15T10:30:00.000Z",
        "updatedAt": "2025-01-15T10:30:00.000Z",
        "memberCount": 5,
        "taskCount": 12
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 8,
      "pages": 1
    }
  }
}
```

**Status Codes**:
- `200`: Projects retrieved successfully
- `400`: Validation error
- `401`: Unauthorized
- `500`: Server error

### POST /api/projects

**Description**: Create a new project

**Authentication**: Required

**Request Body**:
```json
{
  "name": "Website Redesign",
  "description": "Complete redesign of company website"
}
```

**Validation Rules**:
- `name`: Required, 3-100 characters
- `description`: Optional, max 1000 characters

**Response**:
```json
{
  "success": true,
  "data": {
    "project": {
      "id": "project-uuid",
      "name": "Website Redesign",
      "description": "Complete redesign of company website",
      "status": "active",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z"
    }
  },
  "message": "Project created successfully"
}
```

**Status Codes**:
- `201`: Project created successfully
- `400`: Validation error
- `401`: Unauthorized
- `500`: Server error

## Analytics and Reporting Endpoints

### GET /api/analytics/dashboard

**Description**: Get dashboard analytics for current user

**Authentication**: Required

**Response**:
```json
{
  "success": true,
  "data": {
    "taskStats": {
      "total": 25,
      "todo": 8,
      "inProgress": 12,
      "done": 5,
      "overdue": 2
    },
    "priorityStats": {
      "low": 5,
      "medium": 15,
      "high": 5
    },
    "recentActivity": [
      {
        "id": "activity-uuid",
        "action": "TASK_CREATED",
        "description": "Created task: Complete documentation",
        "timestamp": "2025-01-15T10:30:00.000Z"
      }
    ],
    "productivity": {
      "tasksCompletedThisWeek": 12,
      "tasksCompletedLastWeek": 8,
      "improvement": 50
    }
  }
}
```

**Status Codes**:
- `200`: Analytics retrieved successfully
- `401`: Unauthorized
- `500`: Server error

### GET /api/analytics/reports

**Description**: Generate custom reports (Admin only)

**Authentication**: Required (Admin role)

**Query Parameters**:
- `type`: Report type (user-activity, task-completion, system-usage)
- `startDate`: Start date (ISO format)
- `endDate`: End date (ISO format)
- `format`: Output format (json, csv, pdf)

**Response**:
```json
{
  "success": true,
  "data": {
    "report": {
      "type": "user-activity",
      "generatedAt": "2025-01-15T10:30:00.000Z",
      "period": "2025-01-01 to 2025-01-15",
      "data": {
        "totalUsers": 150,
        "activeUsers": 120,
        "newUsers": 25,
        "userActivity": [...]
      }
    }
  }
}
```

**Status Codes**:
- `200`: Report generated successfully
- `400`: Validation error
- `401`: Unauthorized
- `403`: Insufficient permissions
- `500`: Server error

## WebSocket Endpoints

### WebSocket Connection

**URL**: `ws://localhost:3000/ws` (Development)
**URL**: `wss://yourdomain.com/ws` (Production)

**Authentication**: JWT token in query parameter or headers

**Connection**:
```javascript
const socket = new WebSocket('ws://localhost:3000/ws?token=jwt-token-here');
```

**Events**:

**Client to Server**:
- `task:create`: Create new task
- `task:update`: Update existing task
- `task:delete`: Delete task
- `task:move`: Move task between columns

**Server to Client**:
- `task:created`: New task created
- `task:updated`: Task updated
- `task:deleted`: Task deleted
- `task:moved`: Task moved
- `user:online`: User came online
- `user:offline`: User went offline

**Example Usage**:
```javascript
// Listen for task updates
socket.on('task:updated', (data) => {
    console.log('Task updated:', data);
    // Update UI accordingly
});

// Create new task
socket.emit('task:create', {
    title: 'New Task',
    description: 'Task description',
    priority: 'medium'
});
```

## Error Handling

### Common Error Codes

**4xx Client Errors**:
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Missing or invalid authentication
- `403 Forbidden`: Insufficient permissions
- `404 Not Found`: Resource not found
- `409 Conflict`: Resource conflict (e.g., duplicate email)
- `413 Payload Too Large`: File too large
- `429 Too Many Requests`: Rate limit exceeded

**5xx Server Errors**:
- `500 Internal Server Error`: Unexpected server error
- `502 Bad Gateway`: Upstream service error
- `503 Service Unavailable`: Service temporarily unavailable

### Error Response Examples

**Validation Error**:
```json
{
  "success": false,
  "error": "Validation failed",
  "details": [
    {
      "field": "email",
      "message": "Must be a valid email",
      "value": "invalid-email"
    },
    {
      "field": "password",
      "message": "Password must be at least 8 characters",
      "value": "123"
    }
  ],
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

**Authentication Error**:
```json
{
  "success": false,
  "error": "Authentication required",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

**Permission Error**:
```json
{
  "success": false,
  "error": "Insufficient permissions",
  "details": "Admin role required for this operation",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

## Rate Limiting

### Rate Limit Headers

All API responses include rate limiting headers:

```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642233600
Retry-After: 60
```

### Rate Limit Response

When rate limit is exceeded:

```json
{
  "success": false,
  "error": "Too many requests, please slow down",
  "retryAfter": 60,
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

## Pagination

### Pagination Headers

List endpoints include pagination headers:

```
X-Total-Count: 150
X-Page-Count: 8
X-Current-Page: 1
X-Per-Page: 20
```

### Pagination Query Parameters

- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)

### Pagination Response

```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "pages": 8,
      "hasNext": true,
      "hasPrev": false
    }
  }
}
```

## Filtering and Sorting

### Filtering

Most list endpoints support filtering via query parameters:

```
GET /api/tasks?status=done&priority=high&search=documentation
```

### Sorting

Sorting is supported via query parameters:

```
GET /api/tasks?sortBy=dueDate&sortOrder=asc
GET /api/tasks?sortBy=priority&sortOrder=desc
```

### Advanced Filtering

Some endpoints support advanced filtering with operators:

```
GET /api/tasks?dueDate[gte]=2025-01-01&dueDate[lte]=2025-01-31
GET /api/tasks?priority[in]=high,medium
```

## Bulk Operations

### POST /api/tasks/bulk

**Description**: Perform bulk operations on tasks

**Authentication**: Required

**Request Body**:
```json
{
  "operation": "update",
  "taskIds": ["uuid1", "uuid2", "uuid3"],
  "data": {
    "status": "done",
    "priority": "low"
  }
}
```

**Supported Operations**:
- `update`: Update multiple tasks
- `delete`: Delete multiple tasks
- `move`: Move multiple tasks to different status

**Response**:
```json
{
  "success": true,
  "data": {
    "updated": 3,
    "failed": 0,
    "results": [
      {
        "id": "uuid1",
        "status": "success"
      }
    ]
  },
  "message": "Bulk operation completed successfully"
}
```

## Search and Full-Text Search

### GET /api/search

**Description**: Search across multiple resources

**Authentication**: Required

**Query Parameters**:
- `q`: Search query
- `type`: Resource type (tasks, projects, users)
- `page`: Page number
- `limit`: Items per page

**Response**:
```json
{
  "success": true,
  "data": {
    "query": "documentation",
    "results": {
      "tasks": [
        {
          "id": "task-uuid",
          "title": "Complete project documentation",
          "description": "Write comprehensive documentation...",
          "score": 0.95
        }
      ],
      "projects": [
        {
          "id": "project-uuid",
          "name": "Documentation Project",
          "description": "Project for creating documentation",
          "score": 0.87
        }
      ]
    },
    "totalResults": 15
  }
}
```

## API Versioning

### Version Header

API versioning is handled via headers:

```
Accept: application/vnd.taskmanager.v1+json
```

### Current Version

- **v1**: Current stable version
- **v1.1**: Minor updates and improvements
- **v2**: Major version (planned)

### Deprecation Warnings

Deprecated endpoints include deprecation headers:

```
X-API-Deprecated: true
X-API-Deprecation-Date: 2025-12-31
X-API-Deprecation-Info: This endpoint will be removed in v2.0
```

## Testing the API

### Postman Collection

A complete Postman collection is available for testing:

```json
{
  "info": {
    "name": "Task Manager API",
    "description": "Complete API collection for Task Manager App",
    "version": "1.0.0"
  },
  "item": [
    {
      "name": "Authentication",
      "item": [
        {
          "name": "Register User",
          "request": {
            "method": "POST",
            "url": "{{baseUrl}}/api/auth/register",
            "body": {
              "mode": "raw",
              "raw": "{\n  \"name\": \"Test User\",\n  \"email\": \"test@example.com\",\n  \"password\": \"TestPass123!\",\n  \"confirmPassword\": \"TestPass123!\"\n}",
              "options": {
                "raw": {
                  "language": "json"
                }
              }
            }
          }
        }
      ]
    }
  ]
}
```

### cURL Examples

**Register User**:
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "TestPass123!",
    "confirmPassword": "TestPass123!"
  }'
```

**Create Task**:
```bash
curl -X POST http://localhost:3000/api/tasks \
  -H "Content-Type: application/json" \
  -H "Cookie: token=jwt-token-here" \
  -d '{
    "title": "Test Task",
    "description": "Test description",
    "priority": "medium"
  }'
```

**Upload File**:
```bash
curl -X POST http://localhost:3000/api/tasks/task-uuid/attachments \
  -H "Cookie: token=jwt-token-here" \
  -F "files=@screenshot.png"
```

## Performance Considerations

### Response Time Targets

- **Simple queries**: < 100ms
- **Complex queries**: < 500ms
- **File uploads**: < 2s (per MB)
- **Bulk operations**: < 1s (per 100 items)

### Caching

- **User data**: 5 minutes
- **Task lists**: 2 minutes
- **Project data**: 10 minutes
- **Analytics**: 15 minutes

### Compression

All responses are compressed using gzip when supported by the client.

## Security Features

### Authentication

- JWT tokens with 15-minute expiration
- Refresh tokens with 7-day expiration
- HTTP-only cookies for token storage
- Automatic token rotation

### Authorization

- Role-based access control (RBAC)
- Resource ownership validation
- Admin-only endpoints
- Permission-based operations

### Input Validation

- Comprehensive input sanitization
- SQL injection prevention
- XSS protection
- File type validation

### Rate Limiting

- IP-based rate limiting
- Progressive rate limiting
- Endpoint-specific limits
- Automatic blocking of abusive IPs

## Key Takeaways

✅ **Comprehensive Documentation**: Complete API reference with examples

✅ **RESTful Design**: Consistent and intuitive API structure

✅ **Security First**: Built-in authentication and authorization

✅ **Performance Optimized**: Caching, compression, and rate limiting

✅ **Developer Friendly**: Clear examples and testing tools

✅ **Production Ready**: Error handling, validation, and monitoring

---

*This chapter provides a complete reference for developers integrating with the Task Manager App API. The comprehensive documentation ensures smooth integration and reduces development time for third-party applications.*
