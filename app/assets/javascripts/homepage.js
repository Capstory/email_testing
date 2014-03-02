//= require ./homepage/public
//= require jquery.ui.datepicker

$("#industry_professional").click(function(){
  $(".industry_explanation").show('slow');
  $(".industry_explanation input[type=text]").focus();
});

$(".non_industry").click(function(){
  $(".industry_explanation").hide('slow');
});

$("#show_partner_code").click(function(){
  // $(this).hide('slow');
  $("#partner_code").toggle('slow');
});

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