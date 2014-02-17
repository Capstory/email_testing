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
//= require jquery.cycle.all
//= require jquery.localscroll
//= require jquery.scrollto
//= require date
//= require jquery.ui.datepicker
//= require angular
//= require angular-resource
//= require angular-route


$(function(){ 
  
  $(document).foundation(); 
  
	
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
  
  $('a.login-window').click(function() {
		
		// Getting the variable's value from a link 
		var loginBox = $(this).attr('href');

		//Fade in the Popup and add close button
		$(loginBox).fadeIn(300);
		
		//Set the center alignment padding + border
		var popMargTop = ($(loginBox).height() + 24) / 2; 
		var popMargLeft = ($(loginBox).width() + 24) / 2; 
		
		$(loginBox).css({ 
			'margin-top' : -popMargTop,
			'margin-left' : -popMargLeft
		});
		
		// Add the mask to body
		$('body').append('<div id="mask"></div>');
		$('#mask').fadeIn(300);
		
		return false;
	});
	
	$("#menutog button.redirect_to_login").click(function(){
	  document.location.href = "/login";
	});
	
	// When clicking on the button close or the mask layer the popup closed
	$('a.close-login-popup, #mask').on('click', function() { 
	  $('#mask , .login-popup').fadeOut(300);
	  $("div").remove("#mask"); 
		return false;
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
	
	
	$("#stripe_engage").click(function (event){
	  $(".stripe-button-el").click();
	  event.preventDefault();
	});
	
	//
	// ======================================
	// Admin Dashboard JS
  // ======================================
  //
  
  $(".admin_links").click(function (event) {
    var partial_id = $(this).attr('id');
    new_partial = "#" + partial_id + "_data";
    $(".data_partial").hide();
    $(new_partial).show();
    event.preventDefault();
  });
  
});
