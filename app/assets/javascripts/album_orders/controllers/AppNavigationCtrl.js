album_orders_app.controller("AppNavigationCtrl", ["$scope", "$location", "$window", function($scope, $location, $window) {
	$scope.toHome = function() {
		$location.path("/");
	};	

	$scope.toBack = function() {
		$window.history.back();
	};
}]);
