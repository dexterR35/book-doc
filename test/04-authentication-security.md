# Chapter 4: Authentication & Security

## Enterprise Security Architecture

### Multi-Layer Security Implementation

The SYNC application implements a comprehensive security architecture with multiple layers of protection:

```
┌───────────────────────────────────────────────────────────┐
│                           SECURITY ARCHITECTURE           │
├───────────────────────────────────────────────────────────┤
│                                                           │
│  ┌──────────────────────────────────────────────────────┐ │
│  │                           CLIENT LAYER               │ │
│  │  • Input validation and sanitization                 │ │
│  │  • XSS prevention                                    │ │
│  │  • CSRF token management                             │ │
│  │  • Secure cookie handling                            │ │
│  └──────────────────────────────────────────────────────┘ │
│                                    │                      │
│                                    ▼                      │
│  ┌─────────────────────────────────────────────────────┐  │
│  │                         TRANSPORT LAYER             │  │
│  │  • HTTPS/TLS 1.3 encryption                         │  │
│  │  • Certificate pinning                              │  │
│  │  • Secure headers (HSTS, CSP)                       │  │
│  │  • Rate limiting and DDoS protection                │  │
│  └─────────────────────────────────────────────────────┘  │
│                                    │                      │
│                                    ▼                      │
│  ┌─────────────────────────────────────────────────────┐  │
│  │                        APPLICATION LAYER            │  │
│  │  • JWT authentication                               │  │
│  │  • Role-based access control (RBAC)                 │  │
│  │  • Input validation and sanitization                │  │
│  │  • SQL injection prevention                         │  │
│  └─────────────────────────────────────────────────────┘  │
│                                    │                      │
│                                    ▼                      │
│  ┌──────────────────────────────────────────────────────┐ │
│  │                           DATA LAYER                 │ │
│  │  • Database encryption at rest                       │ │
│  │  • Secure connection strings                         │ │
│  │  • Audit logging                                     │ │
│  │  • Backup encryption                                 │ │
│  └──────────────────────────────────────────────────────┘ │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

### Authentication Service Implementation

```javascript
// server/services/authService.js
class AuthService {
  static async register(userData) {
    const { email, password, firstName, lastName } = userData;
    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email }
    });
    if (existingUser) {
      throw new Error('User already exists');
    }
    // Hash password
    const saltRounds = 12;
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    // Create user
    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        firstName,
        lastName,
        role: 'USER'
      },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        role: true,
        createdAt: true
      }
    });
    // Generate tokens
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );
    const refreshToken = await createRefreshToken(user.id);
    return {
      user,
      accessToken,
      refreshToken
    };
  }

  static async login(email, password) {
    // Find user
    const user = await prisma.user.findUnique({
      where: { email }
    });
    if (!user) {
      throw new Error('Invalid credentials');
    }
    // Verify password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      throw new Error('Invalid credentials');
    }
    // Generate tokens
    const accessToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );
    const refreshToken = await createRefreshToken(user.id);
    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role
      },
      accessToken,
      refreshToken
    };
  }

  static async refreshAccessToken(refreshToken) {
    const payload = await verifyRefreshToken(refreshToken); 
    const user = await prisma.user.findUnique({
      where: { id: payload.userId },
      select: {
        id: true,
        email: true,
        role: true
      }
    });
    if (!user) {
      throw new Error('User not found');
    }
    const newAccessToken = jwt.sign(
      { userId: user.id, email: user.email, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '15m' }
    );
    return { accessToken: newAccessToken };
  }
}

```


### CSRF Protection Middleware

```javascript
// server/middleware/csrf.js
const crypto = require('crypto');

const generateCSRFToken = (req, res, next) => {
  try {
    // Generate CSRF token
    const csrfToken = crypto.randomBytes(32).toString('hex');
    // Store token in session or memory
    req.session = req.session || {};
    req.session.csrfToken = csrfToken;
    res.locals.csrfToken = csrfToken;
    next();
  } catch (error) {
    next(error);
  }
};

const validateCSRFToken = (req, res, next) => {
  try {
    const { csrfToken } = req.body;
    const sessionToken = req.session?.csrfToken;
    if (!csrfToken || !sessionToken || csrfToken !== sessionToken) {
      return res.status(403).json({
        success: false,
        message: 'CSRF token validation failed'
      });
    }
    // Clear used token
    delete req.session.csrfToken;
    next();
  } catch (error) {
    next(error);
  }
};
```



*This chapter provides exmaples of security implementation for applications with multi-layer protection, authentication, and authorization systems.*
