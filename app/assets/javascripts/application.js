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
//= require masonry.pkgd.min
//= require jquery.cycle.all
//= require jquery.localscroll
//= require jquery.maximage
//= require jquery.scrollto
//= require jquery.fullscreen
//= require_tree .

$(function(){ 
  
  $(document).foundation(); 
  
  $('.imgLiquidFill').imgLiquid({
    verticalAlign: '80%'
  });
  
  $(window).load(function(){
    $('#masonryContainer').masonry({  
      itemSelector: '.masonry-brick',
      columnWidth: 240
    });
  });
  
  $("#maximage").maximage();
  
  $("#enterFullScreen").click(function(){
    $("#maximage").fullscreen();
  });
  
  $("#start_jobs").click(function(){
		interval = setInterval(intervalRun, 30000);
		$("#start_jobs").hide();
		$("#stop_jobs").show();
	});
	
	$("#stop_jobs").click(function(){
		clearInterval(interval);
		$("#stop_jobs").hide();
		$("#start_jobs").show();
	});
	
	function intervalRun(){
			$("#reload_button").click();
			$("#get_emails_button").click();
		}
});
