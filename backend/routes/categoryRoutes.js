const express = require('express');
const router = express.Router();
const {
    getAllCategories,
    getCategoryById
} = require('../controllers/categoryController');

router.get('/:city', getAllCategories);
router.get('/:city/:id', getCategoryById);

module.exports = router;
