# Chapter 11: API Reference

## Complete REST API Documentation

This chapter provides a comprehensive reference for all API endpoints in the Task Manager application. Each endpoint includes detailed information about methods, parameters, request bodies, responses, and authentication requirements.

## Base URL

```
Development: http://localhost:5000/api
Production: https://your-domain.com/api
```

## Authentication

All protected endpoints require a valid JWT token in the `Authorization` header or as an HTTP-only cookie.

```
Authorization: Bearer <access_token>
```

## Response Format

All API responses follow this standard format:

```json
{
  "success": boolean,
  "message": "string",
  "data": object | array | null,
  "pagination": object | null,
  "errors": array | null
}
```

## HTTP Status Codes

- **200** - Success
- **201** - Created
- **400** - Bad Request
- **401** - Unauthorized
- **403** - Forbidden
- **404** - Not Found
- **409** - Conflict
- **422** - Validation Error
- **429** - Too Many Requests
- **500** - Internal Server Error

---

## Authentication Endpoints

### 1. User Registration

**POST** `/api/auth/register`

Creates a new user account.

**Request Body:**
```json
{
  "email": "user@example.com",
  "username": "username",
  "password": "SecurePassword123!"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "User registered successfully. Please check your email for verification.",
  "data": {
    "user": {
      "id": "clx1234567890",
      "email": "user@example.com",
      "username": "username",
      "role": "USER",
      "createdAt": "2025-01-15T10:30:00.000Z"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  }
}
```

**Validation Rules:**
- Email must be valid format
- Username: 3-30 characters, alphanumeric and underscore only
- Password: minimum 8 characters, must include lowercase, uppercase, number, and special character

---

### 2. User Login

**POST** `/api/auth/login`

Authenticates user and returns access tokens.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": "clx1234567890",
      "email": "user@example.com",
      "username": "username",
      "role": "USER"
    },
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  }
}
```

---

### 3. Refresh Token

**POST** `/api/auth/refresh`

Refreshes expired access token using refresh token.

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "data": {
    "tokens": {
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    }
  }
}
```

---

### 4. User Logout

**POST** `/api/auth/logout`

Logs out user and invalidates tokens.

**Response (200):**
```json
{
  "success": true,
  "message": "Logout successful"
}
```

---

### 5. Request Password Reset

**POST** `/api/auth/forgot-password`

Sends password reset email to user.

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "If an account with that email exists, a password reset link has been sent."
}
```

---

### 6. Reset Password

**POST** `/api/auth/reset-password`

Resets user password using reset token.

**Request Body:**
```json
{
  "token": "reset_token_here",
  "newPassword": "NewSecurePassword123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

---

## User Endpoints

### 1. Get User Profile

**GET** `/api/users/profile`

Returns current user's profile information.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "clx1234567890",
      "email": "user@example.com",
      "username": "username",
      "role": "USER",
      "avatar": "https://example.com/avatar.jpg",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "_count": {
        "projects": 5,
        "tasks": 12
      }
    }
  }
}
```

---

### 2. Update User Profile

**PUT** `/api/users/profile`

Updates current user's profile information.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "username": "newusername",
  "avatar": "https://example.com/new-avatar.jpg"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user": {
      "id": "clx1234567890",
      "email": "user@example.com",
      "username": "newusername",
      "role": "USER",
      "avatar": "https://example.com/new-avatar.jpg",
      "updatedAt": "2025-01-15T11:00:00.000Z"
    }
  }
}
```

---

### 3. Change Password

**PUT** `/api/users/change-password`

Changes current user's password.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "currentPassword": "CurrentPassword123!",
  "newPassword": "NewSecurePassword123!"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

---

## Project Endpoints

### 1. Create Project

**POST** `/api/projects`

Creates a new project.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "Project Name",
  "description": "Project description"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Project created successfully",
  "data": {
    "project": {
      "id": "clx1234567890",
      "name": "Project Name",
      "description": "Project description",
      "status": "ACTIVE",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "owner": {
        "id": "clx1234567890",
        "username": "username",
        "email": "user@example.com"
      },
      "members": [
        {
          "id": "clx1234567890",
          "role": "OWNER",
          "joinedAt": "2025-01-15T10:30:00.000Z",
          "user": {
            "id": "clx1234567890",
            "username": "username",
            "email": "user@example.com"
          }
        }
      ],
      "_count": {
        "tasks": 0,
        "members": 1
      }
    }
  }
}
```

---

### 2. Get All Projects

**GET** `/api/projects`

Returns all projects for the authenticated user.

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `status` (optional): Filter by status (ACTIVE, ARCHIVED, DELETED)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": "clx1234567890",
        "name": "Project Name",
        "description": "Project description",
        "status": "ACTIVE",
        "createdAt": "2025-01-15T10:30:00.000Z",
        "updatedAt": "2025-01-15T10:30:00.000Z",
        "owner": {
          "id": "clx1234567890",
          "username": "username",
          "email": "user@example.com"
        },
        "_count": {
          "tasks": 5,
          "members": 3
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 1,
      "pages": 1
    }
  }
}
```

---

### 3. Get Project by ID

**GET** `/api/projects/:id`

Returns a specific project with all details.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "project": {
      "id": "clx1234567890",
      "name": "Project Name",
      "description": "Project description",
      "status": "ACTIVE",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "owner": {
        "id": "clx1234567890",
        "username": "username",
        "email": "user@example.com"
      },
      "members": [
        {
          "id": "clx1234567890",
          "role": "OWNER",
          "joinedAt": "2025-01-15T10:30:00.000Z",
          "user": {
            "id": "clx1234567890",
            "username": "username",
            "email": "user@example.com"
          }
        }
      ],
      "tasks": [
        {
          "id": "clx1234567890",
          "title": "Task Title",
          "description": "Task description",
          "status": "TODO",
          "priority": "MEDIUM",
          "dueDate": null,
          "createdAt": "2025-01-15T10:30:00.000Z",
          "updatedAt": "2025-01-15T10:30:00.000Z",
          "assignee": {
            "id": "clx1234567890",
            "username": "username"
          }
        }
      ],
      "_count": {
        "tasks": 1,
        "members": 1
      }
    }
  }
}
```

---

### 4. Update Project

**PUT** `/api/projects/:id`

Updates a specific project.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "name": "Updated Project Name",
  "description": "Updated project description",
  "status": "ARCHIVED"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Project updated successfully",
  "data": {
    "project": {
      "id": "clx1234567890",
      "name": "Updated Project Name",
      "description": "Updated project description",
      "status": "ARCHIVED",
      "updatedAt": "2025-01-15T11:00:00.000Z",
      "owner": {
        "id": "clx1234567890",
        "username": "username",
        "email": "user@example.com"
      }
    }
  }
}
```

---

### 5. Delete Project

**DELETE** `/api/projects/:id`

Deletes a specific project.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Project deleted successfully"
}
```

---

### 6. Add Project Member

**POST** `/api/projects/:id/members`

Adds a new member to a project.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "userId": "clx1234567890",
  "role": "MEMBER"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Member added successfully",
  "data": {
    "member": {
      "id": "clx1234567890",
      "role": "MEMBER",
      "joinedAt": "2025-01-15T11:00:00.000Z",
      "user": {
        "id": "clx1234567890",
        "username": "newmember",
        "email": "newmember@example.com"
      }
    }
  }
}
```

---

### 7. Remove Project Member

**DELETE** `/api/projects/:id/members/:userId`

Removes a member from a project.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Member removed successfully"
}
```

---

## Task Endpoints

### 1. Create Task

**POST** `/api/tasks`

Creates a new task.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "title": "Task Title",
  "description": "Task description",
  "projectId": "clx1234567890",
  "assigneeId": "clx1234567890",
  "priority": "HIGH",
  "dueDate": "2025-02-15T10:30:00.000Z"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Task created successfully",
  "data": {
    "task": {
      "id": "clx1234567890",
      "title": "Task Title",
      "description": "Task description",
      "status": "TODO",
      "priority": "HIGH",
      "dueDate": "2025-02-15T10:30:00.000Z",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "project": {
        "id": "clx1234567890",
        "name": "Project Name"
      },
      "assignee": {
        "id": "clx1234567890",
        "username": "username"
      }
    }
  }
}
```

---

### 2. Get All Tasks

**GET** `/api/tasks`

Returns all tasks for the authenticated user.

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)
- `projectId` (optional): Filter by project
- `status` (optional): Filter by status (TODO, IN_PROGRESS, REVIEW, DONE)
- `priority` (optional): Filter by priority (LOW, MEDIUM, HIGH, URGENT)
- `assigneeId` (optional): Filter by assignee

**Response (200):**
```json
{
  "success": true,
  "data": {
    "tasks": [
      {
        "id": "clx1234567890",
        "title": "Task Title",
        "description": "Task description",
        "status": "TODO",
        "priority": "HIGH",
        "dueDate": "2025-02-15T10:30:00.000Z",
        "createdAt": "2025-01-15T10:30:00.000Z",
        "updatedAt": "2025-01-15T10:30:00.000Z",
        "project": {
          "id": "clx1234567890",
          "name": "Project Name"
        },
        "assignee": {
          "id": "clx1234567890",
          "username": "username"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 1,
      "pages": 1
    }
  }
}
```

---

### 3. Get Task by ID

**GET** `/api/tasks/:id`

Returns a specific task with all details.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "task": {
      "id": "clx1234567890",
      "title": "Task Title",
      "description": "Task description",
      "status": "TODO",
      "priority": "HIGH",
      "dueDate": "2025-02-15T10:30:00.000Z",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "project": {
        "id": "clx1234567890",
        "name": "Project Name"
      },
      "assignee": {
        "id": "clx1234567890",
        "username": "username"
      },
      "comments": [
        {
          "id": "clx1234567890",
          "content": "Comment content",
          "createdAt": "2025-01-15T10:30:00.000Z",
          "user": {
            "id": "clx1234567890",
            "username": "username"
          }
        }
      ],
      "attachments": [
        {
          "id": "clx1234567890",
          "filename": "attachment.pdf",
          "originalName": "document.pdf",
          "mimeType": "application/pdf",
          "size": 1024000,
          "url": "https://example.com/attachment.pdf",
          "createdAt": "2025-01-15T10:30:00.000Z"
        }
      ]
    }
  }
}
```

---

### 4. Update Task

**PUT** `/api/tasks/:id`

Updates a specific task.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "title": "Updated Task Title",
  "description": "Updated task description",
  "status": "IN_PROGRESS",
  "priority": "MEDIUM",
  "assigneeId": "clx1234567890",
  "dueDate": "2025-02-20T10:30:00.000Z"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Task updated successfully",
  "data": {
    "task": {
      "id": "clx1234567890",
      "title": "Updated Task Title",
      "description": "Updated task description",
      "status": "IN_PROGRESS",
      "priority": "MEDIUM",
      "dueDate": "2025-02-20T10:30:00.000Z",
      "updatedAt": "2025-01-15T11:00:00.000Z"
    }
  }
}
```

---

### 5. Delete Task

**DELETE** `/api/tasks/:id`

Deletes a specific task.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Task deleted successfully"
}
```

---

### 6. Bulk Update Tasks

**PUT** `/api/tasks/bulk-update`

Updates multiple tasks at once.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "projectId": "clx1234567890",
  "updates": [
    {
      "id": "clx1234567890",
      "status": "DONE"
    },
    {
      "id": "clx1234567891",
      "priority": "HIGH"
    }
  ]
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Tasks updated successfully",
  "data": {
    "updatedTasks": [
      {
        "id": "clx1234567890",
        "status": "DONE",
        "updatedAt": "2025-01-15T11:00:00.000Z"
      },
      {
        "id": "clx1234567891",
        "priority": "HIGH",
        "updatedAt": "2025-01-15T11:00:00.000Z"
      }
    ]
  }
}
```

---

## Comment Endpoints

### 1. Create Comment

**POST** `/api/tasks/:taskId/comments`

Creates a new comment on a task.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "content": "Comment content"
}
```

**Response (201):**
```json
{
  "success": true,
  "message": "Comment created successfully",
  "data": {
    "comment": {
      "id": "clx1234567890",
      "content": "Comment content",
      "createdAt": "2025-01-15T10:30:00.000Z",
      "updatedAt": "2025-01-15T10:30:00.000Z",
      "user": {
        "id": "clx1234567890",
        "username": "username"
      }
    }
  }
}
```

---

### 2. Get Task Comments

**GET** `/api/tasks/:taskId/comments`

Returns all comments for a specific task.

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 20)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "comments": [
      {
        "id": "clx1234567890",
        "content": "Comment content",
        "createdAt": "2025-01-15T10:30:00.000Z",
        "updatedAt": "2025-01-15T10:30:00.000Z",
        "user": {
          "id": "clx1234567890",
          "username": "username"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 1,
      "pages": 1
    }
  }
}
```

---

### 3. Update Comment

**PUT** `/api/tasks/:taskId/comments/:commentId`

Updates a specific comment.

**Headers:** `Authorization: Bearer <token>`

**Request Body:**
```json
{
  "content": "Updated comment content"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Comment updated successfully",
  "data": {
    "comment": {
      "id": "clx1234567890",
      "content": "Updated comment content",
      "updatedAt": "2025-01-15T11:00:00.000Z"
    }
  }
}
```

---

### 4. Delete Comment

**DELETE** `/api/tasks/:taskId/comments/:commentId`

Deletes a specific comment.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Comment deleted successfully"
}
```

---

## File Upload Endpoints

### 1. Upload File

**POST** `/api/tasks/:taskId/attachments`

Uploads a file attachment to a task.

**Headers:** `Authorization: Bearer <token>`

**Request Body:** `multipart/form-data`
- `file`: File to upload
- `description` (optional): File description

**Response (201):**
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "data": {
    "attachment": {
      "id": "clx1234567890",
      "filename": "document.pdf",
      "originalName": "report.pdf",
      "mimeType": "application/pdf",
      "size": 1024000,
      "url": "https://storage.googleapis.com/bucket/document.pdf",
      "createdAt": "2025-01-15T10:30:00.000Z"
    }
  }
}
```

---

### 2. Get Task Attachments

**GET** `/api/tasks/:taskId/attachments`

Returns all attachments for a specific task.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "attachments": [
      {
        "id": "clx1234567890",
        "filename": "document.pdf",
        "originalName": "report.pdf",
        "mimeType": "application/pdf",
        "size": 1024000,
        "url": "https://storage.googleapis.com/bucket/document.pdf",
        "createdAt": "2025-01-15T10:30:00.000Z"
      }
    ]
  }
}
```

---

### 3. Delete Attachment

**DELETE** `/api/tasks/:taskId/attachments/:attachmentId`

Deletes a specific attachment.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "message": "Attachment deleted successfully"
}
```

---

## Search Endpoints

### 1. Search Tasks

**GET** `/api/search/tasks`

Searches tasks across all accessible projects.

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `q`: Search query
- `projectId` (optional): Filter by project
- `status` (optional): Filter by status
- `priority` (optional): Filter by priority
- `assigneeId` (optional): Filter by assignee
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "tasks": [
      {
        "id": "clx1234567890",
        "title": "Task Title",
        "description": "Task description",
        "status": "TODO",
        "priority": "HIGH",
        "project": {
          "id": "clx1234567890",
          "name": "Project Name"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 1,
      "pages": 1
    }
  }
}
```

---

### 2. Search Projects

**GET** `/api/search/projects`

Searches projects accessible to the user.

**Headers:** `Authorization: Bearer <token>`

**Query Parameters:**
- `q`: Search query
- `status` (optional): Filter by status
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "projects": [
      {
        "id": "clx1234567890",
        "name": "Project Name",
        "description": "Project description",
        "status": "ACTIVE",
        "owner": {
          "id": "clx1234567890",
          "username": "username"
        }
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 1,
      "pages": 1
    }
  }
}
```

---

## Statistics Endpoints

### 1. Get Dashboard Stats

**GET** `/api/stats/dashboard`

Returns dashboard statistics for the authenticated user.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "stats": {
      "totalProjects": 5,
      "activeProjects": 4,
      "totalTasks": 25,
      "completedTasks": 15,
      "pendingTasks": 10,
      "overdueTasks": 2,
      "recentActivity": [
        {
          "type": "TASK_CREATED",
          "description": "New task 'Implement Login' created in Project A",
          "timestamp": "2025-01-15T10:30:00.000Z"
        }
      ]
    }
  }
}
```

---

### 2. Get Project Stats

**GET** `/api/projects/:id/stats`

Returns statistics for a specific project.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "stats": {
      "totalTasks": 25,
      "completedTasks": 15,
      "pendingTasks": 10,
      "overdueTasks": 2,
      "tasksByStatus": {
        "TODO": 8,
        "IN_PROGRESS": 5,
        "REVIEW": 2,
        "DONE": 15
      },
      "tasksByPriority": {
        "LOW": 5,
        "MEDIUM": 12,
        "HIGH": 6,
        "URGENT": 2
      }
    }
  }
}
```

---

## WebSocket Events

### Connection

**Event:** `connect`
**Description:** Client connects to WebSocket server

**Data:**
```json
{
  "userId": "clx1234567890",
  "username": "username"
}
```

---

### Task Updates

**Event:** `task:updated`
**Description:** Task has been updated

**Data:**
```json
{
  "taskId": "clx1234567890",
  "projectId": "clx1234567890",
  "changes": {
    "status": "IN_PROGRESS",
    "assigneeId": "clx1234567890"
  },
  "updatedBy": "clx1234567890",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

---

### New Comments

**Event:** `comment:created`
**Description:** New comment has been added to a task

**Data:**
```json
{
  "commentId": "clx1234567890",
  "taskId": "clx1234567890",
  "projectId": "clx1234567890",
  "content": "Comment content",
  "createdBy": "clx1234567890",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

---

### Project Updates

**Event:** `project:updated`
**Description:** Project has been updated

**Data:**
```json
{
  "projectId": "clx1234567890",
  "changes": {
    "name": "Updated Project Name",
    "status": "ACTIVE"
  },
  "updatedBy": "clx1234567890",
  "timestamp": "2025-01-15T10:30:00.000Z"
}
```

---

## Error Responses

### Validation Error (400)

```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Valid email is required",
      "value": "invalid-email"
    }
  ]
}
```

### Authentication Error (401)

```json
{
  "success": false,
  "message": "Access token required"
}
```

### Authorization Error (403)

```json
{
  "success": false,
  "message": "Insufficient permissions",
  "required": ["ADMIN"],
  "current": "USER"
}
```

### Not Found Error (404)

```json
{
  "success": false,
  "message": "Project not found"
}
```

### Rate Limit Error (429)

```json
{
  "success": false,
  "message": "Too many requests from this IP, please try again later."
}
```

### Internal Server Error (500)

```json
{
  "success": false,
  "message": "Internal server error"
}
```

---

## Rate Limiting

The API implements rate limiting to prevent abuse:

- **General endpoints:** 100 requests per 15 minutes per IP
- **Authentication endpoints:** 5 requests per 15 minutes per IP
- **API endpoints:** 1000 requests per 15 minutes per IP
- **File uploads:** 10 uploads per hour per user

---

## File Upload Limits

- **Maximum file size:** 5MB
- **Allowed file types:** JPEG, PNG, GIF, PDF
- **Storage:** Google Cloud Storage
- **File naming:** UUID-based to prevent conflicts

---

## Pagination

All list endpoints support pagination with these parameters:

- **page:** Page number (starts from 1)
- **limit:** Items per page (default: 10, max: 100)

Response includes pagination metadata:

```json
{
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 100,
    "pages": 10
  }
}
```

---

## Summary & Key Takeaways

### API Features
- **RESTful design** with consistent naming conventions
- **Comprehensive authentication** with JWT tokens
- **Role-based access control** for security
- **Real-time updates** via WebSocket
- **File upload support** with Google Cloud Storage
- **Search functionality** across projects and tasks
- **Statistics and analytics** for insights

### Best Practices
- **Consistent response format** across all endpoints
- **Proper HTTP status codes** for different scenarios
- **Input validation** and sanitization
- **Rate limiting** to prevent abuse
- **Comprehensive error handling** with detailed messages
- **Pagination** for large datasets
- **Real-time notifications** for collaborative features

### Next Steps
In the next chapter, we'll explore the appendix with configuration examples, middleware snippets, and additional resources.

---

💡 **Tip**: Use the WebSocket events for real-time updates in your frontend application. This provides a better user experience for collaborative features.

⚠️ **Warning**: Always validate and sanitize user input on both client and server sides. Never trust client-side data.

✅ **Best Practice**: Implement proper rate limiting and pagination to ensure your API scales well and provides a good user experience.
