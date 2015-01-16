angular_capsule_app.controller("PostCtrl", ["$scope", "$routeParams", "$location", "$window", "$timeout", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($scope, $routeParams, $location, $window, $timeout, CapsuleData, CapsuleModel, PostModel, VideoModel) {
	var setArrowDivHeight = function() {
		return angular.element("#mainElement")[0].clientHeight;
	};

	var setLineHeight = function() {
		var height = setArrowDivHeight();
		return height;
	};

	var capsulePermissions = {
		tagPermission: false
	};


	$scope.arrowShow = false;

	$scope.postId = $routeParams.postId;
	$scope.init = function(postId) {
		angular.element(".capsuleOffCanvasMenuItems").hide();
		$scope.capsule = CapsuleModel.setAndGetCapsuleData(CapsuleData.getCapsuleData());
		$scope.posts = PostModel.setAndGetPostsData(CapsuleData.getPosts());
		// $scope.visiblePosts = CapsuleData.getVisiblePosts();
		// $scope.visiblePosts = PostModel.getVisiblePosts(CapsuleData.getPosts());
		$scope.videos = VideoModel.setAndGetVideoData(CapsuleData.getVideos());

		$scope.post = PostModel.getCurrentPost($scope.posts, $routeParams.postId);
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");
		$scope.post.hasVideo = PostModel.checkPostHasVideo($scope.post, $scope.videos);
		$scope.post.video_url = PostModel.getVideoUrl($scope.post, $scope.videos);

		capsulePermissions = CapsuleModel.setAndGetCapsulePermissions(CapsuleData.getAuthDetails());

		$timeout(function() {
			$scope.arrowDivHeight = { 'height': setArrowDivHeight() + "px" };
			$scope.lineHeight = { 'line-height': setLineHeight() + "px" };
			$scope.arrowShow = true;
		}, 200);
	};

	$scope.backToCapsule = function() {
		$location.path("/");
	};

	$scope.goNext = function(posts, postId) {
		var nextPostId = PostModel.findNextPostId(posts, postId);
		$location.path("/photo/" + nextPostId);
	};

	$scope.goPrevious = function(posts, postId) {
		var previousPostId = PostModel.findPreviousPostId(posts, postId);
		$location.path("/photo/" + previousPostId)
	};

	$scope.$on("$destroy", function() {
		angular.element("#video").attr("src", "");	
	});

	$scope.keypressNext = function(posts, postId) {
		$scope.$apply(function() {
			$scope.goNext(posts, postId);
		});
	};

	$scope.showDelete = function() {
		if ( capsulePermissions.tagPermission ) { return true; }

		return false;
	};

	$scope.keypressPrevious = function(posts, postId) {
		$scope.$apply(function() {
			$scope.goPrevious(posts, postId);
		});
	};

	$scope.deletePost = function(postId) {
		PostModel.deletePost(postId).then(function(data, status) {
			// console.log("Data: ", data);
			$location.path("/");
		}, function(data, status) {
			console.log("Status: ", status);	
		});	
	};

	$timeout(function() {
		angular.element("#navAdvice").fadeOut("slow");
	}, 1000);
}]);
