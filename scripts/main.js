// replace text within element by ID
function replaceText(id, text) {
    var q = document.getElementById(id);
    if (q) q.innerHTML = text;
}
  
// listen to URL parameters
const urlParameter = new URLSearchParams(window.location.search);

// Dynamic logo height
function resizeLogo() {
    var logoHeight = $(window).outerHeight() - ($('#footer').outerHeight() + $('h2').outerHeight() + $('#link-gallery').outerHeight()) - 150;
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

// Image Load
$(window).on("load", function(e) {
    resizeLogo();
    $('#container').css({'opacity':'1'})
});
    
// Window resize listener
$(window).on( "resize", function(e) {
    resizeLogo();
});
