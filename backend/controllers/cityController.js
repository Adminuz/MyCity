const City = require('../models/City');

const getAllCities = async (req, res) => {
    try {
        const cities = await City.find({ isActive: true }).sort({ name: 1 });
        
        res.json({
            success: true,
            data: { cities }
        });
    } catch (error) {
        console.error('Shaharlarni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const getCityByCode = async (req, res) => {
    try {
        const { code } = req.params;
        const city = await City.findOne({ code: code.toLowerCase(), isActive: true });
        
        if (!city) {
            return res.status(404).json({
                success: false,
                message: 'Shahar topilmadi'
            });
        }

        res.json({
            success: true,
            data: { city }
        });
    } catch (error) {
        console.error('Shaharni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

module.exports = {
    getAllCities,
    getCityByCode
};