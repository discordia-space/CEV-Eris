/obj/item/weapon/material/hatchet/tacknife/armblade
	icon_state = "armblade"
	item_state = null
	name = "armblade"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "armblade"
	applies_material_colour = 0

/obj/item/organ_module/active/simple/armblade
	name = "embed blade"
	verb_name = "Deploy embed blade"
	icon_state = "armblade"
	allowed_organs = list(BP_R_HAND, BP_L_HAND)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade



/obj/item/weapon/material/hatchet/tacknife/armblade/claws
	icon_state = "wolverine"
	name = "claws"

/obj/item/organ_module/active/simple/wolverine
	name = "embed claws"
	verb_name = "Deploy embed claws"
	icon_state = "wolverine"
	allowed_organs = list(BP_R_HAND, BP_L_HAND)
	holding_type = /obj/item/weapon/material/hatchet/tacknife/armblade/claws

