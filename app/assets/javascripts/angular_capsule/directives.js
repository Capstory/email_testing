angular_capsule_app.directive("keypress", ["$document", function($document) {
	var evalExpression = function(scope, attrs, keyCode) {
		var keyOptions = attrs.split(";");
		
		var createExpression = function(options, code) {
			var attrsArray = options.pop().split(":");
			var attrsFunc = attrsArray[1];

			if ( code == attrsArray[0] ) {
				scope.$eval(attrsFunc);
			}

			return options.join(";");
		};

		if (keyOptions.length !== 1) {
			keyOptions = createExpression(keyOptions, keyCode);
			evalExpression(scope, keyOptions, keyCode);
		} else {
			createExpression(keyOptions, keyCode);
		}
	};

	return {
		restrict: "A",
		link: function(scope, element, attrs) {
			// $document.bind("keypress", function(event) {
			// 	console.log("Key press code: ", event.keyCode);
			// });

			$document.bind("keydown", function(event) {
				// console.log("Key down code: ", event.keyCode);
				evalExpression(scope, attrs.keypress, event.keyCode);
			});

			element.on("$destroy", function() {
				// $document.unbind("keypress");
				$document.unbind("keydown");
			});
		}
	}
}]);

angular_capsule_app.directive("onassetload", [function() {
	return {
		restrict: "A",
		link: function(scope, elem, attrs) {
			elem.bind("load", function() {
				// console.log("Image Loaded");
				scope.mainElementLoading = false;
			});

			elem.on("$destroy", function() {
				elem.unbind("load");
			});
		}
	};
}]);
