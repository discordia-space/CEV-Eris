/obj/item/dnainjector
	name = "\improper DNA injector"
	desc = "This injects the person with DNA."
	icon = 'icons/obj/items.dmi'
	icon_state = "dnainjector"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/block=0
	var/datum/dna2/record/buf
	var/s_time = 10
	var/uses = 1
	var/nofail
	var/is_bullet = 0
	var/inuse = 0

	// USE ONLY IN PREMADE SYRINGES.  WILL NOT WORK OTHERWISE.
	var/datatype=0
	var/value=0

/obj/item/dnainjector/New()
	..()
	if(datatype && block)
		buf=new
		buf.dna=new
		buf.types = datatype
		buf.dna.ResetSE()
		//testing("69name69: DNA2 SE blocks prior to SetValue: 69english_list(buf.dna.SE)69")
		SetValue(src.value)
		//testing("69name69: DNA2 SE blocks after SetValue: 69english_list(buf.dna.SE)69")

/obj/item/dnainjector/proc/GetRealBlock(var/selblock)
	if(selblock==0)
		return block
	else
		return selblock

/obj/item/dnainjector/proc/GetState(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEState(real_block)
	else
		return buf.dna.GetUIState(real_block)

/obj/item/dnainjector/proc/SetState(var/on,69ar/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEState(real_block,on)
	else
		return buf.dna.SetUIState(real_block,on)

/obj/item/dnainjector/proc/GetValue(var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.GetSEValue(real_block)
	else
		return buf.dna.GetUIValue(real_block)

/obj/item/dnainjector/proc/SetValue(var/val,var/selblock=0)
	var/real_block=GetRealBlock(selblock)
	if(buf.types&DNA2_BUF_SE)
		return buf.dna.SetSEValue(real_block,val)
	else
		return buf.dna.SetUIValue(real_block,val)

/obj/item/dnainjector/proc/inject(mob/M as69ob,69ob/user as69ob)
	if(isliving(M))
		var/mob/living/L =69
		L.apply_effect(rand(5,20), IRRADIATE, check_protection = FALSE)

	if (!(NOCLONE in69.mutations)) // prevents drained people from having their DNA changed
		if (buf.types & DNA2_BUF_UI)
			if (!block) //isolated block?
				M.UpdateAppearance(buf.dna.UI.Copy())
				if (buf.types & DNA2_BUF_UE) //uni69ue enzymes? yes
					M.real_name = buf.dna.real_name
					M.name = buf.dna.real_name
				uses--
			else
				M.dna.SetUIValue(block,src.GetValue())
				M.UpdateAppearance()
				uses--
		if (buf.types & DNA2_BUF_SE)
			if (!block) //isolated block?
				M.dna.SE = buf.dna.SE.Copy()
				M.dna.UpdateSE()
			else
				M.dna.SetSEValue(block,src.GetValue())
			domutcheck(M, null, block!=null)
			uses--
			if(prob(5))
				trigger_side_effect(M)

	spawn(0)//this prevents the collapse of space-time continuum
		if (user)
			user.drop_from_inventory(src)
		69del(src)
	return uses

/obj/item/dnainjector/attack(mob/M as69ob,69ob/user as69ob)
	if (!ismob(M))
		return
	if (!usr.IsAdvancedToolUser())
		return
	if(inuse)
		return 0

	user.visible_message(SPAN_DANGER("\The 69user69 is trying to inject \the 69M69 with \the 69src69!"))
	inuse = 1
	s_time = world.time
	spawn(50)
		inuse = 0

	if(!do_after(user,50,M))
		return

	user.setClickCooldown(DEFAULT_69UICK_COOLDOWN)
	user.do_attack_animation(M)

	M.visible_message(SPAN_DANGER("\The 69M69 has been injected with \the 69src69 by \the 69user69."))

	var/mob/living/carbon/human/H =69
	if(!istype(H))
		to_chat(user, SPAN_WARNING("Apparently it didn't work..."))
		return

	// Used by admin log.
	var/injected_with_monkey = ""
	if((buf.types & DNA2_BUF_SE) && (block ? (GetState() && block ==69ONKEYBLOCK) : GetState(MONKEYBLOCK)))
		injected_with_monkey = " <span class='danger'>(MONKEY)</span>"

	M.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been injected with 69name69 by 69user.name69 (69user.ckey69)</font>")
	user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Used the 69name69 to inject 69M.name69 (69M.ckey69)</font>")
	log_attack("69user.name69 (69user.ckey69) used the 69name69 to inject 69M.name69 (69M.ckey69)")
	message_admins("69key_name_admin(user)69 injected 69key_name_admin(M)69 with \the 69src6969injected_with_monkey69")

	// Apply the DNA shit.
	inject(M, user)
	return

/obj/item/dnainjector/hulkmut
	name = "\improper DNA injector (Hulk)"
	desc = "This will69ake you big and strong, but give you a bad skin condition."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = HULKBLOCK
		..()

/obj/item/dnainjector/antihulk
	name = "\improper DNA injector (Anti-Hulk)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = HULKBLOCK
		..()

/obj/item/dnainjector/xraymut
	name = "\improper DNA injector (Xray)"
	desc = "Finally you can see what the Captain does."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 8
	New()
		block = XRAYBLOCK
		..()

/obj/item/dnainjector/antixray
	name = "\improper DNA injector (Anti-Xray)"
	desc = "It will69ake you see harder."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 8
	New()
		block = XRAYBLOCK
		..()

/obj/item/dnainjector/firemut
	name = "\improper DNA injector (Fire)"
	desc = "Gives you fire."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 10
	New()
		block = FIREBLOCK
		..()

/obj/item/dnainjector/antifire
	name = "\improper DNA injector (Anti-Fire)"
	desc = "Cures fire."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 10
	New()
		block = FIREBLOCK
		..()

/obj/item/dnainjector/telemut
	name = "\improper DNA injector (Tele.)"
	desc = "Super brain69an!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 12
	New()
		block = TELEBLOCK
		..()

/obj/item/dnainjector/antitele
	name = "\improper DNA injector (Anti-Tele.)"
	desc = "Will69ake you not able to control your69ind."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 12
	New()
		block = TELEBLOCK
		..()

/obj/item/dnainjector/nobreath
	name = "\improper DNA injector (No Breath)"
	desc = "Hold your breath and count to infinity."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = NOBREATHBLOCK
		..()

/obj/item/dnainjector/antinobreath
	name = "\improper DNA injector (Anti-No Breath)"
	desc = "Hold your breath and count to 100."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = NOBREATHBLOCK
		..()

/obj/item/dnainjector/remoteview
	name = "\improper DNA injector (Remote69iew)"
	desc = "Stare into the distance for a reason."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = REMOTEVIEWBLOCK
		..()

/obj/item/dnainjector/antiremoteview
	name = "\improper DNA injector (Anti-Remote69iew)"
	desc = "Cures green skin."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = REMOTEVIEWBLOCK
		..()

/obj/item/dnainjector/regenerate
	name = "\improper DNA injector (Regeneration)"
	desc = "Healthy but hungry."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = REGENERATEBLOCK
		..()

/obj/item/dnainjector/antiregenerate
	name = "\improper DNA injector (Anti-Regeneration)"
	desc = "Sickly but sated."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = REGENERATEBLOCK
		..()

/obj/item/dnainjector/runfast
	name = "\improper DNA injector (Increase Run)"
	desc = "Running69an."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = INCREASERUNBLOCK
		..()

/obj/item/dnainjector/antirunfast
	name = "\improper DNA injector (Anti-Increase Run)"
	desc = "Walking69an."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = INCREASERUNBLOCK
		..()

/obj/item/dnainjector/morph
	name = "\improper DNA injector (Morph)"
	desc = "A total69akeover."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block =69ORPHBLOCK
		..()

/obj/item/dnainjector/antimorph
	name = "\improper DNA injector (Anti-Morph)"
	desc = "Cures identity crisis."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block =69ORPHBLOCK
		..()

/* No COLDBLOCK on bay
/obj/item/dnainjector/cold
	name = "\improper DNA injector (Cold)"
	desc = "Feels a bit chilly."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = COLDBLOCK
		..()

/obj/item/dnainjector/anticold
	name = "\improper DNA injector (Anti-Cold)"
	desc = "Feels room-temperature."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = COLDBLOCK
		..()
*/

/obj/item/dnainjector/noprints
	name = "\improper DNA injector (No Prints)"
	desc = "Better than a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = NOPRINTSBLOCK
		..()

/obj/item/dnainjector/antinoprints
	name = "\improper DNA injector (Anti-No Prints)"
	desc = "Not 69uite as good as a pair of budget insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = NOPRINTSBLOCK
		..()

/obj/item/dnainjector/insulation
	name = "\improper DNA injector (Shock Immunity)"
	desc = "Better than a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = SHOCKIMMUNITYBLOCK
		..()

/obj/item/dnainjector/antiinsulation
	name = "\improper DNA injector (Anti-Shock Immunity)"
	desc = "Not 69uite as good as a pair of real insulated gloves."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = SHOCKIMMUNITYBLOCK
		..()

/obj/item/dnainjector/midgit
	name = "\improper DNA injector (Small Size)"
	desc = "Makes you shrink."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = SMALLSIZEBLOCK
		..()

/obj/item/dnainjector/antimidgit
	name = "\improper DNA injector (Anti-Small Size)"
	desc = "Makes you grow. But not too69uch."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = SMALLSIZEBLOCK
		..()

/////////////////////////////////////
/obj/item/dnainjector/antiglasses
	name = "\improper DNA injector (Anti-Glasses)"
	desc = "Toss away those glasses!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 1
	New()
		block = GLASSESBLOCK
		..()

/obj/item/dnainjector/glassesmut
	name = "\improper DNA injector (Glasses)"
	desc = "Will69ake you need dorkish glasses."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 1
	New()
		block = GLASSESBLOCK
		..()

/obj/item/dnainjector/epimut
	name = "\improper DNA injector (Epi.)"
	desc = "Shake shake shake the room!"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 3
	New()
		block = HEADACHEBLOCK
		..()

/obj/item/dnainjector/antiepi
	name = "\improper DNA injector (Anti-Epi.)"
	desc = "Will fix you up from shaking the room."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 3
	New()
		block = HEADACHEBLOCK
		..()

/obj/item/dnainjector/anticough
	name = "\improper DNA injector (Anti-Cough)"
	desc = "Will stop that awful noise."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 5
	New()
		block = COUGHBLOCK
		..()

/obj/item/dnainjector/coughmut
	name = "\improper DNA injector (Cough)"
	desc = "Will bring forth a sound of horror from your throat."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 5
	New()
		block = COUGHBLOCK
		..()

/obj/item/dnainjector/clumsymut
	name = "\improper DNA injector (Clumsy)"
	desc = "Makes clumsy69inions."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 6
	New()
		block = CLUMSYBLOCK
		..()

/obj/item/dnainjector/anticlumsy
	name = "\improper DNA injector (Anti-Clumy)"
	desc = "Cleans up confusion."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 6
	New()
		block = CLUMSYBLOCK
		..()

/obj/item/dnainjector/antitour
	name = "\improper DNA injector (Anti-Tour.)"
	desc = "Will cure tourrets."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 7
	New()
		block = TWITCHBLOCK
		..()

/obj/item/dnainjector/tourmut
	name = "\improper DNA injector (Tour.)"
	desc = "Gives you a nasty case off tourrets."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 7
	New()
		block = TWITCHBLOCK
		..()

/obj/item/dnainjector/stuttmut
	name = "\improper DNA injector (Stutt.)"
	desc = "Makes you s-s-stuttterrr"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 9
	New()
		block = NERVOUSBLOCK
		..()

/obj/item/dnainjector/antistutt
	name = "\improper DNA injector (Anti-Stutt.)"
	desc = "Fixes that speaking impairment."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 9
	New()
		block = NERVOUSBLOCK
		..()

/obj/item/dnainjector/blindmut
	name = "\improper DNA injector (Blind)"
	desc = "Makes you not see anything."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 11
	New()
		block = BLINDBLOCK
		..()

/obj/item/dnainjector/antiblind
	name = "\improper DNA injector (Anti-Blind)"
	desc = "ITS A69IRACLE!!!"
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 11
	New()
		block = BLINDBLOCK
		..()

/obj/item/dnainjector/deafmut
	name = "\improper DNA injector (Deaf)"
	desc = "Sorry, what did you say?"
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 13
	New()
		block = DEAFBLOCK
		..()

/obj/item/dnainjector/antideaf
	name = "\improper DNA injector (Anti-Deaf)"
	desc = "Will69ake you hear once69ore."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 13
	New()
		block = DEAFBLOCK
		..()

/obj/item/dnainjector/hallucination
	name = "\improper DNA injector (Halluctination)"
	desc = "What you see isn't always what you get."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 2
	New()
		block = HALLUCINATIONBLOCK
		..()

/obj/item/dnainjector/antihallucination
	name = "\improper DNA injector (Anti-Hallucination)"
	desc = "What you see is what you get."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 2
	New()
		block = HALLUCINATIONBLOCK
		..()

/obj/item/dnainjector/h2m
	name = "\improper DNA injector (Human >69onkey)"
	desc = "Will69ake you a flea bag."
	datatype = DNA2_BUF_SE
	value = 0xFFF
	//block = 14
	New()
		block =69ONKEYBLOCK
		..()

/obj/item/dnainjector/m2h
	name = "\improper DNA injector (Monkey > Human)"
	desc = "Will69ake you...less hairy."
	datatype = DNA2_BUF_SE
	value = 0x001
	//block = 14
	New()
		block =69ONKEYBLOCK
		..()
