/mob/living/silicon/robot/Login()
	..()
	regenerate_icons()
	update_hud()
	show_laws(0)

	winset(src, null, "mainwindow.macro=borgmacro hotkey_toggle.is-checked=false input.focus=true input.background-color=#D3B5B5")

	// Forces synths to select an icon relevant to their module
	if(!icon_selected)
		choose_icon(icon_selection_tries, module_sprites)


/*/mob/living/carbon/human/HUD_check()
	var/mob/living/carbon/human/H = src
	if(!H.client)
		return
	if(istype(H, /mob/living/carbon/human) && (H.client.prefs.UI_style != null) && (H.defaultHUD == null || H.defaultHUD == ""))
		if (!(global.HUDdatums.Find(H.client.prefs.UI_style))) // Проверка наличии данных
			log_debug("[H] try update a HUD, but HUDdatums not have [H.client.prefs.UI_style]!")
			H << "Some problem hase accure, use default HUD type"
			H.defaultHUD = "ErisStyle"
		else
			H.defaultHUD = H.client.prefs.UI_style

	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	var/recreate_flag = 0
	if ((H.HUDneed.len != 0) && (H.HUDneed.len == species.hud.ProcessHUD.len)) //Если у моба есть ХУД и кол-во эл. худа соотвсетсвует заявленному
		for (var/i=1,i<=HUDneed.len,i++)
			if(!(HUDdatum.HUDneed.Find(HUDneed[i]) && species.hud.ProcessHUD.Find(HUDneed[i]))) //Если данного худа нет в датуме худа и в датуме расы.
				recreate_flag = 1
				break //то нахуй это дерьмо
	else
		recreate_flag = 1

	if ((H.HUDinventory.len != 0) && (H.HUDinventory.len == species.hud.gear.len) && !(recreate_flag))
		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			if(!(HUDdatum.slot_data.Find(HUDinv.slot_id) && species.hud.gear.Find(HUDinv.slot_id))) //Если данного slot_id нет в датуме худа и в датуме расы.
				recreate_flag = 1
				break //то нахуй это дерьмо
	else
		recreate_flag = 1

	if (recreate_flag)
		H.destroy_HUD()
		H.HUD_create()
		H.show_HUD()
	else
		H.show_HUD()

	return recreate_flag*/