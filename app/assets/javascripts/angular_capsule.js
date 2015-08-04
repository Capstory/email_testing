//= require jquery
//= require jquery_ujs
//= require foundation
//= require ./capsules/isotope.pkgd.min
//= require angular_src_files/angular
//= require ./angular_src_files/angular-route
//= require ./angular_src_files/angular-touch
//= require ./angular_src_files/angular-cookies
//= require ./angular_capsule/angular_capsule.js.erb
//= require_tree ./angular_capsule/controllers
//= require_tree ./angular_capsule/services
//= require_tree ./angular_capsule/models
//= require ./angular_capsule/filters.js
//= require ./angular_capsule/directives.js
// require ./common_use/angular-isotope.js
//= require ./common_use/ng-infinite-scroll.js
// require string
//= require_self

var emitMenuClick = function() {
	var event = new Event("menuClick");
	document.dispatchEvent(event);
};

var emitFilepickerEngage = function() {
	var event = new Event("filepickerEngage");
	document.dispatchEvent(event);
	// e.preventDefault();
	// return false;
};

$(function() {
	$(document).foundation();

});
