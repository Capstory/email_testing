conference_capsule_app.controller("CapsuleController", ["$scope", "$timeout", "$interval", "CapsuleData", "CapsuleModel", function($scope, $timeout, $interval, CapsuleData, CapsuleModel) {
	$scope.capsule_data = CapsuleData.get();
	$scope.group = "0800";
	$scope.posts;
	$scope.init = function() {
		CapsuleModel.getPostsAPI($scope.capsule_data.id).then(function(data) {
			// console.log(data);
			$scope.posts = data;
			$timeout(function() {
				$scope.$emit("iso-method", {name: "arrange", params:null});
			}, 500);
			$scope.interval = $interval(function() {
				if ( $scope.posts.length === 0 ) {
					after_id = 0;
				} else {
					after_id = $scope.posts[$scope.posts.length - 1].id;
				}
				CapsuleModel.getNewPostsAPI($scope.capsule_data.id, after_id).then(function(data) {
					console.log("New posts: ", data);
					var new_posts = data;
					angular.forEach(new_posts, function(post) {
						$scope.posts.push(post);
					});
				});
			}, 15000);
		});
	};

	$scope.refreshIsotope = function() {
		$timeout(function() {
			$scope.$emit("iso-method", {name: "arrange", params: null });
		}, 500);
	};

	$scope.capsuleImage = function(post) {
		var imageUrl = post.image;
		var body = post.body;
		if ( body === "No message" || body === null || body === "no message" ) {
			var newUrl = imageUrl.replace("original", "capsule_width");

			return newUrl;
		} else {
			return imageUrl;
		}
	};

	$scope.isPhoto = function(post) {
		var body = post.body;
		if ( body === "No message" || body === null || body === "no message") {
			return true;
		} else {
			return false;
		}
	};

	$scope.$on("$destroy", function() {
		$interval.cancel($scope.interval);
	});
}]);
