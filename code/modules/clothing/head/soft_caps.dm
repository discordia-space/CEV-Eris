/obj/item/clothing/head/soft
	name = "cargo cap"
	initial_name = "yellow cap"
	desc = "A peaked cap in a tasteless yellow color."
	icon_state = "cargosoft"
	item_state_slots = list(
		slot_l_hand_str = "helmet", //probably a placeholder
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0
	var/flipped = 0

/obj/item/clothing/head/soft/dropped()
	src.icon_state = initial(icon_state)
	src.flipped=0
	..()

/obj/item/clothing/head/soft/attack_self(mob/user)
	src.flipped = !src.flipped
	if(src.flipped)
		icon_state = "[icon_state]_flipped"
		to_chat(user, "You flip the hat backwards.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You flip the hat back in normal position.")
	update_wear_icon()	//so our mob-overlays update

/obj/item/clothing/head/soft/red
	name = "red cap"
	initial_name = "red cap"
	desc = "A baseball hat in a tasteful crimson color."
	icon_state = "redsoft"

/obj/item/clothing/head/soft/blue
	name = "blue cap"
	initial_name = "blue cap"
	desc = "A baseball cap in a tasteless blue color."
	icon_state = "bluesoft"

/obj/item/clothing/head/soft/green
	name = "green cap"
	initial_name = "green cap"
	desc = "A baseball cap in a tasteless green color."
	icon_state = "greensoft"

/obj/item/clothing/head/soft/yellow
	name = "yellow cap"
	initial_name = "yellow cap"
	desc = "A baseball cap in a tasteless yellow color."
	icon_state = "yellowsoft"

/obj/item/clothing/head/soft/grey
	name = "grey cap"
	initial_name = "grey cap"
	desc = "A baseball cap in a tasteful grey color. Reeks of welder fuel."
	icon_state = "greysoft"

/obj/item/clothing/head/soft/black
	name = "black cap"
	initial_name = "black cap"
	desc = "A simple baseball cap in a tasteful black color."
	icon_state = "blacksoft"

/obj/item/clothing/head/soft/orange
	name = "orange cap"
	initial_name = "orange cap"
	desc = "A baseball cap in a bleak orange color."
	icon_state = "orangesoft"

/obj/item/clothing/head/soft/mime
	name = "white cap"
	initial_name = "cap"
	desc = "A baseball cap in a tasteless white color."
	icon_state = "mimesoft"

/obj/item/clothing/head/soft/purple
	name = "purple cap"
	initial_name = "purple cap"
	desc = "A peaked cap in a tasteless purple color."
	icon_state = "purplesoft"

/obj/item/clothing/head/soft/rainbow
	name = "rainbow cap"
	initial_name = "rainbow cap"
	desc = "A flimsy cap in a bright rainbow of colors."
	icon_state = "rainbowsoft"

/obj/item/clothing/head/soft/sec
	name = "old security cap"
	initial_name = "old  security cap"
	desc = "A washed out red cap bearing logo of the long defunct \"Securitech\" company."
	icon_state = "secsoft"

/obj/item/clothing/head/soft/synd
	name = "ancient syndicate cap"
	initial_name = "ancient syndicate cap"
	desc = "A corporate war style field cap. Popular among patriots and veterans nowadays."
	icon_state = "syndsoft"

/obj/item/clothing/head/soft/sec/corp
	name = "corporate security cap"
	initial_name = "corporate security cap"
	desc = "An old field cap for an ancient security corp. Popular fashion statement recently."
	icon_state = "corpsoft"

// S E R B I A //

/obj/item/clothing/head/soft/green2soft
	name = "green military cap"
	initial_name = "green cap"
	desc = "A field cap in tasteful green color."
	icon_state = "green2soft"

/obj/item/clothing/head/soft/tan2soft
	name = "tan military cap"
	initial_name = "tan cap"
	desc = "A field cap in tasteful tan color."
	icon_state = "tansoft"

// I H S //

/obj/item/clothing/head/soft/sec2soft
	name = "IH field cap"
	initial_name = "IH field cap"
	desc = "A field cap for operatives."
	icon_state = "sec2soft"

/obj/item/clothing/head/soft/sarge2soft
	name = "IH sergeant cap"
	initial_name = "IH sergeant cap"
	desc = "A field cap for officers."
	icon_state = "sargesoft"

// M O E B I U S //

/obj/item/clothing/head/soft/medical
	name = "Moebius medical cap"
	desc = "Cap worn by moebius medical personnel, usually outside spacecraft."
	icon_state = "medcap"
	item_state = "medcap"

///obj/item/clothing/head/soft/science
	//name = "moebius research cap"
	//desc = "Cap worn by moebius research personnel."
	//icon_state = "scicap"
	//item_state = "scicap"
