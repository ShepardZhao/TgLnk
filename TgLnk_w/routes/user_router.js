/**
 * Created by Shepard on 22/04/15.
 */
var express = require('express'),
    router = express.Router(),
    connectionPool = require('mysqlConnectionPool'),
    rules = require('rules'),
    fs = require('fs'),
    path = require("path");

/* POST users register. */
router.post('/user/register', function (req, res, next) {
    var getUserEmail = req.body.email,
        getUserFullName = req.body.userFullName,
        getUserPass = req.body.userPass,
        getUserID = req.body.userID;

    //check the user weather existed
    connectionPool.CRUD('SELECT COUNT(*) AS COUNT FROM USER_T WHERE UEMAIL =?', [getUserEmail], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching the user email address : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully find the email account');

            //if the email address does not exist
            if (result.getresult[0].COUNT == 0) {
                //if not existed then insert a new record
                connectionPool.CRUD('INSERT INTO USER_T (UID,UNICKNAME,UEMAIL,PASSWORD) VALUES (?,?,?,?)', [getUserID, getUserFullName, getUserEmail, getUserPass], function (result) {
                    if (result.success == 0) {
                        console.log('Error happens on insert user register data : %s', result.error);
                    }
                    else if (result.success == 1) {
                        console.log('Has successfully insert an new record for a user');
                        res.json({success: 'true'});
                    }
                });
            }
            else{//if the email address does exist
                res.json({success:'false',message:'The email address already existed'});
            }
        }
    });
});

/*POST users login*/
router.post('/user/login', function (req, res, next) {
    var getUserEmail = req.body.email,
        gePass = req.body.pass,
        getLoginTime = rules.getCurrentTime(),
        setUserLoginArray = [];

    //query user
    connectionPool.CRUD('SELECT * FROM USER_T WHERE UEMAIL =? AND PASSWORD=?', [getUserEmail, gePass], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user login data : %s', result.error);
        }
        else if (result.success == 1) {
            if(result.getresult.length>0){
                setUserLoginArray = result.getresult[0];
                //update the user login time
                connectionPool.CRUD('UPDATE USER_T SET ULOGIN_TIME =? WHERE UEMAIL =?', [getLoginTime, getUserEmail], function (result) {
                    if (result.success == 0) {
                        console.log('Error happens on fetching user login data : %s', result.error);
                    }
                    else if (result.success == 1) {
                        console.log('Has successfully get user login data');
                        res.json(rules.getResponseJson('true',setUserLoginArray,'1'));
                    }
                });
            } else{
                res.json(rules.getResponseJson('false','wrong username or password','0'));

            }
        }
    });

});


/** GET user **/

router.get('/user/info', function (req, res, next) {
    var getUserID = req.query.userID;

    //query user
    connectionPool.CRUD('SELECT * FROM USER_T WHERE UID =?', [getUserID], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user info : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully get user info data');
            res.json({success: true, userInfo: result.getresult[0]});

        }
    });


});


/* GET user check. */
router.get('/user/userIDCheck', function (req, res, next) {
    var getPreDefinedUserID = req.query.perDefindedUserID;

    //check user is existed
    connectionPool.CRUD('SELECT COUNT(*) AS COUNTS FROM USER_T WHERE UID =?', [getPreDefinedUserID], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user id data : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully get the number of user ids');
            if (result.getresult[0]['COUNTS'] == 0) {
                res.json({success: 'true', advised: 'false', message: 'none'});
            }
            else {
                res.json({
                    success: 'false',
                    advised: 'true',
                    message: rules.getUserIDRandomlyAcoordingToUserName(getPreDefinedUserID)
                });

            }


        }
    });


});


//user email check

router.get('/user/userEmailCheck', function (req, res, next) {
    var getUserEmailCheck = req.query.emailAddress;
    //check user is existed
    connectionPool.CRUD('SELECT * FROM USER_T WHERE UEMAIL =?', [getUserEmailCheck], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user email data : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully fetching user email data');
            if (result.getresult.length > 0) {
                res.json(rules.getResponseJson('false','email has been taken','0'));
            }
            else {
                res.json(rules.getResponseJson('true','email is available','1'));
            }


        }
    });


});



//user information update

router.put('/user/info',function(req,res,next){
    var getUserID = req.body.UID,
        getUserUserName = req.body.UNICKNAME,
        getUserEmail = req.body.UEMAIL,
        getUserPHONE = req.body.UPHONE;

    console.log(getUserID,getUserUserName,getUserEmail,getUserPHONE);


    connectionPool.CRUD('SELECT * FROM USER_T WHERE UEMAIL =? AND UID !=?', [getUserEmail,getUserID], function (result) {
        if (result.success == 0) {
            res.json(rules.getResponseJson('false','Error happens on fetching user email data : '+result.error,'0'));
        }
        else if (result.success == 1) {
            if (result.getresult.length > 0) {
                console.log(rules.getResponseJson('false','This Email already been used, please change to another one!','0'));
                res.json(rules.getResponseJson('false','This Email already been used, please change to another one!','0'));
            }
            else {
                connectionPool.CRUD('UPDATE USER_T SET UNICKNAME=?, UEMAIL=?, UPHONE=? WHERE UID =?', [getUserUserName,getUserEmail,getUserPHONE,getUserID], function (result) {
                    if (result.success == 0){
                        console.log(rules.getResponseJson('false','Error happens on update user information','0'));
                        res.json(rules.getResponseJson('false','Error happens on update user information'  +result.error,'0'));
                    }
                    else if (result.success == 1) {
                        console.log(rules.getResponseJson('true','Has successfully fetching user email data','1'));
                        res.json(rules.getResponseJson('true','Has successfully fetching user email data','1'));
                    }
                });

            }
        }
    });

});


//user avatar upload


router.post('/user/avatar',function(req,res,next){
    var getUID = req.body.UID;
    console.log(req);
    var tmp_path = req.files.avatar.path,
        newFileName = getUID+'.' + req.files.avatar.extension,
        target_path = path.join(__dirname, '../public/images/userAvatars/' + newFileName);

    // move file
    fs.rename(tmp_path, target_path, function (err) {
        if (err) throw err;
        // delete temp file,
        fs.unlink(tmp_path, function () {
            if (err) {
                throw err;
            } else {
                //update the avatar for current user
                connectionPool.CRUD('UPDATE USER_T SET UAVATAR=? WHERE UID =?', ['/images/userAvatars/' + newFileName,getUID], function (result) {
                    if (result.success == 0){
                        console.log(rules.getResponseJson('false','Error happens on update user avatar','0'));
                        res.json(rules.getResponseJson('false','Error happens on update user avatar'  +result.error,'0'));
                    }
                    else if (result.success == 1) {
                        console.log(rules.getResponseJson('true','Has successfully update user avatar','1'));
                        res.json(rules.getResponseJson('true','/images/userAvatars/' + newFileName,'1'));
                    }
                });
            }
        });
    });

});


module.exports = router;
