$(document).ready(function() {

    $(".se-pre-con").show().fadeOut("slow");

    $(".notice").fadeOut(4000);
    $("#error-container").fadeOut(6000);
    $("#notice-container").fadeOut(6000);

    let win = $(this); //this = window
    let drpdwn = $(".q");
    if (win.width() >= 720) {
        drpdwn.hide();}
    else if (win.width() < 720){
        drpdwn.show();
    }
});

$(window).on('resize', function() {
    let win = $(this); //this = window
    let drpdwn = $(".q");
    if (win.width() >= 720) {
        drpdwn.hide();}
    else {
        drpdwn.show();
    }
});

