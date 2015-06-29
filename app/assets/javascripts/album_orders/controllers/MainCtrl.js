album_orders_app.controller("MainCtrl", ["$scope", "$location", "OrdersData", function($scope, $location, OrdersData) {

	var countByStatus = function(orders, status) {
		var i;
		var count = 0;

		for (i = 0; i < orders.length; i++) {
			if ( orders[i].status == status ) {
				count += 1;
			}
		}

		return count;
	};

	$scope.init = function() {
		$scope.orders = OrdersData.getOrders();
		
		$scope.newCount = countByStatus($scope.orders, "new");
		$scope.inProgressCount = countByStatus($scope.orders, "progress");
		$scope.finishedCount = countByStatus($scope.orders, "finished");

		$scope.searching = false;
		$scope.statusFilter = "all";
	};

	$scope.toOrdersList = function(status) {
		$location.path("/lists/" + status);	
	};
}]);
