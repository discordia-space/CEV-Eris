// These exist for Baycode compatibility

/atom/proc/ClearOverlays()
	cut_overlays()

/atom/proc/AddOverlays(overlay)
	overlays += overlay

/atom/proc/CopyOverlays(atom/other, clear = FALSE)
	if(clear)
		cut_overlays()
	overlays += other.overlays

/image/proc/AddOverlays(sources)
	overlays += sources

/image/proc/CutOverlays(sources)
	overlays -= sources

/image/proc/ClearOverlays()
	cut_overlays()

/image/proc/CopyOverlays(atom/other, clear = FALSE)
	if(clear)
		cut_overlays()
	overlays += other.overlays
