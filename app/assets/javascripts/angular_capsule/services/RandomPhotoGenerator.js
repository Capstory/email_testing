angular_capsule_app.service("RandomPhotoGenerator", [function() {
	var imageArray = [
		"http://www.ibiblio.org/wm/paint/auth/holbein/tuke.jpg",
		"http://www.ibiblio.org/wm/paint/auth/holbein/southwell.jpg",
		"http://www.ibiblio.org/wm/paint/auth/durer/hare.jpg",
		"http://www.ibiblio.org/wm/paint/auth/cezanne/portraits/cezanne.father.jpg",
		"http://www.ibiblio.org/wm/paint/auth/cezanne/sl/cezanne.compotier-pitcher-fruit.jpg",
		"http://www.ibiblio.org/wm/paint/auth/cezanne/st-victoire/cezanne.lauves-802.jpg",
		"http://www.ibiblio.org/wm/paint/auth/renoir/lady-piano.jpg",
		"http://www.ibiblio.org/wm/paint/auth/renoir/swing.jpg",
		"http://www.ibiblio.org/wm/paint/auth/sargent/sargent.hayloft.jpg",
		"http://www.ibiblio.org/wm/paint/auth/giordano/forge.jpg",
		"http://www.ibiblio.org/wm/paint/auth/rembrandt/1660/magn-glass.jpg",
		"http://www.ibiblio.org/wm/paint/auth/velazquez/valladolid.jpg",
		"http://www.ibiblio.org/wm/paint/auth/velazquez/velazquez.meninas.jpg",
		"http://www.ibiblio.org/wm/paint/auth/goya/goya.teresa-sureda.jpg"
	];
	
	var getImage = function() {
		var element = Math.floor(Math.random() * imageArray.length);

		return imageArray[element];
	};

	this.getImage = function() {
		return getImage();
	};
}]);
