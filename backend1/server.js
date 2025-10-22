const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors());
app.use(morgan('combined'));
app.use(express.json());

// Routes
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    service: 'user-service',
    timestamp: new Date().toISOString()
  });
});

app.get('/auth/login', (req, res) => {
  res.json({ 
    message: 'Login endpoint from Node.js service',
    service: 'user-service'
  });
});

app.get('/users', (req, res) => {
  res.json({ 
    users: [
      { id: 1, name: 'John Doe', email: 'john@example.com' },
      { id: 2, name: 'Jane Smith', email: 'jane@example.com' }
    ],
    service: 'user-service'
  });
});

app.get('/users/:id', (req, res) => {
  res.json({ 
    user: { 
      id: req.params.id, 
      name: 'User ' + req.params.id,
      email: 'user' + req.params.id + '@example.com'
    },
    service: 'user-service'
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`User Service running on port ${PORT}`);
});
