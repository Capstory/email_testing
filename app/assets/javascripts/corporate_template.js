//= require jquery
//= require jquery_ujs
//= require ./corporate_template/bootstrap.min
//= require ./corporate_template/jquery.scrollTo
//= require ./corporate_template/jquery.nav
//= require ./corporate_template/jquery.easing
//= require ./corporate_template/jquery.flexslider-min
//= require ./corporate_template/jquery.isotope.min
//= require ./corporate_template/jquery.fitvids
//= require ./corporate_template/jquery.appear
//= require ./corporate_template/retina
//= require ./corporate_template/respond.min
//= require ./corporate_template/jquery.parallax-1.1.3
//= require ./corporate_template/jquery.magnific-popup.min
//= require ./corporate_template/jquery.sticky
//= require ./corporate_template/jquery.countTo
//= require ./corporate_template/jquery.mb.YTPlayer
//= require ./corporate_template/jquery.superslides
//= require ./corporate_template/functions
//= require ./corporate_template/layerslider/js/greensock
//= require ./corporate_template/layerslider/js/layerslider.transitions
//= require ./corporate_template/layerslider/js/layerslider.kreaturamedia.jquery
//= require_self


$(function(){
	var resetContactForm = function() {
		$("#name2").val("");
		$("#email2").val("");
		$("#message2").val("");

	};

	var resetCustomizeForm = function() {
		$("#customize_name2").val("");
		$("#customize_email2").val("");
		$("#customize_message2").val("");

	};

	var resetCheckBox = function(elementId) {
		$(elementId).attr("checked", false);
	};

	var resetCheckBoxes = function(elementArray) {
		if (elementArray.length == 0) { return true; }

		var elId = elementArray.pop();
		resetCheckBox(elId);

		resetCheckBoxes(elementArray);	
	};

	var resetPackageInfoForm = function() {
		$("#package_info_name2").val("");
		$("#package_info_email2").val("");
		$("#package_info_message2").val("");
		$("#package_info_date").val("");
		
		resetCheckBoxes(["#bronze_package", "#silver_package", "#gold_package", "#custom_package"]);	
	};

// 	$("#modalSubmitButton").on("click", function() {
// 		$("#contactSubmitButton").click();
// 	});

	$("#new_contact_form")
		.on("ajax:success", function(e, data, status, xhr) {
			// console.log(data);
			// console.log(status);
			// console.log(xhr);

			$("#contact_form_success").show();
			$("#err-form").hide();
			resetContactForm();
		})
		.on("ajax:error", function(e, xhr, status, error) {
			// console.log(e);
			// console.log(error);
			// console.log(xhr);
			// alert("Unable to send contact form");
			
			$("#contact_form_success").hide();
			$("#err-form").show();
		});

	$("#customizeContactForm")
		.on("ajax:success", function(e, data, status, xhr) {
			// console.log(data);
			// console.log(status);
			// console.log(xhr);

			$("#customize_form_success").show();
			$("#customize_form_err").hide();
			resetCustomizeForm();
		})
		.on("ajax:error", function(e, xhr, status, error) {
			// console.log(e);
			// console.log(error);
			// console.log(xhr);
			// alert("Unable to send contact form");
			
			$("#customize_form_success").hide();
			$("#customize_form_err").show();
		});

	$("#requestPackageInfo")
		.on("ajax:success", function(e, data, status, xhr) {
			// console.log(data);
			// console.log(status);
			// console.log(xhr);

			$("#package_info_form_success").show();
			$("#package_info_form_err").hide();
			resetPackageInfoForm();
		})
		.on("ajax:error", function(e, xhr, status, error) {
			// console.log(e);
			// console.log(error);
			// console.log(xhr);
			// alert("Unable to send contact form");
			
			$("#package_info_form_success").hide();
			$("#package_info_form_err").show();
		});
});
