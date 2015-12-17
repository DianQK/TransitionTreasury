$(document).ready(function () {

  var $body = $('body');
  var $themeMenu = $('.resume-dropdown-menu > li > a');

  $themeMenu.on('click', function(event) {

    $body.attr('class', '');

    var themeColor = $(this).attr('id');
    var themeColorClass = "theme-" + themeColor;
    $body.addClass(themeColorClass);

    event.preventDefault();

  });

});
