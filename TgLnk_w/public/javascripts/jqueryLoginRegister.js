/**
 * Created by Shepard on 6/05/15.
 */
$(document).ready(function () {

    /*************************************
     * login area
     *************************************/

    /**
     * login field check
     */
        //login email
    $('body').on('focusout', '#LoginEmail', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('.fieldCheck').fadeOut(),
            getError = getThisParent.find('.fieldError').fadeOut();

        if ($(this).val() === '') {
            getError.fadeIn();
            $('#loginMailCorrect').val('false');

        }
        else if (!mailRegex.test($(this).val())) {
            getError.fadeIn();
            $('#loginMailCorrect').val('false');

        }
        else {
            getTick.fadeIn();
            $('#loginMailCorrect').val('true');

        }
    });

    //login pass
    $('body').on('focusout', '#loginPassword', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('.fieldCheck').fadeOut(),
            getError = getThisParent.find('.fieldError').fadeOut();
        if ($(this).val() === '') {
            getError.fadeIn();
            $('#loginPasswordCorrect').val('false');
        }
        else {
            getTick.fadeIn();
            $('#loginPasswordCorrect').val('true');
        }

    });


    /**
     * login action
     */
    $('body').on('click', '#loginBtn', function () {
        var getUserEmail = $('#LoginEmail').val(),
            getPassword = $('#loginPassword').val();

        if ($('#loginMailCorrect').val() === 'true' && $('#passwordCorrect').val() === 'true') {
            //alert error
            infoBox('Please make sure all fields are correct', 'alert', $('#forgetPassword'));
        }
        else {
            $('.modal-backdrop').removeClass('hide');
            //ajax get login
            $.ajax({
                url: '/user/login',
                type: 'post',
                dataType: 'json',
                data: {email: getUserEmail, pass: $.md5(getPassword)},
                success: function (data) {
                    console.log(data);
                    $('.modal-backdrop').addClass('hide');
                    if (data.success == 'true') {
                        infoBox('Cheers! you have successfully login, Please waiting for redirect..', 'success', $('#forgetPassword'));
                        //add the login info into the cookie
                        setUpCookies('UEMAIL', data.user.UEMAIL);
                        setUpCookies('UID', data.user.UID);
                        setUpCookies('UNICKNAME', data.user.UNICKNAME);
                        setUpCookies('UAVATAR', data.user.UAVATAR);

                        setTimeout(function () {
                            location.reload();
                        }, 3500);

                    }
                    else {
                        infoBox('Sorry, wrong email address or password', 'alert', $('#forgetPassword'));
                    }
                }
            });


        }

    });

    /**
     * login close
     */

    $('body').on('click', '#loginModalClose', function () {
        var $LoginEmail = $('#LoginEmail'),
            $loginPassword = $('#loginPassword');
        //clear the login email area
        $LoginEmail.val('');
        $LoginEmail.parent().find('.fieldCheck').fadeOut();
        $LoginEmail.parent().find('.fieldError').fadeOut();
        //clear the login password area
        $loginPassword.val('');
        $loginPassword.parent().find('.fieldCheck').fadeOut();
        $loginPassword.parent().find('.fieldError').fadeOut();

    });


    /*************************************
     * register area
     *************************************/

    /**
     * suggested unique user id
     */
    var checkUniqueUserName = function () {
        var getThisVal = $('#signUpUserName').val();
        $('#usernameError').hide();
        $('#usernameTick').hide();
        if ($('#signUpUserNameCorrect').val() === 'true') {
            $('#usernameLoadingAnimation').fadeIn();
            $.ajax({
                url: '/user/userIDCheck',
                type: 'get',
                dataType: 'json',
                data: {perDefindedUserID: getThisVal},
                success: function (data) {
                    if (data.advised == 'false') {
                        $('#usernameLoadingAnimation').fadeOut(500, function () {
                            $('#usernameError').fadeOut(500, function () {
                                $('#usernameTick').fadeIn();
                                $('#signUpSuggestedUserName').fadeOut();
                                $('#signUpUserNameCorrect').val('true');

                            });
                        });

                    }
                    else if (data.advised == 'true') {
                        $('#usernameLoadingAnimation').fadeOut(500, function () {
                            $('#usernameTick').fadeOut(500, function () {
                                $('#usernameError').fadeIn();
                                var value = '';
                                for (var i = 0; i < data.message.length; i++) {
                                    value += data.message[i] + ' ';
                                }
                                $('#signUpSuggestedUserName').empty();
                                $('<div style="font-size: 11px"><span>Suggested: </span><span style="color: #e67e22">  ' + value + '</span></div>').appendTo($('#signUpSuggestedUserName'));
                                $('#signUpUserNameCorrect').val('false');
                            });
                        });

                    }

                }
            });
        }

        else {
            $('#usernameError').fadeIn();


        }

    };


    /**
     * register action
     */
    $('body').on('click', '#signUpBtn', function () {
        var getFullName = $('#signUpFullName').val(),
            getEmailAddress = $('#signUpEmail').val(),
            getRePassword = $('#signUpRePassword').val(),
            getUniqueUserName = $('#signUpUserName').val(),
            getConditionStatus = $('#readConditionCheckBox').is(':checked');

        if ($('#signUpFullNameCorrect').val() == 'true' && $('#signUpEmailAddressCorrect').val() == 'true' && $('#passwordCorrect').val() == 'true' && $('#rePasswordCorrect').val() == 'true' && $('#signUpUserNameCorrect').val() == 'true' && getConditionStatus) {
            $('.modal-backdrop').removeClass('hide');

            $.ajax({
                url: '/user/register',
                type: 'post',
                dataType: 'json',
                data: {
                    email: getEmailAddress,
                    userFullName: getFullName,
                    userPass: $.md5(getRePassword),
                    userID: getUniqueUserName
                },
                success: function (data) {
                    if (data.success == 'true') {
                        $('.modal-backdrop').addClass('hide');

                        infoBox('You have successfully registered!', 'success', $('#signUpSuggestedUserName').parent());
                        setTimeout(function(){
                            //relocated the page
                            location.reload();
                        },2000);


                    } else {
                        infoBox('Something was error', 'alert', $('#signUpSuggestedUserName').parent());

                    }
                }
            });
        }
        else {
            //show error
            infoBox('Please making sure all fields are correct', 'alert', $('#signUpSuggestedUserName').parent());
        }
    });


    /**
     * key fields check
     */
        //signUp FullName
    $('body').on('focusout', '#signUpFullName', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('.fieldCheck').fadeOut(),
            getError = getThisParent.find('.fieldError').fadeOut();
        if (getThis.val() === '') {
            getError.fadeIn();
            $('#signUpFullNameCorrect').val('false');
        }
        else {
            getTick.fadeIn();
            $('#signUpFullNameCorrect').val('true');
        }
    });


    //email check
    $('body').on('focusout', '#signUpEmail', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('.fieldCheck').fadeOut(),
            getError = getThisParent.find('.fieldError').fadeOut();
        if (getThis.val() === '') {
            getError.fadeIn();
            $('#signUpEmailAddressCorrect').val('false');
        }
        else if (!mailRegex.test($(this).val())) {
            getError.fadeIn();
            $('#signUpEmailAddressCorrect').val('false');
        }
        else {
            getTick.fadeIn();
            $('#signUpEmailAddressCorrect').val('true');
        }


    });


    //signUp pass match
    $('body').on('focusout', '#signUpPassword', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('.fieldCheck').fadeOut(),
            getError = getThisParent.find('.fieldError').fadeOut();
        if (getThis.val() === '') {
            getError.fadeIn();
            $('#passwordCorrect').val('false');

        }
        else if (getThis.val() !== $('#signUpRePassword').val()) {
            getError.fadeIn();
            $('#passwordCorrect').val('false');

        }
        else {
            getTick.fadeIn();

            $('#signUpRePassword').parent().find('.fieldError').fadeOut();
            $('#signUpRePassword').parent().find('.fieldCheck').fadeIn();


            $('#passwordCorrect').val('true');
            $('#rePasswordCorrect').val('true');


        }

    });

    //signUp rePassword
    $('body').on('focusout', '#signUpRePassword', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('.fieldCheck').fadeOut(),
            getError = getThisParent.find('.fieldError').fadeOut();
        if (getThis.val() === '') {
            getError.fadeIn();
            $('#rePasswordCorrect').val('false');

        }
        else if (getThis.val() !== $('#signUpPassword').val()) {
            getError.fadeIn();
            $('#rePasswordCorrect').val('false');

        }
        else {
            getTick.fadeIn();
            $('#signUpPassword').parent().find('.fieldError').fadeOut();
            $('#signUpPassword').parent().find('.fieldCheck').fadeIn();

            $('#passwordCorrect').val('true');
            $('#rePasswordCorrect').val('true');
        }

    });

    //signUp signUpUserName
    $('body').on('focusout', '#signUpUserName', function () {
        var getThis = $(this),
            getThisParent = getThis.parent(),
            getTick = getThisParent.find('#usernameTick').fadeOut(),
            getError = getThisParent.find('#usernameError').fadeOut();
        if (getThis.val() === '') {
            getError.fadeIn();
            $('#signUpUserNameCorrect').val('false');
        }
        else if (getThis.val().length < 5 || getThis.val().length > 15) {
            getError.fadeIn();
            $('#signUpUserNameCorrect').val('false');
        }
        else if (!userNameRegex.test($(this).val())) {
            getError.fadeIn();
            $('#signUpUserNameCorrect').val('false');
        }
        else {
            $('#signUpUserNameCorrect').val('true');
            checkUniqueUserName();

        }

    });

    /**
     * signUp close
     */
    $('body').on('click', '#signUpModalClose', function () {
        var $fullName = $('#signUpFullName'),
            $signUpEmail = $('#signUpEmail'),
            $signUpPassword = $('#signUpPassword'),
            $signUpRePassword = $('#signUpRePassword'),
            $signUpUserName = $('#signUpUserName');
        //clear the fields
        $fullName.val('');
        $fullName.parent().find('.fieldCheck').fadeOut();
        $fullName.parent().find('.fieldError').fadeOut();

        $signUpEmail.val('');
        $signUpEmail.parent().find('.fieldCheck').fadeOut();
        $signUpEmail.parent().find('.fieldError').fadeOut();

        $signUpPassword.val('');
        $signUpPassword.parent().find('.fieldCheck').fadeOut();
        $signUpPassword.parent().find('.fieldError').fadeOut();

        $signUpRePassword.val('');
        $signUpRePassword.parent().find('.fieldCheck').fadeOut();
        $signUpRePassword.parent().find('.fieldError').fadeOut();

        $signUpUserName.val('');
        $signUpUserName.parent().find('.fieldCheck').fadeOut();
        $signUpUserName.parent().find('.fieldError').fadeOut();


    });


});



