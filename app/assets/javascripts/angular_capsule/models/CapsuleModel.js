angular_capsule_app.service("CapsuleModel", ["$rootScope", function($rootScope) {

	var setCapsuleData = function(capsuleData) {
		$rootScope.capsuleData = angular.copy(capsuleData, {});
	};
	
	var getCapsuleData = function() {
		return $rootScope.capsuleData;
	}

	var updateCapsuleData = function(newCapsuleData) {
		$rootScope.capsuleData = newCapsuleData;
		return getCapsuleData();
	};

	this.setAndGetCapsuleData = function(capsuleData) {
		if ( !angular.isDefined($rootScope.capsuleData) ) {
			setCapsuleData(capsuleData);
		}
		return getCapsuleData();
	};

	this.getCapsuleData = function() {
		return getCapsuleData();
	};

	this.updateCapsuleData = function(newCapsuleData) {
		return updateCapsuleData(newCapsuleData);
	};	
}]);
