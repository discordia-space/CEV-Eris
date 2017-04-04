/mob/proc/create_HUD()
	return

/mob/living/proc/destroy_HUD()
	var/mob/living/H = src
	src.client.screen.Cut()
	H.HUDprocess.Cut()
	for (var/i=1,i<=H.HUDneed.len,i++)
		var/p = H.HUDneed[i]
		qdel(H.HUDneed[p])
	for (var/HUDelement in H.HUDinventory)
		qdel(HUDelement)
	for (var/HUDelement in H.HUDfrippery)
		qdel(HUDelement)
	for (var/i=1,i<=H.HUDtech.len,i++)
		var/p = H.HUDtech[i]
		qdel(H.HUDtech[p])
	H.HUDtech.Cut()
	H.HUDneed.Cut()
	H.HUDinventory.Cut()
	H.HUDfrippery.Cut()

/mob/living/proc/show_HUD()
	if(src.client)
		src.client.screen.Cut()
		for (var/i=1,i<=HUDneed.len,i++)
			var/p = HUDneed[i]
			src.client.screen += HUDneed[p]
		for (var/obj/screen/HUDinv in src.HUDinventory)
			src.client.screen += HUDinv
		for (var/obj/screen/frippery/HUDfri in src.HUDfrippery)
			src.client.screen += HUDfri
		for (var/i=1,i<=HUDtech.len,i++)
			var/p = HUDtech[i]
			src.client.screen += HUDtech[p]
//For HUD checking needs

/mob/living/proc/recolor_HUD(var/_color, var/_alpha)
	for (var/i=1,i<=HUDneed.len,i++)
		var/p = HUDneed[i]
		var/obj/screen/HUDelm = HUDneed[p]
		HUDelm.color = _color
		HUDelm.alpha = _alpha
	for (var/obj/screen/HUDinv in src.HUDinventory)
		HUDinv.color = _color
		HUDinv.alpha = _alpha
	return

/mob/living/proc/check_HUD()//Main HUD check process
	return

/mob/living/proc/check_HUDdatum()//correct a datum?
	return
/mob/living/proc/check_HUDinventory()//correct a HUDinventory?
	return
/mob/living/proc/check_HUDneed()
	return
/mob/living/proc/check_HUDfrippery()
	return
/mob/living/proc/check_HUDprocess()
	return
/mob/living/proc/check_HUDtech()
	return
/mob/living/proc/check_HUD_style()
	return


/mob/living/proc/create_HUDinventory()//correct a HUDinventory?
	return
/mob/living/proc/create_HUDneed()
	return
/mob/living/proc/create_HUDfrippery()
	return
///mob/living/proc/create_HUDprocess()
//	return
/mob/living/proc/create_HUDtech()
	return

/*/mob/living/proc/check_HUDdatum(default, target)// NEED REWORK
	if (((!default) || (default = "")) && ((!target) || (target = "")))
		log_debug("[src] try check HUDdatum, but default or target arg is empty")
		return 0

	if((src.client.prefs.UI_style != null) && (src.defaultHUD == null || src.defaultHUD == ""))
		if (!(global.HUDdatums.Find(src.client.prefs.UI_style))) // Проверка наличии данных
			log_debug("[H] try update a HUD, but HUDdatums not have [src.client.prefs.UI_style]!")
			src << "Some problem hase accure, use default HUD type"
			src.defaultHUD = "ErisStyle"
		else
			src.defaultHUD = H.client.prefs.UI_style
		return 1
	return 0

/mob/living/proc/check_HUDneed()
	var/datum/hud/HUDdatum = global.HUDdatums[H.defaultHUD]
	if ((HUDneed.len) && (HUDneed.len == HUDdatums.HUDneed.len)) //Если у моба есть ХУД и кол-во эл. худа соотвсетсвует заявленному
		for (var/i=1,i<=HUDneed.len,i++)
			if(!(HUDdatum.HUDneed.Find(HUDneed[i])) //Если данного худа нет в датуме худа.
				return 0
				break //то нахуй это дерьмо
	else
		return 0
	return 1

/mob/living/proc/check_HUDinventory()
	var/datum/hud/HUDdatum = global.HUDdatums[H.defaultHUD]
	if ((H.HUDinventory.len != 0) && (H.HUDinventory.len == species.hud.gear.len) && !(recreate_flag))
		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			if(!(HUDdatum.slot_data.Find(HUDinv.slot_id) && species.hud.gear.Find(HUDinv.slot_id))) //Если данного slot_id нет в датуме худа и в датуме расы.
				recreate_flag = 1
				break //то нахуй это дерьмо
	else
		recreate_flag = 1*/

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