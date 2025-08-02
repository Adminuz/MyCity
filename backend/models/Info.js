const mongoose = require('mongoose');

const infoSchema = new mongoose.Schema({
    city: {
        type: String,
        required: [true, 'Shahar majburiy'],
        lowercase: true,
        trim: true,
        unique: true
    },
    weather: {
        temperature: {
            type: Number,
            required: true
        },
        description: {
            type: String,
            required: true
        }
    },
    prayerTimes: [{
        name: {
            type: String,
            required: true
        },
        time: {
            type: String,
            required: true
        }
    }]
}, {
    timestamps: true
});

infoSchema.index({ city: 1 });

module.exports = mongoose.model('Info', infoSchema);
