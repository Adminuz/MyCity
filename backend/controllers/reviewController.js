const Review = require('../models/Review');
const Service = require('../models/Product');
const mongoose = require('mongoose');

const getReviewsForService = async (req, res) => {
    try {
        const { cityName, serviceId } = req.params;

        if (!cityName) {
            return res.status(400).json({
                success: false,
                message: 'Shahar nomi majburiy'
            });
        }

        if (!serviceId) {
            return res.status(400).json({
                success: false,
                message: 'Xizmat ID majburiy'
            });
        }

        if (!mongoose.Types.ObjectId.isValid(serviceId)) {
            return res.status(400).json({
                success: false,
                message: 'Noto\'g\'ri xizmat ID'
            });
        }

        const service = await Service.findOne({ 
            _id: serviceId, 
            city: cityName.toLowerCase() 
        });

        if (!service) {
            return res.status(404).json({
                success: false,
                message: 'Xizmat topilmadi'
            });
        }

        const reviews = await Review.find({
            serviceId: serviceId,
            cityName: cityName.toLowerCase()
        }).sort({ createdAt: -1 });

        const formattedReviews = reviews.map(review => ({
            id: review._id,
            name: review.userName,
            rating: review.rating,
            comment: review.comment,
            date: review.date
        }));

        res.json({
            success: true,
            data: formattedReviews
        });

    } catch (error) {
        console.error('Sharhlarni yuklashda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Sharhlarni yuklashda xatolik'
        });
    }
};

const addReviewToService = async (req, res) => {
    try {
        const { cityName, serviceId } = req.params;
        const { name, rating, comment, date } = req.body;

        if (!cityName) {
            return res.status(400).json({
                success: false,
                message: 'Shahar nomi majburiy'
            });
        }

        if (!serviceId) {
            return res.status(400).json({
                success: false,
                message: 'Xizmat ID majburiy'
            });
        }

        if (!mongoose.Types.ObjectId.isValid(serviceId)) {
            return res.status(400).json({
                success: false,
                message: 'Noto\'g\'ri xizmat ID'
            });
        }

        if (!name || !rating || !comment) {
            return res.status(400).json({
                success: false,
                message: 'Barcha maydonlar to\'ldirilishi kerak'
            });
        }

        if (name.trim().length < 2) {
            return res.status(400).json({
                success: false,
                message: 'Ism kamida 2 ta belgi bo\'lishi kerak'
            });
        }

        if (rating < 1 || rating > 5) {
            return res.status(400).json({
                success: false,
                message: 'Reyting 1 dan 5 gacha bo\'lishi kerak'
            });
        }

        if (comment.trim().length < 10) {
            return res.status(400).json({
                success: false,
                message: 'Sharh kamida 10 ta belgi bo\'lishi kerak'
            });
        }

        const service = await Service.findOne({ 
            _id: serviceId, 
            city: cityName.toLowerCase() 
        });

        if (!service) {
            return res.status(404).json({
                success: false,
                message: 'Xizmat topilmadi'
            });
        }

        const newReview = new Review({
            serviceId: serviceId,
            serviceName: service.name,
            cityName: cityName.toLowerCase(),
            userName: name.trim(),
            rating: parseInt(rating),
            comment: comment.trim(),
            date: date ? new Date(date) : new Date()
        });

        const savedReview = await newReview.save();

        const allReviews = await Review.find({
            serviceId: serviceId,
            cityName: cityName.toLowerCase()
        });

        if (allReviews.length > 0) {
            const averageRating = allReviews.reduce((sum, review) => sum + review.rating, 0) / allReviews.length;
            
            await Service.updateOne(
                { _id: serviceId, city: cityName.toLowerCase() },
                { 
                    $set: { 
                        rating: Math.round(averageRating * 10) / 10,
                        reviewCount: allReviews.length,
                        updatedAt: new Date()
                    }
                }
            );
        }

        res.status(201).json({
            success: true,
            message: 'Sharh muvaffaqiyatli qo\'shildi',
            data: {
                id: savedReview._id,
                name: savedReview.userName,
                rating: savedReview.rating,
                comment: savedReview.comment,
                date: savedReview.date
            }
        });

    } catch (error) {
        console.error('Sharh qo\'shishda xato:', error);
        res.status(500).json({
            success: false,
            message: 'Sharh qo\'shishda xatolik'
        });
    }
};

module.exports = {
    getReviewsForService,
    addReviewToService
};
