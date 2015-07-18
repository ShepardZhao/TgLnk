/**
 * Created by Shepard on 16/06/15.
 */
var express = require('express'),
    router = express.Router(),
    rules = require('rules'),
    connectionPool = require('mysqlConnectionPool');

router
    .post('/active/following',function(req,res,next){
        var getBID = req.body.bid,
            getUID = req.body.uid;

        connectionPool.CRUD('INSERT INTO FOLLOW_T (UID,BID) VALUES (?,?)', [getUID,getBID], function (result) {
            if (result.success === 0) {
                console.log('Error to insert into new record for follow table : %s', result.error);
                res.json(rules.getResponseJson('false', 'Error to insert the following information: %s', result.error, '0'));
            }
            else if (result.success === 1){
                res.json(rules.getResponseJson('true','Successfully to insert the new record to follow table','1'));
            }
        });
    })

    .delete('/active/following',function(req,res,next){
        var getBID = req.query.bid,
            getUID = req.query.uid;
        console.log(getBID,getUID);
        connectionPool.CRUD('DELETE FROM FOLLOW_T WHERE UID=? AND BID =?',[getUID,getBID],function(result){
            if(result.success === 0){
                console.log('Error to delete the record from the follow table %s',result.error);
                res.json(result.getResponseJson('false','Error to delete the record from the follow table '+result.error,'0'))
            }
            else if (result.success === 1){
                res.json(rules.getResponseJson('true','Successfully delete the record from the follow table','1'));
            }
        });

    });

module.exports = router;
