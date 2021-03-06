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
		
		// url += "&post_ids=" + dataSyncObject.postIds;
		url += "&max_post_id=" + dataSyncObject.maxPostId;

		url += "&posts_tagged_for_deletion=" + dataSyncObject.postsTaggedForDeletion;

		url += "&posts_unverified=" + dataSyncObject.postsUnverified;

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
			data.currentPostId = dataSyncObject.currentPostId;
			deferred.resolve(data);
		})
		.error(function(data, status, headers) {
			deferred.reject(status);
		});

		return deferred.promise;
	};

	var findNextPostId = function(posts, index, visiblePosts) {

		var newIndex;
		if (index == -1) {
			newIndex = posts.length - 1;
		} else {
			newIndex = index;
		}

		if ( visiblePosts.indexOf(posts[newIndex].id) != -1 ) {
			return posts[newIndex].id;
		}

		return findNextPostId(posts, newIndex - 1, visiblePosts);
	};

	var doFindNextPostId = function(posts, currentPostId) {
		var visiblePosts = getVisiblePosts(posts)[1];
		var currentPostIndex = findPostIndexById(posts, currentPostId);

		return findNextPostId(posts, currentPostIndex - 1, visiblePosts);
	};

	this.findNextPostId = function(posts, currentPostId) {
		return doFindNextPostId(posts, currentPostId);
	};

	// this.findNextPostId = function(posts, currentPostId) {
	// 	// console.log("Posts: ", posts);
	// 	var filteredPosts = getVisiblePosts(posts);
	// 	var visiblePosts = filteredPosts[1];
	// 	var i;
	// 	var nextPostId;

	// 	for(i = 0; i < visiblePosts.length; i++) {
	// 		if ( parseInt(visiblePosts[i]) == parseInt(currentPostId) ) {
	// 			switch(i) {
	// 				case 0:
	// 					nextPostId = visiblePosts[visiblePosts.length - 1];
	// 					break;
	// 				// case visiblePosts.length - 1:
	// 				// 	nextPostId = visiblePosts[0];
	// 				// 	break;
	// 				default:
	// 					nextPostId = visiblePosts[i-1];	
	// 					break;
	// 			}
	// 		}	
	// 	}

	// 	return nextPostId;
	// };

	var findPostIndexById = function(posts, postId) {
		var i = 0;

		for (i = 0; i < posts.length; i++) {
			if (posts[i].id == postId) {
				return i;
			}
		}

		return -1;
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

	this.getPostIds = function(posts) {
		return getPostIds(posts);
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

	var genDataSyncObject = function(capsuleId, posts, currentPostId) {
		var object = {
			capsuleId: capsuleId,
			maxPostId: Math.max.apply(null, getPostIds(posts)),
			// postIds: getPostIds(posts),
			postsTaggedForDeletion: getTaggedForDeletionPosts(posts),
			postsUnverified: getUnverifiedPosts(posts),
			currentPostId: currentPostId == undefined ? 0 : currentPostId
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

	this.getNewPosts = function(capsuleId, posts, currentPostId) {
		var dataSyncObject = genDataSyncObject(capsuleId, posts, currentPostId);

		return getNewPosts(dataSyncObject);
	};

	// var injectNewPosts = function(posts, newPostsArray, injectIndex) {
	// 	var spliceArgs = [injectIndex, 0].concat(newPostsArray);
	// 	Array.prototype.splice.apply(posts, spliceArgs);
	// 	return posts;
	// };
	
	var removePosts = function(posts, postsToRemoveArray) {
		var i;

		for(i = 0; i < postsToRemoveArray.length; i++) {
			var index = findPostIndexById(posts, postsToRemoveArray[i].id);
			// console.log("Removing post at: ", index, " Post: ", postsToRemoveArray[i]);
			posts.splice(index, 1);
		}

		// return posts;
	};

	var injectPost = function(posts, postToInject, injectIndex) {
		Array.prototype.splice.apply(posts, [injectIndex, 0, postToInject]);
	};

	var injectPosts = function(posts, postsToInject, injectIndex) {
		if ( postsToInject.length == 0 ) { return posts; }

		injectPost(posts, postsToInject.pop(), injectIndex);

		return injectPosts(posts, postsToInject, injectIndex);
	};

	// var injectPosts = function(posts, newData, injectIndex) {
	// 	removePosts(posts, newData.new_verified);	

	// 	var spliceArgs = [injectIndex, 0].concat(newData.new_posts, newData.new_verified);
	// 	Array.prototype.splice.apply(posts, spliceArgs);
	// 	return posts;
	// };
	
	var injectChanges = function(posts, newData, injectIndex) {
		removePosts(posts, newData.new_verified);

		return injectPosts(posts, newData.new_posts.concat(newData.new_verified), injectIndex);
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

	var moveForwardInVisiblePosts = function(posts, postId, stop, iteration) {
		if (stop == iteration) { return postId; }
		
		nextPostId = doFindNextPostId(posts, postId);

		iteration += 1;
		return moveForwardInVisiblePosts(posts, nextPostId, stop, iteration);

		// var nextPostId = findNextPostId(posts, currentPostIndex, visiblePosts);
		// var nextIndex = findPostIndexById(posts, nextPostId);

		// return moveForwardInVisiblePosts(posts, nextIndex, visiblePosts, stop, iteration + 1);
	};

	var addToIndexOfVisiblePosts = function(posts, postId, n) {
		// var visiblePosts = getVisiblePosts(posts)[1];
		// var currentPostIndex = findPostIndexById(posts, currentId);

		// return moveForwardInVisiblePosts(posts, currentPostIndex - 1, visiblePosts, n, 0);
		
		return moveForwardInVisiblePosts(posts, postId, n, 0);
	};

	// var addToIndexOfVisiblePosts = function(posts, index, n) {
	// 	var visiblePosts = getVisiblePosts(posts)[1];
	// 	console.log("Visible Posts: ", visiblePosts);
	// 	var nextPostId = findNextPostId(posts, index, visiblePosts);
	// 	console.log("Next Post Id: ", nextPostId);

	// 	for (i = 0; i < n; i++) {
			
	// 	}
	// };

	this.updatePostData = function(currentPosts, newData, options) {
		var posts;

		if ( angular.isDefined(options) ) {
			if ( options.currentPostId == 0 ) {
				var currentPostIndex = 0;	
			} else {
				var currentPostIndex = findPostIndexById(currentPosts, options.currentPostId);
				var injectionId = addToIndexOfVisiblePosts(currentPosts, options.currentPostId, 2);
				var injectionIndex = findPostIndexById(currentPosts, injectionId);
				
				// console.log("Injection Point: ", injectionIndex, " Current Index: ", currentPostIndex);
			}

			// posts = injectNewPosts(currentPosts, newData.new_posts, currentPostIndex);
			posts = injectChanges(currentPosts, newData, injectionIndex);
		} else {
			posts = updatePosts(currentPosts, newData.new_posts);
			posts = applyUpdates(posts, newData.new_verified, "verified");
		}

		posts = applyUpdates(posts, newData.new_undeleted, "undeletion");
		posts = applyUpdates(posts, newData.new_deletions, "deletion");

		setRootPostsData(posts);		

		return posts;
	};

	this.filterNewPosts = function(posts, newPostsArray, data) {
		var newPostIds = getPostIds(data.new_posts);

		angular.forEach(newPostIds, function(post_id) {
			post = getCurrentPost(posts, post_id);
			newPostsArray.push(post);
		});

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

	this.filterOutTextPosts = function(posts) {
		var results = [];

		angular.forEach(posts, function(post) {
			if( checkPostIsImage(post) ) {
				results.push(post);
			}			
		});

		return results;
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

	this.buildSecureImageUrl = function(post, genre) {
		var imageUrl = buildImageUrl(post, genre);

		return imageUrl.replace("http", "https");
	};
}]);
