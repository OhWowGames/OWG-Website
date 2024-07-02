// replace text within element by ID
function replaceText(id, text) {
    var q = document.getElementById(id);
    if (q) q.innerHTML = text;
}
  
// listen to URL parameters
const urlParameter = new URLSearchParams(window.location.search);

// Page Load
document.addEventListener("DOMContentLoaded", function(e) {
    replaceText('year', new Date().getFullYear());

    function resizeLogo() {
        var logoHeight = $(window).outerHeight() - ($('#footer').outerHeight() + $('h2').outerHeight()) - 150;
        $('#main-logo').height(logoHeight);
    }
    resizeLogo();
    
    $(window).on( "resize", function(e) {
        resizeLogo();
    } );

    // register sign-up themes
    if (urlParameter.has('theme')){
        var theme = urlParameter.get('theme');
        if (theme == 'none'){
            $('#bg').hide();
            $('#main-hero').hide();
        }
    }

});


