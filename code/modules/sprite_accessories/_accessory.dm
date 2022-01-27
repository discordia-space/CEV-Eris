/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to69o actual coding experience.
	The process of adding in69ew hairstyles has been69ade pain-free and easy to do.
	Enjoy! - Doohl

	Notice: This all gets automatically compiled in a list in dna2.dm, so you do69ot
	have to define any UI69alues for sprite accessories69anually for hair and facial
	hair. Just add in69ew hair types and the game will69aturally adapt.

	!!WARNING!!: changing existing hair information can be69ERY hazardous to savefiles,
	to the point where you69ay completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory
	var/name                                       // The preview69ame of the accessory
	var/icon                                       // the icon file the accessory is located in
	var/icon_state                                 // the icon_state of the accessory
	var/preview_state                              // A custom preview state for whatever reason
	var/gender =69EUTER                            // Restricted to specific genders.
	var/list/species_allowed = list(SPECIES_HUMAN) // Restrict some styles to specific species
	var/do_colouration = 1                         // Whether or69ot the accessory can be affected by colouration
	var/blend = ICON_ADD
