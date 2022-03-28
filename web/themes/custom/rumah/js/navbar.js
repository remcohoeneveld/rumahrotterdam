(function ($) {
  $(document).ready(function () {
    let mobile_menu = $('#mobile-menu');
    let mobile_btn = $("button[aria-controls='mobile-menu']");
    let open_sidebar_btn =  $("#open-sidebar-mobile-user-page");
    let close_sidebar_btn =  $("#close-sidebar-mobile-user-page");
    let mobile_sidebar_user = $('.mobile-sidebar-user-page');

    if (open_sidebar_btn.length) {
      open_sidebar_btn.click(function () {
        mobile_sidebar_user.show();
      });
    }

    if (close_sidebar_btn.length) {
      close_sidebar_btn.click(function () {
        mobile_sidebar_user.hide();
      });
    }

    if (!mobile_menu.length) {
      mobile_btn.hide();
    }
    else {
      mobile_btn.click(function () {
        mobile_menu.toggle();
      });
    }

    $("#user-menu-button").click(function () {
      $('div[aria-labelledby="user-menu-button"]').toggle();
    });
  });
})(jQuery);
