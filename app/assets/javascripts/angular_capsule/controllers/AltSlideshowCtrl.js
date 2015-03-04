angular_capsule_app.controller("AltSlideshowCtrl", ["$scope", "$timeout", "$interval", "$location", "RandomPhotoGenerator", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($scope, $timeout, $interval, $location, RandomPhotoGenerator, CapsuleData, CapsuleModel, PostModel, VideoModel) {
	var changeTopBarDiv = function(endState) {
		var el = angular.element("#topBarDiv");

		switch(endState) {
			case "make_invisible":
				el.hide();
				break;
			case "make_visible":
				el.show();
				break;
		}
	};

	var computeNewPostTopPosition = function(element, offset) {
		var elementHeight = element[0].clientHeight;
		if (elementHeight > offset) {
			elementHeight -= offset;
		}

		return "-" + elementHeight.toString() + "px";
	};

	var setNewPostPosition = function() {
		var element = angular.element("#currentNewPostDiv");

		return {
			position: "relative",
			left: "0px",
			"z-index": 1000,
			top: computeNewPostTopPosition(element, 100)
		};	
	};

	var getNextPost = function(posts, currentId, videos) {
		var nextId = PostModel.findNextPostId(posts, currentId);
		var nextPost = PostModel.getCurrentPost(posts, nextId);

		if ( PostModel.checkPostHasVideo(nextPost, videos) ) {
			return getNextPost(posts, nextId, videos);
		}

		return nextPost;
	};

	var getPreviousPost = function(posts, currentId, videos) {
		var previousId = PostModel.findPreviousPostId(posts, currentId);
		var previousPost = PostModel.getCurrentPost(posts, previousId);
	
		if (PostModel.checkPostHasVideo(previousPost, videos)) {
			return getPreviousPost(posts, previousId, videos);
		}

		return previousPost;
	};

	var rotateImages = function(posts, post, videos, filmStrip) {
		$scope.post = filmStrip.shift();
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");
		$scope.filmStrip = buildFilmStrip(posts, $scope.post, videos, 5, []);
		$scope.smallFilmStrip = buildFilmStrip(posts, $scope.post, videos, 4, []);
	};

	var imageRotator = undefined;

	var setImageRotation = function(timeInterval) {
		imageRotator = $timeout(function() {
			rotateImages($scope.posts, $scope.post, $scope.videos, $scope.filmStrip);
			setImageRotation($scope.timeInterval);
		}, timeInterval);
	};

	var stopImageRotation = function() {
		$timeout.cancel(imageRotator);
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

	$scope.timeInterval = 5000;
	$scope.newPhotos = false;
	$scope.currentNewPostPosition = setNewPostPosition();


	$scope.init = function() {
		changeTopBarDiv("make_invisible");

		$scope.capsule = CapsuleModel.setAndGetCapsuleData(CapsuleData.getCapsuleData());
		$scope.posts = PostModel.setAndGetPostsData(CapsuleData.getPosts());
		$scope.videos = VideoModel.setAndGetVideoData(CapsuleData.getVideos());
		$scope.post = PostModel.getCurrentPost($scope.posts, $scope.posts[0].id);
		$scope.post.thumb = PostModel.buildImageUrl($scope.post, "thumb");
		$scope.post.large_image = PostModel.buildImageUrl($scope.post, "lightbox_width");

		$scope.filmStrip = buildFilmStrip($scope.posts, $scope.post, $scope.videos, 5, []);
		$scope.smallFilmStrip = buildFilmStrip($scope.posts, $scope.post, $scope.videos, 4, []);

		setImageRotation($scope.timeInterval);

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
					var maxId = Math.max.apply(null, PostModel.getPostIds($scope.posts));
					var objects = createNewPostObject(1, maxId, []);
					angular.forEach(objects, function(object) {
						data.new_posts.push(object);
					});
				}

				PostModel.updatePostData($scope.posts, data, { genre: "inject", currentPostId: $scope.post.id });
				$scope.filmStrip = buildFilmStrip($scope.posts, $scope.post, $scope.videos, 5, []);
				
				// PostModel.updatePostData($scope.posts, data);

				// PostModel.filterNewPosts($scope.posts, $scope.newPosts, data);

			}, function(status) {
				console.log("There was an error", status);
			});
		}, 3000);
	}

	var stopPoller = function() {
		if ( angular.isDefined(poller) ) {
			$interval.cancel(poller);
			poller = undefined;
		}
	};

	$scope.$on("$destroy", function() {
		changeTopBarDiv("make_visible");
		stopPoller();
		stopImageRotation();
	});

	$scope.currentNewPostVisible = false;

	$scope.toggleNewPhotos = function() {
		$scope.newPhotos = !$scope.newPhotos;
	};

	var showCurrentNewPost = function() {
		$scope.currentNewPost = $scope.newPosts.shift();
		$timeout(function() {
			$scope.currentNewPostPosition = setNewPostPosition();			
		}, 100);
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
			$scope.currentNewPostVisible = true;
			startNewPhotoInterval();
		} else {
			stopNewPhotoInterval();
			$timeout(function() {
				$scope.currentNewPost = undefined;
				$scope.currentNewPostVisible = false;
			}, 2000);
		}
	});

	startPoller();

	$scope.backToCapsule = function() {
		$location.path("/");
	};
}]);
