/*	This code is responsible for the examine tab.  When someone examines something, it copies the examined object's description_info,
	description_fluff, and description_antag, and shows it in a new tab.
	In this file, some atom and69ob stuff is defined here.  It is defined here instead of in the normal files, to keep the whole system self-contained.
	This69eans that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.
*/


/atom/
	var/description_info = null //Helpful blue text.
	var/description_fluff = null //Green text about the atom's fluff, if any exists.
	var/description_antag = null //Malicious red text, for the antags.

//Override these if you need special behaviour for a specific type.
/atom/proc/get_description_info()
	if(description_info)
		return description_info
	return

/atom/proc/get_description_fluff()
	if(description_fluff)
		return description_fluff
	return

/atom/proc/get_description_antag()
	if(description_antag)
		return description_antag
	return

/mob/living/get_description_fluff()
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_description_fluff()
	return print_flavor_text(0)

/* The examine panel itself */

/client/var/description_holders69069

/client/proc/update_description_holders(atom/A, update_antag_info=0)
	description_holders69"info"69 = A.get_description_info()
	description_holders69"fluff"69 = A.get_description_fluff()
	description_holders69"antag"69 = (update_antag_info)? A.get_description_antag() : ""

	description_holders69"name"69 = "69A.name69"
	description_holders69"icon"69 = "\icon69A69"
	description_holders69"desc"69 = A.desc

/mob/Stat()
	. = ..()
	if(client && statpanel("Examine"))
		stat(null,"69client.description_holders69"icon"6969    <font size='5'>69client.description_holders69"name"6969</font>") //The name, written in big letters.
		stat(null,"69client.description_holders69"desc"6969") //the default examine text.
		if(client.description_holders69"info"69)
			stat(null,"<font color='#084b8a'><b>69client.description_holders69"info"6969</b></font>") //Blue, informative text.
		if(client.description_holders69"fluff"69)
			stat(null,"<font color='#298a08'><b>69client.description_holders69"fluff"6969</b></font>") //Yellow, fluff-related text.
		if(client.description_holders69"antag"69)
			stat(null,"<font color='#8a0808'><b>69client.description_holders69"antag"6969</b></font>") //Red,69alicious antag-related text

//override examinate69erb to update description holders when things are examined
/mob/examinate(atom/A as69ob|obj|turf in69iew())
	if(..())
		return 1

	var/is_antag = (isghost(src) || player_is_antag(mind)) //ghosts don't have69inds
	if(client)
		client.update_description_holders(A, is_antag)