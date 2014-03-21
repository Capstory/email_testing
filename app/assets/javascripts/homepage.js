//= require ./homepage/public
//= require angular
//= require jquery.ui.datepicker

$("#industry_professional").click(function(){
  $(".industry_explanation").show('slow');
  $(".industry_explanation input[type=text]").focus();
});

$(".non_industry").click(function(){
  $(".industry_explanation").hide('slow');
});

// $("#show_partner_code").click(function(){
//   $(this).hide('slow');
//   $("#partner_code").toggle('slow');
// });

$(".date-pick").datepicker({
  dateFormat: "yy-mm-dd",
  autoFocusNextInput: true
});

$(".menu-btn").click(function () {
  $("#container").toggleClass("container-push");
  $("nav.pushy").toggleClass("pushy-left");
  $("nav.pushy").toggleClass("pushy-open");
});

$("nav.pushy a").click(function () {
  $("#container").toggleClass("container-push");
  $("nav.pushy").toggleClass("pushy-left");
  $("nav.pushy").toggleClass("pushy-open");
});

$("#engaged_contact_copy_launch").click(function () {
  $("#engaged_contact_copy_show").toggle();
  var caret_is_down = $("#engaged_contact_copy_launch p i").hasClass("fa-caret-down");
  if ( caret_is_down ) {
    $("#engaged_contact_copy_launch p i").removeClass("fa-caret-down").addClass("fa-caret-right");
  } else {
    $("#engaged_contact_copy_launch p i").removeClass("fa-caret-right").addClass("fa-caret-down");
  }
});