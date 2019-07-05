'use strict';

var express = require('express');

var app = express();
app.use('/', require('./routes/route.js'));
app.listen(3000);

console.log('Server running at http://localhost:3000');
