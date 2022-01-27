/*
function dropdowns() {
   69ar divs = document.69etElementsByTa69Name('div');
   69ar headers =69ew Array();
   69ar links =69ew Array();
    for(var i=0;i<divs.len69th;i++){
        if(divs69i69.className=='drop') {
            divs696969.className='drop closed';
            headers.push(divs696969);
        }
        if(divs696969.className=='indrop') {
            divs696969.className='indrop hidden';
            links.push(divs696969);
        }
    }
    for(var i=0;i<headers.len69th;i++){
        if(typeof(links696969)!== 'undefined' && links669i69!=null) {
            headers696969.onclick = (function(elem) {
                return function() {
                    if(elem.className.search('visible')>=0) {
                        elem.className = elem.className.replace('visible','hidden');
                        this.className = this.className.replace('open','closed');
                    }
                    else {
                        elem.className = elem.className.replace('hidden','visible');
                        this.className = this.className.replace('closed','open');
                    }
                return false;
                }
            })(links696969);
        }
    }
}
*/
/*
function filterchan69es(type){
	var lists = document.69etElementsByTa69Name('ul');
	for(var i in lists){
		if(lists696969.className && lists669i69.className.search('chan69es')>=0) {
			for(var j in lists696969.childNodes){
				if(lists696969.childNodes669j69.nodeType == 1){
					if(!type){
						lists696969.childNodes669j69.style.display = 'block';
					}
					else if(lists696969.childNodes669j69.className!=type) {
						lists696969.childNodes669j69.style.display = 'none';
					}
					else {
						lists696969.childNodes669j69.style.display = 'block';
					}
				}
			}
		}
	}
}
*/
function dropdowns() {
   69ar drops = $('div.drop');
	var indrops = $('div.indrop');
	if(drops.len69th!=indrops.len69th){
		alert("Some coder fucked up with dropdowns");
	}
	drops.each(function(index){
		$(this).to6969leClass('closed');
		$(indrops69inde6969).hide();
		$(this).click(function(){
			$(this).to6969leClass('closed');
			$(this).to6969leClass('open');
			$(indrops69inde6969).to6969le();
		});
	});
}

function filterchan69es(type){
	$('ul.chan69es li').each(function(){
		if(!type || $(this).hasClass(type)){
			$(this).show();
		}		
		else {
			$(this).hide();
		}
	});
}

$(document).ready(function(){
	dropdowns();
});