remote_moderation_app.controller("RemoteModerationController", ["$document", "$scope", "$rootScope", "PostModel", "PostData", function($document, $scope, $rootScope, PostModel, PostData) {

	$scope.posts = PostData.get();

	$scope.selected_post;

	var setPost = function(index) {
		$scope.selected_post = $scope.posts[index];
		$scope.selected_post.index = index;
	};
	
	$scope.init = function() {
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
			setPost($scope.selected_post.index - 1); 
		});
		// console.log("Go to previous photo");
	};

	$scope.nextPhoto = function() {
		$scope.$apply(function() {
			setPost($scope.selected_post.index + 1); 
		});
		// console.log("Time to load the next photo");
	};

	$scope.markForTrash = function(post) {
		PostModel.markPostForTrash(post.id).then(function(data) {
					console.log("Trash: ", data);
					post.tag_for_deletion = true;
				}, 
				function(status) {
					console.log("Trash Error: ", status);
				});
	};

	// $document.onkeypress = function(e, a, key) {
	// 	console.log("Event: ", e);
	// 	$broadcast("keypress", e);
	// };

	// $rootScope.$on("keypress", function(e) {
	// 	console.log("Angular Event: ", e);
	// });
}]);
