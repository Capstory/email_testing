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
//= require_tree ./lib
//= require masonry.pkgd.min
//= require jquery.cycle.all
//= require jquery.localscroll
//= require jquery.scrollto
//= require jquery.fullscreen
//= require date
//= require jquery.ui.datepicker
//= require fancybox
//= require main
//= require angular
//= require angular-resource
//= require_tree .

function facebook_modal_show (){
  $("#facebook_photo_push_modal").foundation("reveal", "open");
}

function slideshow_setup (){
  var slideshow_array = [];
  var counter = 0;
  var slideshow_length;
  return {
    start_slideshow: function () {
      capsule_slideshow.set_slideshow_length();
      $("#slideshow img").attr('src', slideshow_array[counter]);
      window.setInterval(function () {
        if (counter === 0) {
          $("#slideshow img").fadeOut('slow', function(){
            $(this).attr('src', slideshow_array[counter]).fadeIn('slow');
          });
          counter += 1;
          $("#loading_div").css('background-image', "url(" + slideshow_array[counter] + ")");
        }
        else if (counter >= slideshow_length) {        
          $("#slideshow img").fadeOut('slow', function(){
            $(this).attr('src', slideshow_array[counter]).fadeIn('slow');
          });
          counter = 0;
          $("#loading_div").css('background-image', "url(" + slideshow_array[counter] + ")");
        }
        else {
          $("#slideshow img").fadeOut('slow', function(){
            $(this).attr('src', slideshow_array[counter]).fadeIn('slow');
          });
          counter += 1;
          $("#loading_div").css('background-image', "url(" + slideshow_array[counter] + ")");
        }
      }, 5000);
    },
    stop_slideshow: function (slideshow_variable) {
      clearInterval(slideshow_variable);
    },
    set_slideshow_length: function() {
      slideshow_length = slideshow_array.length - 1;
    },
    set_slideshow_array: function (array_of_slides) {
      slideshow_array = array_of_slides;
      capsule_slideshow.start_slideshow();
    },
    add_new_element: function (new_item) {
      slideshow_array.unshift(new_item);
      counter += 1;
      capsule_slideshow.set_slideshow_length();
    },
    change_data_id: function (new_id) {
      $("#slideshow").attr('data-id', new_id);
    },
    show_slideshow_array: function() {
      alert(slideshow_array);
    }
  };
};

var capsule_slideshow = slideshow_setup();

$(function(){ 
  
  $(document).foundation(); 
  
  
  // Masonry Related JS
  var $container = $("#original_container");
  $(window).bind('load', function(){
    $container.masonry({  
      itemSelector: '.masonry-brick',
      columnWidth: 150
    });
  });
  
  
  $("#enterFullScreen").click(function(){
    $("#slideshow").fullscreen();
    return false;
  });

	
	$(".sub-nav dd").click(function(){
	  var item_id = $(this).attr('id');
	  $(".sub-nav dd").removeClass("active");
	  $(".list_of_requests").hide();
	  $(this).addClass("active");
	  var item_to_show = "#" + item_id + "_requests";
	  $(item_to_show).show();
	});
	
	$(".mc-image").removeAttr('title');
	
	$(".grouped_elements").fancybox({
    beforeLoad: function(){
      var $elementTitle = $(this.element).attr('data-title');
      if ($elementTitle === "No Title") {
        this.title = $(this.element).attr('title');
      } 
      else {
        this.title = $elementTitle;
      }
    }
	});
  
  $(".show_delete").click(function(){
    $(this).next("small").toggle('slow');
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
	  $(".industry_explanation").show();
	  $(".industry_explanation input[type=text]").focus();
	});
	
	$(".non_industry").click(function(){
	  $(".industry_explanation").hide();
	});
	
	$("#facebook_modal_engage").click(function(e){
	  e.preventDefault();
	  facebook_modal_show();
	  $("#facebook_photo_push_modal input[type=checkbox]").hide();
	});
	
	$("#facebook_push_submit").click(function(e){
	  e.preventDefault();
	  $("#facebook_modal_submit_button").click();
	});
	
	$(".modal_img").click(function(){
	  photo_id = $(this).attr('id');
	  photo_id = "#photos_" + photo_id;
	  $(photo_id).trigger('click');
	  $(this).toggleClass("modal_highlight");
	});
});
