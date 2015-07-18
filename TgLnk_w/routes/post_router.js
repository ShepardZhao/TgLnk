/**
 * Created by Shepard on 2/05/15.
 */
var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    connectionPool = require('mysqlConnectionPool'),
    eventProxy = require('eventproxy'),
    fs = require('fs'),
    path = require("path");

/**
 *  POST API
 */

router
    /*
    //image post api
    .post('/post/submitImage', function (req, res, next) {
        var tmp_path = req.files.uploadedImageBtn.path,
            newFileName = 'upload' + rules.getUniqueID() + '.' + req.files.uploadedImageBtn.extension,
            target_path = path.join(__dirname, '../public/images/asserts/' + newFileName),
            sessionStore = [],
            getSession = req.session;

        // move file
        fs.rename(tmp_path, target_path, function (err) {
            if (err) throw err;
            // delete temp file,
            fs.unlink(tmp_path, function () {
                if (err) {
                    throw err;
                } else {

                    //save or remove the temp image from current user
                    if (getSession.submitImageStorage) {
                        getSession.submitImageStorage.push(newFileName);
                    } else {
                        sessionStore.push(newFileName);
                        getSession.submitImageStorage = sessionStore;
                    }
                    res.json({success: 1, imageUrl: 'images/asserts/' + newFileName});
                }
            });
        });
    })
    */


    //get post api according to user id
    .get('/post', function (req, res, next) {
        var getType = req.query.type,
            getID = req.query.requestID, //may be boardID or userID
            setQueryID;
        //there are two type of requesting, one is the requesting from requestByBoard
        if (getType === 'requestByBoard'){
            setQueryID = 'BID';
        }
        //another is the requesting from requestByUser
        else if (getType === 'requestByUser'){
            setQueryID = 'UID';

        }

        connectionPool.CRUD('SELECT * FROM POST_T WHERE '+setQueryID+' = ? ORDER BY PFULLTIME DESC', [getID], function (result) {
            if (result.success == 0) {
                console.log('Error to get post for user %s, and reason is : %s', getID, result.error);
                res.json(rules.getResponseJson('false', 'Error to get post', '0'));
            }
            else if (result.success == 1) {
                console.log('Successfully get the post via board id');
                res.json(rules.getResponseJson('true', result.getresult, '1'));
            }
        });

    })


    //post api that user can submit a post directly
    .post('/post', function (req, res, next) {
        var getNoticeBoardID = req.body.boardID,
            getPostID = 'P' + rules.getUniqueID(),
            getUserID = req.body.userID,
            getPostDesc = req.body.postDesc,
            getPostImageSrc = req.body.postImageSrc,
            getPostEmail = req.body.postEmail,
            getTempTimeAndDate = rules.getCurrentTime().split(' '),
            getCurrentTime = new Date().toLocaleTimeString().toString(),
            getCurrentDate = getTempTimeAndDate[0],
            getCurrentFullTime = rules.getCurrentTime(),
            getPostPhone = req.body.postPhone,
            getSession = req.session,
            getMode = req.body.mode;
        if (getMode === 'mobile') {
            var tmp_path = req.files[0].path,
                newFileName = 'upload' + rules.getUniqueID() + '.jpg',
                target_path = path.join(__dirname, '../public/images/asserts/' + newFileName),
                getPostImageSrc = '/images/asserts/' + newFileName;
            // move file

            fs.rename(tmp_path, target_path, function (err) {
                if (err) throw err;
                // delete temp file,
                fs.unlink(tmp_path, function () {
                    if (err) {
                        throw err;
                    } else {
                        connectionPool.CRUD('INSERT INTO POST_T (PID,UID,BID,PNAME,PIMG,PTIME,PDATE,PEMAIL,PPHONE,PFULLTIME) VALUES (?,?,?,?,?,?,?,?,?,?)', [getPostID, getUserID, getNoticeBoardID, getPostDesc, getPostImageSrc, getCurrentTime, getCurrentDate, getPostEmail, getPostPhone,getCurrentFullTime], function (result) {
                            if (result.success == 0) {
                                console.log('Error to insert post data into db : %s', result.error);
                                res.json(rules.getResponseJson('false', 'Error to get post', '0'));
                            }
                            else if (result.success == 1) {
                                if (result.getresult.affectedRows > 0) {
                                    res.json(rules.getResponseJson('true', {PPHONE:getPostPhone,PID:getPostID,PNAME:getPostDesc,BID:getNoticeBoardID,PEMAIL:getPostEmail,PFULLTIME:getCurrentFullTime,PIMG: '/images/asserts/' + newFileName,PDATE:getCurrentDate,PTIME:getCurrentTime}, '1'));
                                }
                            }
                        });
                    }
                });
            });
        }
        else if (getMode === 'web') {
            //insert the data into the db, then here we go
            connectionPool.CRUD('INSERT INTO POST_T (PID,UID,BID,PNAME,PIMG,PTIME,PDATE,PEMAIL,PPHONE,PFULLTIME) VALUES (?,?,?,?,?,?,?,?,?,?)', [getPostID, getUserID, getNoticeBoardID, getPostDesc, getPostImageSrc, getCurrentTime, getCurrentDate, getPostEmail, getPostPhone,getCurrentFullTime], function (result) {
                if (result.success == 0) {
                    console.log('Error to insert post data into db : %s', result.error);
                }
                else if (result.success == 1) {
                    if (result.getresult.affectedRows > 0) {

                        //remove the temp images according to session
                        if (getSession.submitImageStorage) {
                            for (var i = 0; i < getSession.submitImageStorage.length; i++) {
                                var target_path = path.join(__dirname, '../public/images/asserts/' + getSession.submitImageStorage[i]);
                                if (getPostImageSrc !== '/images/asserts/' + getSession.submitImageStorage[i]) {
                                    console.log(getSession.submitImageStorage[i]);
                                    fs.unlinkSync(target_path, function (err) {
                                        if (err) {
                                            throw err;
                                        }
                                    });
                                }
                            }
                        }
                        res.json({success: 1});
                    }
                }
            });
        }

    })






module.exports = router;
