datum/preferences
	var/icon/preview_icon  = null
	var/icon/preview_south = null
	var/icon/preview_north = null
	var/icon/preview_east  = null
	var/icon/preview_west  = null
	var/preview_dir = SOUTH	//for augmentation

datum/preferences/proc/update_preview_icon(var/naked = FALSE)
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin(client_ckey)
	mannequin.delete_inventory(TRUE)
	preview_icon = icon('icons/effects/96x64.dmi', bgstate)

	if(SSticker.current_state > GAME_STATE_STARTUP)
		dress_preview_mob(mannequin, naked)
	
	preview_east = getFlatIcon(mannequin, EAST, always_use_defdir = 1)

	mannequin.dir = WEST
	var/icon/stamp = getFlatIcon(mannequin, WEST, always_use_defdir = 1)
	preview_icon.Blend(stamp, ICON_OVERLAY, preview_icon.Width()/100 * 3, preview_icon.Height()/100 * 29)
	preview_west = stamp

	mannequin.dir = NORTH
	stamp = getFlatIcon(mannequin, NORTH, always_use_defdir = 1)
	preview_icon.Blend(stamp, ICON_OVERLAY,preview_icon.Width()/100 * 35, preview_icon.Height()/100 * 53)
	preview_north = stamp

	mannequin.dir = SOUTH
	stamp = getFlatIcon(mannequin, SOUTH, always_use_defdir = 1)
	preview_icon.Blend(stamp, ICON_OVERLAY, preview_icon.Width()/100 * 68,preview_icon.Height()/100 * 5)
	preview_south = stamp

	// Scaling here to prevent blurring in the browser.
	preview_east.Scale(preview_east.Width() * 2, preview_east.Height() * 2)
	preview_west.Scale(preview_west.Width() * 2, preview_west.Height() * 2)
	preview_north.Scale(preview_north.Width() * 2, preview_north.Height() * 2)
	preview_south.Scale(preview_south.Width() * 2, preview_south.Height() * 2)
	preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) 
	return mannequin.icon
