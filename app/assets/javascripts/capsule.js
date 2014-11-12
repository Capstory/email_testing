//= require_tree ./capsules
//= require fancybox

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
      }, 8000);
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

$(function (){

  $("#enterFullScreen").click(function(){
    $("#slideshow").fullscreen();
    return false;
  });

  $(".grouped_elements").fancybox({
    beforeLoad: function(){
      var $elementTitle = $(this.element).attr('data-title');
      if ($elementTitle === "No Title") {
        this.title = $(this.element).attr('title');
      } 
      else {
        this.title = $elementTitle;
      }
    },
    beforeShow: function () {
      var newWidth = this.width * 2;
      var newHeight = this.height * 2;
      $(".fancybox-image").css({
        "width": newWidth,
        "height": newHeight
      });
      this.width = newWidth;
      this.height = newHeight;
    },
    helpers: {
      overlay: {
        locked: false
      }
    }
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


  // $(".modal_img").click(function(){
  //   photo_id = $(this).attr('id');
  //   checkmark_id = "#checkmark_" + photo_id;
  //   photo_id = "#photos_" + photo_id;
  //   $(photo_id).trigger('click');
  //   $(this).toggleClass("modal_highlight");
  //   $(checkmark_id).toggle();
  // });

  $(".show_delete").click(function(){
    $(this).next("small").toggle('slow');
  });
  
  $('#activate_filepicker').click(function () {
    $('.pick_file').click();
  });

  // Masonry Related JS
  var $container = $("#original_container");
  
  $container.imagesLoaded(function () {
    $container.masonry({  
      itemSelector: '.masonry-brick',
      columnWidth: 320
    });
  });
  
  if ( $(".next_page").length > 0 ) {
    $container.infinitescroll({
      loading: {
        msgText: "<em>Loading the next set of photos...</em>",
        img: "",
        finishedMsg: ""
      },
      navSelector: '.pagination',
      nextSelector: '.pagination a.next_page',
      itemSelector: '.masonry-brick',
      errorCallback: function () {
        $("#spinner").hide();
        $("#finished_text").show().delay(5000).fadeOut('slow');
      }
      },
      function ( newElements ) {
        var $newElems = $(newElements).css({ opacity: 0 });
        $newElems.imagesLoaded(function () {
          $newElems.animate({ opacity: 1 });
          $container.masonry( "appended", $newElems, true);
        });
      }
    );
  }
  else if ( $(".post").length > 0 ) {
    $("#spinner").hide();
  }
  else {
    $("#spinner").hide();
    $("#no_photos").fadeIn("slow");
  }
});
