//CLOTH RANDOM
/obj/random/cloth/masks
	name = "random mask"
	desc = "This is a random mask."

/obj/random/cloth/masks/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/mask/))

/obj/random/cloth/armor
	name = "random armor"
	desc = "This is a random armor."

/obj/random/cloth/armor/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/suit/armor) - list(/obj/item/clothing/suit/armor/tdome))

/obj/random/cloth/storagesuit
	name = "random storagesuit"
	desc = "This is a random storagesuit."

/obj/random/cloth/storagesuit/item_to_spawn()
	var/list/possibilities = subtypesof(/obj/item/clothing/suit/storage)
	possibilities -= /obj/item/clothing/suit/storage/toggle
	return pick(possibilities)

/obj/random/cloth/hazmatsuit
	name = "random hazmatsuit"
	desc = "This is a random hazmatsuit."

/obj/random/cloth/hazmatsuit/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/suit/bio_suit))

/obj/random/cloth/shittysuit
	name = "random shittysuit"
	desc = "This is a random shittysuit."

/obj/random/cloth/shittysuit/item_to_spawn()
	return pick(list(
				/obj/item/clothing/suit/nun,
				/obj/item/clothing/suit/chef/classic,
				/obj/item/clothing/suit/pirate,
				/obj/item/clothing/suit/cyborg_suit,
				/obj/item/clothing/suit/chickensuit,
				/obj/item/clothing/suit/monkeysuit,
				/obj/item/clothing/suit/xenos,
				/obj/item/clothing/suit/radiation,
				/obj/item/clothing/suit/bomb_suit
			))

/obj/random/cloth/under
	name = "random under"
	desc = "This is a random under."

/obj/random/cloth/under/item_to_spawn()
	var/list/possibilities = subtypesof(/obj/item/clothing/under)
	possibilities -= /obj/item/clothing/under/color
	possibilities -= /obj/item/clothing/under/shorts
	possibilities -= /obj/item/clothing/under/swimsuit
	possibilities -= /obj/item/clothing/under/rank
	possibilities -= /obj/item/clothing/under/pj
	possibilities -= /obj/item/clothing/under/acj
	return pick(possibilities)

/obj/random/cloth/helmet
	name = "random helmet"
	desc = "This is a random helmet."

/obj/random/cloth/helmet/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/head/helmet))

/obj/random/cloth/head
	name = "random head gear."
	desc = "This is a random head gear."

/obj/random/cloth/head/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/head))

/obj/random/cloth/gloves
	name = "random gloves"
	desc = "This is a random gloves."

/obj/random/cloth/gloves/item_to_spawn()
	var/list/possibilities = subtypesof(/obj/item/clothing/gloves)
	possibilities -= subtypesof(/obj/item/clothing/gloves/rig)
	return pick(possibilities)

/obj/random/cloth/glasses
	name = "random glasses"
	desc = "This is a random glasses."

/obj/random/cloth/glasses/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/glasses) - subtypesof(/obj/item/clothing/glasses/thermal))

/obj/random/cloth/shoes
	name = "random shoes"
	desc = "This is a random shoes."

/obj/random/cloth/shoes/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/shoes))

/obj/random/cloth/tie
	name = "random tie"
	desc = "This is a random tie."

/obj/random/cloth/tie/item_to_spawn()
	return pick(subtypesof(/obj/item/clothing/accessory))

/obj/random/cloth/storage
	name = "random storage"
	desc = "This is a random storage."

/obj/random/cloth/storage/item_to_spawn()
	return pickweight(list(
			/obj/random/cloth/backpack = 69,
			/obj/random/cloth/belt = 34,
			/obj/random/pouch = 12
			))

/obj/random/cloth/backpack
	name = "random storage"
	desc = "This is a random storage."

/obj/random/cloth/backpack/item_to_spawn()
	return pickweight(list(
			/obj/item/weapon/storage/backpack/clown = 10,
			/obj/item/weapon/storage/backpack/medic = 10,
			/obj/item/weapon/storage/backpack/industrial = 10,
			/obj/item/weapon/storage/backpack/security = 8
			))

/obj/random/cloth/belt
	name = "random storage"
	desc = "This is a random storage."

/obj/random/cloth/belt/item_to_spawn()
	return pickweight(list(
			/obj/item/weapon/storage/belt/security = 8,
			/obj/item/weapon/storage/belt/medical = 8,
			/obj/item/weapon/storage/belt/utility = 8,
			/obj/item/weapon/storage/belt/archaeology = 8
			))

/obj/random/cloth/randomhead
	name = "random head"
	desc = "This is a random head."

/obj/random/cloth/randomhead/item_to_spawn()
	return pickweight(list(
				/obj/random/cloth/head = 12,
				/obj/random/cloth/helmet = 4
			))

/obj/random/cloth/randomsuit
	name = "random suit"
	desc = "This is a random suit."

/obj/random/cloth/randomsuit/item_to_spawn()
	return pickweight(list(
				/obj/random/cloth/hazmatsuit = 12,
				/obj/random/cloth/shittysuit = 16,
				/obj/random/cloth/storagesuit = 16,
				/obj/random/voidsuit = 2,
				/obj/random/cloth/armor = 6
			))

/obj/random/cloth/random_cloth
	name = "Random cloth supply"
	desc = "This is a random cloth supply."

/obj/random/cloth/random_cloth/item_to_spawn()
	return pickweight(list(
					/obj/random/cloth/randomsuit = 12,
					/obj/random/cloth/randomhead = 12,
					/obj/random/cloth/under = 12,
					/obj/random/cloth/tie = 8,
					/obj/random/cloth/shoes = 8,
					/obj/random/cloth/glasses = 4,
					/obj/random/cloth/gloves = 12,
					/obj/random/cloth/masks = 10,
					/obj/random/cloth/storage = 4
				))
