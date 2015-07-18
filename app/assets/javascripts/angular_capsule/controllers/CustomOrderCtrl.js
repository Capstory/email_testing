angular_capsule_app.controller("CustomOrderCtrl", ["$scope", "$rootScope", "$timeout", "$interval", "$location", "$cookies", "CapsuleData", "PostModel", "CapsuleModel", function($scope, $rootScope, $timeout, $interval, $location, $cookies, CapsuleData, PostModel, CapsuleModel) {
	var buildViewPost = function(post) {
		post.image = PostModel.cleanMissingImageUrl(post.image);
		post.view_image = PostModel.buildSecureImageUrl(post, "capsule_width");
		post.isImage = PostModel.checkPostIsImage(post);
		post.thumb = PostModel.buildSecureImageUrl(post, "thumb");
		post.capsule_height = PostModel.buildSecureImageUrl(post, "capsule_height");
		post.style = {"opacity": 0.7};

		if ( !angular.isDefined(post.visible) ) {
			post.visible = true;
		}
	};

	var buildViewPosts = function(posts) {
		angular.forEach(posts, function(post) {
			buildViewPost(post);
		});

		return posts;
	};

	var getSelectedPosts = function(posts) {
		var results = [];

		angular.forEach(posts, function(post) {
			if ( !!post.selected ) { results.push(post); }
		});

		return results;
	};

	$scope.thereAreSelections = false;

	var toggleSelectionsFromCookie = function(posts, idsFromCookie) {
		angular.forEach(posts, function(post) {
			if ( idsFromCookie.indexOf(post.id) != -1 ) {
				if ( !post.selected ) { toggleSelection(post); }
			}
		});	
	};

	var setAllPostsToInvisible = function(posts, acc) {
		angular.forEach(posts, function(post) {
			post.visible = false;
		});

		return posts;
	};

	$scope.init = function() {
		$scope.capsuleTemplateUrl = CapsuleData.getTemplateUrl();
		$scope.capsuleName = CapsuleData.getCapsuleNamedUrl();

		var postsData = buildViewPosts(CapsuleData.getPosts()); 
		$scope.posts = setAllPostsToInvisible(postsData, new Array);

		if ( !!$cookies[$scope.capsuleName + "_photoSelections"] ) {
			toggleSelectionsFromCookie($scope.posts, angular.fromJson($cookies[$scope.capsuleName + "_photoSelections"]));
		}

		$timeout(function() {
			$scope.iso = new Isotope("#isotopeContainer", {
				itemSelector: ".isotopeItem",
				layout: "masonry"
			});
		}, 500);

		$scope.isoInterval = $interval(function() {
			$scope.iso = new Isotope("#isotopeContainer", {
				itemSelector: ".isotopeItem",
				layout: "masonry"
			});
		}, 500);

		$scope.$emit("postSelected");
	};

	var toggleSelection = function(selection) {
		selection.selected = !selection.selected;
		selection.style = {"opacity": selection.selected ? 1 : 0.7 };
		$scope.$emit("postSelected");
	};

	$scope.toggleSelection = function(selection) {
		return toggleSelection(selection);
	};

	$scope.selectedCount = 0;
	$scope.selectionLimit = 20;
	$scope.tooManySelections = false;
	$scope.enoughSelections = false;

	$scope.$watch("selectedCount", function() {
		if ( $scope.selectedCount > $scope.selectionLimit ) {
			$scope.tooManySelections = true;
		} else {
			$scope.tooManySelections = false;
		} 

		if ( $scope.selectedCount == $scope.selectionLimit ) {
			$scope.enoughSelections = true;
		} else {
			$scope.enoughSelections = false;
		}
	});

	$scope.$on("postSelected", function() {
		// var count = 0;

		// angular.forEach($scope.posts, function(post) {
		// 	if ( !!post.selected ) { count += 1; }
		// });
		
		$scope.selectedCount = getSelectedPosts($scope.posts).length;

		if ( $scope.selectedCount > 0 ) {
			$scope.thereAreSelections = true;
		} else {
			$scope.thereAreSelections = false;		
		}

	});

	$scope.toNextCoverPhoto = function() {
		var selections = getSelectedPosts($scope.posts);		
		// console.log("Selected Posts: ", selections.length);
		$rootScope[$scope.capsuleName + "_selections"] = [];

		angular.forEach(selections, function(post) {
			$rootScope[$scope.capsuleName + "_selections"].push(angular.copy(post, {}));
		});

		$cookies[$scope.capsuleName + "_photoSelections"] = angular.toJson(PostModel.getPostIds($rootScope[$scope.capsuleName + "_selections"]));
		
		// console.log("Root Selections: ", $rootScope[$scope.capsuleName + "_selections"]);
		// console.log("Cookie Selections: ", $cookies[$scope.capsuleName + "_photoSelections"]);

		$location.path("/coverphoto");
	};

	var loadPhotos = function(n, c, posts) {
		if ( n == 0 ) { return; }
		if ( CapsuleModel.allPostsVisible(posts) ) { return; }

		if ( !posts[c].visible ) {
			posts[c].visible = true;
			if ( !posts[c].tag_for_deletion && posts[c].verified ) { n -= 1; } 
		}

		return loadPhotos(n, (c - 1), posts);
	}

	$scope.loadPhotos = function() {
		loadPhotos(9, ($scope.posts.length - 1), $scope.posts);

		$timeout(function() {
			$scope.iso = new Isotope("#isotopeContainer", {
				itemSelector: ".isotopeItem",
				layout: "masonry"
			});
		}, 500);
	};

	$scope.$on("$destroy", function() {
		$interval.cancel($scope.isoInterval);
	});
}]);
