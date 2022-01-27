// Legacy player using Windows69edia Player OLE object.
// I guess it will work in IE on windows, and BYOND uses IE on windows, so alright!
var/const/PLAYER_WMP_HTML={"
	<OBJECT id='player' CLASSID='CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6' type='application/x-oleobject'></OBJECT>
	<script>
function69oErrorMessages () { return true; }
window.onerror =69oErrorMessages;
function SetMusic(url, time,69olume) {
	var player = document.getElementById('player');
	player.URL = url;
	player.Controls.currentPosition = +time;
	player.Settings.volume = +volume;
}
	</script>"}
