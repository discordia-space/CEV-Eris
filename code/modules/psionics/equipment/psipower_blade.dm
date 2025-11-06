/obj/item/psychic_power/psiblade
	name = "psychokinetic slash"
	force = WEAPON_FORCE_PAINFUL
	armor_divisor = ARMOR_PEN_MAX // Psionic blades mostly ignore armour, but don't deal too much damage
	sharp = TRUE
	edge = TRUE
	maintain_cost = 1
	icon_state = "psiblade_short"

/obj/item/psychic_power/psiblade/master
	force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_MAX
	maintain_cost = 1

/obj/item/psychic_power/psiblade/master/grand
	force = WEAPON_FORCE_ROBUST
	armor_divisor = ARMOR_PEN_MAX
	maintain_cost = 1
	icon_state = "psiblade_long"

/obj/item/psychic_power/psiblade/master/grand/paramount // Silly typechecks because rewriting old interaction code is outside of scope.
	force = WEAPON_FORCE_BRUTAL
	armor_divisor = ARMOR_PEN_MAX
	maintain_cost = 1
	icon_state = "psiblade_long"
