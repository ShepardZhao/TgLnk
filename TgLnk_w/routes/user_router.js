/**
 * Created by Shepard on 22/04/15.
 */
var express = require('express'),
    router = express.Router(),
    connectionPool = require('mysqlConnectionPool'),
    rules = require('rules'),
    eventProxy = require('eventproxy');


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
        setUserLoginArray = [],
        setQueryStatus = false,
        setUpdateLoginTimeStatus = false,
        ep = new eventProxy();

    //query user
    connectionPool.CRUD('SELECT * FROM USER_T WHERE UEMAIL =? AND PASSWORD=?', [getUserEmail, gePass], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user login data : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully get user login data');
            setUserLoginArray = result.getresult[0];
            if(result.getresult.length>0){
                setQueryStatus = true;
            }
        }
        ep.emit('syn');
    });


    //update the user login time
    connectionPool.CRUD('UPDATE USER_T SET ULOGIN_TIME =? WHERE UEMAIL =?', [getLoginTime, getUserEmail], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user login data : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully get user login data');
            setUpdateLoginTimeStatus = true;
        }
        ep.emit('syn');
    });

    ep.after('syn', 2, function () {

        if (setQueryStatus && setUpdateLoginTimeStatus) {
            res.json({success: 'true', user: setUserLoginArray});
        }
        else {
            res.json({success: 'false', message:'user does not match'});
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
    connectionPool.CRUD('SELECT COUNT(*) AS COUNTS FROM USER_T WHERE UEMAIL =?', [getUserEmailCheck], function (result) {
        if (result.success == 0) {
            console.log('Error happens on fetching user email data : %s', result.error);
        }
        else if (result.success == 1) {
            console.log('Has successfully fetching user email data');
            if (result.getresult[0]['COUNTS'] == 0) {
                res.json({success: 'true'});
            }
            else {
                res.json({
                    success: 'false'
                });

            }


        }
    });


});


module.exports = router;
