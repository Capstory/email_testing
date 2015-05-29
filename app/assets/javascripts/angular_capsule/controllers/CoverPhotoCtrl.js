angular_capsule_app.controller("CoverPhotoCtrl", ["$scope", "$rootScope", "$cookies", "$timeout", "CapsuleData", "PostModel", function($scope, $rootScope, $cookies, $timeout, CapsuleData, PostModel) {
	var capsuleData;
	
	var buildImage = function(post) {
		post.image = PostModel.cleanMissingImageUrl(post.image);
		post.coverImage = PostModel.buildSecureImageUrl(post, "capsule_width");
		post.thumb = PostModel.buildSecureImageUrl(post, "thumb");
		post.style = {"opacity": 0.7, "width": 200};
		post.coverPhotoSelection = false;

		return post;
	};

	var buildImages = function(posts, acc) {
		if ( posts.length == 0 ) { return acc; }

		var currentImage = posts.shift();

		acc = acc.concat(buildImage(currentImage));
		
		return buildImages(posts, acc);
	};

	$scope.init = function() {
		if ( !!$rootScope.selections ) {
			$scope.selections = buildImages($rootScope.selections, new Array); 
		} else if ( !!$cookies.photoSelections ) {
			capsuleData = CapsuleData.getPosts();		
			var selectionIds = angular.fromJson($cookies.photoSelections);

			$scope.selections = [];
			angular.forEach(selectionIds, function(id) {
				$scope.selections.push(PostModel.getCurrentPost(capsuleData, id));
			});

			$scope.selections = buildImages($scope.selections, new Array);
		} else {
			$scope.selections = [];
		}

		if ( !!$cookies.coverPhotoSelection && ( PostModel.getPostIds($scope.selections).indexOf(parseInt($cookies.coverPhotoSelection)) != -1 )) {
			angular.forEach($scope.selections, function(post) {
				if ( post.id == $cookies.coverPhotoSelection ) {
					$scope.coverPhoto = setCurrentPhotoToSelected($scope.selections, post);
				}
			});
		} else {
			$scope.coverPhoto = setCurrentPhotoToSelected($scope.selections, $scope.selections[0]);
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

		}, 300);
	};

	var setCoverPhotoCookie = function(selection) {
		$cookies.coverPhotoSelection = selection.id;

		console.log("Cookie for Cover photo: ", $cookies.coverPhotoSelection);
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
}]);
