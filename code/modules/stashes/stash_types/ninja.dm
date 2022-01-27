/*
	Ninja Gear
	Foreshadowing a future and past antag
	Contains tons of stealthy gear
*/
/datum/stash/ninja
	base_type = /datum/stash/ninja
	weight = 0.2
	nonmaint_reroll = 100
	contents_list_base = list(/obj/item/storage/box/smokes)
	contents_list_random = list(

		/obj/item/storage/box/anti_photons = 60,
		/obj/item/gun/projectile/mandella = 50)

/datum/stash/ninja/haiku
	lore = "Swift electric ghost<br>\
 Yakuza of cold lightning<br>\
 Hide stars underfoot<br>\
%D"

/datum/stash/ninja/seppuku
	contents_list_external = list(/obj/item/remains/human = 1)
	lore = "My69ission has failed, and I have brought dishonour upon the clan.<br>\
	Worse still,69y suit has69alfunctioned, the self destruct69odule will69ot activate.<br>\
	I am crippled, unable to walk, and soldiers hunt for69e all over the ship. I cannot even crawl to an airlock.<br>\
	Our technology69ust remain hidden, death in battle is69ot an option.<br>\
	My only remaining recourse is to hide in the darkest corner I can find, and die with some semblance of honour. %D<br>\
	If you, reader are69ot of our clan, then I ask one final favour. Destroy everything you find with69y body. Erase69y existence from history"