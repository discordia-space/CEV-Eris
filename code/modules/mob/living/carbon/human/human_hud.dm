/mob/living/carbon/human/check_HUD()
	var/mob/living/carbon/human/H = src
	if(!H.client)
		return

//	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]
	var/recreate_flag = 0

	if(!check_HUDdatum())//проверка настроек клиента на правильность
		log_debug("[H] try check a HUD, but HUDdatums not have \"[H.client.prefs.UI_style]!\"")
		H << "Some problem hase accure, use default HUD type"
		H.defaultHUD = "ErisStyle"
		++recreate_flag
	else if (H.client.prefs.UI_style != H.defaultHUD)//Если стиль у МОБА не совпадает со стилем у клинета
		H.defaultHUD = H.client.prefs.UI_style
		++recreate_flag

	if (recreate_flag)
		H.destroy_HUD()
		H.create_HUD()

	H.show_HUD()

	if(!recreate_flag && !check_HUD_style())
		H.recolor_HUD(H.client.prefs.UI_style_color, H.client.prefs.UI_style_alpha)

	return recreate_flag

/mob/living/carbon/human/check_HUD_style()
	var/mob/living/carbon/human/H = src


	for (var/obj/screen/inventory/HUDinv in H.HUDinventory)

		if (HUDinv.color != H.client.prefs.UI_style_color || HUDinv.alpha != H.client.prefs.UI_style_alpha)
			return 0

	for (var/p in HUDneed)
		var/obj/screen/HUDelm = HUDneed[p]
		if (HUDelm.color != H.client.prefs.UI_style_color || HUDelm.alpha != H.client.prefs.UI_style_alpha)
			return 0
	return 1

/mob/living/carbon/human/check_HUDdatum()//correct a datum?
	var/mob/living/carbon/human/H = src

	if (H.client.prefs.UI_style && !(H.client.prefs.UI_style == "")) //если у клиента моба прописан стиль\тип ХУДа
		if(global.HUDdatums.Find(H.client.prefs.UI_style))//Если существует такой тип ХУДА
			return 1

	return 0

/*/mob/living/carbon/human/check_HUDinventory()//correct a HUDinventory?
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]
	var/mob/living/carbon/human/H = src

	if ((H.HUDinventory.len != 0) && (H.HUDinventory.len == species.hud.gear.len) && !(recreate_flag))
		for (var/obj/screen/inventory/HUDinv in H.HUDinventory)
			if(!(HUDdatum.slot_data.Find(HUDinv.slot_id) && species.hud.gear.Find(HUDinv.slot_id))) //Если данного slot_id нет в датуме худа и в датуме расы.
				recreate_flag = 1
				break //то нахуй это дерьмо
	else
		recreate_flag = 1

	return

/mob/living/carbon/human/check_HUDneed()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	if ((H.HUDneed.len != 0) && (H.HUDneed.len == species.hud.ProcessHUD.len)) //Если у моба есть ХУД и кол-во эл. худа соотвсетсвует заявленному
		for (var/i=1,i<=HUDneed.len,i++)
			if(!(HUDdatum.HUDneed.Find(HUDneed[i]) && species.hud.ProcessHUD.Find(HUDneed[i]))) //Если данного худа нет в датуме худа и в датуме расы.
				recreate_flag = 1
				break //то нахуй это дерьмо
	else
		recreate_flag = 1
	return

/mob/living/carbon/human/check_HUDfrippery()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]
	return
/mob/living/carbon/human/check_HUDprocess()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]
	return
/mob/living/carbon/human/check_HUDtech()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]
	return*/


/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(client)
		check_HUD()
		client.screen |= contents
		//if(hud_used)
			//hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar







/mob/living/carbon/human/create_HUD()
//	var/mob/living/carbon/human/H = src
//	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	create_HUDinventory()
	create_HUDneed()
	create_HUDfrippery()
	create_HUDtech()
	recolor_HUD(src.client.prefs.UI_style_color, src.client.prefs.UI_style_alpha)

/mob/living/carbon/human/create_HUDinventory()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	for (var/gear_slot in species.hud.gear)//Добавляем Элементы ХУДа (инвентарь)
		if (!HUDdatum.slot_data.Find(gear_slot))
			log_debug("[usr] try take inventory data for [gear_slot], but HUDdatum not have it!")
			src << "Sorry, but something wrong witch creating a inventory slots, we recomendend chance a HUD type or call admins"
			return
		else
			var/HUDtype
			if(HUDdatum.slot_data[gear_slot]["type"])
				HUDtype = HUDdatum.slot_data[gear_slot]["type"]
			else
				HUDtype = /obj/screen/inventory

			var/obj/screen/inventory/inv_box = new HUDtype(HUDdatum.slot_data[gear_slot]["name"], HUDdatum.slot_data[gear_slot]["loc"], species.hud.gear[gear_slot], HUDdatum.icon, HUDdatum.slot_data[gear_slot]["state"], H)
			if(HUDdatum.slot_data[gear_slot]["dir"])
				inv_box.set_dir(HUDdatum.slot_data[gear_slot]["dir"])
			if(HUDdatum.slot_data[gear_slot]["hideflag"])
				inv_box.hideflag = HUDdatum.slot_data[gear_slot]["hideflag"]
			H.HUDinventory += inv_box
	return

/mob/living/carbon/human/create_HUDneed()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	for(var/HUDname in species.hud.ProcessHUD) //Добавляем Элементы ХУДа (не инвентарь)
		if (!(HUDdatum.HUDneed.Find(HUDname))) //Ищем такой в датуме
			log_debug("[usr] try create a [HUDname], but it no have in HUDdatum [HUDdatum.name]")
		else
			var/HUDtype = HUDdatum.HUDneed[HUDname]["type"]
			var/obj/screen/HUD = new HUDtype(HUDname, HUDdatum.HUDneed[HUDname]["loc"], H, HUDdatum.HUDneed[HUDname]["icon"] ? HUDdatum.HUDneed[HUDname]["icon"] : HUDdatum.icon, HUDdatum.HUDneed[HUDname]["icon_state"] ? HUDdatum.HUDneed[HUDname]["icon_state"] : null)
/*			if(HUDdatum.HUDneed[HUDname]["icon"])//Анализ на овверайд icon
				HUD.icon = HUDdatum.HUDneed[HUDname]["icon"]
			else
				HUD.icon = HUDdatum.icon
			if(HUDdatum.HUDneed[HUDname]["icon_state"])//Анализ на овверайд icon_state
				HUD.icon_state = HUDdatum.HUDneed[HUDname]["icon_state"]*/
			if(HUDdatum.HUDneed[HUDname]["hideflag"])
				HUD.hideflag = HUDdatum.HUDneed[HUDname]["hideflag"]
			H.HUDneed[HUD.name] += HUD//Добавляем в список худов
			if (HUD.process_flag)//Если худ нужно процессить
				H.HUDprocess += HUD//Вливаем в соотвествующий список

	return
/mob/living/carbon/human/create_HUDfrippery()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	//Добавляем Элементы ХУДа (украшения)
	for (var/list/whistle in HUDdatum.HUDfrippery)
		var/obj/screen/frippery/perdelka = new (whistle["icon_state"],whistle["loc"], whistle["dir"],H)
		perdelka.icon = HUDdatum.icon
		if(whistle["hideflag"])
			perdelka.hideflag = whistle["hideflag"]
		H.HUDfrippery += perdelka
	return

/mob/living/carbon/human/create_HUDtech()
	var/mob/living/carbon/human/H = src
	var/datum/hud/human/HUDdatum = global.HUDdatums[H.defaultHUD]

	//Добавляем технические элементы(damage,flash,pain... оверлеи)
	for (var/techobject in HUDdatum.HUDoverlays)
		var/HUDtype = HUDdatum.HUDoverlays[techobject]["type"]
		var/obj/screen/HUD = new HUDtype(techobject, HUDdatum.HUDoverlays[techobject]["loc"], H)
		if(HUDdatum.HUDoverlays[techobject]["icon"])//Анализ на овверайд icon
			HUD.icon = HUDdatum.HUDoverlays[techobject]["icon"]
		else
			HUD.icon = HUDdatum.icon
		if(HUDdatum.HUDoverlays[techobject]["icon_state"])//Анализ на овверайд icon_state
			HUD.icon_state = HUDdatum.HUDoverlays[techobject]["icon_state"]
		H.HUDtech[HUD.name] += HUD//Добавляем в список худов
		if (HUD.process_flag)//Если худ нужно процессить
			H.HUDprocess += HUD//Вливаем в соотвествующий список
	return