album_orders_app.controller("NewOrdersCtrl", ["$scope", "$location", "$window", "$routeParams", "OrdersData", function($scope, $location, $window, $routeParams, OrdersData) {
	$scope.orders = OrdersData.getOrders();
	$scope.status = $routeParams.status;
}]);
