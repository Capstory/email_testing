angular_capsule_app.controller("SlideshowCtrl", ["$scope", "$timeout", "$interval", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($scope, $timeout, $interval, CapsuleData, CapsuleModel, PostModel, VideoModel) {
	$scope.timeInterval = 5000;

	var getNextPost = function(posts, currentId, videos) {
		var nextId = PostModel.findNextPostId(posts, currentId);
		var nextPost = PostModel.getCurrentPost(posts, nextId);
		
		if ( PostModel.checkPostHasVideo(nextPost, videos) ) {
			return getNextPost(posts, nextId, videos);
		}

		return nextPost;
	};

	var rotateImages = function(posts, post, videos) {
		var newPost = getNextPost(posts, post.id, videos);
		$scope.post = newPost;
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");
		$scope.filmStrip = buildFilmStrip(posts, $scope.post, videos, 6, []);
	};

	var setImageRotation = function(posts, post, videos, timeInterval) {
		$timeout(function() {
			rotateImages(posts, post, videos);
			setImageRotation($scope.posts, $scope.post, $scope.videos, $scope.timeInterval);
		}, timeInterval);
	};

	var buildFilmStrip = function(posts, currentPost, videos, n, acc) {

		var nextPost = getNextPost(posts, currentPost.id, videos);
		nextPost.thumb = PostModel.buildImageUrl(nextPost, "thumb");
		acc.push(nextPost);

		if (acc.length == n) {
			return acc;
		}
		return buildFilmStrip(posts, nextPost, videos, n, acc);
	};

	$scope.init = function() {
		$scope.capsule = CapsuleModel.setAndGetCapsuleData(CapsuleData.getCapsuleData());
		$scope.posts = PostModel.setAndGetPostsData(CapsuleData.getPosts());
		$scope.videos = VideoModel.setAndGetVideoData(CapsuleData.getVideos());
		$scope.post = PostModel.getCurrentPost($scope.posts, $scope.posts[0].id);
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");

		$scope.filmStrip = buildFilmStrip($scope.posts, $scope.post, $scope.videos, 6, []);

		setImageRotation($scope.posts, $scope.post, $scope.videos, $scope.timeInterval);
	};

	var poller;
	var startPoller = function() {
		if ( angular.isDefined(poller) ) { return; }

		poller = $interval(function() {
			PostModel.getNewPosts($scope.capsule.id, $scope.posts).then(function(data) {
				PostModel.updatePostData($scope.posts, data);
				// console.log("Poller response: ", data);
			}, function(status) {
				console.log("There was an error", status);
			});
		}, 5000);
	}
	
	var stopPoller = function() {
		if ( angular.isDefined(poller) ) {
			$interval.cancel(poller);
			poller = undefined;
		}
	};

	$scope.$on("$destroy", function() {
		stopPoller();
	});

	startPoller();
}]);
