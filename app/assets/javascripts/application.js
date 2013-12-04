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
//= require jquery.maximage
//= require jquery.scrollto
//= require jquery.fullscreen
//= require date
//= require jquery.ui.datepicker
//= require fancybox
//= require main
//= require_tree .

$(function(){ 
  
  $(document).foundation(); 
  
  $('.imgLiquidFill').imgLiquid({
    verticalAlign: '80%'
  });
  
  // Masonry Related JS
  var $container = $("#original_container");
  $(window).bind('load', function(){
    $container.masonry({  
      itemSelector: '.masonry-brick',
      columnWidth: 150
    });
  });
  
  
  $("#maximage").maximage({
      fillElement: "#maximage_container",
      backgroundSize: 'contain'
    });
  
  $("#enterFullScreen").click(function(){
    $("#maximage").fullscreen();
    return false;
  });
  
  //   $("#start_jobs").click(function(){
  //  interval = setInterval(intervalRun, 30000);
  //  $("#start_jobs").hide();
  //  $("#stop_jobs").show();
  // });
  // 
  // $("#stop_jobs").click(function(){
  //  clearInterval(interval);
  //  $("#stop_jobs").hide();
  //  $("#start_jobs").show();
  // });
  // 
  // function intervalRun(){
  //    $("#reload_button").click();
  //    $("#get_emails_button").click();
  //  }
		
  // $(document).bind('cbox_open', function(){
  //   $("#cboxClose").hide();
  // });
	
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
  
  // $("#show_capsule_controls").click(function(){
  //   $(".capsule_controls").toggle('slow');
  //   return false;
  // });
  
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
	
	// When clicking on the button close or the mask layer the popup closed
	$('a.close, #mask').on('click', function() { 
	  $('#mask , .login-popup').fadeOut(300);
	  $("div").remove("#mask"); 
		return false;
		});
});
