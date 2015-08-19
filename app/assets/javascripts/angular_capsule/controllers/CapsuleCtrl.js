angular_capsule_app.controller("CapsuleCtlr", ["$document", "$window", "$scope", "$rootScope", "$location", "$timeout", "$interval", "CapsuleData", "CapsuleModel", "PostModel", "VideoModel", function($document, $window, $scope, $rootScope, $location, $timeout, $interval, CapsuleData, CapsuleModel, PostModel, VideoModel) {

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
			post.capsule_image = PostModel.buildSecureImageUrl(post, "capsule_width");
			post.isImage = PostModel.checkPostIsImage(post);
			if ( !angular.isDefined(post.visible) ) {
				post.visible = true;
			}
		});
		return posts;
	};

	var setAllPostsToInvisible = function(posts) {
		angular.forEach(posts, function(post) {
			post.visible = false;
		});
		return posts;
	};

	var toggleData = function(dataToShow) {
		var element = "show" + dataToShow + "Data";
		$scope[element] = !$scope[element];
	};

	$scope.spinnerVisible = true;

	var hideSpinner = function() {
		if ( $scope.spinnerVisible ) {
			$scope.spinnerVisible = false;
			// console.log("Hiding the spinner");
		}
	};

	var loadPhotos = function(n, posts) {
		var searching = true;
		var i;
		var counter = 0;
		
		if ( posts.length < 1 ) { return "hideSpinner()"; }

		for (i = posts.length - 1; counter < n; i--) {
			if ( CapsuleModel.allPostsVisible(posts) ) { return "hideSpinner()"; }

			if ( !posts[i].visible ) {
				posts[i].visible = true;
				if (!posts[i].tag_for_deletion && posts[i].verified) { counter += 1; }
			}
		}

		return true;
	};

	$scope.showCapsuleData = false;
	$scope.showPostsData = false;
	$scope.showVideoData = false;

	$scope.capsule = CapsuleModel.setAndGetCapsuleData(CapsuleData.getCapsuleData());

	$scope.posts = setAllPostsToInvisible(buildCapsuleImages(CapsuleData.getPosts()));
	// console.log("Posts: ", $scope.posts);

	$scope.videos = VideoModel.setAndGetVideoData(CapsuleData.getVideos());
	$scope.slideshowImage = CapsuleData.getSlideshowImagePath();
	$scope.uploadImage = CapsuleData.getUploadImagePath();

	$scope.loadPhotos = function() {
		// console.log("Photos loading...");
		var result = loadPhotos(9, $scope.posts);
		$timeout(function() {
			refreshIsotope();
			eval(result);
		}, 300);
	};

	$scope.OKSaveScrollPos = false;

	$scope.init = function() {
		angular.element(".capsuleOffCanvasMenuItems").show();
		if ( angular.element("#flashAlert") ) {
			$timeout(function() {
				angular.element("#flashAlert").fadeOut("slow");
			}, 3000);
		}

		if (angular.isUndefined($rootScope.scrollPos)) {
			$rootScope.scrollPos = {};
			$scope.scrollPos = 0;
			$scope.OKSaveScrollPos = true;
		} else {
			console.log("Scroll is set: ", $rootScope.scrollPos);
			$scope.scrollPos = $rootScope.scrollPos[$location.absUrl()];

			// $(window).scrollTop($scope.scrollPos);
			$scope.goToScroll($scope.scrollPos);
		}

		console.log("Original Posts: ", $scope.posts);
	};

	$scope.goToScroll = function(scrollTarget) {
		var settingScroll = true;

		console.log("Scrolling to: ", scrollTarget);
		$timeout(function() {
			$(window).scrollTop(scrollTarget);
			console.log("Current Pos: ", $(window).scrollTop());

			var remainingDistance = Math.abs(scrollTarget - $(window).scrollTop());

			if ( remainingDistance > 50 ) {
				$scope.goToScroll(scrollTarget);
			}
		}, 500);
		$scope.OKSaveScrollPos = true;
	};

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
		$document.unbind("scroll");
		angular.element("#capsuleNavLinks").fadeOut();
	});

	$scope.$on("$locationChangeStart", function(evt, newUrl, oldUrl) {
		console.log("New Url: ", newUrl);
		console.log("Old Url: ", oldUrl);
		console.log("Scroll position: ", $scope.scrollPos); 

		$rootScope.scrollPos[oldUrl] = $scope.scrollPos;
		$scope.OKSaveScrollPos = false;
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

	// $scope.testScroll = function() {
	// 	console.log("Hey, a scroll event happened");
	// 	$scope.loadPhotos();
	// }

	$scope.showFixedBar = false;

	$document.bind("menuClick", function() {
		console.log("Someone just clicked the menu");
	});

	$document.bind("filepickerEngage", function() {
		// console.log("Filepicker engaged");
		$scope.activateFilepicker();
	});


	$document.bind("scroll", function() {
		var isoContainerTop = angular.element("#isotopeContainer")[0].getClientRects()[0].top;
		var capsuleNavLinks = angular.element("#capsuleNavLinks");
		if ( isoContainerTop < 40 ) {
			$scope.$apply(function() {
				if ( capsuleNavLinks.is(":visible") ) { return; }
				capsuleNavLinks.fadeIn("slow");
			});
		} else {
			$scope.$apply(function() {
				if ( !capsuleNavLinks.is(":visible") ) { return; }
				capsuleNavLinks.fadeOut("slow");
			});
		}

		if ( $scope.OKSaveScrollPos ) {
			$scope.$apply(function() {
				$scope.scrollPos = $(window).scrollTop();
			});
		}
	});

}]);
