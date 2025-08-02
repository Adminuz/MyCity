const mongoose = require('mongoose');

const eventSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, 'Tadbir nomi majburiy'],
        trim: true,
        maxlength: [200, 'Nom 200 belgidan uzun bo\'lishi mumkin emas']
    },
    desc: {
        type: String,
        required: [true, 'Tavsif majburiy'],
        maxlength: [1000, 'Tavsif 1000 belgidan uzun bo\'lishi mumkin emas']
    },
    date: {
        type: String,
        required: [true, 'Sana majburiy']
    },
    city: {
        type: String,
        required: [true, 'Shahar majburiy'],
        lowercase: true,
        trim: true
    }
}, {
    timestamps: true
});

eventSchema.index({ title: 'text', desc: 'text' });
eventSchema.index({ date: 1 });
eventSchema.index({ city: 1 });
eventSchema.index({ city: 1, date: 1 });

module.exports = mongoose.model('Event', eventSchema);
