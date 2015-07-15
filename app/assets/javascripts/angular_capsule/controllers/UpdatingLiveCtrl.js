angular_capsule_app.controller("UpdatingLiveCtrl", ["$scope", "$interval", function($scope, $interval) {
	var counter = 0;
	
	$scope.text = "Updating Live";

	$interval(function() {
		var result;
		switch(counter) {
			case 0:
				result = "Updating Live.";
				counter += 1;
				break;
			case 1:
				result = "Updating Live..";
				counter += 1;
				break;
			case 2:
				result = "Updating Live...";
				counter = 0;
				break;
		}		

		$scope.text = result;
	}, 500);
}]);
