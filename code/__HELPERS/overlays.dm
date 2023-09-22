// These exist for Baycode compatibility

/atom/proc/AddOverlays(overlay)
	overlays += overlay

/atom/proc/CopyOverlays(atom/other, clear)
	if(clear)
		cut_overlays()
	AddOverlays(other.overlays)
