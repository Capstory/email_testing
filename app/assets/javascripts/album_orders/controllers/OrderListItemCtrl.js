album_orders_app.controller("OrderListItemCtrl", ["$scope", "$location", function($scope, $location) {
	$scope.goToOrder = function(order_id) {
		$location.path("/orders/" + order_id);
	};
}]);
