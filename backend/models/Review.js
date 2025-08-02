const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema({
    serviceId: {
        type: String,
        required: [true, 'Xizmat ID majburiy'],
        trim: true
    },
    serviceName: {
        type: String,
        required: [true, 'Xizmat nomi majburiy'],
        trim: true
    },
    cityName: {
        type: String,
        required: [true, 'Shahar nomi majburiy'],
        lowercase: true,
        trim: true
    },
    userName: {
        type: String,
        required: [true, 'Foydalanuvchi ismi majburiy'],
        trim: true,
        minlength: [2, 'Ism kamida 2 ta belgi bo\'lishi kerak']
    },
    rating: {
        type: Number,
        required: [true, 'Reyting majburiy'],
        min: [1, 'Reyting kamida 1 bo\'lishi kerak'],
        max: [5, 'Reyting ko\'pi bilan 5 bo\'lishi kerak']
    },
    comment: {
        type: String,
        required: [true, 'Sharh majburiy'],
        trim: true,
        minlength: [10, 'Sharh kamida 10 ta belgi bo\'lishi kerak']
    },
    date: {
        type: Date,
        default: Date.now
    }
}, {
    timestamps: true
});

reviewSchema.index({ serviceId: 1, cityName: 1 });
reviewSchema.index({ createdAt: -1 });
reviewSchema.index({ serviceId: 1 });

module.exports = mongoose.model('Review', reviewSchema);
