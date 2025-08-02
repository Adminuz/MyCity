const Info = require('../models/Info');

const getInfo = async (req, res) => {
    try {
        const { city } = req.params;
        
        if (!city) {
            return res.status(400).json({
                success: false,
                message: 'Shahar parametri majburiy'
            });
        }

        const info = await Info.findOne({ city: city.toLowerCase() });
        
        if (!info) {
            return res.status(404).json({
                success: false,
                message: 'Ushbu shahar uchun ma\'lumot topilmadi'
            });
        }

        res.json({
            success: true,
            data: {
                weather: info.weather,
                prayerTimes: info.prayerTimes
            }
        });
    } catch (error) {
        console.error('Ma\'lumotni olishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Ichki server xatosi'
        });
    }
};

module.exports = {
    getInfo
};
