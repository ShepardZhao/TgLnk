/**
 * foundation initialization
 */
$(document).foundation();
//set up cookie for initial
var setUpCookies = function (key, value) {
    document.cookie = key + '=' + value;
};

/**
 * regex
 */
var mailRegex = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.(?:com|cn)$/,
    userNameRegex = /^[a-zA-Z][a-zA-Z0-9_.-]{4,14}$/;


/**
 *get current domain
 */
var getCurrentDomain = function(){

    return window.location.origin;

};

/**
 * info box
 * @param message
 * @param type
 */

var infoBox = function (message, type,className) {
    if(className.parent().find('#loginInfoBar').length==0){
    $('<div class="row" id="loginInfoBar"><div class="small-12-12 columns"> <div data-alert class="alert-box ' + type + '"> <h7 style="font-size: 12px">' + message + '</h7> </div> </div> </div>').fadeIn().insertBefore(className);
    setTimeout(function () {
        className.parent().find('#loginInfoBar').fadeOut(500,function(){
            $(this).remove();
        });

    }, 2500);
    }
};


/**
 * get cookie
 * @param cname
 * @returns {*}
 */
var getCookie = function (cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length, c.length);
    }
    return "";
};

/**
 * get user id
 * @returns {*}
 */

var getUserNameAPI = function () {
    return getCookie('UID');
};


/**
 * user login
 */
(function () {
    if (getCookie('UID') !== 'null') {
        $('#login').hide();
        $('#signUp').hide();
        $('#loginedUserName').find('i').text(getUserNameAPI());
        $('#loginedUserName').css('display', 'block');
        $('#logOut').css('display', 'block');
        $('#unlogin').hide();
        if(getCookie('UAVATAR')==='null'){
            console.log(1);

            $('#loggedIn').find('img').attr('src',getCurrentDomain()+'/images/sys/UserAvatarLoginned.png');
        }
        else{
            $('#loggedIn').find('img').attr('src',getCurrentDomain()+getCookie('UAVATAR'));
        }
        $('#loggedIn').show();

    }
})();


/**
 * click logout to remove the cookies
 */
$('body').on('click','#logOut',function(){
    setUpCookies('UEMAIL',null);
    setUpCookies('UID', null);
    setUpCookies('UNICKNAME', null);
    setUpCookies('UAVATAR', null);
    location.reload();
});


/**
 * file upload api
 */

var fileUploadAPI = function(elementID, url,callback){
    $.ajaxFileUpload
    (
        {
            url: url,
            secureuri: false,
            fileElementId: elementID,
            dataType: 'json',
            success: function (data, status) {
                $('.modal-backdrop').addClass('hide');
                callback(data);
            },
            error: function (data, status, e) {
                alert(e);
            }
        }
    )

    return false;
};



