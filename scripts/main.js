// replace text within element by ID
function replaceText(id, text) {
    var q = document.getElementById(id);
    if (q) q.innerHTML = text;
}
  
// listen to URL parameters
const urlParameter = new URLSearchParams(window.location.search);

// Dynamic logo height
function resizeLogo() {
    var logoHeight = $(window).outerHeight() - ($('#footer').outerHeight() + $('h2').outerHeight() + $('#link-gallery').outerHeight()) - 50 /*margin top+bottom*/;
    $('.logo-splash').height(logoHeight);
}

// Page Load
document.addEventListener("DOMContentLoaded", function(e) {
    // Copyright Year
    replaceText('year', new Date().getFullYear());
    resizeLogo();

    // register sign-up themes
    if (urlParameter.has('theme')){
        var theme = urlParameter.get('theme');
        if (theme == 'none'){
            $('#bg').hide();
            $('#main-hero').hide();
            // $('body').css({'background-color':'#fff'});
        }
    }

});

// Palettopia Landing Page
function resizePalettopia() {
    var winWidth = $(window).width();
    var waveWidth = winWidth / 100 * 11.43 //vw;
    var waveScale = (waveWidth / 250);
    var birdWidth = winWidth / 100 * 4.45 //vw;
    var birdScale = (birdWidth / 125);
    $('.swell').css({transform:'scale('+waveScale+')'});
    $('.bird').css({transform:'scale('+birdScale+')'});
}

// Image Load
$(window).on("load", function(e) {
    resizeLogo();
    resizePalettopia();
    $('#container').css({'opacity':'1'})
    $('#main-logo').css({'animation-play-state':'running'})
});
    
// Window resize listener
$(window).on( "resize", function(e) {
    resizeLogo();
    resizePalettopia();
});