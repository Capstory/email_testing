conference_capsule_app.controller("CapsuleController", ["$scope", "$timeout", "$interval", "CapsuleData", "CapsuleModel", function($scope, $timeout, $interval, CapsuleData, CapsuleModel) {
	var visible_index = 0;
	var refreshIsotope = function() {
		$scope.$emit("iso-method", {name: "arrange", params: null});
	};

	$scope.all_loaded = true;
	$scope.capsule_data = CapsuleData.get();

	if ( angular.fromJson($scope.capsule_data.time_group) ) {
		$scope.time_groups = angular.fromJson($scope.capsule_data.time_group);
		$scope.group = Object.keys($scope.time_groups)[1];
	} else {
		$scope.time_groups = { "": "All" };
		$scope.group = "";	
	}

	$scope.posts;
	$scope.segmented_posts;
	$scope.visible_posts = [];
	$scope.init = function() {
		CapsuleModel.getPostsAPI($scope.capsule_data.id).then(function(data) {
			// console.log(data);
			$scope.posts = data;
			$scope.segmented_posts = CapsuleModel.segmentPosts($scope.time_groups, $scope.posts);
			// console.log("Segmented Posts: ", $scope.segmented_posts);

			$scope.loadPhotos(6, "visible_posts");

			$scope.all_loaded = false;

			$timeout(function() {
				$scope.$emit("iso-method", {name: "arrange", params: null});
			}, 500);

			$scope.isotopeInterval = $interval(function() {
				refreshIsotope();
			}, 2000);

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

	$scope.loadPhotos = function(number, load_target) {
		var push_counter = 0;
		while ( push_counter < number) {
			if ( CapsuleModel.allVisible($scope.segmented_posts[$scope.group]) ) {
				return;
			} else {
				// var next_post = CapsuleModel.nextInvisible($scope.segmented_posts[$scope.group]);
				var post_index = 0;
				var searching = true;
				while ( searching ) {
					if ( !$scope.segmented_posts[$scope.group][post_index].visible ) {
						$scope.segmented_posts[$scope.group][post_index].visible = true;
						$scope[load_target].push($scope.segmented_posts[$scope.group][post_index]);
						push_counter += 1;
						searching = false;
					}
					post_index += 1
				}
			}
		}

		// console.log("All loaded? ", CapsuleModel.allVisible($scope.segmented_posts[$scope.group]));
		// console.log("Relevant Time Group Photos: ", $scope.segmented_posts[$scope.group]);
	};

	$scope.loadMorePosts = function() {
		if ( $scope.posts !== undefined ) {
			if ( CapsuleModel.allVisible($scope.segmented_posts[$scope.group]) ) {
				// console.log("All the photos in this time group are visible");
				return;
			} else {
				// console.log("Need to load more photos");
				return $scope.loadPhotos(6, "visible_posts");	
			}
		}
	};

	// $scope.loadMorePosts = function() {
	// 	if ( $scope.posts !== undefined && $scope.all_loaded === false ) {
	// 		console.log("Loading more posts...");
	// 		var i;
	// 		var start_index = visible_index + 1;
	// 		for(i = start_index; i < start_index + 10; i++) {
	// 			if ( visible_index === $scope.posts.length - 1) {
	// 				$scope.all_loaded = true;
	// 			} else {
	// 				if ( $scope.visible_posts.indexOf($scope.posts[i].id) === -1 ) {
	// 					$scope.visible_posts.push($scope.posts[i]);
	// 					visible_index += 1;
	// 				}
	// 			}
	// 		}
	// 	}
	// };

	$scope.$watch("group", function() {
		// console.log("Current group: ", $scope.group);
		$timeout(function() {
			$scope.$emit("iso-method", {name: "arrange", params: null });
		}, 500);
	});

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
		$interval.cancel($scope.isotopeInterval);
		$interval.cancel($scope.interval);
	});
}]);
