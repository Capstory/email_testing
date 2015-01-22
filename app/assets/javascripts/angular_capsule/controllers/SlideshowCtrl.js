angular_capsule_app.controller("SlideshowCtrl", ["$scope", "$timeout", "$interval", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($scope, $timeout, $interval, CapsuleData, CapsuleModel, PostModel, VideoModel) {
	$scope.timeInterval = 5000;

	var rotateImages = function(posts, currentId) {
		var nextPostId = PostModel.findNextPostId(posts, currentId);
		var newPost = PostModel.getCurrentPost(posts, nextPostId);
		if ( PostModel.checkPostHasVideo(newPost, $scope.videos) ) {
			// console.log("Skipped image", newPost);
			return rotateImages(posts, newPost.id);
		}
		$scope.post = newPost;
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");
	};

	var setImageRotation = function(timeInterval) {
		$timeout(function() {
			rotateImages($scope.posts, $scope.post.id);
			setImageRotation($scope.timeInterval);
		}, timeInterval);
	};

	$scope.init = function() {
		$scope.capsule = CapsuleModel.setAndGetCapsuleData(CapsuleData.getCapsuleData());
		$scope.posts = PostModel.setAndGetPostsData(CapsuleData.getPosts());
		$scope.videos = VideoModel.setAndGetVideoData(CapsuleData.getVideos());
		$scope.post = PostModel.getCurrentPost($scope.posts, $scope.posts[0].id);
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");
	};

	// $interval(function() {
	// 	rotateImages($scope.posts, $scope.post.id);
	// }, 5000);
	
	setImageRotation($scope.timeInterval);
}]);
