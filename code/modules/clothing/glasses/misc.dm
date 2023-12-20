/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	style = STYLE_HIGH

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol
	body_parts_covered = 0
	style = STYLE_HIGH

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"
	body_parts_covered = 0
	prescription = TRUE

/obj/item/clothing/glasses/regular/scanners
	name = "Scanning Goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

/obj/item/clothing/glasses/regular/goggles
	name = "Green Goggles"
	desc = "A very oddly shaped pair of green goggles with bits of wire poking out the sides. This is the future!"
	icon_state = "green_goggles"
	item_state = "green_goggles"

/obj/item/clothing/glasses/regular/goggles/black
	name = "Black Goggles"
	desc = "A very oddly shaped pair of black goggles with bits of wire poking out the sides. This is the future!"
	icon_state = "black_goggles"
	item_state = "black_goggles"

/obj/item/clothing/glasses/regular/goggles/clear
	name = "Goggles"
	desc = "Goggles made of plastic."
	icon_state = "clear_goggles"
	item_state = "clear_goggles"

/obj/item/clothing/glasses/regular/hipster
	name = "Prescription Glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state = "3d"
	body_parts_covered = 0

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"
	body_parts_covered = 0

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Doesn't really protects from flashes, but stylish."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MINOR // does not "cover the whole eye socket", lets light leak.
	style = STYLE_HIGH

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
	tint = TINT_BLIND

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "A robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	volumeClass = ITEM_SIZE_TINY

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = TRUE

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"
	flash_protection = FLASH_PROTECTION_MODERATE //does cover the whole eye socket

/obj/item/clothing/glasses/artist
	name = "4-D Glasses"
	desc = "You can see in every dimension, and get four times the amount of headache!"
	icon_state = "artist"
	item_state = "artist_glasses"
	body_parts_covered = 0
	spawn_frequency = 0
