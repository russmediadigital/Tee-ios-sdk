let touchEvent = "touchstart";
let teeElems = document.getElementsByClassName("tee-element");
for(var i = 0; i < teeElems.length; i++) {
	let teeElem = teeElems[i];
	teeElem.style.display = "block";
	if (teeElem.classList.contains("tee-open-btn")) {
		let dataOpen = teeElem.getAttribute("data-open")
		if (dataOpen != null) {
			teeElem.addEventListener(touchEvent, function(e) {
				e.preventDefault();
				window.webkit.messageHandlers.tee_messanger.postMessage(dataOpen);
				
			})
		}
	}
}
