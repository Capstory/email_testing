// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require date
//= require jquery.ui.datepicker
//= require angular
//= require angular-resource
//= require angular-route
//= require ./capsules/isotope.pkgd.min.js
//= require_self
//
function checkForErrors () {
  var alert_array = []
  
  if ( $(".error").length > 0 ) {
    $(".error").each(function() {
      if ( $(this).children().prop("tagName") == "INPUT" ) {
        $(this).children('input').after("<small>Invalid</small>");
      }
    });
  }
}

function downloadPoller () {
	var timeoutID;

	return {
		startPolling: function (download_id) {
			timeoutID = window.setInterval(function(){
				downloadManager.poll(download_id);
			}, 1000);
		},
		poll: function(download_id) {
			var request_url = "/download_poller.json?download_id=" + download_id;
			$.get(request_url, function(response){
				if ( response.ready ) {
					window.clearTimeout(timeoutID);

					url = "/download_link?download_id=" + download_id;
					window.location = url;
				}
			});	
		}
	}
}

var downloadManager = downloadPoller();

$(function(){ 
  
  $(document).foundation(); 
	checkForErrors();
	
	$(".sub-nav dd").click(function(){
	  var item_id = $(this).attr('id');
	  $(".sub-nav dd").removeClass("active");
	  $(".list_of_requests").hide();
	  $(this).addClass("active");
	  var item_to_show = "#" + item_id + "_requests";
	  $(item_to_show).show();
	});
	
	$(".mc-image").removeAttr('title');
	
  
  $("#second_reservation_button").click(function(){
    $("a.login-window").click();
  });
	
	
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
	
	// $("#stripe_engage").click(function (){
	//   $(".stripe-button-el").click();
	// });
	
	//
	// ======================================
	// Admin Dashboard JS
  // ======================================
  //
  
  $(".admin_links").click(function (event) {
    var partial_id = $(this).attr('id');
    var new_partial = "#" + partial_id + "_data";
    $(".data_partial").hide();
    $(new_partial).show();
    event.preventDefault();
  });
 
	$(".vendor_dashboard_link").click(function(event){
		var partial_id = $(this).attr("id");
		var new_partial = "#" + partial_id + "_data";
		$(".vendor_partial").hide();
		$(new_partial).show();
		event.preventDefault();
	});

  $(".date-pick").datepicker({
    dateFormat: "yy-mm-dd",
    autoFocusNextInput: true
  });
  
  $(".modal_img").click(function(){
	  photo_id = $(this).attr('id');
	  checkmark_id = "#checkmark_" + photo_id;
	  photo_id = "#photos_" + photo_id;
	  $(photo_id).trigger('click');
	  $(this).toggleClass("modal_highlight");
	  $(checkmark_id).toggle();
	});
	
	$("#download_engage").click(function () {
	  $("#download_engage").hide();
	  $("#post_download").fadeIn();
	});
	
	$("#download_submit_button").click(function () {
	  $("#download_modal").foundation('reveal', 'open', {
      closeOnBackgroundClick: false
    });
	});
	
	$("#download_select_all").click(function(event){
		$(".modal_img").click();
		$("#download_submit_button").click();
		event.preventDefault();
	});	

	$(".vendor_order").click(function(e) {
		var id = $(this).attr("data-id");	
		var vendor_selector = "#vendor_order_" + id;
		$(vendor_selector).fadeToggle("medium");
		e.preventDefault();
	});

	// if ( $("#isotope_div").length > 0 ) {
	// 	$("#isotope_div").isotope({
	// 		itemSelector: ".alt_cap_img",
	// 		layoutMode: "fitRows"
	// 	});
	// }

	$(".faq_answers").click(function(e) {
	  $(".faq_questions.open").removeClass("open").hide();
	  $answer_id = $(this).attr("data-answer");
	  $("#" + $answer_id).addClass("open").fadeToggle("slow");
	  e.preventDefault();
	});

	$("#live_slideshow").addClass("open").show();
});
