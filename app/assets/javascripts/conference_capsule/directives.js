conference_capsule_app.directive("isotope", function() {
	return function(scope, element, attrs) {
		element.isotope({
			itemSelector: ".isotopeElement",
			layoutMode: "masonry"
		});
	}
});
