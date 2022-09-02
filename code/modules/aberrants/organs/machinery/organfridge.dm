/obj/machinery/smartfridge/secure/medbay/organs
	name = "Organ Freezer"
	desc = "A refrigerated storage unit for organs."
	icon_state = "smartfridge"
	icon_on = "smartfridge"
	icon_off = "smartfridge-off"
	icon_panel = "organfridge-panel"
	icon_fill10 = "organfridge-fill10"
	icon_fill20 = "organfridge-fill20"
	icon_fill30 = "organfridge-fill30"

/obj/machinery/smartfridge/secure/medbay/organs/accept_check(obj/item/O)
	if(istype(O, /obj/item/organ))
		return TRUE
	if(istype(O, /obj/item/modification/organ))
		return TRUE
	if(istype(O, /obj/item/storage/freezer))
		return TRUE
	if(istype(O, /obj/item/computer_hardware/hard_drive/portable/design/omg))
		return TRUE
	if(istype(O, /obj/item/computer_hardware/hard_drive/portable/design/medical))
		return TRUE
	if(istype(O, /obj/item/computer_hardware/hard_drive/portable/design/surgery))
		return TRUE	
	return FALSE

/obj/machinery/vending/organfridge_aberrant
	name = "Oh My Guts!"
	desc = "Grass-fed organic organs or your money back!"
	icon = 'icons/obj/machines/organ_vendor.dmi'
	icon_state = "organfridge"
	product_slogans = "Don\'t be heartless!;Can you stomach these prices?!;You don\'t have the guts, pal!"
	product_ads = "Don\'t be heartless!;Can you stomach these prices?!;You don\'t have the guts, pal!"
	spawn_tags = SPAWN_TAG_ABERRANT_VENDOR_ORGANS
	spawn_frequency = 10
	rarity_value = 40
	vendor_department = DEPARTMENT_OFFSHIP
	var/icon_on = "organfridge"
	var/icon_off = "organfridge-off"
	var/icon_panel = "organfridge-panel"
	var/icon_fill10 = "organfridge-fill10"
	var/icon_fill20 = "organfridge-fill20"
	var/icon_fill30 = "organfridge-fill30"
	var/light_colors = list("red", "yellow", "green")
	var/contents_current
	products = list(
		/obj/item/organ/internal/scaffold = 3,
		/obj/item/storage/freezer/medical = 5,
		/obj/item/tool/scalpel/laser = 1,
		/obj/item/organ/internal/scaffold/aberrant/teratoma/input = 6,
		/obj/item/organ/internal/scaffold/aberrant/teratoma/process = 9,
		/obj/item/organ/internal/scaffold/aberrant/teratoma/output = 6
	)
	contraband = list(
		/obj/item/computer_hardware/hard_drive/portable/design/omg/teratoma = 1
	)
	premium = list(
		/obj/item/computer_hardware/hard_drive/portable/design/omg/teratoma_rare = 1
	)
	prices = list(
		/obj/item/organ/internal/scaffold = 100,
		/obj/item/storage/freezer/medical = 34,
		/obj/item/tool/scalpel/laser = 16,
		/obj/item/organ/internal/scaffold/aberrant/teratoma/input = 500,
		/obj/item/organ/internal/scaffold/aberrant/teratoma/process = 500,
		/obj/item/organ/internal/scaffold/aberrant/teratoma/output = 500,
		/obj/item/computer_hardware/hard_drive/portable/design/omg/teratoma = 0,
		/obj/item/computer_hardware/hard_drive/portable/design/omg/teratoma_rare = 0
	)

/obj/machinery/vending/organfridge_aberrant/New()
	..()
	var/light_color = pick(\
		COLOR_LIGHTING_RED_DARK,\
		COLOR_LIGHTING_BLUE_DARK,\
		COLOR_LIGHTING_GREEN_DARK,\
		COLOR_LIGHTING_ORANGE_DARK,\
		COLOR_LIGHTING_PURPLE_DARK,\
		COLOR_LIGHTING_CYAN_DARK\
		)
	set_light(1.4, 1, light_color)
	earnings_account = department_accounts[vendor_department]

	contents_current = 0
	for(var/i in products)
		contents_current += products[i]
	for(var/i in contraband)
		contents_current += contraband[i]

	wires = new /datum/wires/vending/intermediate(src)

	update_icon()

/obj/machinery/vending/organfridge_aberrant/update_icon()
	cut_overlays()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

	if(panel_open && icon_panel)
		overlays += image(icon, icon_panel)
	else
		overlays += image(icon, "fridge_light-top_left-" + pick(light_colors))
		overlays += image(icon, "fridge_light-top_right-" + pick(light_colors))
		overlays += image(icon, "fridge_light-bottom_left-" + pick(light_colors))
		overlays += image(icon, "fridge_light-bottom_right-" + pick(light_colors))

	if(contents_current > 0)
		if(contents_current <= 10)
			overlays += image(icon, icon_fill10)
		else if(contents_current <= 20)
			overlays += image(icon, icon_fill20)
		else
			overlays += image(icon, icon_fill30)



/obj/machinery/vending/organfridge_aberrant/attackby()
	. = ..()
	update_icon()	// Vending code doesn't update the whole sprite when the panel is opened/closed

/obj/machinery/vending/organfridge_aberrant/vend()
	..()
	if(!currently_vending)
		contents_current -= 1
		update_icon()

/obj/machinery/vending/organfridge_aberrant/stock()
	..()
	contents_current += 1
	update_icon()

/obj/machinery/vending/organfridge_aberrant/update_icon()
	..()
	overlays += image(icon, "organfridge_screen-omg")

/obj/machinery/vending/organfridge_aberrant/simple
	name = "OMG! The Classics"
	desc = "The classic organs from the original OMG! Mart. Oh My Guts!"
	product_slogans = "Do you have the guts?;Your liver will thank you!;It's what\'s on the inside that counts!"
	product_ads = "Do you have the guts?;Your liver will thank you!;It's what\'s on the inside that counts!"
	rarity_value = 60
	products = list(
		/obj/item/storage/freezer/medical = 5,
		/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/blood = 3,
		/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/ingest = 3,
		/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/touch = 3
	)
	contraband = list(
		/obj/item/computer_hardware/hard_drive/portable/design/omg/simple = 1
	)
	premium = list(
		/obj/item/organ/internal/scaffold/aberrant/gastric = 3,
		/obj/item/organ/internal/scaffold/aberrant/damage_response = 3
	)
	prices = list(
		/obj/item/storage/freezer/medical = 34,
		/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/blood = 1000,
		/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/ingest = 1000,
		/obj/item/organ/internal/scaffold/aberrant/scrub_toxin/touch = 1000,
		/obj/item/computer_hardware/hard_drive/portable/design/omg/simple = 0,
		/obj/item/organ/internal/scaffold/aberrant/gastric = 1000,
		/obj/item/organ/internal/scaffold/aberrant/damage_response = 1000
	)

/obj/machinery/vending/organfridge_aberrant/alcoholic
	name = "OMG! Discount Organs"
	desc = "Humanely harvested discount organs! Oh My Guts!"
	product_slogans = "Get a heart on!;At least, you\'ll be beautiful on the inside!;No guts, no glory!"
	product_ads = "Get a heart on!;At least, you\'ll be beautiful on the inside!;No guts, no glory!"
	rarity_value = 80
	products = list(
		/obj/item/storage/freezer/medical = 10,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/liver = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/stomach = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/kidney = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/liver = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/stomach = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/kidney = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy/liver = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy/stomach = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy/kidney = 3
	)
	contraband = list(
		/obj/item/computer_hardware/hard_drive/portable/design/omg/alcoholic = 1
	)
	premium = list(
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater = 5,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic = 5,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy = 5
	)
	prices = list(
		/obj/item/storage/freezer/medical = 34,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/liver = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/stomach = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater/kidney = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/liver = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/stomach = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic/kidney = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy/liver = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy/stomach = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy/kidney = 1500,
		/obj/item/computer_hardware/hard_drive/portable/design/omg/alcoholic = 0,
		/obj/item/organ/internal/scaffold/aberrant/dependent/wifebeater = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/functional_alcoholic = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/classy = 1500
	)

/obj/machinery/vending/organfridge_aberrant/addict
	name = "OMG! Refurbished Organs"
	desc = "Humanely harvested refurbished organs! Oh My Guts!"
	product_slogans = "Bad kidney? Sounds like you\'re in trouble.;You only liver once!;I've got you under my skin!"
	product_ads = "Bad kidney? Sounds like you\'re in trouble.;You only liver once!;I've got you under my skin!"
	rarity_value = 80
	products = list(
		/obj/item/storage/freezer/medical = 10,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/blood_vessel = 6,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/liver = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/muscle = 6,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/blood_vessel = 6,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/liver = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/kidney = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/blood_vessel = 6,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/liver = 3,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/muscle = 6
	)
	contraband = list(
		/obj/item/computer_hardware/hard_drive/portable/design/omg/addict = 1
	)
	premium = list(
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster = 5,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist = 5,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary = 5
	)
	prices = list(
		/obj/item/storage/freezer/medical = 34,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/blood_vessel = 750,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/liver = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster/muscle = 750,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/blood_vessel = 750,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/liver = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist/kidney = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/blood_vessel = 750,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/liver = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary/muscle = 750,
		/obj/item/computer_hardware/hard_drive/portable/design/omg/addict = 0,
		/obj/item/organ/internal/scaffold/aberrant/dependent/mobster = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/chemist = 1500,
		/obj/item/organ/internal/scaffold/aberrant/dependent/exmercenary = 1500
	)

// Unused organ slogans: "Come back if you have a change of heart!;Broken heart? We've got you covered!;;I've got you deep in the heart of me!;Owner of a lonely heart?; Owner of a broken heart?"
//						 "Wanna liver 'nother day?;Cry me a liver!;You got a bone to pick with me?;Let liver let die!;Bone appetit!"
