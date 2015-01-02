angular_capsule_app.service("VideoModel", ["$rootScope", function($rootScope) {

	var setVideoData = function(videoData) {
		var videos = []
		
		angular.forEach(videoData, function(video) {
			videos.push(angular.copy(video, {}));
		});

		$rootScope.videoData = videos;
	};
	
	var getVideoData = function() {
		return $rootScope.videoData;
	}

	var updateVideoData = function(newVideoData) {
		$rootScope.videoData = newVideoData;
		return getVideoData();
	};

	this.setAndGetVideoData = function(videoData) {
		if ( !angular.isDefined($rootScope.videoData) ) {
			setVideoData(videoData);
		}
		return getVideoData();
	};

	this.getVideoData = function() {
		return getVideoData();
	};

	this.updateVideoData = function(newVideoData) {
		return updateVideoData(newVideoData);
	};	
}]);
