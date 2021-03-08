$(document).ready(function() {

    $(".se-pre-con").show().fadeOut("slow");

    $(".notice").fadeOut(4000);
    $("#error-container").fadeOut(6000);
    $("#notice-container").fadeOut(6000);


    if ($(".chat-index").length) {
        // timer that reloads page when url changes
        let myVar = setInterval(urlChange, 1000);
        let url = window.location.href;

        function urlChange() {
            if (window.location.href !== url) {
                clearInterval(myVar);
                location.reload();
            }
        }

        let win = $(this); //this = window
        let drpdwn = $(".q");
        if (win.width() >= 720) {
            drpdwn.hide();
        } else if (win.width() < 720) {
            drpdwn.show();
        }

        $(window).on('resize', function () {
            let win = $(this); //this = window
            let drpdwn = $(".q");
            if (win.width() >= 720) {
                drpdwn.hide();
            } else {
                drpdwn.show();
            }
        });
    }
});



