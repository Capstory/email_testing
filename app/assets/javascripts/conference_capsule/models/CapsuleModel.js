conference_capsule_app.service("CapsuleModel", ["$http", "$q", function($http, $q) {
	var posts;

	var togglePostVisibility = function(post) {
		if ( post["visible"] === undefined ) {
			post["visible"] = false;
		} else {
			post["visible"] = !post["visible"];
		}

		return post;
	};

	var addVisibleProperty = function(posts) {
		for (var post in posts) {
			posts[post] = togglePostVisibility(posts[post]);
		}

		return posts;
	};

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

	this.allVisible = function(posts) {
		var visible_array = [];
		angular.forEach(posts, function(post) {
			visible_array.push(post.visible);
		});
		// console.log("Visible Array", visible_array);
		// console.log("Index of false", visible_array.indexOf(false));

		if ( visible_array.indexOf(false) === -1 ) {
			return true;	
		} else {
			return false;
		}
	};

	this.nextInvisible = function(posts) {
		angular.forEach(posts, function(post) {
			if ( !post.visible ) {
				return post;
			}
		});
	};

	this.segmentPosts = function(time_groups, posts) {
		groups = Object.keys(time_groups);
		posts = addVisibleProperty(posts);
		segmented_object = {};

		// console.log("Pre-Segmented Posts: ", posts);
		
		segmented_object[null] = [];
		angular.forEach(groups, function(group) {
			segmented_object[group] = [];

			for (var post in posts) {
				if ( posts[post].time_group === group ) {
					segmented_object[group].push(posts[post]);
				} else if ( group === "" ) {
					segmented_object[group].push(posts[post]);
					segmented_object[null].push(posts[post]);
				}
			}	
		});

		return segmented_object;
	};
}]);
