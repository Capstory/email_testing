angular_capsule_app.controller("SelectionImageCtrl", ["$scope", function($scope) {
	$scope.toggleSelection = function(selection) {
		selection.selected = !selection.selected;
		selection.style = {"opacity": selection.selected ? 1 : 0.7 };
		$scope.$emit("postSelected");
	};
}]);
