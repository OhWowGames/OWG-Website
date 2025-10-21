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

// Dark Mode, matches os default settings
function themeColorChange(color){
    if (color === 'dark'){
        $('body').addClass('dark');
    } else {
        $('body').removeClass('dark');
    }
}
function setThemeColor(){
    const isDarkMode = window.matchMedia("(prefers-color-scheme: dark)").matches;    
    if (isDarkMode) themeColorChange('dark');
}
const darkModeMediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
darkModeMediaQuery.addEventListener("change", (event) => {
    if (event.matches)
        themeColorChange('dark');
    else
        themeColorChange('light');
});

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
        } else if (theme == vd){
            $('#bg').addClass(vd);
            $('#main-hero').addClass(vd);
        }
    }
    // Homepage - animate scroll on Team link
    $('#link-gallery > div a[href="#team"]').click(function(event){
        event.preventDefault();
        $('.team-member img').removeClass('shimmer');
        var bodyH = $(document).height(), windowH = $(window).height(), elemOffset = $('#team').offset().top;
        var remainingScroll = bodyH-elemOffset;
        var scrollDist = windowH < remainingScroll ? elemOffset : elemOffset-(windowH-remainingScroll);
        var scrollSpeed = Math.max(scrollDist / 0.9, 200);
        $("html, body").stop().animate({scrollTop: scrollDist}, scrollSpeed, 'swing', function() {
            $('.team-member img').addClass('shimmer');
        });
    });
    // Toggle Dark Mode
    $('#theme-color').click(function(){
        var isDarkActive = $('body')[0].classList.contains('dark');
        if (isDarkActive)
            themeColorChange('light');
        else
            themeColorChange('dark');
    });

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

    var mobileWave = $('#palettopia-content').outerHeight() + (winWidth / 1.8);
    $('.swell:nth-child(4)').css({marginTop: mobileWave });
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