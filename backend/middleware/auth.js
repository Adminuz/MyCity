const jwt = require('jsonwebtoken');
const User = require('../models/User');

const authenticateToken = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        const token = authHeader && authHeader.split(' ')[1];

        if (!token) {
            return res.status(401).json({
                success: false,
                message: 'Kirish tokeni yo\'q'
            });
        }

        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        
        const user = await User.findById(decoded.userId);
        if (!user || !user.isActive) {
            return res.status(401).json({
                success: false,
                message: 'Yaroqsiz token'
            });
        }

        req.user = decoded;
        next();

    } catch (error) {
        if (error.name === 'JsonWebTokenError') {
            return res.status(401).json({
                success: false,
                message: 'Yaroqsiz token'
            });
        }
        
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                success: false,
                message: 'Token muddati tugagan'
            });
        }

        console.error('Autentifikatsiya xatosi:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const requireAdmin = async (req, res, next) => {
    try {
        const user = await User.findById(req.user.userId);
        
        if (!user || user.role !== 'admin') {
            return res.status(403).json({
                success: false,
                message: 'Kirish taqiqlangan. Administrator huquqlari talab qilinadi'
            });
        }

        next();
    } catch (error) {
        console.error('Rol tekshirishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const requireOwnerOrAdmin = async (req, res, next) => {
    try {
        const user = await User.findById(req.user.userId);
        const resourceId = req.params.id;

        if (!user) {
            return res.status(401).json({
                success: false,
                message: 'Foydalanuvchi topilmadi'
            });
        }

        if (user.role === 'admin') {
            return next();
        }

        if (user._id.toString() === resourceId) {
            return next();
        }

        return res.status(403).json({
            success: false,
            message: 'Kirish taqiqlangan'
        });

    } catch (error) {
        console.error('Huquqlarni tekshirishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

module.exports = {
    authenticateToken,
    requireAdmin,
    requireOwnerOrAdmin
};
