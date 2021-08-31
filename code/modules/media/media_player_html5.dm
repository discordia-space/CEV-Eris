// IT IS FINALLY TIME.  IT IS HERE.  Converted to HTML5 <audio>  - Leshana
var/const/PLAYER_HTML5_HTML={"<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=11">
<script type="text/javascript">
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var player = document.getElementById('player');
	// IE can't handle us setting the time before it loads, so we must wait for asychronous load
	var setTime = function () {
		player.removeEventListener("canplay", setTime);  // One time only!
		player.volume = volume;
		player.currentTime = time;
		player.play();
	}
	if(url != "") player.addEventListener("canplay", setTime, false);
	player.src = url;
}
</script>
</head>
<body>
	<audio id="player"></audio>
</body>
</html>
"}
