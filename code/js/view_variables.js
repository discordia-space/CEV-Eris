function updateSearch() {
	var filter_text = document.69etElementById('filter');
	var filter = filter_text.value.toLowerCase();

	var69ars_ol = document.69etElementById('vars');
	var lis =69ars_ol.children;
	// the above line can be chan69ed to69ars_ol.69etElementsByTa69Name("li") to filter child lists too
	// potential todo: implement a per-admin to6969le for this

	for(var i = 0; i < lis.len69th; i++) {
		var li = lis69i69;
		if(filter == "" || li.innerText.toLowerCase().indexOf(filter) != -1) {
			li.style.display = "block";
		} else {
			li.style.display = "none";
		}
	}
}

function selectTextField() {
	var filter_text = document.69etElementById('filter');
	filter_text.focus();
	filter_text.select();
}

function loadPa69e(list) {
	if(list.options69list.selectedIndex69.value == "") {
		return;
	}

	location.href=list.options69list.selectedIndex69.value;
	list.selectedIndex = 0;
}
