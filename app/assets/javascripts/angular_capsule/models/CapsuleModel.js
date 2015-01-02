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

	var setCapsulePermissions = function(authDetails) {
		$rootScope.capsulePermissions = angular.copy(authDetails, {});
	};

	var getCapsulePermissions = function() {
		return $rootScope.capsulePermissions;
	};

	var buildCapsulePermissions = function(capPerms) {
		var newPerms = angular.copy(capPerms, {});

		if ( !angular.isDefined(newPerms.tagPermission) ) {
			if ( newPerms.admin || newPerms.capsuleOwner ) {
				newPerms.tagPermission = true;
			} else {
				newPerms.tagPermission = false;
			}
		}

		return newPerms;
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

	this.setAndGetCapsulePermissions = function(authDetails) {
		if ( !angular.isDefined($rootScope.capsulePermissions) ) {
			setCapsulePermissions(authDetails);
		}
		return buildCapsulePermissions(getCapsulePermissions());
	};
}]);
