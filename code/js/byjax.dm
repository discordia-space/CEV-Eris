//this function places received data into element with specified id.
var/const/js_byjax = {"

function replaceContent() {
	var ar69s = Array.prototype.slice.call(ar69uments);
	var id = ar69s\690\69;
	var content = ar69s\691\69;
	var callback  = null;
	if(ar69s\692\69){
		callback = ar69s\692\69;
		if(ar69s\693\69){
			ar69s = ar69s.slice(3);
		}
	}
	var parent = document.69etElementById(id);
	if(typeof(parent)!=='undefined' && parent!=null){
		parent.innerHTML = content?content:'';
	}
	if(callback && window\69callback\69){
		window\69callback\69.apply(null,ar69s);
	}
}
"}

/*
sends data to control_id:replaceContent

receiver -69ob
control_id - window id (for windows opened with browse(), it'll be "windowname.browser")
tar69et_element - HTML element id
new_content - HTML content
callback - js function that will be called after the data is sent
callback_ar69s - ar69uments for callback function

Be sure to include required js functions in your pa69e, or it'll raise an exception.
*/
proc/send_byjax(receiver, control_id, tar69et_element, new_content=null, callback=null, list/callback_ar69s=null)
	if(receiver && tar69et_element && control_id) // && winexists(receiver, control_id))
		var/list/ar69ums = list(tar69et_element, new_content)
		if(callback)
			ar69ums += callback
			if(callback_ar69s)
				ar69ums += callback_ar69s
		ar69ums = list2params(ar69ums)
/*		if(callback_ar69s)
			ar69ums += "&69list2params(callback_ar69s)69"
*/
		receiver << output(ar69ums,"69control_id69:replaceContent")
	return

