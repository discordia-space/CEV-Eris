/datum/stat_holder/ui_state(mob/user)
	return GLOB.always_state

/datum/stat_holder/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Stats")
		ui.open()

/datum/stat_holder/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/simple/perks)
	)

/datum/stat_holder/ui_static_data(mob/user)
	var/list/data = list(
		"name" = holder.name
	)

	var/list/stats_data = list()
	for(var/S in ALL_STATS)
		var/stat_data = list(
			"name" = S,
			"value" = getStat(S)
		)
		LAZYADD(stats_data, list(stat_data))
	data["stats"] = stats_data

	data["hasPerks"] = length(perks) > 0
	if(!length(perks))
		return data

	var/list/perks_data = list()
	for(var/datum/perk/P in perks)
		var/list/perk_data = list(
			"name" = P.name,
			"icon" = P.icon_state,
			"desc" = P.desc
		)
		LAZYADD(perks_data, list(perk_data))
	data["perks"] = perks_data

	return data
