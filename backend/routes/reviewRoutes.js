const express = require('express');
const router = express.Router();
const {
    getReviewsForService,
    addReviewToService
} = require('../controllers/reviewController');

router.get('/:cityName/service/:serviceId/reviews', getReviewsForService);
router.post('/:cityName/service/:serviceId/reviews', addReviewToService);

module.exports = router;
