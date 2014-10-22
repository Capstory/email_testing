remote_moderation_app.controller("RemoteModerationController", ["$document", "$interval", "$scope", "$rootScope", "PostModel", "PostData", function($document, $interval, $scope, $rootScope, PostModel, PostData) {

	var cleanImageUrl = function(post_url) {
		if ( post_url == "/images/original/missing.png" ) {
			return	"http://placehold.it/300x300"; 
		} else {
			return post_url;
		}
	};


	var setPost = function(index) {
		$scope.selected_post = $scope.posts[index];
		$scope.selected_post.index = index;
	};

	var visiblePosts = function(posts) {
		var post_array = [];
		angular.forEach(posts, function(post) {
			if ( !post.tag_for_deletion ) {
				post_array.push(post);
			}
		});
		return post_array;
	};

	var trashPosts = function(posts) {
		var post_array = [];
		angular.forEach(posts, function(post) {
			if ( post.tag_for_deletion ) {
				post_array.push(post);
			}
		});
		return post_array;
	};

	var filterPosts = function(posts) {
		$scope.posts = visiblePosts(posts);
		$scope.trash_posts = trashPosts(posts);
	};
	
	var raw_posts = angular.forEach(PostData.get(), function(post) {
		post.image = cleanImageUrl(post.image);
		return post;
	});
	var after_id = raw_posts[0].id;

	$scope.selected_post;
	$scope.init = function() {
		filterPosts(raw_posts);
		setPost(0);
	};

	$scope.selectPost = function(index) {
		console.log("Index: ", index);
		setPost(index);
	};

	$scope.postSelected = function(post) {
		if (post === $scope.selected_post) { return "selected" }

		return 
	};

	$scope.thumbnailImage = function(post) {
		var imageUrl = post.image;

		var body = post.body;
		if ( body === "No message" || body === null || body === "no message" ) {
			var newUrl = imageUrl.replace("original", "thumb");

			return newUrl;
		} else {
			return imageUrl;
		}
	};
	
	$scope.keypresser = function(keyEvent) {
		console.log("You hit keypresser");
	};

	$scope.previousPhoto = function() {
		$scope.$apply(function() {
			if ( $scope.selected_post.index == 0 ) {
				setPost($scope.posts.length	- 1);				
			} else {
				setPost($scope.selected_post.index - 1); 
			}
		});
		// console.log("Go to previous photo");
	};

	$scope.nextPhoto = function() {
		$scope.$apply(function() {
			if ( $scope.selected_post.index + 1 == $scope.posts.length ) {
				setPost(0);
			} else {
				setPost($scope.selected_post.index + 1); 
			}
		});
		// console.log("Time to load the next photo");
	};

	$scope.inTrash = function(post) {
		if ( post.tag_for_deletion ) {
			return true;
		}

		return false;
	};

	$scope.markForTrash = function(post) {
		PostModel.markPostForTrash(post.id)
			.then(function(data) {
				console.log("Trash: ", data);
				
				var post_index = $scope.posts.indexOf(post);
				$scope.posts.splice(post_index, 1);
				$scope.trash_posts.unshift(post);
				post.tag_for_deletion = true;
			}, 
			function(status) {
				console.log("Trash Error: ", status);
			});
	};

	$scope.removeFromTrash = function(post) {
		PostModel.removeFromTrash(post.id)
			.then(function(data) {
				console.log("Removed From Trash: ", data);
				var post_index = $scope.trash_posts.indexOf(post);
				$scope.trash_posts.splice(post_index, 1);
				$scope.posts.unshift(post);
				post.tag_for_deletion = false;	
			}, 
			function(status){
				console.log("Remove From Trash Error: ", status);	
			});
	};

	$scope.verifyPost = function(post) {
		PostModel.verifyPost(post.id)
			.then(function(data) {
				console.log("Post Verified: ", data);
				post.verified = true;	
			}, 
			function(status) {
				console.log("Unable to Verify Post: ", status);
			});
	}; 

	$scope.postNotPicture = function(post) {
		if ( post.body == "No message" || post.body == null ) {
			return false;
		}
		return true;
	};

	$scope.dropdownId = function(post) {
		return "hover_" + post.id;
	};

	$scope.hoverOnPost = function(post) {
		post.hover = true;
	};

	$scope.hoverOffPost = function(post) {
		post.hover = false;
	};

	$interval(function() {
		PostModel.getNewPosts(after_id)
			.then(function(data) {
				console.log("New Data: ", data);
				if ( data.length > 0 ) {
					angular.forEach(data, function(post) {
						$scope.posts.unshift(post);
						after_id = post.id > after_id ? post.id : after_id;
					});
				}
			}, 
			function(status) {
				console.log("Couldn't get new data", status);
			});	
	}, 50000);
}]);
