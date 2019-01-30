//Weapon Stashes
//Weapons are so crazy varied that there are no base items for this stash type
/datum/stash/weapon
	base_type = /datum/stash/weapon
	loot_type = "Weapons"
	contents_list_base = list()
	contents_list_extra = list()
	contents_list_random = list()


//Contains boomsticks, ie, shotguns
/datum/stash/weapon/mutiny_boomstick
	story_type = "Mutiny"
	directions = DIRECTION_COORDS | DIRECTION_LANDMARK
	contents_list_base = list(/obj/item/weapon/gun/projectile/shotgun/doublebarrel = 2)
	lore = "MUTINY TOMORROW 0300 MEET AT %D <br><br>BRING YOUR OWN BOOMSTICK ONLY A FEW SPARES"

//because this one is styled like a telegram, lets capitalise the directions
/datum/stash/weapon/mutiny_boomstick/create_direction_string(var/data)
	.=..()
	direction_string = capitalize(direction_string)