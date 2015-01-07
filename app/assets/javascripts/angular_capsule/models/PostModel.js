angular_capsule_app.service("PostModel", ["$rootScope", "$http", "$q", "$sce", "CapsuleData", function($rootScope, $http, $q, $sce, CapsuleData) {
	var setRootPostsData = function(postsData) {
		var posts = [];
		
		angular.forEach(postsData, function(post) {
			posts.push(angular.copy(post, {}));
		});

		$rootScope.postsData = posts;
	};

	var getRootPostsData = function() {
		return $rootScope.postsData;
	};

	var deletePost = function(postId) {
		var deferred = $q.defer();

		var request_url = "/mark_for_deletion.json?post_id=" + postId;

		$http({
			method: "PUT",
			url: request_url
		})
		.success(function(data, status, headers) {
			deferred.resolve(data, status);
		})
		.error(function(data, status, header) {
			deferred.reject(data, status);
		});

		return deferred.promise;
	};

	this.deletePost = function(postId) {
		return deletePost(postId);
	};

	var buildGetNewPostUrl = function(dataSyncObject) {
		var url = "/check_new_posts.json?capsule_id=" + dataSyncObject.capsuleId;
		
		// if (dataSyncObject.postIds.length > 0) {
			url += "&post_ids=" + dataSyncObject.postIds;
		// }

		// if (dataSyncObject.postsTaggedForDeletion.length > 0) {
			url += "&posts_tagged_for_deletion=" + dataSyncObject.postsTaggedForDeletion;
		// }

		// if (dataSyncObject.postsUnverified.length > 0) {
			url += "&posts_unverified=" + dataSyncObject.postsUnverified;
		// }

		return url;
	};

	var getNewPosts = function(dataSyncObject) {
		var deferred = $q.defer();
		// var request_url = "/check_new_posts.json?capsule_id=" + dataSyncObject.capsuleId + "&post_ids=" + dataSyncObject.postIds + "&posts_tagged_for_deletion=" + dataSyncObject.postsTaggedForDeletion + "&posts_unverified=" + dataSyncObject.postsUnverified;
		var request_url = buildGetNewPostUrl(dataSyncObject);

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

	this.findNextPostId = function(posts, currentPostId) {
		// console.log("Posts: ", posts);
		var filteredPosts = getVisiblePosts(posts);
		var visiblePosts = filteredPosts[1];
		var i;
		var nextPostId;

		for(i = 0; i < visiblePosts.length; i++) {
			if ( parseInt(visiblePosts[i]) == parseInt(currentPostId) ) {
				switch(i) {
					case 0:
						nextPostId = visiblePosts[visiblePosts.length - 1];
						break;
					// case visiblePosts.length - 1:
					// 	nextPostId = visiblePosts[0];
					// 	break;
					default:
						nextPostId = visiblePosts[i-1];	
						break;
				}
			}	
		}

		return nextPostId;
	};

	var findPostById = function(posts, postId) {
		var result;

		angular.forEach(posts, function(post) {
			if (parseInt(post.id) == parseInt(postId)) {
				result = post;
			}
		});

		return result;
	};

	var getPostIds = function(posts) {
		var postIds = [];

		angular.forEach(posts, function(post) {
			postIds.push(post.id);
		});

		return postIds;
	};

	var getTaggedForDeletionPosts = function(posts) {
		var postIds = [];

		angular.forEach(posts, function(post) {
			if (post.tag_for_deletion) {
				postIds.push(post.id);
			}
		});

		return postIds;
	};

	var getUnverifiedPosts = function(posts) {
		var postIds = [];
	
		angular.forEach(posts, function(post) {
			if (!post.verified) {
				postIds.push(post.id);
			}
		});

		return postIds;
	}

	var genDataSyncObject = function(capsuleId, posts) {
		var object = {
			capsuleId: capsuleId,
			postIds: getPostIds(posts),
			postsTaggedForDeletion: getTaggedForDeletionPosts(posts),
			postsUnverified: getUnverifiedPosts(posts)
		};

		return object;
	};

	this.findPreviousPostId = function(posts, currentPostId) {
		var filteredPosts = getVisiblePosts(posts);
		var visiblePosts = filteredPosts[1];
		var i;
		var previousPostId;

		for (i = 0; i < visiblePosts.length; i++) {
			if ( parseInt(visiblePosts[i]) == parseInt(currentPostId) ) {
				switch(i) {
					case visiblePosts.length - 1:
						previousPostId = visiblePosts[0];
						break;
					default:
						previousPostId = visiblePosts[i + 1];
						break;
				}
			}
		}

		return previousPostId;
	};

	var cleanMissingImageUrl = function(post_image) {
		var url = post_image.split("/");
		if ( url[url.length - 1] == "missing.png" ) { 
			return "http://placehold.it/350x350";
		};

		return post_image;	
	};

	this.cleanMissingImageUrl = function(post_image) {
		return cleanMissingImageUrl(post_image);
	};

	var checkPostIsImage = function(post) {
		var body = post.body;

		if ( body == null || body.toLowerCase() == "no message" ) {
			return true;
		} else {
			return false;
		}
	};

	this.checkPostIsImage = function(post) {
		return checkPostIsImage(post);
	};

	var getCurrentPost = function(posts, postId) {
		var resultPost = {
			image: "http://placehold.it/350x350"
		};

		angular.forEach(posts, function(post) {
			var candidatePostId = parseInt(post.id);	
			var targetPostId = parseInt(postId);

			if (candidatePostId == targetPostId) {
				resultPost = angular.copy(post, {});
			}
		});

		return resultPost;
	};

	this.getCurrentPost = function(posts, postId) {
		post = getCurrentPost(posts, postId);
		post.image = cleanMissingImageUrl(post.image);
		post.isImage = checkPostIsImage(post);

		return post;
	};

	var checkPostHasVideo = function(post, videos) {
		var postId = post.id;
		var result = false;

		angular.forEach(videos, function(video) {
			if ( parseInt(video.post_id) == parseInt(postId) ) {
				result = true;
			}
		});

		return result;
	};

	this.checkPostHasVideo = function(post, videos) {
		return checkPostHasVideo(post, videos);
	};

	var getVideoUrl = function(post, videos) {
		var result = null;
		var postId = post.id;

		angular.forEach(videos, function(video) {
			if ( parseInt(video.post_id) == parseInt(postId) ) {
				result = $sce.trustAsResourceUrl(video.zencoder_url);
			}
		});

		return result;
	};

	this.getVideoUrl = function(post, videos) {
		var video_url = getVideoUrl(post, videos);
		return video_url;
	};

	this.getNewPosts = function(capsuleId, posts) {
		var dataSyncObject = genDataSyncObject(capsuleId, posts);

		return getNewPosts(dataSyncObject);
	};

	var updatePosts = function(currentPosts, newPosts) {
		angular.forEach(newPosts, function(post) {
			currentPosts.push(post);
		});
		
		return currentPosts;	
	};
	
	var applyUpdates = function(posts, newUpdates, genre) {
		var newUpdateIds = getPostIds(newUpdates);

		angular.forEach(posts, function(post) {
			var updateIndex = newUpdateIds.indexOf(post.id);

			if (updateIndex != -1) {
				switch(genre) {
					case "deletion":
						post.tag_for_deletion = true;
						break;
					case "undeletion":
						post.tag_for_deletion = false;
						break;
					case "verified":
						post.verified = true;
						break;
				}
			}

		});

		return posts;
	};

	this.updatePostData = function(currentPosts, newData) {
		var posts = updatePosts(currentPosts, newData.new_posts);
		posts = applyUpdates(posts, newData.new_deletions, "deletion");
		posts = applyUpdates(posts, newData.new_undeleted, "undeletion");
		posts = applyUpdates(posts, newData.new_verified, "verified");

		setRootPostsData(posts);		

		return posts;
	};

	var filterPostsByTagForDeletionAndVerified = function(posts) {
		var filteredPosts = [];

		angular.forEach(posts, function(post) {
			if ( post.verified && !post.tag_for_deletion ) {
				filteredPosts.push(post);
			}
		});

		return filteredPosts;
	};

	var getVisiblePosts = function(allPosts) {
		var visiblePostIds = getPostIds(filterPostsByTagForDeletionAndVerified(allPosts));
		return [1, visiblePostIds];
	};

	this.getVisiblePosts = function(allPosts) {
		return getVisiblePosts(allPosts);
	};

	this.setAndGetPostsData = function(postsData) {
		if ( !angular.isDefined($rootScope.postsData) ) {
			setRootPostsData(postsData);
		}
		return getRootPostsData();
	};

	var buildImageUrl = function(post, genre) {
		var imageUrl = post.image;

		return imageUrl.replace("original", genre);
	};

	this.buildImageUrl = function(post, genre) {
		return buildImageUrl(post, genre);
	};
}]);
