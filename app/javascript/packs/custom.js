$(document).ready(function() {

    $(".se-pre-con").show().fadeOut("slow");
    $(".notice").fadeOut(4000);
    $("#error-container").fadeOut(6000);
    $("#notice-container").fadeOut(6000);

    $(".start").click(function () {
        $({rotation: 0}).animate({rotation: 1080}, {
            duration: 25000,
            easing: 'linear',
            step: function () {
                $(".se-pre-con").css({transform: 'rotate(' + this.rotation + 'deg)'});
                console.log(this.rotation);
            }
        });
        $(".se-pre-con").fadeIn(400).fadeOut(29600);
    });

});



