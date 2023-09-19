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
	var/force_label = FALSE // if we force a label appear on the sprite, needed for chemmaster bottles

/obj/item/reagent_containers/glass/bottle/update_icon()
	cut_overlays()

	if(reagents?.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]-[get_filling_state()]")
		filling.color = reagents.get_color()
		add_overlay(filling)

	if(has_lid())
		var/lid_icon = lid_icon_state ? lid_icon_state : "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text || force_label || (preloaded_reagents && display_label))
		var/label_icon = label_icon_state ? label_icon_state : "label_[icon_state]"
		var/mutable_appearance/label = mutable_appearance(icon, label_icon)
		add_overlay(label)

/obj/item/reagent_containers/glass/bottle/New()
	..()
	if(preloaded_reagents)
		if(!has_lid())
			toggle_lid()

/obj/item/reagent_containers/glass/bottle/trade
	spawn_blacklisted = TRUE

/obj/item/reagent_containers/glass/bottle/trade/New()
	for(var/reagent_id in preloaded_reagents)
		var/reagent_name = lowertext(get_reagent_name_by_id(reagent_id))
		name = "[reagent_name] bottle"
		desc = "A small bottle. Contains [reagent_name]."
	..()

/obj/item/reagent_containers/glass/bottle/inaprovaline
	name = "Inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	preloaded_reagents = list("inaprovaline" = 60)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "Toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	preloaded_reagents = list("toxin" = 60)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "Cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	preloaded_reagents = list("cyanide" = 30)

/obj/item/reagent_containers/glass/bottle/stoxin
	name = "Soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	preloaded_reagents = list("stoxin" = 60)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "Chloral Hydrate bottle"
	desc = "A small bottle of chloral hydrate. Mickey's Favorite!"
	preloaded_reagents = list("chloralhydrate" = 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "Dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	preloaded_reagents = list("anti_toxin" = 60)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "Unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	preloaded_reagents = list("mutagen" = 60)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "Ammonia bottle"
	desc = "A small bottle. Contains liquid ammonia - a potent nutriment for plants, but not for humans."
	preloaded_reagents = list("ammonia" = 60)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "Diethylamine bottle"
	desc = "A small bottle. Contains diethylamine - plants love this!"
	preloaded_reagents = list("diethylamine" = 60)

/obj/item/reagent_containers/glass/bottle/pacid
	name = "Polytrinic acid bottle"
	desc = "A small bottle. Contains a small amount of polytrinic acid."
	preloaded_reagents = list("pacid" = 60)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Oil bottle"
	desc = "A small bottle. Contains hot sauce."
	preloaded_reagents = list("capsaicin" = 60)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil bottle"
	desc = "A small bottle. Contains cold sauce."
	preloaded_reagents = list("frostoil" = 60)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	preloaded_reagents = list("adminordrazine" = 60)

/obj/item/reagent_containers/glass/bottle/resuscitator
	name = "Resuscitator bottle"
	desc = "A small bottle. Contains your last hope to survive."
	spawn_blacklisted = TRUE
	preloaded_reagents = list("resuscitator" = 60)

// === Used by trade stations
/obj/item/reagent_containers/glass/bottle/trade/clonexadone
	preloaded_reagents = list("clonexadone" = 60)

/obj/item/reagent_containers/glass/bottle/trade/imidazoline
	preloaded_reagents = list("imidazoline" = 60)

/obj/item/reagent_containers/glass/bottle/trade/alkysine
	preloaded_reagents = list("alkysine" = 60)

/obj/item/reagent_containers/glass/bottle/trade/bicaridine
	preloaded_reagents = list("bicaridine" = 60)

/obj/item/reagent_containers/glass/bottle/trade/kelotane
	preloaded_reagents = list("kelotane" = 60)

/obj/item/reagent_containers/glass/bottle/trade/carpotoxin
	preloaded_reagents = list("carpotoxin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/pararein
	preloaded_reagents = list("pararein" = 60)

/obj/item/reagent_containers/glass/bottle/trade/aranecolmin
	preloaded_reagents = list("aranecolmin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/blattedin
	preloaded_reagents = list("blattedin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/diplopterum
	preloaded_reagents = list("diplopterum" = 60)

/obj/item/reagent_containers/glass/bottle/trade/seligitillin
	preloaded_reagents = list("seligitillin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/starkellin
	preloaded_reagents = list("starkellin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/gewaltine
	preloaded_reagents = list("gewaltine" = 60)

/obj/item/reagent_containers/glass/bottle/trade/fuhrerole
	preloaded_reagents = list("fuhrerole" = 60)

/obj/item/reagent_containers/glass/bottle/trade/kaiseraurum
	preloaded_reagents = list("kaiseraurum" = 60)

/obj/item/reagent_containers/glass/bottle/trade/cryptobiolin
	preloaded_reagents = list("cryptobiolin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/impedrezene
	preloaded_reagents = list("impedrezene" = 60)

/obj/item/reagent_containers/glass/bottle/trade/psilocybin
	preloaded_reagents = list("psilocybin" = 60)
// ===
