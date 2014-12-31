//= require jquery
//= require jquery_ujs
//= require foundation
//= require ./capsules/isotope.pkgd.min
//= require ./angular_src_files/angular
//= require ./angular_src_files/angular-route
//= require ./conference_capsule/conference_capsule.js.erb
//= require_tree ./conference_capsule/controllers
//= require_tree ./conference_capsule/services
//= require_tree ./conference_capsule/models
//= require ./conference_capsule/filters.js
//= require ./conference_capsule/directives.js
//= require ./common_use/angular-isotope.js
//= require ./common_use/ng-infinite-scroll.js
//= require_self

var filepicker_submission = function() {
	$("#filepicker_upload").addClass("disabled");
	$("#filepicker_submit").click();
};

$(function(){
	$(document).foundation();
});
