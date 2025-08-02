const Service = require('../models/Product');

const getAllServices = async (req, res) => {
    try {
        const { city } = req.params;
        
        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const services = await Service.find({ city: city.toLowerCase() }).sort({ rating: -1 });
        
        res.json({
            success: true,
            data: services
        });
    } catch (error) {
        console.error('Xizmatlarni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const getServiceById = async (req, res) => {
    try {
        const { city, id } = req.params;

        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const service = await Service.findOne({ _id: id, city: city.toLowerCase() });
        
        if (!service) {
            return res.status(404).json({
                success: false,
                message: 'Xizmat topilmadi'
            });
        }

        res.json({
            success: true,
            data: { service }
        });
    } catch (error) {
        console.error('Xizmatni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const getServicesByCategory = async (req, res) => {
    try {
        const { city, category } = req.params;
        
        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        if (!category) {
            return res.status(400).json({
                success: false,
                message: 'Kategoriya parametri majburiy'
            });
        }

        const services = await Service.find({ 
            city: city.toLowerCase(),
            category: category.toLowerCase()
        }).sort({ rating: -1 });
        
        res.json({
            success: true,
            data: services
        });
    } catch (error) {
        console.error('Kategoriya bo\'yicha xizmatlarni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const searchServices = async (req, res) => {
    try {
        const { city } = req.params;
        const { q } = req.query;
        
        if (!q) {
            return res.status(400).json({
                success: false,
                message: 'Qidiruv parametri majburiy'
            });
        }

        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const services = await Service.find({
            city: city.toLowerCase(),
            $or: [
                { name: { $regex: q, $options: 'i' } },
                { description: { $regex: q, $options: 'i' } }
            ]
        }).limit(10);

        res.json({
            success: true,
            data: services
        });
    } catch (error) {
        console.error('Xizmatlarni qidirishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

module.exports = {
    getAllServices,
    getServiceById,
    getServicesByCategory,
    searchServices
};
