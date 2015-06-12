/**
 * Created by Shepard on 17/05/15.
 */

var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    connectionPool = require('mysqlConnectionPool'),
    eventProxy = require('eventproxy');



module.exports = router;

