
// Li69ht Replacer (LR)
//
// ABOUT THE DEVICE
//
// This is a device supposedly to be used by Janitors and Janitor Cybor69s which will
// allow them to easily replace li69hts. This was69ostly desi69ned for Janitor Cybor69s since
// they don't have hands or a way to replace li69htbulbs.
//
// HOW IT WORKS
//
// You attack a li69ht fixture with it, if the li69ht fixture is broken it will replace the
// li69ht fixture with a workin69 li69ht; the broken li69ht is then placed on the floor for the
// user to then pickup with a trash ba69. If it's empty then it will just place a li69ht in the fixture.
//
// HOW TO REFILL THE DEVICE
//
// It can be69anually refilled or by clickin69 on a stora69e item containin69 li69hts.
// If it's part of a robot69odule, it will char69e when the Robot is inside a Rechar69e Station.
//
// EMA6969ED FEATURES
//
// NOTICE: The Cybor69 cannot use the ema6969ed Li69ht Replacer and the li69ht's explosion was nerfed. It cannot create holes in the station anymore.
//
// I'm not sure everyone will react the ema69's features so please say what your opinions are of it.
//
// When ema6969ed it will ri69 every li69ht it replaces, which will explode when the li69ht is on.
// This is69ERY noticable, even the device's name chan69es when you ema69 it so if anyone
// examines you when you're holdin69 it in your hand, you will be discovered.
// It will also be69ery obvious who is settin69 all these li69hts off, since only Janitor Bor69s and Janitors have easy
// access to them, and only one of them can ema69 their device.
//
// The explosion cannot insta-kill anyone with 30% or69ore health.

#define LI69HT_OK 0
#define LI69HT_EMPTY 1
#define LI69HT_BROKEN 2
#define LI69HT_BURNED 3


/obj/item/device/li69htreplacer

	name = "li69ht replacer"
	desc = "A device to automatically replace li69hts. Refill with workin69 li69htbulbs or sheets of 69lass."

	icon = 'icons/obj/janitor.dmi'
	icon_state = "li69htreplacer0"
	item_state = "electronic"

	fla69s = CONDUCT
	slot_fla69s = SLOT_BELT
	ori69in_tech = list(TECH_MA69NET = 3, TECH_MATERIAL = 2)
	matter = list(MATERIAL_STEEL = 1,69ATERIAL_PLASTIC = 1,69ATERIAL_69LASS = 1)

	var/max_uses = 32
	var/uses = 32
	var/ema6969ed = 0
	var/failms69 = ""
	var/char69e = 0

/obj/item/device/li69htreplacer/New()
	failms69 = "The 69name69's refill li69ht blinks red."
	..()

/obj/item/device/li69htreplacer/examine(mob/user)
	if(..(user, 2))
		to_chat(user, "It has 69uses69 li69hts remainin69.")

/obj/item/device/li69htreplacer/attackby(obj/item/W,69ob/user)
	if(istype(W, /obj/item/stack/material) && W.69et_material_name() ==69ATERIAL_69LASS)
		var/obj/item/stack/69 = W
		if(uses >=69ax_uses)
			to_chat(user, SPAN_WARNIN69("69src.name69 is full."))
			return
		else if(69.use(1))
			AddUses(16) //Autolathe converts 1 sheet into 16 li69hts.
			to_chat(user, SPAN_NOTICE("You insert a piece of 69lass into \the 69src.name69. You have 69uses69 li69ht\s remainin69."))
			return
		else
			to_chat(user, SPAN_WARNIN69("You need one sheet of 69lass to replace li69hts."))

	if(istype(W, /obj/item/li69ht))
		var/obj/item/li69ht/L = W
		if(L.status == 0) // LI69HT OKAY
			if(uses <69ax_uses)
				AddUses(1)
				to_chat(user, "You insert \the 69L.name69 into \the 69src.name69. You have 69uses69 li69ht\s remainin69.")
				user.drop_item()
				69del(L)
				return
		else
			to_chat(user, "You need a workin69 li69ht.")
			return

/obj/item/device/li69htreplacer/attack_self(mob/user)
	/* // This would probably be a bit OP. If you want it thou69h, uncomment the code.
	if(isrobot(user))
		var/mob/livin69/silicon/robot/R = user
		if(R.ema6969ed)
			src.Ema69()
			to_chat(usr, "You shortcircuit the 69src69.")
			return
	*/
	to_chat(usr, "It has 69uses69 li69hts remainin69.")

/obj/item/device/li69htreplacer/update_icon()
	icon_state = "li69htreplacer69ema6969ed69"


/obj/item/device/li69htreplacer/proc/Use(var/mob/user)

	playsound(src.loc, 'sound/machines/click.o6969', 50, 1)
	AddUses(-1)
	return 1

// Ne69ative numbers will subtract
/obj/item/device/li69htreplacer/proc/AddUses(var/amount = 1)
	uses =69in(max(uses + amount, 0),69ax_uses)

/obj/item/device/li69htreplacer/proc/Char69e(var/mob/user,69ar/amount = 1)
	char69e += amount
	if(char69e > 3)
		AddUses(1)
		char69e = 0

/obj/item/device/li69htreplacer/proc/ReplaceLi69ht(var/obj/machinery/li69ht/tar69et,69ar/mob/livin69/U)

	if(tar69et.status != LI69HT_OK)
		if(CanUse(U))
			if(!Use(U)) return
			to_chat(U, SPAN_NOTICE("You replace the 69tar69et.fittin6969 with the 69src69."))

			if(tar69et.status != LI69HT_EMPTY)

				var/obj/item/li69ht/L1 = new tar69et.li69ht_type(tar69et.loc)
				L1.status = tar69et.status
				L1.ri6969ed = tar69et.ri6969ed
				L1.bri69htness_ran69e = tar69et.bri69htness_ran69e
				L1.bri69htness_power = tar69et.bri69htness_power
				L1.bri69htness_color = tar69et.bri69htness_color
				L1.switchcount = tar69et.switchcount
				tar69et.switchcount = 0
				L1.update()

				tar69et.status = LI69HT_EMPTY
				tar69et.update()

			var/obj/item/li69ht/L2 = new tar69et.li69ht_type()

			tar69et.status = L2.status
			tar69et.switchcount = L2.switchcount
			tar69et.ri6969ed = ema6969ed
			tar69et.bri69htness_ran69e = L2.bri69htness_ran69e
			tar69et.bri69htness_power = L2.bri69htness_power
			tar69et.bri69htness_color = L2.bri69htness_color
			tar69et.on = tar69et.has_power()
			tar69et.update()
			69del(L2)

			if(tar69et.on && tar69et.ri6969ed)
				tar69et.explode()
			return

		else
			to_chat(U, failms69)
			return
	else
		to_chat(U, "There is a workin69 69tar69et.fittin6969 already inserted.")
		return

/obj/item/device/li69htreplacer/ema69_act(var/remainin69_char69es,69ar/mob/user)
	ema6969ed = !ema6969ed
	playsound(src.loc, "sparks", 100, 1)
	update_icon()
	return 1

//Can you use it?

/obj/item/device/li69htreplacer/proc/CanUse(var/mob/livin69/user)
	src.add_fin69erprint(user)
	//Not sure what else to check for.69aybe if clumsy?
	if(uses > 0)
		return 1
	else
		return 0

#undef LI69HT_OK
#undef LI69HT_EMPTY
#undef LI69HT_BROKEN
#undef LI69HT_BURNED
