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
    //image post api
    .post('/postNote/submitImage', function (req, res, next) {
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

    //get post api
    .get('/postNote', function (req, res, next) {
        var getUserID = req.query.userID;
        connectionPool.CRUD('SELECT * FROM POST_T WHERE UID = ?', [getUserID], function (result) {
            if (result.success == 0) {
                console.log('Error to get post for user %s, and reason is : %s', getUserID, result.error);
                res.json(rules.getResponseJson('false', 'Error to get post', '0'));
            }
            else if (result.success == 1) {
                console.log('Successfully get the user post');
                res.json(rules.getResponseJson('true', result.getresult, '1'));
            }
        });
    })


    //post a post api
    .post('/postNote', function (req, res, next) {

        var getNoticeBoardID = req.body.boardID,
            getPostID = 'P' + rules.getUniqueID(),
            getUserID = req.body.userID,
            getPostDesc = req.body.postDesc,
            getPostImageSrc = req.body.postImageSrc,
            getPostEmail = req.body.postEmail,
            getTempTimeAndDate = rules.getCurrentTime().split(' '),
            getCurrentTime = new Date().toLocaleTimeString().replace(/([\d]+:[\d]{2})(:[\d]{2})(.*)/, "$1$3"),
            getCurrentDate = getTempTimeAndDate[0],
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
                        connectionPool.CRUD('INSERT INTO POST_T (PID,UID,BID,PNAME,PIMG,PTIME,PDATE,PEMAIL,PPHONE) VALUES (?,?,?,?,?,?,?,?,?)', [getPostID, getUserID, getNoticeBoardID, getPostDesc, getPostImageSrc, getCurrentTime, getCurrentDate, getPostEmail, getPostPhone], function (result) {
                            if (result.success == 0) {
                                console.log('Error to insert post data into db : %s', result.error);
                            }
                            else if (result.success == 1) {
                                if (result.getresult.affectedRows > 0) {
                                    res.json({success: 'true', imageUrl: '/images/asserts/' + newFileName});

                                }
                            }
                        });
                    }
                });
            });
        }
        else if (getMode === 'web') {
            //insert the data into the db, then here we go
            connectionPool.CRUD('INSERT INTO POST_T (PID,UID,BID,PNAME,PIMG,PTIME,PDATE,PEMAIL,PPHONE) VALUES (?,?,?,?,?,?,?,?,?)', [getPostID, getUserID, getNoticeBoardID, getPostDesc, getPostImageSrc, getCurrentTime, getCurrentDate, getPostEmail, getPostPhone], function (result) {
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
