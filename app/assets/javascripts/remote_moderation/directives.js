remote_moderation_app.directive("keypress", ["$document", "$rootScope", function($document, $rootScope) {
	var evalExpression = function(scope, attrs, keyCode) {
		// console.log("Keycode: ", keyCode);
		var keyOptions = attrs.split(";");
		var expression;

		if ( keyOptions.length !== 1) {
			var attrsArray = keyOptions.pop().split(":");
			var attrsFunc = attrsArray[1].replace("()", "");

			expression = attrsFunc + "(" + attrsArray[0] + ")";

			if ( keyCode == attrsArray[0] ) {
				scope.$eval(expression);
			}
			evalExpression(scope, keyOptions.join(";"), keyCode);
		} else {
			var attrsArray = keyOptions[0].split(":");
			var attrsFunc = attrsArray[1].replace("()", "");

			expression = attrsFunc + "(" + attrsArray[0] + ")";

			if ( keyCode == attrsArray[0] ) {
				scope.$eval(expression);
			}
		}
	};

	return {
		restriction: "A",
		link: function(scope, element, attrs) {
			$document.bind("keypress", function(event) {
				// console.log("There was a key press", event);
				// console.log("Scope: ", scope);
				// console.log("Attrs: ", attrs.keypress);
				
				evalExpression(scope, attrs.keypress, event.keyCode);
				// scope.$eval(expression);
			});
		}
	};
}]);
