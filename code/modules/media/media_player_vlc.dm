// Open up VLC and play musique.
// Converted to VLC for cross-platform and ogg support. - N3X
var/const/PLAYER_VLC_HTML={"
<object classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codebase="http://download.videolan.org/pub/videolan/vlc/last/win32/axvlc.cab" id="player"></object>
	<script>
function noErrorMessages () { return true; }
window.onerror = noErrorMessages;
function SetMusic(url, time, volume) {
	var vlc = document.getElementById('player');

	// Stop playing
	vlc.playlist.stop();

	// Clear playlist
	vlc.playlist.items.clear();

	// Add new playlist item.
	var id = vlc.playlist.add(url);

	// Play playlist item
	vlc.playlist.playItem(id);

	vlc.input.time = time*1000; // VLC takes milliseconds.
	vlc.audio.volume = volume*100; // \[0-200]
}
	</script>
"}
