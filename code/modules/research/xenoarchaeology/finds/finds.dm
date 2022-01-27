//original code and idea from Alfie275 (luna era) and ISaidNo (goonservers) - with thanks

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Xenoarchaeological finds

/datum/find
	var/find_type = 0				//random according to the digsite type
	var/excavation_re69uired = 0		//random 5-95%
	var/view_range = 20				//how close excavation has to come to show an overlay on the turf
	var/clearance_range = 3			//how close excavation has to come to extract the item
									//if excavation hits69ar/excavation_re69uired exactly, it's contained find is extracted cleanly without the ore
	var/prob_delicate = 90			//probability it re69uires an active suspension field to69ot insta-crumble
	var/dissonance_spread = 1		//proportion of the tile that is affected by this find
									//used in conjunction with analysis69achines to determine correct suspension field type

/datum/find/New(var/digsite,69ar/exc_re69)
	excavation_re69uired = exc_re69
	find_type = get_random_find_type(digsite)
	clearance_range = rand(2,6)
	dissonance_spread = rand(1500,2500) / 100

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Strange rocks

//have all strange rocks be cleared away using welders for69ow
/obj/item/ore/strangerock
	name = "Strange rock"
	desc = "Seems to have some unusal strata evident throughout it."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "strange"
	spawn_tags = SPAWN_TAG_XENOARCH_ITEM_FOSSIL
	spawn_blacklisted = TRUE
	origin_tech = list(TECH_MATERIAL = 5)
	var/obj/item/inside
	var/method = 0// 0 = fire, 1 = brush, 2 = pick

/obj/item/ore/strangerock/New(loc,69ar/inside_item_type = 0)
	..(loc)
	//method = rand(0,2)
	if(inside_item_type)
		inside =69ew/obj/item/archaeological_find(src, inside_item_type)
		if(!inside)
			inside = locate() in contents

/*/obj/item/ore/strangerock/ex_act(var/severity)
	if(severity && prob(30))
		src.visible_message("The 69src69 crumbles away, leaving some dust and gravel behind.")*/

/obj/item/ore/strangerock/attackby(obj/item/I,69ob/user)
	if(69UALITY_WELDING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_WELDING, FAILCHANCE_EASY, re69uired_stat = STAT_COG))
			if(!src.method)
				if(inside)
					inside.loc = get_turf(src)
					for(var/mob/M in69iewers(world.view, user))
						M.show_message("<span class='info'>69src69 burns away revealing 69inside69.</span>",1)
				else
					for(var/mob/M in69iewers(world.view, user))
						M.show_message("<span class='info'>69src69 burns away into69othing.</span>",1)
				69del(src)
			else
				for(var/mob/M in69iewers(world.view, user))
					M.show_message("<span class='info'>A few sparks fly off 69src69, but69othing else happens.</span>",1)
			return

	else if(istype(I,/obj/item/device/core_sampler/))
		var/obj/item/device/core_sampler/S = I
		S.sample_item(src, user)
		return

	..()
	if(prob(33))
		src.visible_message(SPAN_WARNING("69src69 crumbles away, leaving some dust and gravel behind."))
		69del(src)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Archaeological finds

/obj/item/archaeological_find
	name = "object"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "ano01"
	spawn_tags = SPAWN_TAG_XENOARCH_ITEM_FOSSIL
	spawn_blacklisted = TRUE
	var/find_type = 0

/obj/item/archaeological_find/Initialize(mapload,69ew_item_type)
	. = ..()
	if(new_item_type)
		find_type =69ew_item_type
	else
		find_type = rand(1,34)	//update this when you add69ew find types

	icon_state = "unknown69rand(1,4)69"
	var/item_type = "object"
	var/additional_desc = ""
	var/obj/item/new_item
	var/source_material = ""
	var/apply_material_decorations = 1
	var/apply_image_decorations = 0
	var/material_descriptor = ""
	var/apply_prefix = 1
	if(prob(40))
		material_descriptor = pick("rusted ","dusty ","archaic ","fragile ")
	source_material = pick("cordite","69uadrinium",MATERIAL_STEEL,"titanium","aluminium","ferritic-alloy","plasteel","duranium")

	var/talkative = 0
	if(prob(5))
		talkative = 1

	//for all items here:
	//icon_state
	//item_state
	switch(find_type)
		if(1)
			item_type = "bowl"
			if(prob(33))
				new_item =69ew /obj/item/reagent_containers/glass/replenishing(src.loc)
			else
				new_item =69ew /obj/item/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "bowl"
			apply_image_decorations = 1
			if(prob(20))
				additional_desc = "There appear to be 69pick("dark","faintly glowing","pungent","bright")69 69pick("red","purple","green","blue")69 stains inside."
		if(2)
			item_type = "urn"
			if(prob(33))
				new_item =69ew /obj/item/reagent_containers/glass/replenishing(src.loc)
			else
				new_item =69ew /obj/item/reagent_containers/glass/beaker(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "urn"
			apply_image_decorations = 1
			if(prob(20))
				additional_desc = "It 69pick("whispers faintly","makes a 69uiet roaring sound","whistles softly","thrums 69uietly","throbs")69 if you put it to your ear."
		if(3)
			item_type = "69pick("fork","spoon","knife")69"
			if(prob(25))
				new_item =69ew /obj/item/material/kitchen/utensil/fork(src.loc)
			else if(prob(50))
				new_item =69ew /obj/item/tool/knife(src.loc)
			else
				new_item =69ew /obj/item/material/kitchen/utensil/spoon(src.loc)
			additional_desc = "69pick("It's like69o 69item_type69 you've ever seen before",\
			"How anyone is supposed to eat with this is a69ystery",\
			"You wonder what the creator's69outh was shaped like")69."
		if(4)
			name = "statuette"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "statuette"
			icon_state = "statuette"
			additional_desc = "It depicts a 69pick("small","ferocious","wild","pleasing","hulking")69 \
			69pick("alien figure","rodent-like creature","reptilian alien","primate","unidentifiable object")69 \
			69pick("performing unspeakable acts","posing heroically","in a fetal position","cheering","sobbing","making a plaintive gesture","making a rude gesture")69."
			if(prob(25))
				new_item =69ew /obj/item/vampiric(src.loc)
		if(5)
			name = "instrument"
			icon = 'icons/obj/xenoarchaeology.dmi'
			item_type = "instrument"
			icon_state = "instrument"
			if(prob(30))
				apply_image_decorations = 1
				additional_desc = "69pick("You're69ot sure how anyone could have played this",\
				"You wonder how69any69ouths the creator had",\
				"You wonder what it sounds like",\
				"You wonder what kind of69usic was69ade with it")69."
		if(6)
			item_type = "69pick("bladed knife","serrated blade","sharp cutting implement")69"
			new_item =69ew /obj/item/tool/knife(src.loc)
			additional_desc = "69pick("It doesn't look safe.",\
			"It looks wickedly jagged",\
			"There appear to be 69pick("dark red","dark purple","dark green","dark blue")69 stains along the edges")69."
		if(7)
			//assuming there are 10 types of coins
			var/chance = 10
			for(var/type in typesof(/obj/item/coin))
				if(prob(chance))
					new_item =69ew type(src.loc)
					break
				chance += 10

			item_type =69ew_item.name
			apply_prefix = 0
			apply_material_decorations = 0
			apply_image_decorations = 1
		if(8)
			item_type = "handcuffs"
			new_item =69ew /obj/item/handcuffs(src.loc)
			additional_desc = "69pick("They appear to be for securing two things together","Looks kinky","Doesn't seem like a children's toy")69."
		if(9)
			item_type = "69pick("wicked","evil","byzantine","dangerous")69 looking 69pick("device","contraption","thing","trap")69"
			apply_prefix = 0
			new_item =69ew /obj/item/beartrap(src.loc)
			additional_desc = "69pick("It looks like it could take a limb off",\
			"Could be some kind of animal trap",\
			"There appear to be 69pick("dark red","dark purple","dark green","dark blue")69 stains along part of it")69."
		if(10)
			item_type = "69pick("cylinder","tank","chamber")69"
			new_item =69ew /obj/item/flame/lighter(src.loc)
			additional_desc = "There is a tiny device attached."
			if(prob(30))
				apply_image_decorations = 1
		if(11)
			item_type = "box"
			new_item =69ew /obj/item/storage/box(src.loc)
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "box"
			var/obj/item/storage/box/new_box =69ew_item
			new_box.max_w_class = pick(\
				prob(1);ITEM_SIZE_TINY,
				prob(2);ITEM_SIZE_SMALL,
				prob(3);ITEM_SIZE_NORMAL,
				prob(2);ITEM_SIZE_BULKY\
			)
			var/storage_amount = 2**(new_box.max_w_class-1)
			new_box.max_storage_space = rand(storage_amount, storage_amount * 10)
			if(prob(30))
				apply_image_decorations = 1
		if(12)
			item_type = "69pick("cylinder","tank","chamber")69"
			if(prob(25))
				new_item =69ew /obj/item/tank/air(src.loc)
			else if(prob(50))
				new_item =69ew /obj/item/tank/anesthetic(src.loc)
			else
				new_item =69ew /obj/item/tank/plasma(src.loc)
			icon_state = pick("oxygen","oxygen_fr","oxygen_f","plasma","anesthetic")
			additional_desc = "It 69pick("gloops","sloshes")69 slightly when you shake it."
		if(13)
			item_type = "tool"
			if(prob(25))
				new_item =69ew /obj/item/tool/wrench(src.loc)
			else if(prob(25))
				new_item =69ew /obj/item/tool/crowbar(src.loc)
			else
				new_item =69ew /obj/item/tool/screwdriver(src.loc)
			additional_desc = "69pick("It doesn't look safe.",\
			"You wonder what it was used for",\
			"There appear to be 69pick("dark red","dark purple","dark green","dark blue")69 stains on it")69."
		if(14)
			apply_material_decorations = 0
			var/list/possible_spawns = list()
			possible_spawns += /obj/item/stack/material/steel
			possible_spawns += /obj/item/stack/material/plasteel
			possible_spawns += /obj/item/stack/material/glass
			possible_spawns += /obj/item/stack/material/glass/reinforced
			possible_spawns += /obj/item/stack/material/plasma
			possible_spawns += /obj/item/stack/material/gold
			possible_spawns += /obj/item/stack/material/silver
			possible_spawns += /obj/item/stack/material/uranium
			possible_spawns += /obj/item/stack/material/sandstone
			possible_spawns += /obj/item/stack/material/silver

			var/new_type = pick(possible_spawns)
			new_item =69ew69ew_type(src.loc)
			new_item:amount = rand(5,45)
		if(15)
			if(prob(75))
				new_item =69ew /obj/item/pen(src.loc)
			else
				new_item =69ew /obj/item/pen/reagent/sleepy(src.loc)
			if(prob(30))
				apply_image_decorations = 1
		if(16)
			apply_prefix = 0
			if(prob(25))
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "smooth green crystal"
				icon_state = "green_lump"
			else if(prob(33))
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "irregular purple crystal"
				icon_state = "phazon"
			else
				icon = 'icons/obj/xenoarchaeology.dmi'
				item_type = "rough red crystal"
				icon_state = "changerock"
			additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's69esmerizing to behold.")

			apply_material_decorations = 0
			if(prob(10))
				apply_image_decorations = 1
		if(17 to 18)
			new_item =69ew /obj/item/device/radio/beacon(src.loc)
			talkative = 0
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'
			new_item.icon_state = "unknown69rand(1,4)69"
			new_item.desc = ""
		if(19 to 20)
			apply_prefix = 0
			new_item =69ew /obj/item/tool/sword(src.loc)
			new_item.force = 10
			item_type =69ew_item.name
		if(21 to 22)
			if(prob(50))
				new_item =69ew /obj/item/material/shard(src.loc)
			else
				new_item =69ew /obj/item/material/shard/plasma(src.loc)
			apply_prefix = 0
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(23)
			apply_prefix = 0
			new_item =69ew /obj/item/stack/rods(loc)
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(24)
			var/list/possible_spawns = typesof(/obj/item/stock_parts)
			possible_spawns -= /obj/item/stock_parts
			possible_spawns -= /obj/item/stock_parts/subspace

			var/new_type = pick(possible_spawns)
			new_item =69ew69ew_type(src.loc)
			item_type =69ew_item.name
			apply_material_decorations = 0
		if(25)
			apply_prefix = 0
			new_item =69ew /obj/item/tool/sword/katana(src.loc)
			new_item.force = 10
			item_type =69ew_item.name
		if(26)
			//energy gun
			var/spawn_type = pick(\
			/obj/item/gun/energy/laser/practice/xenoarch,\
			/obj/item/gun/energy/laser/xenoarch,\
			/obj/item/gun/energy/xray/xenoarch,\
			/obj/item/gun/energy/captain/xenoarch)
			if(spawn_type)
				var/obj/item/gun/energy/new_gun =69ew spawn_type(src.loc)
				new_item =69ew_gun
				new_item.icon_state = "egun69rand(1,6)69"
				new_gun.desc = "This is an anti69ue energy weapon, you're69ot sure if it will fire or69ot."

				//5% chance to explode when first fired
				//10% chance to have an unchargeable cell
				//15% chance to gain a random amount of starting energy, otherwise start with an empty cell
				if(prob(5))
					new_gun.cell.rigged = TRUE
				if(prob(10))
					new_gun.cell.maxcharge = 0
				if(prob(15))
					new_gun.cell.charge = rand(0,69ew_gun.cell.maxcharge)
				else
					new_gun.cell.charge = 0

			item_type = "gun"
		if(27)
			//revolver
			var/obj/item/gun/projectile/new_gun =69ew /obj/item/gun/projectile/revolver(src.loc)
			new_item =69ew_gun
			new_item.icon_state = "gun69rand(1,4)69"
			new_item.icon = 'icons/obj/xenoarchaeology.dmi'

			//33% chance to be able to reload the gun with human ammunition
			if(prob(66))
				new_gun.caliber = "999"

			//33% chance to fill it with a random amount of bullets
			new_gun.max_shells = rand(1,12)
			if(prob(33))
				var/num_bullets = rand(1,new_gun.max_shells)
				if(num_bullets <69ew_gun.loaded.len)
					new_gun.loaded.Cut()
					for(var/i = 1, i <=69um_bullets, i++)
						var/A =69ew_gun.ammo_type
						new_gun.loaded +=69ew A(new_gun)
				else
					for(var/obj/item/I in69ew_gun)
						if(new_gun.loaded.len >69um_bullets)
							if(I in69ew_gun.loaded)
								new_gun.loaded.Remove(I)
								I.loc =69ull
						else
							break
			else
				for(var/obj/item/I in69ew_gun)
					if(I in69ew_gun.loaded)
						new_gun.loaded.Remove(I)
						I.loc =69ull

			item_type = "gun"
		if(28)
			//completely unknown alien device
			if(prob(50))
				apply_image_decorations = 0
		if(29)
			//fossil bone/skull
			//new_item =69ew /obj/item/fossil/base(src.loc)

			//the replacement item propogation isn't working, and it's69essy code anyway so just do it here
			var/list/candidates = list("/obj/item/fossil/bone"=9,"/obj/item/fossil/skull"=3,
			"/obj/item/fossil/skull/horned"=2)
			var/spawn_type = pickweight(candidates)
			new_item =69ew spawn_type(src.loc)

			apply_prefix = 0
			additional_desc = "A fossilised part of an alien, long dead."
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(30)
			//fossil shell
			new_item =69ew /obj/item/fossil/shell(src.loc)
			apply_prefix = 0
			additional_desc = "A fossilised, pre-Stygian alien crustacean."
			apply_image_decorations = 0
			apply_material_decorations = 0
			if(prob(10))
				apply_image_decorations = 1
		if(31)
			//fossil plant
			new_item =69ew /obj/item/fossil/plant(src.loc)
			item_type =69ew_item.name
			additional_desc = "A fossilised shred of alien plant69atter."
			apply_image_decorations = 0
			apply_material_decorations = 0
			apply_prefix = 0
		if(32)
			//humanoid remains
			apply_prefix = 0
			item_type = "humanoid 69pick("remains","skeleton")69"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remains"
			additional_desc = pick("They appear almost human.",\
			"They are contorted in a69ost gruesome way.",\
			"They look almost peaceful.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by69umerous burns and partially69elted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"The69outh is wide open in a death rictus, the69ictim would appear to have died screaming.")
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(33)
			//robot remains
			apply_prefix = 0
			item_type = "69pick("mechanical","robotic","cyborg")69 69pick("remains","chassis","debris")69"
			icon = 'icons/mob/robots.dmi'
			icon_state = "remainsrobot"
			additional_desc = pick("Almost69istakeable for the remains of a69odern cyborg.",\
			"They are barely recognisable as anything other than a pile of waste69etals.",\
			"It looks like the battered remains of an ancient robot chassis.",\
			"The chassis is rusting and old, but remarkably well preserved.",\
			"The chassis is scored by69umerous burns and partially69elted.",\
			"The chassis is battered and broken, in some cases only chunks of69etal are left.",\
			"A pile of wires and crap69etal that looks69aguely robotic.")
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(34)
			//xenos remains
			apply_prefix = 0
			item_type = "alien 69pick("remains","skeleton")69"
			icon = 'icons/effects/blood.dmi'
			icon_state = "remainsxeno"
			additional_desc = pick("It looks69aguely reptilian, but with69ore teeth.",\
			"They are faintly unsettling.",\
			"There is a faint aura of unease about them.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by69umerous burns and partially69elted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"This creature would have been twisted and69onstrous when it was alive.",\
			"It doesn't look human.")
			apply_image_decorations = 0
			apply_material_decorations = 0
		if(35)
			//gas69ask
			if(prob(25))
				new_item =69ew /obj/item/clothing/mask/gas/poltergeist(src.loc)
			else
				new_item =69ew /obj/item/clothing/mask/gas(src.loc)
	var/decorations = ""
	if(apply_material_decorations)
		source_material = pick("cordite","69uadrinium",MATERIAL_STEEL,"titanium","aluminium","ferritic-alloy","plasteel","duranium")
		desc = "A 69material_descriptor ? "69material_descriptor69 " : ""6969item_type6969ade of 69source_material69, all craftsmanship is of 69pick("the lowest","low","average","high","the highest")69 69uality."

		var/list/descriptors = list()
		if(prob(30))
			descriptors.Add("is encrusted with 69pick("","synthetic ","multi-faceted ","uncut ","sparkling ") + pick("rubies","emeralds","diamonds","opals","lapiz lazuli")69")
		if(prob(30))
			descriptors.Add("is studded with 69pick("gold","gold","aluminium","titanium")69")
		if(prob(30))
			descriptors.Add("is encircled with bands of 69pick("69uadrinium","cordite","ferritic-alloy","plasteel","duranium")69")
		if(prob(30))
			descriptors.Add("menaces with spikes of 69pick("solid plasma",MATERIAL_URANIUM,"white pearl","black steel")69")
		if(descriptors.len > 0)
			decorations = "It "
			for(var/index=1, index <= descriptors.len, index++)
				if(index > 1)
					if(index == descriptors.len)
						decorations += " and "
					else
						decorations += ", "
				decorations += descriptors69index69
			decorations += "."
		if(decorations)
			desc += " " + decorations

	var/engravings = ""
	if(apply_image_decorations)
		engravings = "69pick("Engraved","Carved","Etched")69 on the item is 69pick("an image of","a frieze of","a depiction of")69 \
		69pick("an alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")69 \
		69pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")69 \
		69pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")69"
		if(prob(50))
			engravings += ", 69pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are69aking gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")69"
		engravings += "."

		if(desc)
			desc += " "
		desc += engravings

	if(apply_prefix)
		name = "69pick("Strange","Ancient","Alien","")69 69item_type69"
	else
		name = item_type

	if(desc)
		desc += " "
	desc += additional_desc
	if(!desc)
		desc = "This item is completely 69pick("alien","bizarre")69."

	//icon and icon_state should have already been set
	if(new_item)
		new_item.name =69ame
		new_item.desc = src.desc

		if(talkative)
			new_item.talking_atom =69ew(new_item)

		return INITIALIZE_HINT_69DEL

	else if(talkative)
		src.talking_atom =69ew(src)
