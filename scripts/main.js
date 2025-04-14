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
        } else if (theme == vd){
            $('#bg').addClass(vd);
            $('#main-hero').addClass(vd);
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

    var mobileWave = $('#palettopia-content').outerHeight() + (winWidth / 1.8);
    $('.swell:nth-child(4)').css({marginTop: mobileWave });
}

// Image Load
$(window).on("load", function(e) {
    resizeLogo();
    resizePalettopia();
    $('#container').css({'opacity':'1'});

    $('#main-logo').css({'animation-play-state':'running'});
    setTimeout(function(){ 
        $('#main-logo').css({'animation-play-state':'paused'});
        $('#main-logo').click(function(){ 
            $(this).css({'animation-play-state':'running'});
            setTimeout(function(){ 
                $('#main-logo').css({'animation-play-state':'paused'});
                $('#main-logo').attr('src', 'images/owg_logo_icon.svg');
                $('#main-logo').css({'animation-name':'kapow2','animation-play-state':'running'});
                setTimeout(function(){ 
                    $('#main-logo').css({'animation-play-state':'paused'});
                    $('#main-logo').off('click');
                    $('#main-logo').click(function(){ 
                        $('#main-logo').css({'animation-name':'eat','animation-iteration-count':'1','animation-duration':'1s','animation-play-state':'running'});
                        setTimeout(function(){
                            $('#main-logo').off('click');
                            $('.tagline').css({'opacity':'0'})
                            $('.main').css({'background-color':'black'});
                            $('#main-logo').attr('src', 'images/palettopia_aligator.svg');
                            $('#main-logo').css({'animation-name':'hop','animation-duration':'4s','padding-bottom':'50px'});
                            $('.speech-bubble').show();
                            setTimeout(function(){
                                $('.tagline').css({'transition':'opacity 2s','opacity':'1'});
                            },1500);
                            setTimeout(function(){
                                $('.speech-bubble').css({'transition':'opacity 2s','opacity':'1'});
                            },4000);                            
                        },800)
                    });
                }, 900);
            }, 900);
        });
    }, 900);
    
});
    
// Window resize listener
$(window).on( "resize", function(e) {
    resizeLogo();
    resizePalettopia();
});