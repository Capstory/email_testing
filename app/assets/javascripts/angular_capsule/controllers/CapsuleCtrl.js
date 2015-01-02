angular_capsule_app.controller("CapsuleCtlr", ["$window", "$scope", "$rootScope", "$location", "$timeout", "$interval", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($window, $scope, $rootScope, $location, $timeout, $interval, CapsuleData, CapsuleModel, PostModel, VideoModel) {
	$scope.initIso = function() {
		$scope.iso = new Isotope("#isotopeContainer", {
			itemSelector: ".isotopeItem",
			layout: "masonry"
		});
	};

	var refreshIsotope = function() {
		$scope.initIso();
	};

	$scope.$watchCollection("posts", function() {
		$timeout(function() {
			refreshIsotope();
		}, 300);
	});

	var buildCapsuleImageUrl = function(post) {
		var imageUrl = post.image;

		return imageUrl.replace("original", "capsule_width");
	};

	var buildCapsuleImages = function(posts) {
		angular.forEach(posts, function(post) {
			post.image = PostModel.cleanMissingImageUrl(post.image);
			post.capsule_image = buildCapsuleImageUrl(post);
			post.isImage = PostModel.checkPostIsImage(post);
		});
		return posts;
	};

	var toggleData = function(dataToShow) {
		var element = "show" + dataToShow + "Data";
		$scope[element] = !$scope[element];
	};

	$scope.showCapsuleData = false;
	$scope.showPostsData = false;
	$scope.showVideoData = false;

	$scope.capsule = CapsuleModel.setAndGetCapsuleData(CapsuleData.getCapsuleData());

	$scope.posts = buildCapsuleImages(CapsuleData.getPosts());

	$scope.videos = VideoModel.setAndGetVideoData(CapsuleData.getVideos());
	$scope.slideshowImage = CapsuleData.getSlideshowImagePath();
	$scope.uploadImage = CapsuleData.getUploadImagePath();

	$scope.toggleData = function(dataToShow) {
		toggleData(dataToShow);
	};

	$scope.goToPost = function(postId) {
		$location.path("/photo/" + postId);	
	};

	$scope.addObject = function(verified) {
		var object = {
			body: "No message",
			image: "http://placehold.it/350x350",
			capsule_image: "http://placehold.it/350x350",
			verified: verified,
			isImage: true,
			tag_for_deletion: false,
			id: $scope.posts[$scope.posts.length - 1].id + 1
		};
		$scope.posts.push(object);
	};

	$scope.refreshArrange = function() {
		refreshIsotope();
	};

	var poller;
	var startPoller	= function() {
		if ( angular.isDefined(poller) ) { return; }

		poller = $interval(function() {
			PostModel.getNewPosts($scope.capsule.id, $scope.posts).then(function(data) {
				PostModel.updatePostData($scope.posts, data);
				buildCapsuleImages($scope.posts);

				$timeout(function() {
					refreshIsotope();
				}, 500);
			}
			, function(status) {
				console.log("There has been an error", status);
			});
		},5000);

	};

	PostModel.getNewPosts($scope.capsule.id, $scope.posts).then(function(data) {
		PostModel.updatePostData($scope.posts, data);
		buildCapsuleImages($scope.posts);

		$timeout(function() {
			refreshIsotope();
		}, 500);
	}
	, function(status) {
		console.log("There has been an error", status);
	});

	var stopPoller = function() {
		if ( angular.isDefined(poller) ) {
			$interval.cancel(poller);
			poller = undefined;
		}
	};

	$scope.stopPoller = function() {
		stopPoller();
	};

	$scope.startPoller = function() {
		startPoller();
	};
	
	$scope.$on("$destroy", function() {
		stopPoller();
	});

	startPoller();

	$scope.pollerActive = function() {
		if ( angular.isDefined(poller) ) { return true; }

		return false;
	};

	$scope.activateFilepicker = function() {
		angular.element(".pick_file").click();
	};

	$window.onImageUpload = function() {
		angular.element("#filepicker_submit_button").click();
	};
}]);
