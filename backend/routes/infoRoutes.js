const express = require('express');
const router = express.Router();
const {
    getInfo
} = require('../controllers/infoController');

router.get('/:city', getInfo);

module.exports = router;
