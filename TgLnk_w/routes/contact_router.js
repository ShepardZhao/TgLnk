/**
 * Created by Shepard on 16/06/15.
 */
var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    connectionPool = require('mysqlConnectionPool'),
    eventProxy = require('eventproxy');



router
    .post('/user/contact', function (req, res, next) {
        var getSourceUser = req.body.sUser,
            getTargetUser = req.body.tUser;

        //check the repeat user in contact list first
        connectionPool.CRUD('SELECT * FROM CONTACT_T WHERE CID =? AND UID =? ', [getSourceUser, getTargetUser], function (result) {
            if (result.success == 0) {
                console.log('Error to fetch contact users : %s', result.error);
                res.json(rules.getResponseJson('false', 'Error to fetch contact users : %s', result.error, '0'));
            }
            else if (result.success == 1) {
                if (result.getresult.length > 0) {
                    res.json(rules.getResponseJson('false', getTargetUser + ' already been your contact', '0'));
                }
                else {
                    //insert the new contact for the poster user
                    connectionPool.CRUD('INSERT INTO CONTACT_T (CID,UID) VALUES (?,?)', [getSourceUser, getTargetUser], function (result) {
                        if (result.success == 0) {
                            console.log('Error to insert the record into the contact table, reason %s', result.error);
                            res.json(rules.getResponseJson('false', 'Error to insert the record into the contact table, reason %s', result.error, '0'));
                        }
                        else if (result.success == 1) {
                            res.json(rules.getResponseJson('true', 'Successfully added new contact to your list', '1'));
                        }

                    });
                }

            }
        });


    })

    .get('/user/contact', function (req, res, next) {
        var getSourceUser = req.query.sUser,
            getQueryType = req.query.stype,
            ep = new eventProxy();

        //if the query type is 'getAll' from CONTACT_T
        if (getQueryType === 'getAll') {
            //only return the all user list
            connectionPool.CRUD('SELECT * FROM CONTACT_T INNER JOIN USER_T ON CONTACT_T.CID=USER_T.UID WHERE CONTACT_T.CID =?', [getSourceUser], function (result) {
                if (result.success == 0) {
                    console.log('Error to get contact list for source user %s and reason is %s', getSourceUser, result.error);
                    res.json(rules.getResponseJson('false', 'Error to get contact list', '0'));
                } else if (result.success == 1) {
                    console.log(result.getresult);
                    res.json(rules.getResponseJson('true', result.getresult, '1'));
                }
            });
        }
        //if the query type is 'specific' from the USER_T
        else if (getQueryType === 'specific') {
            //let set up temp variables to hold the data
            var setUIDResult = null,
                setUsernameResult = null;

            //search the user by user id from user list
            connectionPool.CRUD('SELECT UID,UNICKNAME,UPHONE,UEMAIL,UAVATAR FROM USER_T WHERE UID =?', [getSourceUser], function (result) {
                if (result.success == 0) {
                    console.log('Error to query the user, the reason is %s', result.error);
                    //res.json(rules.getResponseJson('false', 'Error to query the user, the reason is %s' + result.error, '0'));
                } else if (result.success == 1) {
                    //res.json(rules.getResponseJson('true', result.getresult, '1'));
                    setUIDResult = result.getresult;
                }
                ep.emit('syn');

            });

            //search the user by user name from the user list
            connectionPool.CRUD('SELECT UID,UNICKNAME,UPHONE,UEMAIL,UAVATAR FROM USER_T WHERE UNICKNAME =?', [getSourceUser], function (result) {
                if (result.success == 0) {
                    console.log('Error to query the user, the reason is %s', result.error);
                    //res.json(rules.getResponseJson('false', 'Error to query the user, the reason is %s' + result.error, '0'));
                } else if (result.success == 1) {
                    //res.json(rules.getResponseJson('true', result.getresult, '1'));
                    setUsernameResult = result.getresult;
                }
                ep.emit('syn');

            });


            //combing and merge
            ep.after('syn', 2, function () {
                var _filter_concat_array = function(setArrayA,setArrayB){
                    var tempArray =[];
                    for (var i =0 ;i<setArrayA.length;i++) {

                        var setArrayAToString = setArrayA[i].toString();
                        for (var x = 0; x < setArrayB.length; x++) {
                            var setArrayBToString = setArrayB[x].toString();
                            if (setArrayAToString != setArrayBToString) {
                                tempArray.push(setArrayB[x]);
                            }
                        }
                        tempArray.push(setArrayA[i]);

                    }
                        return tempArray;
                    };

                if (setUIDResult.length == 0 && setUsernameResult == 0){
                    res.json(rules.getResponseJson('false', 'None users be found', '0'));
                }
                else if (setUIDResult.length>0 && setUsernameResult.length>0){
                    res.json(rules.getResponseJson('true', _filter_concat_array(setUIDResult,setUsernameResult), '1'))

                }

                else if (setUIDResult.length>0){

                    res.json(rules.getResponseJson('true', setUIDResult, '1'));

                }
                else if (setUsernameResult.length>0){
                    res.json(rules.getResponseJson('true', setUsernameResult, '1'));

                }

            });


        }


    })

    .put('/user/contact', function (req, res, next) {


    })

    .delete('/user/contact', function (req, res, next) {
        var getSourceUser = req.body.sUser,
            getTargetUser = req.body.tUser;

        //delete the a contact user
        connectionPool.CRUD('DELETE FROM CONTACT_T WHERE CID = ?, UID = ?', [getSourceUser, getTargetUser], function (result) {
            if (result.success == 0) {
                console.log('Error to delete the contact from source user %s, and target user %s, reason %s', getSourceUser, getTargetUser, result.error);
                res.json(rules.json('false', 'Error to delete the contact from source user %s, and target user %s, reason %s', getSourceUser, getTargetUser, result.error, '0'));
            }
            else if (result.success == 1) {
                res.json(rules.json('true', 'Successfully delete a contact from your contact list', '1'));

            }
        });


    });


module.exports = router;
