angular_capsule_app.controller("CoverPhotoCtrl", ["$scope", "$rootScope", "$cookies", "$timeout", "CapsuleData", "PostModel", "CapsuleModel", function($scope, $rootScope, $cookies, $timeout, CapsuleData, PostModel, CapsuleModel) {
	var capsuleData;

	var getImageDimensions = function(imageUrl) {
		var results = { width: undefined, height: undefined };
		
		function setResults(img) {
			results.width = img.width;
			results.height = img.height;
		}

		var img = document.createElement("img");

		img.addEventListener("load", function() {
			setResults(img);
		});

		img.setAttribute("src", imageUrl);

		img.removeEventListener("load");

		return results;
	};
	
	var isImageAdequateSize = function(post) {
		if ( post.imageDimensions.width > post.imageDimensions.height) {
			if (post.image_file_size > 100000 ) { return true; }
		} else {
			if (post.image_file_size > 200000 ) { return true; } 
		}

		return false;
	};

	var filterImages = function(posts, filters) {
		var results = [];

		function passesFilter(post, attribute, value) {
			return post[attribute] == value;
		}

		angular.forEach(posts, function(post) {
			var passes = true;
			angular.forEach(filters, function(value, key) {
				if ( !passesFilter(post, key, value) ) {
					passes = false;
				}
			});

			if ( passes ) { results.push(post); }
		});

		return results;
	};

	var buildImage = function(post) {
		post.image = PostModel.cleanMissingImageUrl(post.image);
		post.coverImage = PostModel.buildSecureImageUrl(post, "capsule_width");
		post.thumb = PostModel.buildSecureImageUrl(post, "thumb");
		post.style = {"opacity": 0.7, "width": 200};
		post.coverPhotoSelection = false;

		post.imageDimensions = getImageDimensions(post.image);
		post.adequateSize = isImageAdequateSize(post);

		// console.log("Img Dimensions: ", getImageDimensions(post.image));
		return post;
	};

	var setAllPostsToInvisible = function(posts) {
		angular.forEach(posts, function(post) {
			post.visible = false;
		});

		return posts;
	};

	var buildImages = function(posts, acc) {
		if ( posts.length == 0 ) { return acc; }

		var currentImage = posts.shift();

		acc = acc.concat(buildImage(currentImage));
		
		return buildImages(posts, acc);
	};

	$scope.init = function() {
		$scope.capsuleName = CapsuleData.getCapsuleNamedUrl();

		var posts = setAllPostsToInvisible(buildImages(CapsuleData.getPosts(), new Array));
		$scope.selections = filterImages(posts, {"tag_for_deletion": false, "verified": true, "adequateSize": true});
		// if ( !!$rootScope[$scope.capsuleName + "_selections"] ) {
		// 	$scope.selections = buildImages($rootScope[$scope.capsuleName + "_selections"], new Array); 
		// } else if ( !!$cookies[$scope.capsuleName + "_photoSelections"] ) {
		// 	capsuleData = CapsuleData.getPosts();		
		// 	var selectionIds = angular.fromJson($cookies[$scope.capsuleName + "_photoSelections"]);

		// 	$scope.selections = [];
		// 	angular.forEach(selectionIds, function(id) {
		// 		$scope.selections.push(PostModel.getCurrentPost(capsuleData, id));
		// 	});

		// 	$scope.selections = buildImages($scope.selections, new Array);
		// } else {
		// 	$scope.selections = [];
		// }

		if ( !!$cookies[$scope.capsuleName + "_coverPhotoSelection"] && ( PostModel.getPostIds($scope.selections).indexOf(parseInt($cookies[$scope.capsuleName + "_coverPhotoSelection"])) != -1 )) {
			angular.forEach($scope.selections, function(post) {
				if ( post.id == $cookies[$scope.capsuleName + "_coverPhotoSelection"] ) {
					$scope.coverPhoto = setCurrentPhotoToSelected($scope.selections, post);
				}
			});
		} else {
			$scope.coverPhoto = setCurrentPhotoToSelected($scope.selections, $scope.selections[0]);
		}

		loadPhotos(9, ($scope.selections.length - 1), $scope.selections);

		$timeout(function() {
			$scope.selectionIso = new Isotope("#selectionContainer", {
				itemSelector: ".selectionItem",
				layout: "masonry",
				masonry: {
					"columnWidth": 200,
					"gutter": 10
				},
				containerStyle: {
					"overflow-y": "auto"
				}
			});

		}, 300);
	};

	var setCoverPhotoCookie = function(selection) {
		$cookies[$scope.capsuleName + "_coverPhotoSelection"] = selection.id;

		console.log("Cookie for Cover photo: ", $cookies[$scope.capsuleName + "_coverPhotoSelection"]);
	};

	var setCurrentPhotoToSelected = function(posts, selection) {
		angular.forEach(posts, function(post) {
			post.coverPhotoSelection = false;
			post.style = angular.extend(post.style, {"opacity": 0.7});
		});

		selection.coverPhotoSelection = true;
		setCoverPhotoCookie(selection);

		selection.style = angular.extend(selection.style, {"opacity": 1.0});

		return selection;
	};

	$scope.selectForCover = function(selection) {
		$scope.coverPhoto = setCurrentPhotoToSelected($scope.selections, selection);
	};

	$scope.$watch("selectionIso", function() {
		if ( angular.isDefined($scope.selectionIso) ) {
			angular.element("#selectionContainer").css("height", 400);
		}
	});

	var loadPhotos = function(n, c, posts) {

		if ( n == 0 ) { return; }
		if ( CapsuleModel.allPostsVisible(posts) ) { return; }

		if ( !posts[c].visible ) {

			posts[c].visible = true;
			// if ( !posts[c].tag_for_deletion && posts[c].verified ) { n -= 1; } 
			n -= 1;
		}

		return loadPhotos(n, (c - 1), posts);
	}


	function checkScrolling() {
		// console.log("Scroll height: ", this.scrollHeight);
		// console.log("Scroll Top: ", this.scrollTop);
		// console.log("Client Height: ", this.clientHeight);
		// console.log("Scrolling...");
		if ( this.scrollHeight - this.scrollTop == this.clientHeight ) {
			loadPhotos(9, ($scope.selections.length - 1), $scope.selections);
		}

		$timeout(function() {
			$scope.selectionIso = new Isotope("#selectionContainer", {
				itemSelector: ".selectionItem",
				layout: "masonry",
				masonry: {
					"columnWidth": 200,
					"gutter": 10
				},
				containerStyle: {
					"overflow-y": "auto"
				}
			});

		}, 100);
	}

	angular.element("#selectionContainer").on("scroll", checkScrolling);
}]);
