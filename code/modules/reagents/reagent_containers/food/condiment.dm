
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to69odify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to69ixed-drinks code. If you want an object that starts pre-loaded, you69eed to69ake it in addition to the other code.

//Food items that aren't eaten69ormally and leave an empty container behind.
/obj/item/reagent_containers/food/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	reagent_flags = OPENCONTAINER
	possible_transfer_amounts = list(1,5,10)
	center_of_mass = list("x"=16, "y"=6)
	volume = 50

	attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
		return

	attack_self(var/mob/user as69ob)
		return

	attack(var/mob/M as69ob,69ar/mob/user as69ob,69ar/def_zone)
		standard_feed_mob(user,69)

	afterattack(var/obj/target,69ar/mob/user,69ar/proximity)
		if(!proximity)
			return

		if(standard_pour_into(user, target))
			return
		if(standard_dispenser_refill(user, target))
			return

		if(istype(target, /obj/item/reagent_containers/food/snacks)) // These are69ot opencontainers but we can transfer to them
			if(!reagents || !reagents.total_volume)
				to_chat(user, SPAN_NOTICE("There is69o condiment left in \the 69src69."))
				return

			if(!target.reagents.get_free_space())
				to_chat(user, SPAN_NOTICE("You can't add69ore condiment to \the 69target69."))
				return

			var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
			to_chat(user, SPAN_NOTICE("You add 69trans69 units of the condiment to \the 69target69."))
		else
			..()

	feed_sound(var/mob/user)
		playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

	self_feed_message(var/mob/user)
		to_chat(user, SPAN_NOTICE("You swallow some of contents of \the 69src69."))

	on_reagent_change()
		if(icon_state == "saltshakersmall" || icon_state == "peppermillsmall" || icon_state == "flour")
			return
		if(reagents.reagent_list.len > 0)
			switch(reagents.get_master_reagent_id())
				if("ketchup")
					name = "Ketchup"
					desc = "You feel69ore American already."
					icon_state = "ketchup"
					center_of_mass = list("x"=16, "y"=6)
				if("capsaicin")
					name = "Hotsauce"
					desc = "You can almost TASTE the stomach ulcers69ow!"
					icon_state = "hotsauce"
					center_of_mass = list("x"=16, "y"=6)
				if("enzyme")
					name = "Universal Enzyme"
					desc = "Used in cooking69arious dishes."
					icon_state = "enzyme"
					center_of_mass = list("x"=16, "y"=6)
				if("soysauce")
					name = "Soy Sauce"
					desc = "A salty soy-based flavoring."
					icon_state = "soysauce"
					center_of_mass = list("x"=16, "y"=6)
				if("frostoil")
					name = "Coldsauce"
					desc = "Leaves the tongue69umb in its passage."
					icon_state = "coldsauce"
					center_of_mass = list("x"=16, "y"=6)
				if("sodiumchloride")
					name = "Salt Shaker"
					desc = "Salt. From space oceans, presumably."
					icon_state = "saltshaker"
					center_of_mass = list("x"=16, "y"=10)
				if("blackpepper")
					name = "Pepper69ill"
					desc = "Often used to flavor food or69ake people sneeze."
					icon_state = "peppermillsmall"
					center_of_mass = list("x"=16, "y"=10)
				if("cornoil")
					name = "Corn Oil"
					desc = "A delicious oil used in cooking.69ade from corn."
					icon_state = "oliveoil"
					center_of_mass = list("x"=16, "y"=6)
				if("sugar")
					name = "Sugar"
					desc = "Tastey space sugar!"
					center_of_mass = list("x"=16, "y"=6)
				else
					name = "Misc Condiment Bottle"
					if (reagents.reagent_list.len==1)
						desc = "Looks like it is 69reagents.get_master_reagent_name()69, but you are69ot sure."
					else
						desc = "A69ixture of69arious condiments. 69reagents.get_master_reagent_name()69 is one of them."
					icon_state = "mixedcondiments"
					center_of_mass = list("x"=16, "y"=6)
		else
			icon_state = "emptycondiment"
			name = "Condiment Bottle"
			desc = "An empty condiment bottle."
			center_of_mass = list("x"=16, "y"=6)
			return

/obj/item/reagent_containers/food/condiment/enzyme
	name = "Universal Enzyme"
	desc = "Used in cooking69arious dishes."
	icon_state = "enzyme"
	preloaded_reagents = list("enzyme" = 50)

/obj/item/reagent_containers/food/condiment/sugar
	preloaded_reagents = list("sugar" = 50)

//Seperate from above since it's a small shaker rather then a large one.
/obj/item/reagent_containers/food/condiment/saltshaker
	name = "salt shaker"
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	preloaded_reagents = list("sodiumchloride" = 20)

/obj/item/reagent_containers/food/condiment/peppermill
	name = "pepper69ill"
	desc = "Often used to flavor food or69ake people sneeze."
	icon_state = "peppermillsmall"
	possible_transfer_amounts = list(1,20) //for clown turning the lid off
	amount_per_transfer_from_this = 1
	volume = 20
	preloaded_reagents = list("blackpepper" = 20)

/obj/item/reagent_containers/food/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"
	preloaded_reagents = list("flour" = 30)

