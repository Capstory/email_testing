conference_capsule_app.service("CapsuleModel", ["$http", "$q", function($http, $q) {
	var posts;

	this.set = function(data) {
		posts = data;
	};

	this.get = function() {
		return posts;
	};

	this.getPostsAPI = function(id) {
		var deferred = $q.defer();

		var request_url = "/conference_get_posts.json?id=" + id;

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

	this.getNewPostsAPI = function(capsule_id, after_id) {
		console.log("Getting posts after " + after_id + " for capsule " + capsule_id);
		var deferred = $q.defer();

		var request_url = "/conference_get_new_posts.json?capsule_id=" + capsule_id + "&after_id=" + after_id;

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
}]);
