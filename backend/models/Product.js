const mongoose = require('mongoose');

const serviceSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Xizmat nomi majburiy'],
        trim: true,
        maxlength: [100, 'Nom 100 belgidan uzun bo\'lishi mumkin emas']
    },
    description: {
        type: String,
        required: [true, 'Tavsif majburiy'],
        maxlength: [500, 'Tavsif 500 belgidan uzun bo\'lishi mumkin emas']
    },
    category: {
        type: String,
        required: [true, 'Kategoriya majburiy'],
        enum: ['tovarlar', 'ta\'lim', 'tibbiyot', 'o\'yin-kulgi', 'ta\'mirlash', 'mahsulotlar', 'turizm', 'sport', 'go\'zallik'],
        lowercase: true,
        trim: true
    },
    image: {
        type: String,
        required: [true, 'Rasm majburiy']
    },
    rating: {
        type: Number,
        default: 0,
        min: 0,
        max: 5
    },
    reviewCount: {
        type: Number,
        default: 0,
        min: 0
    },
    price: {
        type: String,
        required: [true, 'Narx majburiy']
    },
    phone: {
        type: String,
        required: [true, 'Telefon majburiy']
    },
    address: {
        type: String,
        required: [true, 'Manzil majburiy']
    },
    workingHours: {
        type: String,
        required: [true, 'Ish vaqti majburiy']
    },
    city: {
        type: String,
        required: [true, 'Shahar majburiy'],
        lowercase: true,
        trim: true
    },
    latitude: {
        type: Number,
        required: false
    },
    longitude: {
        type: Number,
        required: false
    },
    reviews: {
        type: Array,
        default: []
    }
}, {
    timestamps: true
});

serviceSchema.index({ name: 'text', description: 'text' });
serviceSchema.index({ rating: -1 });
serviceSchema.index({ city: 1 });
serviceSchema.index({ city: 1, rating: -1 });
serviceSchema.index({ city: 1, category: 1 });

module.exports = mongoose.model('Service', serviceSchema);
