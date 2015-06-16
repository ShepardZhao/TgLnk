/**
 * Created by Shepard on 2/05/15.
 */
var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    connectionPool = require('mysqlConnectionPool'),
    eventProxy = require('eventproxy');

//get noticeBoard list and find the
router.get('/noticeBoard', function (req, res, next) {
    var getRequestType = req.query.requestType,
        ep = new eventProxy(),
        noticeBoardArray = [],
        postsArray = [];
    //query board only
    connectionPool.CRUD('SELECT  BD.BID, BD.BNAME, BD.BTIME, BD.BVIEW_STATUS, BD.BIMAGE,BD.BACTIVE_CODE,BD.BGPS,U.UID,U.UNICKNAME,U.UEMAIL,U.UAVATAR,U.ULOGIN_TIME FROM NOTICEBOARD_T AS BD INNER JOIN USER_T AS U ON BD.UID = U.UID', null, function (result) {
        if (result.success == 0) {
            console.log('Error to fetch board : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully fetch the noticeBoard');
            noticeBoardArray = result.getresult;

            //loop the notice board and find posts
            for (var i = 0; i < noticeBoardArray.length; i++) {

                connectionPool.CRUD('SELECT * FROM POST_T WHERE BID =?', [noticeBoardArray[i].BID], function (result) {
                    if (result.success == 0) {
                        console.log('Error to fetch posts : %s', result.error);
                    }
                    else if (result.success == 1) {
                        console.log('Has successfully fetch the posts');

                        postsArray.push(result.getresult);

                    }
                    ep.emit('syn');
                });
            }


            ep.after('syn', noticeBoardArray.length, function () {
                if (noticeBoardArray.length > 0) {
                    var merged = postsArray.reduce(function (prev, next) {
                        return prev.concat(next);
                    });

                    //append the posts into noticeboard
                    for (var i = 0; i < noticeBoardArray.length; i++) {
                        noticeBoardArray[i].POSTS = [];

                        for (var x = 0; x < merged.length; x++) {
                            if (noticeBoardArray[i].BID === merged[x].BID) {
                                noticeBoardArray[i].POSTS.push(merged[x]);
                            }
                        }
                    }
                }


                if (getRequestType === 'json') {
                    res.json(rules.getResponseJson('true',noticeBoardArray,'1'));
                } else if (getRequestType === 'render') {
                    res.render('noticeBoardPage', {noticeBoard: noticeBoardArray});

                }


            });

        }
    });


});


//search noticeBoard
router.get('/noticeBoard/query', function (req, res, next) {
    var getQueryID = req.query.queryID;

    //query board
    connectionPool.CRUD('SELECT * FROM NOTICEBOARD_T WHERE BID=?', [getQueryID], function (result) {
        if (result.success == 0) {
            console.log('Error to fetch board : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully fetch the board from %s', getQueryID);
            if (result.getresult.length > 0) {
                res.json(rules.getResponseJson('true',result.getresult[0],'1'));
            } else {
                res.json(rules.getResponseJson('false','It looks like this QR code does not exist!','0'));
            }

        }

    });


});

//board active
router.put('/noticeBoard/active', function (req, res, next) {
    var getBoardID = req.body.noticeBoardID,
        getActiveCode = req.body.activeCode;

    connectionPool.CRUD('UPDATE NOTICEBOARD_T SET BVIEW_STATUS=? WHERE BID=? AND BACTIVE_CODE=?', ['1', getBoardID, getActiveCode], function (result) {
        if (result.success == 0) {
            console.log('Error to active board : %s', result.error);
        }
        else if (result.success == 1) {
            if (result.getresult.affectedRows > 0) {
                res.json(rules.getResponseJson('true','be successfully active','1'));

            }
            else {
                res.json(rules.getResponseJson('false','active failure','0'));

            }

        }

    });
});


//get detail view of noticesBoard
router.get('/noticeBoard/detailView', function (req, res, next) {
    var getAllNoticeBoards = [],
        getAllPosts = [],
        ep = new eventProxy();

    //get the all noticeboards first
    connectionPool.CRUD('SELECT * FROM NOTICEBOARD_T WHERE BID = ?', null, function (result) {
        if (result.success == 0) {
            console.log('Error to fetch noticesBoards : %s', result.error);
        }
        else if (result.success == 1) {
            getAllNoticeBoards = result.getresult;
        }
        ep.emit('syn');
    });

    //get the one of inside posts for each noticeboard
    connectionPool.CRUD('SELECT * FROM POST_T', null, function (result) {
        if (result.success == 0) {
            console.log('Error to fetch posts: %s', result.error);
        }
        else if (result.success == 1) {
            getAllPosts.push(result.getresult);
        }
        ep.emit('syn');
    });

    ep.after('syn', 2, function () {
        //loop the post and noticeBoards then gets match parts
        for (var i = 0; i < getAllNoticeBoards.length; i++) {
            //set up post objects for this noticeBoard
            getAllNoticeBoards[i].posts = [];
            for (var x = 0; x < getAllPosts.length; x++) {
                if (getAllNoticeBoards[i].BID == getAllPosts[x].BID) {
                    getAllNoticeBoards[i].posts.push(getAllPosts[x]);
                }
            }
        }

        res.json({success: 'true', boardsWithPosts: getAllNoticeBoards});


    });


});


module.exports = router;
