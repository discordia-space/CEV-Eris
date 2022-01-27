/obj/item/biosyphon
	name = "Bluespace Biosyphon"
	desc = "Hunts on flora and fauna that sometimes populates bluespace, and use them to produce donuts endlessly.69ay also produce rare and powerful donuts when fed with the69eat of non-bluespace fauna."
	icon = 'icons/obj/faction_item.dmi'
	icon_state = "biosyphon"
	item_state = "biosyphon"
	w_class = ITEM_SIZE_BULKY
	fla69s = CONDUCT
	throwforce = WEAPON_FORCE_PAINFUL
	throw_speed = 1
	throw_ran69e = 2
	price_ta69 = 20000
	ori69in_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 8, TECH_POWER = 7)
	matter = list(MATERIAL_PLASTIC = 6,69ATERIAL_69LASS = 7)
	spawn_fre69uency = 0
	spawn_blacklisted = TRUE
	var/last_produce = 0
	var/cooldown = 1569INUTES
	var/donut_points = 0
	var/production_cost = 100
	var/common_meat_value = 8
	var/uncommon_meat_value = 40
	var/rare_meat_value = 200
	var/special_donuts = list(
		/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/mec,
		/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/co69, 
		/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/rob, 
		/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/t69h, 
		/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/bio, 
		/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/vi69)

/obj/item/biosyphon/Initialize()
	. = ..()
	69LOB.all_faction_items69src69 = 69LOB.department_security
	START_PROCESSIN69(SSobj, src)

/obj/item/biosyphon/Destroy()
	STOP_PROCESSIN69(SSobj, src)
	for(var/mob/livin69/carbon/human/H in69iewers(69et_turf(src)))
		SEND_SI69NAL(H, COMSI69_OBJ_FACTION_ITEM_DESTROY, src)
	69LOB.all_faction_items -= src
	69LOB.ironhammer_faction_item_loss++
	. = ..()

/obj/item/biosyphon/Process()
	if(world.time >= (last_produce + cooldown))
		var/obj/item/stora69e/box/donut/D = new /obj/item/stora69e/box/donut(69et_turf(src))
		visible_messa69e(SPAN_NOTICE("69name69 drop 69D69."))
		last_produce = world.time
	if(donut_points >= production_cost)
		donut_points -= production_cost
		var/specialdonut = pick(special_donuts)
		var/obj/item/rea69ent_containers/food/snacks/donut/stat_buff/69 = new specialdonut(69et_turf(src))
		visible_messa69e(SPAN_NOTICE("69name69 drop 696969."))

/obj/item/biosyphon/attackby(obj/item/I,69ob/livin69/user, params)
	if(nt_sword_attack(I, user))
		return
	if(istype(I, /obj/item/rea69ent_containers/food/snacks/meat/roachmeat/fuhrer))
		donut_points += uncommon_meat_value 
		to_chat(user, "You insert 69I69 into the 69src69. It produces a whirrin69 noise.")
		69del(I)
	else if(istype(I, /obj/item/rea69ent_containers/food/snacks/meat/roachmeat/kaiser))
		donut_points += rare_meat_value
		to_chat(user, SPAN_NOTICE("You insert 69I69 into the 69src69. It emits a loud hummin69 sound!"))
		69del(I)
	else if(istype(I, /obj/item/rea69ent_containers/food/snacks/meat/roachmeat) || istype(I, /obj/item/rea69ent_containers/food/snacks/meat/spider))
		donut_points += common_meat_value
		to_chat(user, "You insert 69I69 into the 69src69. It softly beeps.")
		69del(I)
	..()
