const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
    id: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: [true, 'Kategoriya nomi majburiy'],
        trim: true,
        maxlength: [100, 'Nom 100 belgidan uzun bo\'lishi mumkin emas']
    },
    icon: {
        type: String,
        required: [true, 'Ikonka majburiy']
    },
    color: {
        type: String,
        required: [true, 'Rang majburiy']
    },
    description: {
        type: String,
        required: [true, 'Tavsif majburiy'],
        maxlength: [300, 'Tavsif 300 belgidan uzun bo\'lishi mumkin emas']
    },
    service_count: {
        type: Number,
        default: 0,
        min: 0
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

categorySchema.index({ name: 'text', description: 'text' });
categorySchema.index({ city: 1, id: 1 });
categorySchema.index({ city: 1 });

categorySchema.index({ city: 1, id: 1 }, { unique: true });

module.exports = mongoose.model('Category', categorySchema);
