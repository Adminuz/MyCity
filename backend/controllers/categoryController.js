const Category = require('../models/Category');

const getAllCategories = async (req, res) => {
    try {
        const { city } = req.params;
        
        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const categories = await Category.find({ city: city.toLowerCase() }).sort({ id: 1 });
        
        res.json({
            success: true,
            data: categories
        });
    } catch (error) {
        console.error('Kategoriyalarni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const getCategoryById = async (req, res) => {
    try {
        const { city, id } = req.params;

        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const category = await Category.findOne({ id: id, city: city.toLowerCase() });
        
        if (!category) {
            return res.status(404).json({
                success: false,
                message: 'Kategoriya topilmadi'
            });
        }

        res.json({
            success: true,
            data: { category }
        });
    } catch (error) {
        console.error('Kategoriyani olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

module.exports = {
    getAllCategories,
    getCategoryById
};
