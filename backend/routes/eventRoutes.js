const express = require('express');
const router = express.Router();
const {
    getAllEvents,
    getEventById
} = require('../controllers/eventController');

router.get('/:city', getAllEvents);
router.get('/:city/:id', getEventById);

module.exports = router;
