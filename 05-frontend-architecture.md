# Chapter 5: Frontend Architecture

## React Application Structure

### Main Application Component

```javascript
// client/src/App.jsx


const App = () => {
  return (
    <AuthProvider>
      <Router>
        <div className="min-h-screen bg-gray-50">
          <Routes>
            {/* Public routes */}
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            {/* Protected routes */}
            <Route path="/" element={<ProtectedRoute><Layout /></ProtectedRoute>}>
              <Route index element={<Dashboard />} />
              <Route path="tasks" element={<Tasks />} />
              <Route path="projects" element={<Projects />} />
              <Route path="users" element={<Users />} />
            </Route>
          </Routes>
          <Toaster
            position="top-right"
            toastOptions={{
              duration: 4000,
              style: {
                background: '#363636',
                color: '#fff',
              },
            }}
          />
        </div>
      </Router>
    </AuthProvider>
  );
};
```

## Design System & UI Architecture

Our design system leverages TailwindCSS for consistent, responsive, and beautiful interfaces:

### Component Architecture

The frontend follows a modular component architecture with:

- **Atomic Design Principles**: Building blocks from atoms to organisms
- **Reusable Components**: Shared UI elements across the application
- **Responsive Design**: Mobile-first approach with adaptive breakpoints
- **Accessibility**: WCAG 2.1 AA compliance with screen reader support
- **Theme System**: Light/dark mode with custom branding support
- **Performance**: Code splitting and lazy loading for optimal performance

### State Management with Zustand

Zustand provides lightweight, scalable state management:

- **Simple API**: Minimal boilerplate compared to Redux
- **Type Safety**: Full JavaScript support with type definitions
- **Middleware Support**: DevTools, persistence, and custom middleware
- **React Integration**: Hooks-based API for seamless React integration

```javascript
// client/src/stores/taskStore.js


const useTaskStore = create(
  devtools(
    persist(
      (set, get) => ({
        // State
        tasks: [],
        loading: false,
        error: null,
        filters: {
          status: null,
          priority: null,
          projectId: null,
          search: ''
        },
        pagination: {
          page: 1,
          limit: 10,
          total: 0
        },

        // Actions
        setTasks: (tasks) => set({ tasks }),
        setLoading: (loading) => set({ loading }),
        setError: (error) => set({ error }),
        setFilters: (filters) => set({ filters }),
        setPagination: (pagination) => set({ pagination }),
        // Async actions
        fetchTasks: async (params = {}) => {
          set({ loading: true, error: null });
          try {
            const response = await taskService.getTasks(params);
            set({
              tasks: response.data,
              pagination: response.pagination,
              loading: false
            });
          } catch (error) {
            set({
              error: error.message,
              loading: false
            });
          }
        },

        createTask: async (taskData) => {
          set({ loading: true, error: null });
          try {
            const newTask = await taskService.createTask(taskData);
            set(state => ({
              tasks: [newTask, ...state.tasks],
              loading: false
            }));
            return newTask;
          } catch (error) {
            set({
              error: error.message,
              loading: false
            });
            throw error;
          }
        },


        getFilteredTasks: () => {
          const state = get();
          let filtered = state.tasks;

          if (state.filters.status) {
            filtered = filtered.filter(task => task.status === state.filters.status);
          }

          if (state.filters.priority) {
            filtered = filtered.filter(task => task.priority === state.filters.priority);
          }

          if (state.filters.projectId) {
            filtered = filtered.filter(task => task.projectId === state.filters.projectId);
          }

          if (state.filters.search) {
            const searchLower = state.filters.search.toLowerCase();
            filtered = filtered.filter(task =>
              task.title.toLowerCase().includes(searchLower) ||
              task.description?.toLowerCase().includes(searchLower)
            );
          }

          return filtered;
        }
      }),
      {
        name: 'task-store',
        partialize: (state) => ({
          filters: state.filters,
          pagination: state.pagination
        })
      }
    ),
    {
      name: 'task-store'
    }
  )
);
```


### Form Components

```javascript

const TaskForm = ({ task, onSubmit, onCancel, mode = 'create' }) => {
  const { createTask, updateTask, loading } = useTaskStore();
  const { projects } = useProjectStore();
  const initialValues = {
    title: task?.title || '',
    description: task?.description || '',
    priority: task?.priority || 'MEDIUM',
    status: task?.status || 'TODO',
    dueDate: task?.dueDate ? new Date(task.dueDate).toISOString().split('T')[0] : '',
    projectId: task?.projectId || ''
  };

  const validationSchema = Yup.object({
    title: Yup.string()
      .min(3, 'Title must be at least 3 characters')
      .max(200, 'Title must not exceed 200 characters')
      .required('Title is required'),
  });

  const handleSubmit = async (values, { setSubmitting, resetForm }) => {
    try {
      if (mode === 'create') {
        await createTask(values);
      } else {
        await updateTask(task.id, values);
      }
      
      onSubmit?.(values);
      resetForm();
    } catch (error) {
      console.error('Task submission error:', error);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-sm border p-6">
      <h2 className="text-xl font-semibold text-gray-900 mb-6">
        {mode === 'create' ? 'Create New Task' : 'Edit Task'}
      </h2>
      <Formik
        initialValues={initialValues}
        validationSchema={validationSchema}
        onSubmit={handleSubmit}
      >
        {({ isSubmitting, isValid, dirty }) => (
          <Form className="space-y-6">
            <div>
              <label htmlFor="title" className="block text-sm font-medium text-gray-700 mb-2">
                Title *
              </label>
              <Field
                type="text"
                id="title"
                name="title"
                className="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                placeholder="Enter task title"
              />
              <ErrorMessage name="title" component="div" className="mt-1 text-sm text-red-600" />
            </div>
            <div className="flex justify-end space-x-3 pt-4">
              <Button
                type="button"
                variant="outline"
                onClick={onCancel}
                disabled={isSubmitting}
              >
                Cancel
              </Button>
              <Button
                type="submit"
                disabled={isSubmitting || !isValid || !dirty}
                loading={isSubmitting}
              >
                {mode === 'create' ? 'Create Task' : 'Update Task'}
              </Button>
            </div>
          </Form>
        )}
      </Formik>
    </div>
  );
};
```

### Custom Hooks

```javascript
function useApi(options = {}) {
  const {
    url,
    method = 'GET',
    body = null,
    headers = {},
    immediate = false,
    onSuccess,
    onError
  } = options;

  const execute = useCallback(async (customOptions = {}) => {
    const finalOptions = { ...options, ...customOptions };
    const {
      url: finalUrl,
      method: finalMethod,
      body: finalBody,
      headers: finalHeaders
    } = finalOptions;
    if (!finalUrl) return;
    setLoading(true);
    setError(null);
    try {
      const requestHeaders = {
        'Content-Type': 'application/json',
        ...finalHeaders
      };
      if (accessToken) {
        requestHeaders.Authorization = `Bearer ${accessToken}`;
      }
      const response = await fetch(finalUrl, {
        method: finalMethod,
        headers: requestHeaders,
        body: finalBody ? JSON.stringify(finalBody) : null
      });
      if (!response.ok) {
        if (response.status === 401) {
          logout();
          throw new Error('Authentication required');
        }
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const responseData = await response.json();
      setData(responseData);
      onSuccess?.(responseData);
      return responseData;
    } catch (err) {
      const errorMessage = err.message || 'An error occurred';
      setError(errorMessage);
      onError?.(err);
      throw err;
    } finally {
      setLoading(false);
    }
  }, [url, method, body, headers, accessToken, logout, onSuccess, onError]);

  useEffect(() => {
    if (immediate && url) {
      execute();
    }
  }, [immediate, url, execute]);

  return {
    data,
    loading,
    error,
    execute,
    setData,
    setError
  };
}
```


### Kanban Board Components

```javascript
const KanbanCard = React.memo(({ task, index, onEdit, onDelete }) => {
  const timeAgo = useMemo(() => {
    if (!task.updatedAt) return '';
    return formatDistanceToNow(new Date(task.updatedAt), { addSuffix: true });
  }, [task.updatedAt]);

  const handleEdit = useCallback(() => {
    onEdit?.(task);
  }, [task, onEdit]);

  const handleDelete = useCallback(() => {
    if (window.confirm('Are you sure you want to delete this task?')) {
      onDelete?.(task.id);
    }
  }, [task.id, onDelete]);

  return (
    <Draggable draggableId={task.id} index={index}>
      {(provided, snapshot) => (
        <div
          ref={provided.innerRef}
          {...provided.draggableProps}
          {...provided.dragHandleProps}
          className={`
            bg-white rounded-lg shadow-sm border p-4 mb-3 cursor-move
            ${snapshot.isDragging ? 'shadow-lg rotate-2' : ''}
            hover:shadow-md transition-all duration-200
          `}
        >
          <div className="flex items-start justify-between mb-3">
            <h3 className="font-medium text-gray-900 text-sm leading-tight line-clamp-2">
              {task.title}
            </h3>
            <div className="flex items-center space-x-2 ml-2">
              <PriorityBadge priority={task.priority} />
              <StatusBadge status={task.status} />
            </div>
          </div>

          {task.description && (
            <p className="text-gray-600 text-xs mb-3 line-clamp-3">
              {task.description}
            </p>
          )}
          </div>
        </div>
      )}
    </Draggable>
  );
});

KanbanCard.displayName = 'KanbanCard';
```

## Performance Optimization

### Code Splitting and Lazy Loading


- **Route-based Code Splitting**: Each page is loaded only when needed
- **Component Lazy Loading**: Heavy components are loaded on demand
- **Bundle Optimization**: Tree shaking and dead code elimination
- **Image Optimization**: WebP format with fallbacks and lazy loading
- **Caching Strategies**: Service worker for offline support

### Responsive Design Implementation

- **Mobile-First Approach**: Design starts with mobile and scales up
- **Flexible Grid System**: CSS Grid and Flexbox for adaptive layouts
- **Breakpoint Management**: Consistent breakpoints across components
- **Touch-Friendly Interface**: Optimized for mobile interactions
- **Performance Monitoring**: Real-time performance metrics



*This chapter offer a modern frontend architecture with React, Zustand state management, and component design for scalable applications.*
