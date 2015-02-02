angular_capsule_app.controller("SlideshowCtrl", ["$scope", "$timeout", "$interval", "RandomPhotoGenerator", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($scope, $timeout, $interval, RandomPhotoGenerator, CapsuleData, CapsuleModel, PostModel, VideoModel) {
	$scope.timeInterval = 5000;
	$scope.newPhotos = false;

	$scope.currentPostPosition = {
		position: "relative",
		left: "0px",
		top: "-300px"
	};

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
		$scope.smallFilmStrip = buildFilmStrip(posts, $scope.post, videos, 4, []);
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
		$scope.smallFilmStrip = buildFilmStrip($scope.posts, $scope.post, $scope.videos, 4, []);

		setImageRotation($scope.posts, $scope.post, $scope.videos, $scope.timeInterval);

		$scope.newPhotos = false;
		$scope.newPosts = [];
	};

	var createNewPostObject = function(n, objectId, acc) {

		if ( acc.length == n ) { return acc; }

		var object = {
			body: "No message",
			image: RandomPhotoGenerator.getImage(),
			thumb: RandomPhotoGenerator.getImage(),
			verified: true,
			isImage: true,
			tag_for_deletion: false,
			id: objectId + 1
			// id: $scope.posts[$scope.posts.length - 1].id + 1
		};
		acc.push(object);

		return createNewPostObject(n, objectId + 1, acc);
	};

	var poller;
	var startPoller = function() {
		if ( angular.isDefined(poller) ) { return; }

		poller = $interval(function() {
			PostModel.getNewPosts($scope.capsule.id, $scope.posts).then(function(data) {

				if ($scope.newPhotos) {
					var objects = createNewPostObject(3, $scope.posts[$scope.posts.length - 1].id, []);
					angular.forEach(objects, function(object) {
						data.new_posts.push(object);
					});
				}

				PostModel.updatePostData($scope.posts, data);

				PostModel.filterNewPosts($scope.posts, $scope.newPosts, data);


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

	$scope.currentNewPostVisible = false;

	$scope.toggleNewPhotos = function() {
		$scope.newPhotos = !$scope.newPhotos;
	};

	showCurrentNewPost = function() {
		$scope.currentNewPost = $scope.newPosts.shift();
	};

	var newPhotoInterval;

	var startNewPhotoInterval = function() {
		if ( angular.isDefined(newPhotoInterval) ) { return; }

		if ( !angular.isDefined($scope.currentNewPost) ) { showCurrentNewPost(); }

		newPhotoInterval = $interval(function() {
			showCurrentNewPost();
		}, 2000);
	};

	var stopNewPhotoInterval = function() {
		if ( angular.isDefined(newPhotoInterval) ) {
			$interval.cancel(newPhotoInterval);
			newPhotoInterval = undefined;
		}
	};

	$scope.$watchCollection("newPosts", function() {
		if ($scope.newPosts.length > 0) {
			console.log("Interval Started");
			$scope.currentNewPostVisible = true;
			startNewPhotoInterval();
		} else {
			console.log("Interval Stopped");
			stopNewPhotoInterval();
			$timeout(function() {
				$scope.currentNewPost = undefined;
				$scope.currentNewPostVisible = false;
			}, 2000);
		}
	});

	startPoller();
}]);
