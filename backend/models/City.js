const mongoose = require('mongoose');

const citySchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Shahar nomi majburiy'],
        unique: true,
        trim: true
    },
    code: {
        type: String,
        required: [true, 'Shahar kodi majburiy'],
        unique: true,
        trim: true,
        lowercase: true
    },
    isActive: {
        type: Boolean,
        default: true
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('City', citySchema);
