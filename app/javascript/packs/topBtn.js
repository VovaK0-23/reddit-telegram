$(document).ready(function(){
    if ($(".posts").length){
        // timer that reloads page when url changes
        let myVar = setInterval(urlChange, 1000);
        let url = window.location.href;
        function urlChange() {
            if (window.location.href !== url) {
                clearInterval(myVar);
                location.reload();
            }
        }
        // script for top button
        function scrollTop() {
            $("html, body").animate({scrollTop: 0}, "smooth");
            console.log("3");
            return false

        }
        $(".x").click(scrollTop);


        // move button to footer
        let upDwn = $("#up");
        function btnToFooter() {
            let upRt = $('.btn-up-right');
            let footer = $('.footer');
            let hT = footer.offset().top,
                hH = footer.outerHeight(),
                wH = $(window).height(),
                wS = $(this).scrollTop();
            if (wS > (hT + hH - wH)) {
                upRt.hide(100);
                upDwn.show(200);
            } else {
                upRt.show(200);
                upDwn.hide(100);
            }
        }
        // move button to center when button for previous page appears
        let ftBtn = $(".ft-btn");
        if ($(".posts-index").length) {
            $(window).scroll(btnToFooter);
            if (ftBtn.hasClass("btn-prv")) {
                upDwn.removeClass("btn-up").addClass("btn-up-center")
            } else {
                upDwn.removeClass("btn-up-center").addClass("btn-up")
            }
        } else {
            if (ftBtn.hasClass("btn-prv") && (ftBtn.hasClass("btn-nxt"))) {
                upDwn.removeClass("btn-up");
                console.log("1");
            } else if (ftBtn.hasClass("btn-prv")) {
                $(window).scroll(btnToFooter);
                upDwn.removeClass("btn-up").addClass("btn-up-nxt")
            } else {
                $(window).scroll(btnToFooter);
                upDwn.removeClass("btn-up-nxt").addClass("btn-up")
            }
        }
    }
});
