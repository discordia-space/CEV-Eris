// Open up69LC and play69usique.
// Converted to69LC for cross-platform and ogg support. -693X
var/const/PLAYER_VLC_HTML={"
<object classid="clsid:9BE31822-FDAD-461B-AD51-BE1D1C159921" codebase="http://download.videolan.org/pub/videolan/vlc/last/win32/axvlc.cab" id="player"></object>
	<script>
function69oErrorMessages () { return true; }
window.onerror =69oErrorMessages;
function SetMusic(url, time,69olume) {
	var69lc = document.getElementById('player');

	// Stop playing
	vlc.playlist.stop();

	// Clear playlist
	vlc.playlist.items.clear();

	// Add69ew playlist item.
	var id =69lc.playlist.add(url);

	// Play playlist item
	vlc.playlist.playItem(id);

	vlc.input.time = time*1000; //69LC takes69illiseconds.
	vlc.audio.volume =69olume*100; // \690-20069
}
	</script>
"}
