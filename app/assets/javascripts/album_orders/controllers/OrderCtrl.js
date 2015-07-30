album_orders_app.controller("OrderCtrl", ["$scope", "$location", "$routeParams", "$window", "$http", "$q", "OrdersData", function($scope, $location, $routeParams, $window, $http, $q, OrdersData) {
	var buildOrderStatus = function(orderStatus) {
		var result;

		switch(orderStatus) {
			case "new":
				result = "New";
				break;
			case "progress":
				result = "In Progress";
				break;
			case "finished":
				result = "Finished";
				break;
			default:
				result = "No Status";
		}

		return result;
	};

	var sendImageUrlRequest = function(id, format) {
		var deferred = $q.defer();

		$http({
			method: "GET",
			url: "/get_post_url.json?id=" + id +"&img_format=" + format
		})
		.success(function(data, status, headers) {
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	var buildSelectionUrls = function(order) {
		var i;
		order.selections = [];

		if (order.contents == undefined) { return; }

		for (i = 0; i < order.contents.selections.length; i++) {
			sendImageUrlRequest(order.contents.selections[i], "capsule_width").then(function(data) {
				order.selections.push(data);	
			}, function(status) {
				console.log("Error: ", status);
			});
		}
	};

	var sendSelectionIndexesRequest = function(capsuleName, selectionString) {
		var deferred = $q.defer();

		$http({
			method: "GET",
			url: "/get_post_indexes.json?capsule_id=" + capsuleName +"&post_ids=" + selectionString
		})
		.success(function(data, status, headers) {
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	var buildSelectionIndexes = function(capsuleName, selections) {
		var selectionString = selections.join(",");

		sendSelectionIndexesRequest(capsuleName, selectionString).then(function(data) {
			$scope.selectionIndex = data;
			console.log("Selection index: ", data);
		}, function(status) {
			console.log("There was an error: ", status);
		});
	};

	var buildCoverPhotoUrl = function(order) {
		order.coverPhoto;

		if (order.contents == undefined) { return; }

		sendImageUrlRequest(order.contents.cover_photo, "lightbox_width").then(function(data) {
			order.coverPhoto = data;
		}, function(status) {
			console.log("Error: ", status);
			order.coverPhoto = undefined;
		});
	};

	function snakeToCamel(s){
		    return s.replace(/(\_\w)/g, function(m){return m[1].toUpperCase();});
	}

	var setUploadAttributes = function(order, format, bool) {
		var camelCasedFormat = snakeToCamel(format);
		order[camelCasedFormat + "Present"] = bool;
		order[camelCasedFormat + "FileName"] = order[format + "_file_name"];
	};

	// var buildUploadAttributes = function(order) {
	// 	if ( angular.isDefined(order.cover_photo_file_name) ) {
	// 		setUploadAttributes(order, "cover_photo", true);
	// 	} else {
	// 		setUploadAttributes(order, "cover_photo", false);
	// 	}

	// 	if ( angular.isDefined(order.inner_file_file_name) ) {
	// 		setUploadAttributes(order, "inner_file", true);
	// 	} else {
	// 		setUploadAttributes(order, "inner_file", false);
	// 	}
	// };

	var buildOrder = function(order) {
		// console.log(order);
		order.printableStatus = buildOrderStatus(order.status);

		order.coverPhotoPresent = order.cover_photo_file_name ? true : false;
		order.innerFilePresent = order.inner_file_file_name ? true : false;
		order.softCoverPresent = order.soft_cover_file_name ? true : false;
		order.softInnerPresent = order.soft_inner_file_name ? true : false;

		// buildUploadAttributes(order);
		buildSelectionUrls(order);
		buildCoverPhotoUrl(order);
		buildSelectionIndexes(order.contents.capsule_name, order.contents.selections);

		return order;
	};

	$scope.init = function() {
		$scope.coverPhotoInputPopulated = false;
		$scope.innerFileInputPopulated = false;
		$scope.softCoverInputPopulated = false;
		$scope.softInnerInputPopulated = false;

		$scope.order = OrdersData.getOrder($routeParams.order_id);

		$scope.order = buildOrder($scope.order);

		if ( $scope.order.status == "new" ) {
			// console.log("Make modal appear");
			angular.element("#myModal").foundation("reveal", "open");
		}
	};

	$scope.hideModal = function() {
		angular.element("#myModal").foundation("reveal", "close");
	};

	var sendUpdateStateRequest = function(orderId, status) {
		var deferred = $q.defer();

		var requestUrl = "/orders/update_status.json?id=" + orderId + "&status=" + status;

		$http({
			method: "PUT",
			url: requestUrl
		})
		.success(function(data, status, headers) {
			deferred.resolve(status);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	$scope.updateStatus = function(orderId, orderStatus) {
		sendUpdateStateRequest(orderId, orderStatus).then(function(status) {
			$scope.order.status = orderStatus;
			$scope.order.printableStatus = buildOrderStatus($scope.order.status)
		}, function(status) {
			console.log("Unable to update status");
		});

		$scope.hideModal();
	}

	var sendUploadFileRequest = function(orderId, format, file, fileName, fileType) {
		// console.log("Filename: ", fileName);
		var deferred = $q.defer();

		var request_url = "/orders/upload.json?order_id=" + orderId +"&file_format=" + format + "&file_name=" + fileName + "&file_type=" + fileType
		$http({
			method: "POST",
			url: request_url,
			headers: {
				"Content-Type": "application/pdf"
			},
			data: new Uint8Array(file),
			transformRequest: []
		})
		.success(function(data, status, headers) {
			deferred.resolve(data, status);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	$scope.updateInputState = function(el) {
		// console.log("Input changed");
		// console.log(el.files[0]);

		switch(el.id) {
			case "coverPhotoInput":
				$scope.$apply(function() {
					$scope.coverPhotoInputPopulated = true;
				});
				break;
			case "innerFileInput":
				$scope.$apply(function() {
					$scope.innerFileInputPopulated = true;
				})
				break;
			case "softCoverInput":
				$scope.$apply(function() {
					$scope.softCoverInputPopulated = true;
				});
				break;
			case "softInnerInput":
				$scope.$apply(function() {
					$scope.softInnerInputPopulated = true;
				});
				break;
			default:
				break;
		}

		return;
	};

	$scope.uploadFile = function(orderId, format) {
		var inputId;

		switch(format) {
			case "cover":
				  inputId = "coverPhotoInput";
				  break;
			case "inner":
				  inputId = "innerFileInput";
				  break;
			case "soft_cover":
				  inputId = "softCoverInput";
				  break;
			case "soft_inner":
				  inputId = "softInnerInput";
				  break;
			default:
				  return;
		};

		var file = document.getElementById(inputId).files[0];

		var reader = new FileReader();
		
		reader.onload = function(event) {
			var result = event.target.result;

			sendUploadFileRequest(orderId, format, result, file.name, file.type).then(function(data, status) {
				OrdersData.updateOrder(data);
				$scope.order = buildOrder(data);	
			}, function(status) {
				console.log("Error: ", status);
			});
		};

		reader.readAsArrayBuffer(file);
	};

	var sendDeleteFileRequest = function(orderId, format) {
		var deferred = $q.defer();

		$http({
			method: "PUT",
			url: "/orders/delete_file.json",
			headers: {
				"Content-Type": "application/json"
			},
			data: {
				order_id: orderId,
				file_format: format		
			}
		})
		.success(function(data, status, headers) {
			deferred.resolve(data, status);
		})
		.error(function(data, status, headers) {
			deferred.reject(data, status);
		});

		return deferred.promise;
	};

	$scope.deleteFile = function(orderId, format) {
		sendDeleteFileRequest(orderId, format).then(function(data, status) {
			OrdersData.updateOrder(data);
			$scope.order = buildOrder(data);
		}, function(data, status) {
			console.log("Error on file delete: ", data, " status code: ", status);
		});
	};
}]);
