(function() {
 if (!window.navigator) window.navigator = {};
 if (!window.navigator.mediaDevices) window.navigator.mediaDevices = {};
 window.navigator.getUserMedia = function() {
	webkit.messageHandlers.qr_messanger.postMessage(arguments);
 }
 window.navigator.mediaDevices.getUserMedia = function() {
	webkit.messageHandlers.qr_messanger.postMessage(...arguments);
 }
})();
