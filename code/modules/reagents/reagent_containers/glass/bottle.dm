//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	filling_states = "20;40;60;80;100"
	label_icon_state = "label_bottle"
	lid_icon_state = "lid_bottle"

/obj/item/reagent_containers/glass/bottle/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling =69utable_appearance('icons/obj/reagentfillings.dmi', "69icon_state69-69get_filling_state()69")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(has_lid())
		var/lid_icon = lid_icon_state ? lid_icon_state : "lid_69icon_state69"
		var/mutable_appearance/lid =69utable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text)
		var/label_icon = label_icon_state ? label_icon_state : "label_69icon_state69"
		var/mutable_appearance/label =69utable_appearance(icon, label_icon)
		add_overlay(label)

/obj/item/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon_state = "bottle"
	preloaded_reagents = list("inaprovaline" = 60)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do69ot drink, it is poisonous."
	icon_state = "bottle"
	preloaded_reagents = list("toxin" = 60)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon_state = "bottle"
	preloaded_reagents = list("cyanide" = 30)

/obj/item/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes69ake you sleepy."
	icon_state = "bottle"
	preloaded_reagents = list("stoxin" = 60)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A small bottle of chloral hydrate.69ickey's Favorite!"
	icon_state = "bottle"
	preloaded_reagents = list("chloralhydrate" = 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon_state = "bottle"
	preloaded_reagents = list("anti_toxin" = 60)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable69utagen bottle"
	desc = "A small bottle of unstable69utagen. Randomly changes the DNA structure of whoever comes in contact."
	icon_state = "bottle"
	preloaded_reagents = list("mutagen" = 60)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	preloaded_reagents = list("ammonia" = 60)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	preloaded_reagents = list("diethylamine" = 60)

/obj/item/reagent_containers/glass/bottle/pacid
	name = "polytrinic acid bottle"
	desc = "A small bottle. Contains a small amount of polytrinic acid."
	icon_state = "bottle"
	preloaded_reagents = list("pacid" = 60)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."
	icon_state = "bottle"
	preloaded_reagents = list("capsaicin" = 60)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "frost oil bottle"
	desc = "A small bottle. Contains cold sauce."
	icon_state = "bottle"
	preloaded_reagents = list("frostoil" = 60)


/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "adminordrazine bottle"
	desc = "A small bottle. Contains the li69uid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	preloaded_reagents = list("adminordrazine" = 60)

/obj/item/reagent_containers/glass/bottle/resuscitator
	name = "resuscitator bottle"
	desc = "A small bottle. Contains your last hope to survive."
	icon_state = "bottle"
	spawn_blacklisted = TRUE
	preloaded_reagents = list("resuscitator" = 60)
