//= require jquery
//= require jquery_ujs
//= require jquery.ui.datepicker
// require ./corporate_template/bootstrap.min
//= require_tree ./static_pages
//= require_self

var requestFormValidator = function() {
	function isRequired(el) {
		var errorMsg = {
			elementId: el.id,
			elementName: el.name,
			isError: false, 
			type: "isRequired", 
			msg: "Everything is fine"
		};

		if ( el.value.trim().length == 0 ) {
			errorMsg.isError = true;
			errorMsg.msg = "This is a required field";
		}

		return errorMsg;
	}

	function errorBuilder(displayEl, error) {
		var div = document.createElement("div");
		var errorMessage = "The " + error.elementName + " field has something wrong. Error: " + error.msg; 
		div.appendChild(document.createTextNode(errorMessage));
		div.classList.add("errorModalError");
		displayEl.appendChild(div);
	}

	var errorDisplay = document.getElementById("requestFormErrorDisplay");
	var fields = [{
			id: "name",
			name: "Name",
			type: "text",
			validatorFunctions: [isRequired]
		},
		{
			id: "email",
			name: "Email/Phone Number",
			type: "text",
			validatorFunctions: [isRequired]
		},
		{
			id: "additional_information",
			name: "Additional Information",
			type: "textarea",
			validatorFunctions: []
		}];
	// var fields = [{
	// 	id: "name",
	// 	name: "Name",
	// 	type: "text",
	// 	validatorFunctions: [isRequired]
	// },
	// {
	// 	id: "email",
	// 	name: "Email/Phone Number",
	// 	type: "text",
	// 	validatorFunctions: [isRequired] 
	// },
	// {
	// 	id: "company",
	// 	name: "Company Name",
	// 	type: "text",
	// 	validatorFunctions: [isRequired]
	// },
	// {
	// 	id: "position",
	// 	name: "Position/Title",
	// 	type: "text",
	// 	validatorFunctions: [isRequired]
	// },
	// {
	// 	id: "event_type",
	// 	name: "Event Type",
	// 	type: "text",
	// 	validatorFunctions: []
	// },
	// {
	// 	id: "event_date",
	// 	name: "Event Date",
	// 	type: "text",
	// 	validatorFunctions: []
	// },
	// {
	// 	id: "event_size",
	// 	name: "Event Size",
	// 	type: "text",
	// 	validatorFunctions: []
	// },
	// {
	// 	id: "additional_information",
	// 	name: "Additional Information",
	// 	type: "textarea",
	// 	validatorFunctions: []
	// }];

	return {
		checkRequestFormForErrors: function() {
			var errMsgs = [];
			var i;

			for (i = 0; i < fields.length; i++) {
				var j;
				var el = document.getElementById(fields[i].id);

				for (j = 0; j < fields[i].validatorFunctions.length; j++) {
					var msg = fields[i].validatorFunctions[j].apply(this, [el]);
					if ( msg.isError ) {
						msg.elementName = fields[i].name;
						errMsgs.push(msg);
					}
				}
			}

			return errMsgs;
		},
		showRequestFormErrors: function(errors) {
			console.log(errors);	
			var i;
			errorDisplay.style.visibility = "visible";
			errorDisplay.innerHTML = "";

			for (i = 0; i < errors.length; i++) {
				errorBuilder(errorDisplay, errors[i]);
			}
		},
		hideRequestFormErrors: function() {
			errorDisplay.style.visibility = "hidden";					   
		},
		clearAllFormFields: function() {
			var i;

			for (i = 0; i < fields.length; i++) {
				var el = document.getElementById(fields[i].id);
				el.value = "";
			}			
		},
		run: function(clickEvent) {
			var errorMsgs = this.checkRequestFormForErrors();
			if ( errorMsgs.length != 0 ) {
				this.showRequestFormErrors(errorMsgs);
				clickEvent.preventDefault();
				return false;
			} else {
				this.hideRequestFormErrors();
				return true;
			}
		}
	}
};

function overlay() {
	function setDefaultState() {
		var modals = ["thankYouModalContent", "errorsModalContent"];
		var i;

		for (i = 0; i < modals.length; i++) {
			$("#" + modals[i]).hide();
		}

		$("#mainModalContent").show();
	}

	setDefaultState();

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

var successHandler = function(e, data, status, xhr) {
	// console.log("Event: ", e);
	// console.log("Data: ", data);
	validator.clearAllFormFields();
	$("#mainModalContent").hide();
	$("#thankYouModalContent").show();
};

var errorHandler = function(e, xhr, status, error) {
	console.log("There was an error: ", error);
};

var validator = requestFormValidator();
$(function() {
	// overlay();
	// $("#mainModalContent").hide();
	// $("#thankYouModalContent").hide();

	$(".requestFormCheckBox").on("click", function() {
		var $el = $(this);
		var checkMark = $el.children(".requestFormCheckMark")[0];
		var childInput = $($(checkMark).children("input")[0]);
		checkMark.style.visibility = ( checkMark.style.visibility == "visible" ) ? "hidden" : "visible";
		childInput.prop("checked", !( childInput.prop("checked") ));

		console.log(childInput.prop("checked"));
	});

	$("#requestFormSubmitButton").on("click", function(evt) {
		console.log("I've submittted");
		if (validator.run(evt)) {
			validator.hideRequestFormErrors();
			$("#thankYouModalContent").show();

			$("#closeThankYouModal").on("click", function() {
				overlay();
			});
		} else {
			$("#mainModalContent").hide();
			$("#errorsModalContent").show();
			
			$("#backToMainModal").on("click", function() {
				$("#mainModalContent").show();
				$("#errorsModalContent").hide();
			});
		}
	});

	$("#requestDemoForm").on("ajax:success", successHandler).on("ajax:error", errorHandler);

	if ( $("#introVideo").length > 0 ) {
		function adjustVideoSize() {
			var video = $("#introVideo iframe");
			video.css("width", "100%");

			var vidWidth = video.css("width");
			// console.log("Video is now width of: ", vidWidth);

			var vidHeight = parseInt(vidWidth.replace("px", "")) * 0.562;
			// console.log("Video is of height: ", vidHeight);
			video.css("height", vidHeight);
		}

		$(window).on("resize", function() {
			adjustVideoSize();
		});

		adjustVideoSize();
	}
});
