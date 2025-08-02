const Event = require('../models/Event');

const getAllEvents = async (req, res) => {
    try {
        const { city } = req.params;
        
        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const events = await Event.find({ city: city.toLowerCase() }).sort({ date: 1 });
        
        res.json({
            success: true,
            data: { events }
        });
    } catch (error) {
        console.error('Tadbirlarni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

const getEventById = async (req, res) => {
    try {
        const { city, id } = req.params;

        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const event = await Event.findOne({ _id: id, city: city.toLowerCase() });
        
        if (!event) {
            return res.status(404).json({
                success: false,
                message: 'Tadbir topilmadi'
            });
        }

        res.json({
            success: true,
            data: { event }
        });
    } catch (error) {
        console.error('Tadbirni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

module.exports = {
    getAllEvents,
    getEventById
};
