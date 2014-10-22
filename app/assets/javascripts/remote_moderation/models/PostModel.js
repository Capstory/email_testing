remote_moderation_app.service("PostModel", ["$http", "$q", function($http, $q) {
	this.markPostForTrash = function(post_id) {
		var deferred = $q.defer();

		var request_url = "/remote_moderation/mark_for_trash.json?post_id=" + post_id;

		$http({
			method: "DELETE",
			url: request_url
		})
		.success(function(data, status, headers) {
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	this.removeFromTrash = function(post_id) {
		var deferred = $q.defer();

		var request_url = "/remote_moderation/remove_from_trash.json?post_id=" + post_id;


		$http({
			method: "POST",
			url: request_url
		})
		.success(function(data, status, headers) {
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	this.getNewPosts = function(after_id) {
		var deferred = $q.defer();

		var request_url = "/remote_moderation/get_new_posts.json?after_id=" + after_id;
		$http({
			method: "GET",
			url: request_url
		})
		.success(function(data, status, headers) {
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	this.verifyPost = function(post_id) {
		var deferred = $q.defer();

		var request_url = "/remote_moderation/verify_post.json?post_id=" + post_id;
		$http({
			method: "PUT",
			url: request_url
		})
		.success(function(data, status, headers) {
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	}
}]);
