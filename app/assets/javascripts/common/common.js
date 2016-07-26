$(document).ready(function(){
    $('a#testpop').on('click', function(e) {e.preventDefault(); return true;});
    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"]').tooltip();
});