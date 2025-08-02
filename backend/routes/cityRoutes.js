const express = require('express');
const router = express.Router();
const {
    getAllCities,
    getCityByCode
} = require('../controllers/cityController');

router.get('/', getAllCities);
router.get('/:code', getCityByCode);

module.exports = router;
