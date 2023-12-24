////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	volume = 50
	bad_type = /obj/item/reagent_containers/food/drinks
	var/base_name // Name to put in front of drinks, i.e. "[base_name] of [contents]"
	var/base_icon // Base icon name for fill states

/obj/item/reagent_containers/food/drinks/Initialize()
	. = ..()
	if(is_drainable())
		verbs += /obj/item/reagent_containers/food/drinks/proc/gulp_whole

/obj/item/reagent_containers/food/drinks/on_reagent_change()
	update_icon()
	return

/obj/item/reagent_containers/food/drinks/attack_self(mob/user as mob)
	if(!is_open_container())
		open(user)

/obj/item/reagent_containers/food/drinks/proc/open(mob/user)
	playsound(loc, 'sound/effects/canopen.ogg', rand(10,50), 1)
	icon_state += "_open"
	to_chat(user, SPAN_NOTICE("You open [src] with an audible pop!"))
	reagent_flags |= OPENCONTAINER
	verbs += /obj/item/reagent_containers/food/drinks/proc/gulp_whole
	update_icon()

/obj/item/reagent_containers/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(dhTotalDamage(melleDamages) && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(standard_pour_into(user, target))
		return
	if(standard_dispenser_refill(user, target))
		return
	return ..()

/obj/item/reagent_containers/food/drinks/is_closed_message(mob/user)
	to_chat(user, SPAN_NOTICE("You need to open [src] first!"))

/obj/item/reagent_containers/food/drinks/self_feed_message(var/mob/user)
	to_chat(user, SPAN_NOTICE("You swallow a gulp from \the [src]."))

/obj/item/reagent_containers/food/drinks/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/reagent_containers/food/drinks/update_icon()
	cut_overlays()
	if(reagents && reagents.total_volume)
		if(base_name)
			var/datum/reagent/R = reagents.get_master_reagent()
			SetName("[base_name] of [R.glass_name ? R.glass_name : "something"]")
			desc = R.glass_desc ? R.glass_desc : initial(desc)
		if(filling_states)
			var/mutable_appearance/filling = mutable_appearance(icon, "[base_icon][get_filling_state()]")
			filling.color = reagents.get_color()
			add_overlay(filling)
	else
		SetName(initial(name))
		desc = initial(desc)

/obj/item/reagent_containers/food/drinks/proc/gulp_whole()
	set category = "Object"
	set name = "Gulp Down"
	set src in view(1)

	if(isghost(usr))
		to_chat(usr, "You can't do this as a ghost.")
		return

	if(is_drainable())
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			if(!H.check_has_mouth())
				to_chat(H, SPAN_NOTICE("Where do you intend to put \the [src]? You don't have a mouth!"))
				return
			var/obj/item/blocked = H.check_mouth_coverage()
			if(blocked)
				to_chat(H, SPAN_NOTICE("\The [blocked] is in the way."))
				return

		if(reagents.total_volume == 0)
			to_chat(usr, SPAN_NOTICE("\The [src] is empty."))
			return
		if(reagents.total_volume > 30) // 30 equates to 3 SECONDS.
			usr.visible_message(SPAN_NOTICE("[usr] prepares to gulp down [src]."), SPAN_NOTICE("You prepare to gulp down [src]."))
		if(!do_after(usr, reagents.total_volume))
			standard_splash_mob(usr, usr)
			return

		if(!Adjacent(usr))
			return

		usr.visible_message(SPAN_NOTICE("[usr] gulped down the whole [src]!"),SPAN_NOTICE("You gulped down the whole [src]!"))
		reagents.trans_to_mob(usr, reagents.total_volume, CHEM_INGEST)
		feed_sound(usr)
	else
		is_closed_message(usr)

////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/golden_cup
	desc = "A golden cup"
	name = "golden cup"
	icon_state = "golden_cup"
	item_state = "" //nope :(
	volumeClass = ITEM_SIZE_BULKY
	throwforce = 10
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = null
	volume = 150
	flags = CONDUCT

///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.

/obj/item/reagent_containers/food/drinks/milk
	name = "Space Milk"
	desc = "It's milk. White and nutritious goodness!"
	icon_state = "milk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	preloaded_reagents = list("milk" = 50)

/obj/item/reagent_containers/food/drinks/soymilk
	name = "SoyMilk"
	desc = "It's soy milk. White and nutritious goodness!"
	icon_state = "soymilk"
	item_state = "carton"
	center_of_mass = list("x"=16, "y"=9)
	preloaded_reagents = list("soymilk" = 50)

/obj/item/reagent_containers/food/drinks/coffee
	name = "Robust Coffee"
	desc = "Careful, the beverage you're about to enjoy is extremely hot."
	icon_state = "coffee"
	center_of_mass = list("x"=15, "y"=10)
	base_icon = "coffee"
	filling_states = "100"
	preloaded_reagents = list("coffee" = 30)

/obj/item/reagent_containers/food/drinks/mug/teacup/ice
	name = "Ice Cup"
	desc = "Careful, cold ice, do not chew."
	preloaded_reagents = list("ice" = 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "Dutch Hot Coco"
	desc = "Made in Space South America."
	icon_state = "hot_coco"
	item_state = "hot_coco"
	center_of_mass = list("x"=15, "y"=13)
	preloaded_reagents = list("hot_coco" = 30)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "Cup Ramen"
	desc = "Just add 10ml water, self heats! A taste that reminds you of your school years."
	icon_state = "ramen"
	center_of_mass = list("x"=16, "y"=11)
	reagent_flags = NONE //starts closed
	base_icon = "cup"
	filling_states = "100"
	preloaded_reagents = list("dry_ramen" = 30)
	spawn_tags = SPAWN_TAG_JUNKFOOD
	rarity_value = 15

/obj/item/reagent_containers/food/drinks/dry_ramen/update_icon()
	if(reagent_flags == OPENCONTAINER)
		if(reagents && reagents.total_volume)
			icon_state = "ramen_open"
		else
			icon_state = "ramenempty"

/obj/item/reagent_containers/food/drinks/energy
	name = "energy drink"
	desc = "A heart attack that fits in your pocket."
	icon_state = "energy_drink"
	center_of_mass = list("x"=15, "y"=13)
	preloaded_reagents = list("sugar" = 10, "adrenaline" = 20)
	spawn_tags = SPAWN_TAG_JUNKFOOD
	rarity_value = 15

/obj/item/reagent_containers/food/drinks/energy/update_icon()
	if(reagent_flags == OPENCONTAINER)
		if(reagents && reagents.total_volume)
			icon_state = "energy_drink_open"
		else
			icon_state = "energy_drink_whacked"

/obj/item/reagent_containers/food/drinks/protein_shake
	name = "protein shake"
	//desc = "Smells like prion disease..."
	desc = "The best thing to drink after a workout, tastes like apples! At least, the description on this plastic bottle says so. Smells odd..."
	icon_state = "protein_shake_bottle"
	center_of_mass = list("x"=16, "y"=8)
	preloaded_reagents = list("protein_shake_commercial" = 40)
	rarity_value = 10
	spawn_tags = SPAWN_TAG_JUNKFOOD

/obj/item/reagent_containers/food/drinks/protein_shake/update_icon()
	if(reagent_flags == OPENCONTAINER)
		if(reagents && reagents.total_volume)
			icon_state = "protein_shake_bottle"
		else
			icon_state = "protein_shake_bottle_whacked"

/obj/item/reagent_containers/food/drinks/sillycup
	name = "paper cup"
	desc = "A paper water cup."
	icon_state = "water_cup_e"
	possible_transfer_amounts = null
	volume = 10
	center_of_mass = list("x"=16, "y"=12)

/obj/item/reagent_containers/food/drinks/sillycup/update_icon()
	if(reagents && reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"


//////////////////////////pitchers, pots, flasks and cups//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A metal shaker to mix drinks in."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,20,30,60,120)
	volume = 120
	center_of_mass = list("x"=17, "y"=10)

/obj/item/reagent_containers/food/drinks/teapot
	name = "teapot"
	desc = "An elegant teapot. It simply oozes class."
	icon_state = "teapot"
	item_state = "teapot"
	matter = list(MATERIAL_STEEL = 1)
	amount_per_transfer_from_this = 10
	volume = 120
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/pitcher
	name = "insulated pitcher"
	desc = "A stainless steel insulated pitcher. Everyone's best friend in the morning."
	icon_state = "pitcher"
	volume = 120
	amount_per_transfer_from_this = 10
	matter = list(MATERIAL_STEEL = 1)
	possible_transfer_amounts = list(5,10,20,30,60,120)
	center_of_mass = "x=16;y=9"
	filling_states = "15;30;50;70;85;100"
	base_icon = "pitcher"

/obj/item/reagent_containers/food/drinks/carafe
	name = "pitcher"
	desc = "A handled glass pitcher."
	icon_state = "carafe"
	item_state = "beaker"
	base_name = "pitcher"
	base_icon = "carafe"
	filling_states = "10;20;30;40;50;60;70;80;90;100"
	volume = 120
	matter = list(MATERIAL_GLASS = 1)
	possible_transfer_amounts = list(5,10,20,30,60,120)
	center_of_mass = "x=16;y=7"

/obj/item/reagent_containers/food/drinks/flask
	name = "captain's flask"
	desc = "A metal flask belonging to the captain"
	icon_state = "flask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "shiny flask"
	desc = "A shiny metal flask. It appears to have a Greek symbol inscribed on it."
	icon_state = "shinyflask"

/obj/item/reagent_containers/food/drinks/flask/lithium
	name = "lithium flask"
	desc = "A flask with a Lithium Atom symbol on it."
	icon_state = "lithiumflask"

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "inspector's flask"
	desc = "A metal flask with a leather band and golden badge belonging to the inspector."
	icon_state = "detflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=8)

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "flask"
	desc = "For those who can't be bothered to hang out at the bar to drink."
	icon_state = "barflask"
	volume = 60
	center_of_mass = list("x"=17, "y"=7)
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 20

/obj/item/reagent_containers/food/drinks/flask/vacuumflask
	name = "vacuum flask"
	desc = "Keeping your drinks at the perfect temperature since 1892."
	icon_state = "vacuumflask"
	volume = 60
	center_of_mass = list("x"=15, "y"=4)

/obj/item/reagent_containers/food/drinks/mug
	name = "mug"
	desc = "A plain mug."
	icon_state = "mug"
	item_state = "cup_old"
	volume = 30
	center_of_mass = "x=15;y=13"
	filling_states = "100"
	base_name = "mug"
	base_icon = "mug"

/obj/item/reagent_containers/food/drinks/mug/gold
	name = "gold mug"
	desc = "A shiny gold-like mug."
	icon_state = "mug_gold"

/obj/item/reagent_containers/food/drinks/mug/old_nt
	name = "NanoTrasen mug"
	desc = "Not even your morning coffee is safe from corporate advertising."
	icon_state = "mug_old_nt"

/obj/item/reagent_containers/food/drinks/mug/new_nt
	name = "NeoTheology mug"
	desc = "A brown mug, it prominently features a tau-cross."
	icon_state = "mug_new_nt"

/obj/item/reagent_containers/food/drinks/mug/syndie
	name = "Syndicate mug"
	desc = "A sleek red mug."
	icon_state = "mug_syndie"

/obj/item/reagent_containers/food/drinks/mug/serb
	name = "Serbian mug"
	desc = "A mug with a Serbian flag emblazoned on it."
	icon_state = "mug_serb"

/obj/item/reagent_containers/food/drinks/mug/ironhammer
	name = "Ironhammer mug"
	desc = "A mug with an Ironhammer PMC logo on it."
	icon_state = "mug_hammer"

/obj/item/reagent_containers/food/drinks/mug/league
	name = "Technomancer mug"
	desc = "A mug with a Technomancer League logo on it."
	icon_state = "mug_league"

/obj/item/reagent_containers/food/drinks/mug/moe
	name = "Moebius mug"
	desc = "A white mug with Moebius Laboratories logo on it."
	icon_state = "mug_moe"

/obj/item/reagent_containers/food/drinks/mug/aster
	name = "Aster mug"
	desc = "A fancy gold mug with a Aster Guild logo on it."
	icon_state = "mug_aster"

/obj/item/reagent_containers/food/drinks/mug/guild
	name = "Guild mug"
	desc = "A plain mug with a Aster Guild logo on it."
	icon_state = "mug_guild"

/obj/item/reagent_containers/food/drinks/mug/white
	name = "white mug"
	desc = "A plain white mug."
	icon_state = "mug_white"

/obj/item/reagent_containers/food/drinks/mug/teacup
	name = "cup"
	desc = "A plain white porcelain teacup."
	icon_state = "_cup"
	base_name = "cup"
	base_icon = "_cup"


//tea and tea accessories
/obj/item/reagent_containers/food/drinks/tea
	name = "cup of tea master item"
	desc = "A tall plastic cup full of the concept and ideal of tea."
	icon_state = "tea"
	item_state = "tea"
	center_of_mass = "x=16;y=14"
	filling_states = "100"
	base_name = "tea"
	base_icon = "tea"

/obj/item/reagent_containers/food/drinks/tea/black
	name = "cup of black tea"
	desc = "A tall plastic cup of hot black tea."
	preloaded_reagents = list("tea" = 30)

/obj/item/reagent_containers/food/drinks/tea/green
	name = "cup of green tea"
	desc = "A tall plastic cup of hot green tea."
	preloaded_reagents = list("greentea" = 30)
