/**
 * Created by xunzhao on 6/28/15.
 */
var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    mail = require('mailConfigure'),
    connectionPool = require('mysqlConnectionPool');

router

    .post('/account/updatePassword', function (req, res, next) {
        var getEmail = req.body.email,
            getValidateCode = req.body.validateCode;

        console.log(getEmail,getValidateCode);
        connectionPool.CRUD('SELECT * FROM USER_T WHERE UEMAIL = ? AND ONCETOKEN=? ', [getEmail,getValidateCode], function (result) {
            if (result.success === 0) {
                console.log(rules.getResponseJson('false', 'Validation code does not match!', '0'));
                res.json(rules.getResponseJson('false', 'Validation code does not match!' + result.error, '0'));
            }
            else if (result.success === 1) {
                if (result.getresult.length > 0) {
                    console.log(rules.getResponseJson('true', 'yes, find it', '1'));
                    res.json(rules.getResponseJson('true', 'successfully passed validation', '1'));

                } else {

                    console.log(rules.getResponseJson('false', 'Validation code does not match!', '0'));
                    res.json(rules.getResponseJson('false', 'Validation code does not match!', '0'));
                }
            }
        });
    })

    .get('/account/updatePassword', function (req, res, next) {
        var getEmail = req.query.email;
        //we are going to check the email status first
        connectionPool.CRUD('SELECT * FROM USER_T WHERE UEMAIL = ?', [getEmail], function (result) {
            if (result.success === 0) {
                console.log(rules.getResponseJson('false', 'Error happens on querying user email', '0'));
                res.json(rules.getResponseJson('false', 'Error happens on querying user email' + result.error, '0'));
            }
            else if (result.success === 1) {
                if (result.getresult.length > 0) {
                    console.log(rules.getResponseJson('true', 'yes, find it', '1'));

                    var getTempValidateCode =  rules.getRandomValidationCode();

                    //set temp the pass validate for user

                    connectionPool.CRUD('UPDATE USER_T SET ONCETOKEN =? WHERE UEMAIL=?',[getTempValidateCode,getEmail],function(result){
                        if(result.success === 0){
                            console.log(rules.getResponseJson('false', 'failure to update once token', '0'));

                        }
                        else if(result.success ===1){

                            //if the email is existed then do the mailConfigure sending
                            mail.sendMail('admin@tglnk.com',getEmail,'please using below validation codd to reset your password: <br> <b>' + getTempValidateCode +'</b><br>');

                            res.json(rules.getResponseJson('true', 'Hi, Please find validation code from ' + getEmail, '1'))
                        }
                    });

                } else {

                    console.log(rules.getResponseJson('false', 'Cannot found the matched email', '0'));
                    res.json(rules.getResponseJson('false', 'Cannot found the matched email', '0'));
                }

            }
        });
    })

    .put('/account/updatePassword', function (req, res, next) {
        var getEmail = req.body.email,
            getNewPassword = req.body.password;
        console.log(getNewPassword);

        connectionPool.CRUD('UPDATE USER_T SET PASSWORD=? WHERE UEMAIL =?', [getNewPassword, getEmail], function (result) {
            if (result.success === 0) {
                console.log(rules.getResponseJson('false', 'update password failure' + result.error, '0'));
                res.json(rules.getResponseJson('false', 'update password failure ' + result.error, '0'));
            }
            else if (result.success === 1) {

                console.log(rules.getResponseJson('true', 'update password successfully', '1'));
                res.json(rules.getResponseJson('true', 'update password successfully', '1'));
            }

        });


    });


module.exports = router;