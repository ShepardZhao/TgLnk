var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    connectionPool = require('mysqlConnectionPool'),
    eventProxy = require('eventproxy');



/*landing page*/
router
    .get('/',function(req,res,next){
    res.render('landingPage');
})


/* get target. The target is including the noticeboard id and user id */
    .get('/:id', function (req, res, next) {
    if (rules.getValidationOf_QR_code(req.params.id)) {
        var getNoticeBoards = [],
            getAllPosts = [],
            getTopPosts = [],
            getBID = req.params.id,
            ep = new eventProxy();

        //get the all noticeboards first
        connectionPool.CRUD('SELECT * FROM NOTICEBOARD_T WHERE BID = ?', [getBID], function (result) {
            if (result.success == 0) {
                console.log('Error to fetch noticesBoards : %s', result.error);
            }
            else if (result.success == 1) {
                getNoticeBoards = result.getresult[0];
            }
            ep.emit('syn');
        });


        //GET TOP POSTS FOR NOTICEBOARD
        connectionPool.CRUD('SELECT * FROM POST_T WHERE BID = ? AND PTOP IS NOT NULL ORDER BY PFULLTIME DESC', [getBID], function (result) {
            if (result.success == 0) {
                console.log('Error to fetch noticesBoards : %s', result.error);
            }
            else if (result.success == 1) {
                getTopPosts = result.getresult;
            }
            ep.emit('syn');
        });

        //get the one of inside posts for noticeboard
        connectionPool.CRUD('SELECT * FROM POST_T INNER JOIN USER_T ON POST_T.UID = USER_T.UID WHERE POST_T.BID = ? ORDER BY POST_T.PFULLTIME DESC', [getBID], function (result) {
            if (result.success == 0) {
                console.log('Error to fetch posts: %s', result.error);
            }
            else if (result.success == 1) {
                getAllPosts = result.getresult;
            }
            ep.emit('syn');
        });

        ep.after('syn', 3, function () {
            console.log(getAllPosts);
            res.render('noticeBoardsDetailPage',{noticeBoard: getNoticeBoards, relatedPosts: getAllPosts, topPosts: getTopPosts});


        });


    }
    //here is validation for the user id
    else if(rules.getVlidationOd_UserID(req.params.id)){

        res.json({success:1,message:req.params.id});
    }
    //here is the error page if the parameters are not matched to above UID or BID
    else{
        res.render('404');
    }
});


module.exports = router;
