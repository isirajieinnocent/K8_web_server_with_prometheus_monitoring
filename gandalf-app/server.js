// server.js - Node.js backend with Prometheus metrics
const express = require('express');
const client = require('prom-client');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 80;

// Create a Registry to register the metrics
const register = new client.Registry();



// Add a default label which is added to all metrics
register.setDefaultLabels({
    app: 'gandalf-webapp'
});

// Enable the collection of default metrics
client.collectDefaultMetrics({ register });

// Create custom counters for our endpoints
const gandalfRequestCounter = new client.Counter({
    name: 'gandalf_requests_total',
    help: 'Total number of requests to /gandalf endpoint',
    registers: [register]
});

const colomboRequestCounter = new client.Counter({
    name: 'colombo_requests_total',
    help: 'Total number of requests to /colombo endpoint',
    registers: [register]
});

// Middleware to serve static files (your Gatsby build)
app.use(express.static(path.join(__dirname, 'public')));

// Middleware to increment counters
app.use('/gandalf', (req, res, next) => {
    gandalfRequestCounter.inc();
    next();
});

app.use('/colombo', (req, res, next) => {
    colomboRequestCounter.inc();
    next();
});

// Gandalf endpoint
app.get('/gandalf', (req, res) => {
    const html = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>Gandalf</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                padding: 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                margin: 0;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            .navigation {
                display: flex;
                justify-content: center;
                gap: 30px;
                margin-bottom: 40px;
                flex-wrap: wrap;
            }
            
            .nav-button {
                background: rgba(255, 255, 255, 0.2);
                border: 2px solid rgba(255, 255, 255, 0.3);
                padding: 15px 30px;
                color: white;
                text-decoration: none;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: bold;
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
                cursor: pointer;
                display: inline-block;
            }
            
            .nav-button:hover, .nav-button.active {
                background: rgba(255, 255, 255, 0.3);
                border-color: rgba(255, 255, 255, 0.5);
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            }
            
            .container {
                background: white;
                padding: 30px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                max-width: 600px;
            }
            h1 {
                color: #333;
                margin-bottom: 20px;
            }
            img {
                max-width: 100%;
                height: auto;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
        </style>
    </head>
    <body>
        <div class="navigation">
            <a href="/" class="nav-button active">🏠 Home</a>
            <a href="/gandalf" class="nav-button">🧙‍♂️ Gandalf</a>
            <a href="/colombo" class="nav-button">🇱🇰 Colombo Time</a>
        </div>
        <div class="container">
            <h1>You Shall Not Pass!</h1>
            <img src="https://media-bucket-adcash.s3.us-east-1.amazonaws.com/images.webp" 
                 alt="Gandalf the Grey" 
                 onerror="this.src='https://via.placeholder.com/400x500/333/fff?text=Gandalf+the+Grey'">
            <p style="margin-top: 20px; color: #666;">
                "A wizard is never late, nor is he early. He arrives precisely when he means to."
            </p>
        </div>
    </body>
    </html>
  `;
    res.send(html);
});

// Colombo time endpoint
app.get('/colombo', (req, res) => {
    // Get current time in Colombo (UTC+5:30)
    const now = new Date();
    const utc = now.getTime() + (now.getTimezoneOffset() * 60000);
    const colomboTime = new Date(utc + (5.5 * 3600000));
    const timeString = colomboTime.toLocaleString('en-US', {
        timeZone: 'Asia/Colombo',
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });

    const html = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>Colombo Time</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                padding: 20px;
                background: linear-gradient(135deg, #ff7e5f 0%, #feb47b 100%);
                min-height: 100vh;
                margin: 0;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            .navigation {
                display: flex;
                justify-content: center;
                gap: 30px;
                margin-bottom: 40px;
                flex-wrap: wrap;
            }
            
            .nav-button {
                background: rgba(255, 255, 255, 0.2);
                border: 2px solid rgba(255, 255, 255, 0.3);
                padding: 15px 30px;
                color: white;
                text-decoration: none;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: bold;
                transition: all 0.3s ease;
                backdrop-filter: blur(10px);
                cursor: pointer;
                display: inline-block;
            }
            
            .nav-button:hover, .nav-button.active {
                background: rgba(255, 255, 255, 0.3);
                border-color: rgba(255, 255, 255, 0.5);
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            }
            .container {
                background: white;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                max-width: 600px;
            }
            .time {
                font-size: 2em;
                color: #333;
                font-weight: bold;
                margin: 20px 0;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                border-left: 5px solid #ff7e5f;
            }
            .location {
                color: #666;
                font-size: 1.2em;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="navigation">
            <a href="/" class="nav-button active">🏠 Home</a>
            <a href="/gandalf" class="nav-button">🧙‍♂️ Gandalf</a>
            <a href="/colombo" class="nav-button">🇱🇰 Colombo Time</a>
        </div>
        <div class="container">
            <h1>🌴 Current Time in Colombo</h1>
            <div class="location">Sri Lanka 🇱🇰</div>
            <div class="time">${timeString}</div>
            <p style="color: #666;">
                Time zone: Asia/Colombo (UTC+05:30)
            </p>
        </div>
        <script>
            // Auto-refresh every second
            setTimeout(() => location.reload(), 1000);
        </script>
    </body>
    </html>
  `;
    res.send(html);
});

// Prometheus metrics endpoint
app.get('/metrics', async (req, res) => {
    try {
        res.set('Content-Type', register.contentType);
        const metrics = await register.metrics();
        res.end(metrics);
    } catch (ex) {
        res.status(500).end(ex);
    }
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Serve Gatsby static files for other routes
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
    console.log(`Metrics available at http://localhost:${PORT}/metrics`);
});

module.exports = app;