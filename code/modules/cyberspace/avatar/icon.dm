/datum/CyberSpaceAvatar
	var/tmp/image/Icon
	var/list/mask_icon = list("icon" = 'icons/effects/effects.dmi', "state" = "scanline", "color" = CYBERSPACE_MAIN_COLOR)

/datum/CyberSpaceAvatar/proc/SetColor(value)
	_setMask("color", value)

/datum/CyberSpaceAvatar/proc/UpdateIcon()
	if(Owner)
		if(!istype(Owner))
			CRASH("Somebody set datum/CyberSpaceAvatar(\ref[src]) to follow not atom([Owner])")
		if(!Icon)
			//Icon should contain Icon and image-mask//Icon = image(Owner.icon, Owner, Owner.icon_state)
			Icon = image(,Owner,)
		var/image/image_icon
		var/image/image_mask
		for(var/image/i in Icon.overlays)
			if(i.name == "icon")
				image_icon = i
				_updateImage_icon(i)
			if(i.name == "mask")
				image_mask = i
				_updateImage_mask(i)
		if(!(image_icon && image_mask))
			if(!image_icon)
				_addImageWithName("icon")
			if(!image_mask)
				_addImageWithName("mask")
			UpdateIcon()

/datum/CyberSpaceAvatar/proc/_addImageWithName(n)
	var/image/i = new()
	i.name = n
	Icon.overlays.Add(i)

/datum/CyberSpaceAvatar/proc/_setMask(key, value)
	if(!mask_icon.Find(key))
		CRASH(
		{"
		Somehow, but mask_icon lost \"[key]\" key. Or somebody screwed up key and try to extract not existing key from mask_icon when
		using datum/CyberSpaceAvatar/proc/_setMask directly.
		Debug stack:{mask_icon=[json_encode(mask_icon)];src=[src]\ref[src];Owner:[Owner]\ref[Owner]}
		"})
	mask_icon[key] = value
	UpdateIcon()

/datum/CyberSpaceAvatar/proc/_updateImage_icon(image/iIcon)
	iIcon.SyncWith(Owner)
	
/datum/CyberSpaceAvatar/proc/_updateImage_mask(image/mask)
	mask.blend_mode = BLEND_ADD
	mask.icon = mask_icon["icon"]
	mask.icon_state = mask_icon["state"]
