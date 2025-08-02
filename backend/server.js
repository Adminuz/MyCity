const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const eventRoutes = require('./routes/eventRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const serviceRoutes = require('./routes/serviceRoutes');
const infoRoutes = require('./routes/infoRoutes');
const cityRoutes = require('./routes/cityRoutes');
const reviewRoutes = require('./routes/reviewRoutes');

const app = express();

app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.json({
        message: 'REST API ga xush kelibsiz!',
        version: '1.0.0',
        endpoints: {
            cities: '/api/cities',
            events: '/api/events/tashkent',
            categories: '/api/categories/samarkand',
            services: '/api/services/tashkent',
            info: '/api/info/tashkent'
        }
    });
});

app.use('/api/cities', cityRoutes);
app.use('/api/events', eventRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/services', reviewRoutes);
app.use('/api/info', infoRoutes);

app.use('*', (req, res) => {
    res.status(404).json({
        success: false,
        message: 'Yo\'nalish topilmadi'
    });
});

app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        message: 'Ichki server xatosi'
    });
});

mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
.then(() => {
    console.log('✅ MongoDB ga ulanish muvaffaqiyatli');
})
.catch((error) => {
    console.error('❌ MongoDB ga ulanishda xato:', error);
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`🚀 Server ${PORT} portida ishga tushdi`);
    console.log(`🌐 URL: http://localhost:${PORT}`);
});

module.exports = app;