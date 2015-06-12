/**
 * Created by Shepard on 7/05/15.
 */
$(document).ready(function () {


    /**
     * poster submit
     */
    $('body').on('click', '#postBtn', function () {
        var getPostDesc = $('#postDesc').val(),
            getUserID = getUserNameAPI(),
            getBoardID = $('.noticeBoardWrap').attr('id'),
            getPostImage = $('#preViewImage').attr('src'),
            getPosterPhone = $('#postPhone').val(),
            getPosterEmail = $('#postEmail').val();
    console.log(getPostDesc,getUserID,getBoardID,getPostImage,getPosterPhone,getPosterEmail);
        if (getPostDesc == '' || getPostImage == '' || getPosterPhone == '' || getPosterEmail == '') {
            //alert notification
            infoBox('Please filled all fields', 'alert', $('#postWrap'));
        } else {
            //ajax submit post
            $.ajax({
                url: '/postNote',
                type: 'post',
                dataType: 'json',
                data: {
                    postDesc: getPostDesc,
                    postImageSrc: getPostImage,
                    postEmail: getPosterEmail,
                    postPhone: getPosterPhone,
                    userID: getUserID,
                    boardID: getBoardID
                },
                success: function (data) {
                    if(data.success==1){
                        infoBox('You have successfully posted a new notes', 'success', $('#postWrap'));
                        setTimeout(function(){
                            location.reload();
                        },2000);
                    }
                }
            });
        }
    });

    /**
     *image trigger
     */

    $('body').on('click', '#uploadedImage', function () {

        $('#uploadedImageBtn').trigger('click');
    });

    /**
     * post img upload
     */
    $('body').on('change', '#uploadedImageBtn', function () {
        $('.modal-backdrop').removeClass('hide');
        fileUploadAPI('uploadedImageBtn','/postNote/submitImage',function(data){
            if(data.success === 1){
                $('#preViewImage').attr('src', data.imageUrl).fadeIn();
            }
        });

    });


});