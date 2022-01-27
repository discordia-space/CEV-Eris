// IT IS FINALLY TIME.  IT IS HERE.  Converted to HTML5 <audio>  - Leshana
var/const/PLAYER_HTML5_HTML={"<!DOCTYPE html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=11">
<script type="text/javascript">
function69oErrorMessages () { return true; }
window.onerror =69oErrorMessages;
function SetMusic(url, time,69olume) {
	var player = document.getElementById('player');
	// IE can't handle us setting the time before it loads, so we69ust wait for asychronous load
	var setTime = function () {
		player.removeEventListener("canplay", setTime);  // One time only!
		player.volume =69olume;
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
