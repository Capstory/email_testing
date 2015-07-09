//= require jquery
//= jquery_ujs
//= require jquery.ui.datepicker
// require ./corporate_template/bootstrap.min
//= require_tree ./static_pages
//= require_self

function overlay() {
	var el = document.getElementById("modal-overlay");
	el.style.visibility = ( el.style.visibility == "visible" ) ? "hidden" : "visible";   	

	el.addEventListener("click", function(evt) {
		if (evt.target.id == "modal-overlay") {
			overlay();
		}
	});

	var closeIcon = document.getElementById("close-modal");
	closeIcon.addEventListener("click", function() {
		overlay();
	});

	var closeBtn = document.getElementById("requestFormCloseButton");
	closeBtn.addEventListener("click", function() {
		overlay();
	});
}

$(function() {
	overlay();
	
	$(".requestFormCheckBox").on("click", function() {
		var $el = $(this);
		console.log($el.children(".requestFormCheckMark")[0]);

		$el.children(".requestFormCheckMark")[0].style.visibility = ( $el.children(".requestFormCheckMark")[0].style.visibility == "visible" ) ? "hidden" : "visible";
	});
});
