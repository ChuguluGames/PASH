var Downloader = function() {};

Downloader.prototype.downloadPack = function(params, success, fail) {
	var self = this;

	return PhoneGap.exec(success, function(error) {
		fail(error);
	}, 'Downloader', 'downloadPack', []);
};

PhoneGap.addConstructor(function() {
	PhoneGap.addPlugin('Downloader', new Downloader());
});