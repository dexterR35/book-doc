# Chapter 6: Task Management & Kanban


##  **Kanban Board & Task Management Diagrams**

### Kanban Board Architecture Overview



```
┌──────────────────────────────────────────────────────────────────────┐
│                           KANBAN BOARD ARCHITECTURE                  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐   │
│  │   TODO COLUMN   │    │ IN PROGRESS     │    │   REVIEW        │   │
│  │                 │    │                 │    │                 │   │
│  │ • Task 1        │    │ • Task 4        │    │ • Task 6        │   │
│  │ • Task 2        │    │ • Task 5        │    │ • Task 7        │   │
│  │ • Task 3        │    │                 │    │                 │   │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘   │
│           │                       │                       │          │
│           ▼                       ▼                       ▼          │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐   │
│  │   DRAG & DROP   │    │   STATUS        │    │   WORKFLOW      │   │
│  │   SYSTEM        │    │   UPDATES       │    │   RULES         │   │
│  │                 │    │                 │    │                 │   │
│  │ • Visual        │    │ • Real-time     │    │ • Validation    │   │
│  │ • Intuitive     │    │ • Persistence   │    │ • Permissions   │   │
│  │ • Responsive    │    │ • Notifications │    │ • Automation    │   │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘   │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### Task Status Flow & Workflow Management


```
┌──────────────────────────────────────────────────────────────────────────────┐
│                           TASK WORKFLOW DIAGRAM                              │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │   DRAFT     │───►│   PENDING   │───►│   ACTIVE    │───►│   REVIEW    │    │
│  │             │    │             │    │             │    │             │    │
│  │ • Created   │    │ • Approved  │    │ • In Progress│   │ • Completed │    │
│  │ • Not       │    │ • Assigned  │    │ • Updated   │    │ • Ready for │    │
│  │   Assigned  │    │ • Scheduled │    │ • Tracked   │    │   Approval  │    │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘    │
│           │                   │                   │                   │      │
│           ▼                   ▼                   ▼                   ▼      │
│  ┌─────────────┐    ┌───────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │   ARCHIVED  │    │   BLOCKED     │    │   ON HOLD   │    │   COMPLETED │  │
│  │             │    │               │    │             │    │             │  │
│  │ • Historical│    │ • Dependencies│    │ • Waiting   │    │ • Delivered │  │
│  │ • Reference │    │ • Issues      │    │ • Resources │    │ • Closed    │  │
│  │ • Analytics │    │ • Resolution  │    │ • Approval  │    │ • Archive   │  │
│  └─────────────┘    └───────────────┘    └─────────────┘    └─────────────┘  │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Task Assignment & User Management


```
┌────────────────────────────────────────────────────────────────────────┐
│                           TASK ASSIGNMENT SYSTEM                       │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐     │
│  │   TASK          │    │   USER          │    │   ASSIGNMENT    │     │
│  │   CREATION      │    │   SELECTION     │    │   PROCESS       │     │
│  │                 │    │                 │    │                 │     │
│  │ • Title         │    │ • Skills        │    │ • Notification  │     │
│  │ • Description   │    │ • Availability  │    │ • Permission    │     │
│  │ • Priority      │    │ • Workload      │    │ • Tracking      │     │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘     │
│           │                       │                       │            │
│           ▼                       ▼                       ▼            │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐     │
│  │   VALIDATION    │    │   WORKFLOW      │    │   MONITORING    │     │
│  │   & APPROVAL    │    │   INTEGRATION   │    │   & REPORTING   │     │
│  │                 │    │                 │    │                 │     │
│  │ • Business      │    │ • Status        │    │ • Progress      │     │
│  │   Rules         │    │   Updates       │    │ • Performance   │     │
│  │ • Permissions   │    │ • Notifications │    │ • Analytics     │     │
│  └─────────────────┘    └─────────────────┘    └─────────────────┘     │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### Priority Management & Sorting Algorithms


```
┌──────────────────────────────────────────────────────────────────────────── ─┐
│                           PRIORITY MANAGEMENT SYSTEM                         │
├──────────────────────────────────────────────────────────────────────────── ─┤
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                           PRIORITY LEVELS                               │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐        │ │
│  │  │   URGENT    │ │    HIGH     │ │   MEDIUM    │ │     LOW     │        │ │
│  │  │             │ │             │ │             │ │             │        │ │
│  │  │ • Red       │ │ • Orange    │ │ • Yellow    │ │ • Green     │        │ │
│  │  │ • Top       │ │ • High      │ │ • Normal    │ │ • Low       │        │ │
│  │  │ • Immediate │ │ • Important │ │ • Standard  │ │ • Optional  │        │ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                         │
│                                    ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                         SORTING ALGORITHMS                              │ │
│  │  • Priority-based sorting (High to Low)                                 │ │
│  │  • Due date sorting (Earliest first)                                    │ │
│  │  • Creation date sorting (Newest first)                                 │ │
│  │  • Assignee-based grouping                                              │ │
│  │  • Project-based organization                                           │ │
│  │  • Custom sorting rules                                                 │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────── ─┘
```

**Priority Management Features:**
- **Visual Indicators**: Color-coded priority levels for quick identification
- **Smart Sorting**: Automatic sorting based on priority, due date, and creation time
- **Workload Balancing**: Intelligent task distribution across team members
- **Deadline Management**: Automatic notifications for approaching due dates
- **Escalation Rules**: Automatic priority escalation for overdue tasks
- **Capacity Planning**: Workload visualization and resource allocation

### Real-time Collaboration & Updates


```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           REAL-TIME COLLABORATION                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │   USER      │───►│   WEBSOCKET │───►│   SERVER    │───►│   BROADCAST │   │
│  │   ACTION    │    │   CONNECTION│    │   PROCESSING│    │   TO TEAM   │   │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘   │
│           │                   │                   │                   │     │
│           ▼                   ▼                   ▼                   ▼     │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │   TASK      │    │   STATE     │    │   VALIDATE  │    │   UPDATE    │   │
│  │   UPDATE    │    │   CHANGE    │    │   & PROCESS │    │   CLIENTS   │   │
│  └─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

**Real-time Features:**
- **Live Updates**: Instant synchronization across all team members
- **Conflict Resolution**: Automatic conflict detection and resolution
- **Offline Support**: Local caching with sync when online
- **Activity Feed**: Real-time activity tracking and notifications
- **Collaborative Editing**: Multiple users can work simultaneously
- **Version History**: Complete audit trail of all changes

```javascript
const useKanbanStore = create(
  devtools(
    (set, get) => ({

const initialColumns = {
  TODO: [],
  IN_PROGRESS: [],
  REVIEW: [],
  DONE: [],
};

      columns: initialColumns,
      isDragging: false,
      draggedTask: null,
      targetColumn: null,
      initializeBoard: (tasks) => {
        const columns = { ...initialColumns };
        
        tasks.forEach((task) => {
          if (columns[task.status]) {
            columns[task.status].push(task);
          }
        });
        // Sort tasks by priority and creation date
        Object.keys(columns).forEach((status) => {
          columns[status].sort((a, b) => {
            const priorityOrder = { URGENT: 4, HIGH: 3, MEDIUM: 2, LOW: 1 };
            const priorityDiff = priorityOrder[b.priority] - priorityOrder[a.priority];
            
            if (priorityDiff !== 0) return priorityDiff;
            
            return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
          });
        });
        set({ columns });
      },

      moveTask: async (taskId, fromStatus, toStatus) => {
        try {
          // Update task status via API
          const updatedTask = await taskService.updateTaskStatus(taskId, toStatus);
          // Update local state
          set((state) => {
            const newColumns = { ...state.columns };
            // Remove from source column
            newColumns[fromStatus] = newColumns[fromStatus].filter(
              (task) => task.id !== taskId
            );
            // Add to target column
            newColumns[toStatus] = [...newColumns[toStatus], updatedTask];
            // Sort target column
            newColumns[toStatus].sort((a, b) => {
              const priorityOrder = { URGENT: 4, HIGH: 3, MEDIUM: 2, LOW: 1 };
              const priorityDiff = priorityOrder[b.priority] - priorityOrder[a.priority];
              if (priorityDiff !== 0) return priorityDiff;
              
              return new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime();
            });

            return { columns: newColumns };
          });
          return updatedTask;
        } catch (error) {
          console.error('Failed to move task:', error);
          throw error;
        }
      },
    })
    {
      name: 'kanban-store',
    }
  )
);
```



*This chapter - task management with Kanban boards and role-based access control.*
