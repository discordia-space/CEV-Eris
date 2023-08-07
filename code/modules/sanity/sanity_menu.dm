/datum/sanity/ui_state(mob/user)
	return GLOB.always_state

/datum/sanity/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sanity", owner.name)
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/sanity/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/sanity)
	)

/datum/sanity/ui_data(mob/user)
	var/list/data = list()

	data["style"] = list(
		"value" = owner.get_total_style(),
		"min" = MIN_HUMAN_STYLE,
		"max" = MAX_HUMAN_STYLE
	)

	data["sanity"] = list(
		"value" = level,
		"max" = max_level
	)

	data["desires"] = list(
		"resting" = resting,
		"desires" = desires,
		"value" = insight_rest,
	)

	var/obj/item/implant/core_implant/cruciform/C = owner.get_core_implant(/obj/item/implant/core_implant/cruciform)
	data["righteous"] = list(
		"present" = C ? TRUE : FALSE,
		"value" = C?.righteous_life
	)

	data["insight"] = insight

	return data
