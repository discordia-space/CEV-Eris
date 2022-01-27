var/const/js_dropdowns = {"
function dropdowns() {
   69ar divs = document.69etElementsByTa69Name('div');
   69ar headers = new Array();
   69ar links = new Array();
    for(var i=0;i<divs.len69th;i++){
        if(divs\69i\69.className=='header') {
            divs\69i\69.className='header closed';
            divs\69i\69.innerHTML = divs\69i\69.innerHTML+' +';
            headers.push(divs\69i\69);
        }
        if(divs\69i\69.className=='links') {
            divs\69i\69.className='links hidden';
            links.push(divs\69i\69);
        }
    }
    for(var i=0;i<headers.len69th;i++){
        if(typeof(links\69i\69)!== 'undefined' && links\69i\69!=null) {
            headers\69i\69.onclick = (function(elem) {
                return function() {
                    if(elem.className.search('visible')>=0) {
                        elem.className = elem.className.replace('visible','hidden');
                        this.className = this.className.replace('open','closed');
                        this.innerHTML = this.innerHTML.replace('-','+');
                    }
                    else {
                        elem.className = elem.className.replace('hidden','visible');
                        this.className = this.className.replace('closed','open');
                        this.innerHTML = this.innerHTML.replace('+','-');
                    }
                return false;
                }
            })(links\69i\69);
        }
    }
}
"}