/**
 * Created by Shepard on 5/05/15.
 */
$(document).ready(function () {


    //click the go button then do noticeboard check
    //hide all button
    var hideAllSearchAction = function () {
        $('#emptyContentMessage').fadeOut();
        $('#noneBoardMessage').fadeOut();
        $('#activeAnNewBoard').fadeOut();
        $('#animatedLoading').fadeOut();

    };

    $('body').on('click', '#noticeBoardGo', function () {
        hideAllSearchAction();
        $('.move').addClass('moveToTop');
        $('.searchContent').css('opacity', 1);


        if ($('#input_noticeBoard_search').val() == '') {
            $('#emptyContentMessage').fadeIn();
            setTimeout(function () {
                $('#emptyContentMessage').fadeOut();
            }, 2500);
        }
        else {
            $('#animatedLoading').fadeIn();

            $.ajax({
                url: '/noticeBoard/query',
                type: 'get',
                dataType: 'json',
                data: {queryID: $('#input_noticeBoard_search').val()},
                success: function (data) {
                    if (data.success == 1) {
                        if (data.noticeBoard.BVIEW_STATUS == 0) {
                            $('#animatedLoading').fadeOut(500, function () {
                                $('#activeAnNewBoard').fadeIn();
                            });

                        }
                        else if (data.noticeBoard.BVIEW_STATUS == 1) {
                            $('#animatedLoading').fadeOut(500, function () {
                                setTimeout(function () {
                                    window.location.href = '/' + data.noticeBoard.BID;
                                }, 1500);
                            });
                        }
                    }
                    else {

                        $('#animatedLoading').fadeOut(500, function () {
                            $('#noneBoardMessage').fadeIn(500, function () {
                                setTimeout(function () {
                                    $('#noneBoardMessage').fadeOut();
                                }, 2500);

                            });
                        });


                    }


                }
            });

        }

    });

    /**
     * active qr code
     */


    $('body').on('click', '#activeCodeBtn', function () {
        var getNoticeBoardID = $('#input_noticeBoard_search').val(),
            getActiveCode = $('#activeCodeInput').val();

        if (getActiveCode == '') {
            $('#errorSecurityCode').fadeIn();
        }
        else {
            $('#activeAnNewBoard').fadeOut(500, function () {
                $('#animatedLoading').fadeIn();
            });

            $.ajax({
                url: '/noticeBoard/active',
                type: 'get',
                dataType: 'json',
                data: {noticeBoardID: getNoticeBoardID, activeCode: getActiveCode},
                success: function (data) {
                    console.log(data);
                    if (data.success == 1) {
                        $('#animatedLoading').fadeOut(500, function () {
                            setTimeout(function () {
                                window.location.href = '/' + getNoticeBoardID;
                            }, 1500);
                        });

                    } else {
                        $('#animatedLoading').fadeOut(500, function () {
                            $('#errorSecurityCode').fadeIn();
                        });
                    }

                }

            });

        }

    });


});