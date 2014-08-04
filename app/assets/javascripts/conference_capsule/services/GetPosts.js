conference_capsule_app.factory("APIHandler", ["$http", "$q", function($http, $q) {
	return {
		getPosts: function(id) {
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
		}
	};
}]);
