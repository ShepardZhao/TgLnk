var express = require('express');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var multer = require('multer');
var ejs = require('ejs');//import ejs engine
var app = express();
var cookieSession = require('cookie-session');
var session =require('express-session');


app.engine('.html', ejs.__express); //chang the ejs engine that identified as html
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'html'); //set extension name as html
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use(multer());
app.use(session({ secret: 'oM_p3WWn6J7gCCgUeYsXsZPKPe',resave: true, saveUninitialized: true, cookie: { maxAge: 60000 }}))






/**
 * user router
 * @type {router|exports|module.exports}
 */
var user_router = require('./routes/user_router');
app.post('/user/register',user_router);
app.get('/user/userEmailCheck',user_router);
app.get('/user/userIDCheck',user_router);
app.post('/user/login',user_router);
app.get('/user/info',user_router);


/**
 * noticeBoard router
 * @type {router|exports|module.exports}
 */
var board_router = require('./routes/noticeBoard_router');
app.get('/noticeBoard',board_router);
app.get('/noticeBoard/query',board_router);
app.get('/noticeBoard/active',board_router);

/**
 * post router
 * @type {router|exports|module.exports}
 */
var postNote_router = require('./routes/postNote_router');
app.get('/postNote',postNote_router);
app.post('/postNote',postNote_router);
app.post('/postNote/submitImage',postNote_router);

/**
 * target router
 * @type {router|exports|module.exports}
 */
var target_router = require('./routes/target_router');
app.get('/',target_router);//landing page
app.get('/:id',target_router);


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});


module.exports = app;
