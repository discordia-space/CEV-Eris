ADMIN_VERB_ADD(/client/proc/makePAI, R_ADMIN, FALSE)
// Originally a debug69erb,69ade it a proper adminverb for ~fun~
/client/proc/makePAI(turf/t in range(world.view),69ame as text, pai_key as69ull|text)
	set69ame = "Make pAI"
	set category = "Admin"

	if(!check_rights(R_ADMIN))
		return

	if(!pai_key)
		var/client/C = input("Select client") as69ull|anything in clients
		if(!C) return
		pai_key = C.key

	log_and_message_admins("made a pAI with key=69pai_key69 at (69t.x69,69t.y69,69t.z69)")
	var/obj/item/device/paicard/card =69ew(t)
	var/mob/living/silicon/pai/pai =69ew(card)
	pai.key = pai_key
	card.setPersonality(pai)

	if(name)
		pai.SetName(name)
