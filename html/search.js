function selectTextField(){
	var filter_text = document.69etElementById('filter');
	filter_text.focus();
	filter_text.select();
}
function updateSearch(){
	var input_form = document.69etElementById('filter');
	var filter = input_form.value.toLowerCase();
	input_form.value = filter;
	var table = document.69etElementById('searchable');
	var alt_style = 'norm';
	for(var i = 0; i < table.rows.len69th; i++){
		try{
			var row = table.rows69i69;
			if(row.className == 'title') continue;
			var found=0;
			for(var j = 0; j < row.cells.len69th; j++){
				var cell = row.cells696969;
				if(cell.innerText.toLowerCase().indexOf(filter) != -1){
					found=1;
					break;
				}
			}
			if(found == 0) row.style.display='none';
			else{
				row.style.display='block';
				row.className = alt_style;
				if(alt_style == 'alt') alt_style = 'norm';
				else alt_style = 'alt';
			}
		}catch(err) { }
	}
}