//Grown foods.
/obj/item/reagent_containers/food/snacks/grown

	name = "fruit"
	icon = 'icons/obj/hydroponics_products.dmi'
	icon_state = "blank"
	desc = "Nutritious! Probably."
	slot_flags = SLOT_HOLSTER
	spawn_frequency = 0
	var/plantname
	var/datum/seed/seed
	var/potency = -1


/obj/item/reagent_containers/food/snacks/grown/New(newloc,planttype)

	..()
	if(!dried_type)
		dried_type = type
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

	// Fill the object up with the appropriate reagents.
	if(planttype)
		plantname = planttype

	if(!plantname)
		return

	if(!plant_controller)
		sleep(250) // ugly hack, should mean roundstart plants are fine.
	if(!plant_controller)
		to_chat(world, SPAN_DANGER("Plant controller does not exist and [src] requires it. Aborting."))
		qdel(src)
		return

	seed = plant_controller.seeds[plantname]

	if(!seed)
		return

	name = "[seed.seed_name]"
	trash = seed.get_trash_type()

	update_icon()

	if(!seed.chems)
		return

	potency = seed.get_trait(TRAIT_POTENCY)

	for(var/rid in seed.chems)
		var/list/reagent_data = seed.chems[rid]
		if(reagent_data && reagent_data.len)
			var/rtotal = reagent_data[1]
			var/list/data = list()
			if(reagent_data.len > 1 && potency > 0)
				rtotal += round(potency/reagent_data[2])
			if(rid == "nutriment")
				data[seed.seed_name] = max(1,rtotal)
			reagents.add_reagent(rid,max(1,rtotal),data)
	update_desc()
	if(reagents.total_volume > 0)
		bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/proc/update_desc()

	if(!seed)
		return
	if(!plant_controller)
		sleep(250) // ugly hack, should mean roundstart plants are fine.
	if(!plant_controller)
		to_chat(world, SPAN_DANGER("Plant controller does not exist and [src] requires it. Aborting."))
		qdel(src)
		return

	if(plant_controller.product_descs["[seed.uid]"])
		desc = plant_controller.product_descs["[seed.uid]"]
	else
		var/list/descriptors = list()
		if(reagents.has_reagent("sugar") || reagents.has_reagent("cherryjelly") || reagents.has_reagent("honey") || reagents.has_reagent("berryjuice"))
			descriptors |= "sweet"
		if(reagents.has_reagent("anti_toxin"))
			descriptors |= "astringent"
		if(reagents.has_reagent("frostoil"))
			descriptors |= "numbing"
		if(reagents.has_reagent("nutriment"))
			descriptors |= "nutritious"
		if(reagents.has_reagent("condensedcapsaicin") || reagents.has_reagent("capsaicin"))
			descriptors |= "spicy"
		if(reagents.has_reagent("coco"))
			descriptors |= "bitter"
		if(reagents.has_reagent("orangejuice") || reagents.has_reagent("lemonjuice") || reagents.has_reagent("limejuice"))
			descriptors |= "sweet-sour"
		if(reagents.has_reagent("radium") || reagents.has_reagent(MATERIAL_URANIUM))
			descriptors |= "radioactive"
		if(reagents.has_reagent("amatoxin") || reagents.has_reagent("toxin"))
			descriptors |= "poisonous"
		if(reagents.has_reagent("psilocybin") || reagents.has_reagent("space_drugs"))
			descriptors |= "hallucinogenic"
		if(reagents.has_reagent("bicaridine"))
			descriptors |= "medicinal"
		if(reagents.has_reagent(MATERIAL_GOLD))
			descriptors |= "shiny"
		if(reagents.has_reagent("lube"))
			descriptors |= "slippery"
		if(reagents.has_reagent("pacid") || reagents.has_reagent("sacid") || reagents.has_reagent("hclacid"))
			descriptors |= "acidic"
		if(seed.get_trait(TRAIT_JUICY))
			descriptors |= "juicy"
		if(seed.get_trait(TRAIT_STINGS))
			descriptors |= "stinging"
		if(seed.get_trait(TRAIT_TELEPORTING))
			descriptors |= "glowing"
		if(seed.get_trait(TRAIT_EXPLOSIVE))
			descriptors |= "bulbous"

		var/descriptor_num = rand(2,4)
		var/descriptor_count = descriptor_num
		desc = "A"
		while(descriptors.len && descriptor_num > 0)
			var/chosen = pick(descriptors)
			descriptors -= chosen
			desc += "[(descriptor_count>1 && descriptor_count!=descriptor_num) ? "," : "" ] [chosen]"
			descriptor_num--
		if(seed.seed_noun == "spores")
			desc += " mushroom"
		else
			desc += " fruit"
		plant_controller.product_descs["[seed.uid]"] = desc
	desc += ". Delicious! Probably."

/obj/item/reagent_containers/food/snacks/grown/on_update_icon()
	if(!seed || !plant_controller || !plant_controller.plant_icon_cache)
		return
	cut_overlays()
	var/image/plant_icon
	var/icon_key = "fruit-[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"
	if(plant_controller.plant_icon_cache[icon_key])
		plant_icon = plant_controller.plant_icon_cache[icon_key]
	else
		plant_icon = image('icons/obj/hydroponics_products.dmi',"blank")
		var/image/fruit_base = image('icons/obj/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-product")
		fruit_base.color = "[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
		plant_icon.overlays |= (fruit_base)
		if("[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf" in icon_states('icons/obj/hydroponics_products.dmi'))
			var/image/fruit_leaves = image('icons/obj/hydroponics_products.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]-leaf")
			fruit_leaves.color = "[seed.get_trait(TRAIT_PLANT_COLOUR)]"
			plant_icon.overlays |= (fruit_leaves)
		plant_controller.plant_icon_cache[icon_key] = plant_icon
	associate_with_overlays(plant_icon)

/obj/item/reagent_containers/food/snacks/grown/Crossed(var/mob/living/M)
	if(seed && seed.get_trait(TRAIT_JUICY) == 2)
		if(istype(M))

			if(M.buckled)
				return

			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.shoes && H.shoes.item_flags & NOSLIP)
					return

			M.stop_pulling()
			to_chat(M, SPAN_NOTICE("You slipped on the [name]!"))
			playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			M.Stun(8)
			M.Weaken(5)
			seed.thrown_at(src,M)
			sleep(-1)
			if(src) qdel(src)
			return

/obj/item/reagent_containers/food/snacks/grown/throw_impact(atom/hit_atom)
	if(seed) seed.thrown_at(src,hit_atom)
	..()

/obj/item/reagent_containers/food/snacks/grown/attackby(var/obj/item/W, var/mob/user)

	if(seed)
		if(seed.get_trait(TRAIT_PRODUCES_POWER) && istype(W, /obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/C = W
			if(C.use(5))
				//TODO: generalize this.
				to_chat(user, SPAN_NOTICE("You add some cable to the [src.name] and slide it inside the battery casing."))
				var/obj/item/cell/large/potato/pocell = new /obj/item/cell/large/potato(get_turf(user))
				if(src.loc == user && !(user.l_hand && user.r_hand) && ishuman(user))
					user.put_in_hands(pocell)
				pocell.maxcharge = src.potency * 10
				pocell.charge = pocell.maxcharge
				qdel(src)
				return
		else if(W.sharp)
			if(seed.kitchen_tag == "pumpkin") // Ugggh these checks are awful.
				user.show_message(SPAN_NOTICE("You carve a face into [src]!"), 1)
				new /obj/item/clothing/head/pumpkinhead (user.loc)
				qdel(src)
				return
			else if(seed.chems)
				if((QUALITY_CUTTING in W.tool_qualities) && !isnull(seed.chems["woodpulp"]))
					if(W.use_tool(user, src, WORKTIME_FAST, QUALITY_CUTTING, FAILCHANCE_EASY,  required_stat = STAT_BIO))
						user.show_message(SPAN_NOTICE("You make planks out of \the [src]!"), 1)
						var/flesh_colour = seed.get_trait(TRAIT_FLESH_COLOUR)
						if(!flesh_colour) flesh_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
						for(var/i=0,i<2,i++)
							var/obj/item/stack/material/wood/NG = new (user.loc)
							if(flesh_colour) NG.color = flesh_colour
							for (var/obj/item/stack/material/wood/G in user.loc)
								if(G==NG)
									continue
								if(G.amount>=G.max_amount)
									continue
								G.attackby(NG, user)
							to_chat(user, "You add the newly-formed wood to the stack. It now contains [NG.amount] planks.")
						qdel(src)
					return
				else if(!isnull(seed.chems["potato"]))
					to_chat(user, "You slice \the [src] into sticks.")
					new /obj/item/reagent_containers/food/snacks/rawsticks(get_turf(src))
					qdel(src)
					return
				else if(!isnull(seed.chems["carrotjuice"]))
					to_chat(user, "You slice \the [src] into sticks.")
					new /obj/item/reagent_containers/food/snacks/carrotfries(get_turf(src))
					qdel(src)
					return
				else if(!isnull(seed.chems["soymilk"]))
					to_chat(user, "You roughly chop up \the [src].")
					new /obj/item/reagent_containers/food/snacks/soydope(get_turf(src))
					qdel(src)
					return
				else if(seed.get_trait(TRAIT_FLESH_COLOUR))
					to_chat(user, "You slice up \the [src].")
					var/slices = rand(3,5)
					var/reagents_to_transfer = round(reagents.total_volume/slices)
					for(var/i=0; i<=slices; i++)
						var/obj/item/reagent_containers/food/snacks/fruit_slice/F = new(get_turf(src),seed)
						if(reagents_to_transfer) reagents.trans_to_obj(F,reagents_to_transfer)
					qdel(src)
					return
	..()

/obj/item/reagent_containers/food/snacks/grown/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()

	if(seed && seed.get_trait(TRAIT_STINGS))
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3))
		seed.thrown_at(src, target)
		sleep(-1)
		if(!src)
			return
		if(prob(35))
			if(user)
				to_chat(user, SPAN_DANGER("\The [src] has fallen to bits."))
				user.drop_from_inventory(src)
			qdel(src)

/obj/item/reagent_containers/food/snacks/grown/attack_self(mob/user as mob)

	if(!seed)
		return

	if(istype(user.loc,/turf/space))
		return

	if(user.a_intent == I_HURT)
		user.visible_message(SPAN_DANGER("\The [user] squashes \the [src]!"))
		seed.thrown_at(src,user)
		sleep(-1)
		if(src) qdel(src)
		return

	if(seed.kitchen_tag == "grass")
		user.show_message(SPAN_NOTICE("You make a grass tile out of \the [src]!"), 1)
		var/flesh_colour = seed.get_trait(TRAIT_FLESH_COLOUR)
		if(!flesh_colour) flesh_colour = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		for(var/i=0,i<2,i++)
			var/obj/item/stack/tile/grass/G = new (user.loc)
			if(flesh_colour) G.color = flesh_colour
			for (var/obj/item/stack/tile/grass/NG in user.loc)
				if(G==NG)
					continue
				if(NG.amount>=NG.max_amount)
					continue
				NG.attackby(G, user)
			to_chat(user, "You add the newly-formed grass to the stack. It now contains [G.amount] tiles.")
		qdel(src)
		return

	if(seed.get_trait(TRAIT_SPREAD) > 0)
		to_chat(user, SPAN_NOTICE("You plant the [src.name]."))
		new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
		qdel(src)
		return

/obj/item/reagent_containers/food/snacks/grown/pre_pickup(mob/user)
	if(!seed)
		return FALSE
	if(seed.get_trait(TRAIT_STINGS))
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.gloves)
			return TRUE //We have gloves, so we can pick it up safely
		if(!reagents || reagents.total_volume <= 0)
			return TRUE //Out of reagents
		reagents.remove_any(rand(1,3)) //Todo, make it actually remove the reagents the seed uses.
		seed.do_thorns(H,src)
		seed.do_sting(H,src,pick(BP_R_ARM, BP_L_ARM))
	return ..()

// Predefined types for placing on the map.
/obj/item/reagent_containers/food/snacks/grown/mushroom/libertycap
	plantname = "libertycap"

/obj/item/reagent_containers/food/snacks/grown/ambrosiavulgaris
	plantname = "ambrosia"

/obj/item/reagent_containers/food/snacks/fruit_slice
	name = "fruit slice"
	desc = "A slice of some tasty fruit."
	icon = 'icons/obj/hydroponics_misc.dmi'
	icon_state = ""

var/list/fruit_icon_cache = list()

/obj/item/reagent_containers/food/snacks/fruit_slice/New(var/newloc, var/datum/seed/S)
	..(newloc)
	// Need to go through and make a general image caching controller. Todo.
	if(!istype(S))
		qdel(src)
		return

	name = "[S.seed_name] slice"
	desc = "A slice of \a [S.seed_name]. Tasty, probably."

	var/rind_colour = S.get_trait(TRAIT_PRODUCT_COLOUR)
	var/flesh_colour = S.get_trait(TRAIT_FLESH_COLOUR)
	if(!flesh_colour) flesh_colour = rind_colour
	if(!fruit_icon_cache["rind-[rind_colour]"])
		var/image/I = image(icon,"fruit_rind")
		I.color = rind_colour
		fruit_icon_cache["rind-[rind_colour]"] = I
	associate_with_overlays(fruit_icon_cache["rind-[rind_colour]"])
	if(!fruit_icon_cache["slice-[rind_colour]"])
		var/image/I = image(icon,"fruit_slice")
		I.color = flesh_colour
		fruit_icon_cache["slice-[rind_colour]"] = I
	associate_with_overlays(fruit_icon_cache["slice-[rind_colour]"])
