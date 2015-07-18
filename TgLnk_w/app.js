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


/**
 * configure
 */

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
 * account router
 * @type {router|exports|module.exports}
 */
var account_router = require('./routes/account_router');
app.post('/account/updatePassword',account_router);
app.get('/account/updatePassword',account_router);
app.put('/account/updatePassword',account_router);


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
app.post('/user/avatar',user_router);
app.put('/user/info',user_router);


/**
 * noticeBoard router
 * @type {router|exports|module.exports}
 */
var board_router = require('./routes/noticeBoard_router');
app.get('/noticeBoard',board_router);
app.get('/noticeBoard/query',board_router);
app.put('/noticeBoard/active',board_router);

/**
 * post router
 * @type {router|exports|module.exports}
 */
var post_router = require('./routes/post_router');
app.get('/post',post_router);
app.post('/post',post_router);

//app.post('/postNote/submitImage',post_router);

/**
 * target router
 * @type {router|exports|module.exports}
 */
var target_router = require('./routes/target_router');
app.get('/',target_router);//landing page
app.get('/:id',target_router);


/**
 * contact router
 * @type {router|exports|module.exports}
 */
var contact_router = require('./routes/contact_router');
app.get('/user/contact',contact_router);
app.post('/user/contact',contact_router);
app.put('/user/contact',contact_router);
app.delete('/user/contact',contact_router);


/**
 * follow router
 * @type {router|exports|module.exports}
 */
var follow_router = require('./routes/follow_router');
app.post('/active/following',follow_router);
app.delete('/active/following',follow_router);



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
