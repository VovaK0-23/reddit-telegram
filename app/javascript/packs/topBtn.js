$(document).ready(function() {
        $(".x").click(function () {
            $("html, body").animate({scrollTop: 0}, "smooth");
            return false;
        });

    if ($(".ft-btn").hasClass("btn-prv")) {
        let upDwn = $("#up");
        upDwn.removeClass("btn-up").addClass("btn-up-center")
    }
});

    $(window).scroll(function() {
        let upDwn = $( "#up" );
        let upRt = $('.btn-up-right');
        let footer = $('.footer');
        let hT = footer.offset().top,
            hH = footer.outerHeight(),
            wH = $(window).height(),
            wS = $(this).scrollTop();
        if (wS > (hT+hH-wH)){
            upRt.hide(100);
            upDwn.show(200);
        } else {
            upRt.show(200);
            upDwn.hide(100);
        }
    });

