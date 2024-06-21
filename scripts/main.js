function replaceText(id, text) {
    var q = document.getElementById(id);
    if (q) q.innerHTML = text;
  }

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

});
