const express = require('express');
const router = express.Router();
const {
    getAllServices,
    getServiceById,
    getServicesByCategory,
    searchServices
} = require('../controllers/serviceController');

router.get('/:city', getAllServices);
router.get('/:city/search', searchServices);
router.get('/:city/category/:category', getServicesByCategory);
router.get('/:city/service/:id', getServiceById);

module.exports = router;

module.exports = router;
