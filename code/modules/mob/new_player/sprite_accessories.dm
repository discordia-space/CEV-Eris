/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list("Human")

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair

	icon = 'icons/mob/hair.dmi'	  // default icon for all hairs

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE

	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "a" // you do not need to define _s or _l sub-states, game automatically does this for you

	cut
		name = "Cut Hair"
		icon_state = "c"

	flair
		name = "Flaired Hair"
		icon_state = "flair"

	long
		name = "Shoulder-length Hair"
		icon_state = "b"

	longalt
		name = "Shoulder-length Hair Alt"
		icon_state = "longfringe"

	/*longish
		name = "Longer Hair"
		icon_state = "b2"*/

	longer
		name = "Long Hair"
		icon_state = "vlong"

	longeralt
		name = "Long Hair Alt"
		icon_state = "vlongfringe"

	longest
		name = "Very Long Hair"
		icon_state = "longest"

	longfringe
		name = "Long Fringe"
		icon_state = "longfringe"

	longestalt
		name = "Longer Fringe"
		icon_state = "vlongfringe"

	halfbang
		name = "Half-banged Hair"
		icon_state = "halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "halfbang_alt"

	ponytail1
		name = "Ponytail 1"
		icon_state = "ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "pa"
		gender = FEMALE

	ponytail3
		name = "Ponytail 3"
		icon_state = "ponytail3"

	ponytail4
		name = "Ponytail 4"
		icon_state = "ponytail4"
		gender = FEMALE

	sideponytail
		name = "Side Ponytail"
		icon_state = "stail"
		gender = FEMALE

	parted
		name = "Parted"
		icon_state = "parted"

	pompadour
		name = "Pompadour"
		icon_state = "pompadour"
		gender = MALE

	quiff
		name = "Quiff"
		icon_state = "quiff"
		gender = MALE

	bedhead
		name = "Bedhead"
		icon_state = "bedhead"

	bedhead2
		name = "Bedhead 2"
		icon_state = "bedheadv2"

	bedhead3
		name = "Bedhead 3"
		icon_state = "bedheadv3"

	beehive
		name = "Beehive"
		icon_state = "beehive"
		gender = FEMALE

	beehive2
		name = "Beehive 2"
		icon_state = "beehive2"
		gender = FEMALE

	bobcurl
		name = "Bobcurl"
		icon_state = "bobcurl"
		gender = FEMALE

	bob
		name = "Bob"
		icon_state = "bobcut"
		gender = FEMALE

	bowl
		name = "Bowl"
		icon_state = "bowlcut"
		gender = MALE

	buzz
		name = "Buzzcut"
		icon_state = "buzzcut"
		gender = MALE

	crew
		name = "Crewcut"
		icon_state = "crewcut"
		gender = MALE

	combover
		name = "Combover"
		icon_state = "combover"
		gender = MALE

	father
		name = "Father"
		icon_state = "father"
		gender = MALE

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "reversemohawk"
		gender = MALE

	devillock
		name = "Devil Lock"
		icon_state = "devilock"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "dreads"

	curls
		name = "Curls"
		icon_state = "curls"

	afro
		name = "Afro"
		icon_state = "afro"

	afro2
		name = "Afro 2"
		icon_state = "afro2"

	afro_large
		name = "Big Afro"
		icon_state = "bigafro"
		gender = MALE

	sargeant
		name = "Flat Top"
		icon_state = "sargeant"
		gender = MALE

	emo
		name = "Emo"
		icon_state = "emo"

	longemo
		name = "Long Emo"
		icon_state = "emolong"
		gender = FEMALE

	rightemo
		name = "Right Emo"
		icon_state = "emoright"

	shortovereye
		name = "Overeye Short"
		icon_state = "shortovereye"

	longovereye
		name = "Overeye Long"
		icon_state = "longovereye"

	fag
		name = "Flow Hair"
		icon_state = "f"

	feather
		name = "Feather"
		icon_state = "feather"

	hitop
		name = "Hitop"
		icon_state = "hitop"
		gender = MALE

	mohawk
		name = "Mohawk"
		icon_state = "d"

	jensen
		name = "Adam Jensen Hair"
		icon_state = "jensen"
		gender = MALE

	gelled
		name = "Gelled Back"
		icon_state = "gelled"
		gender = FEMALE

	gentle
		name = "Gentle"
		icon_state = "gentle"
		gender = FEMALE

	spiky
		name = "Spiky"
		icon_state = "spikey"

	kusangi
		name = "Kusanagi Hair"
		icon_state = "kusanagi"

	kagami
		name = "Pigtails"
		icon_state = "kagami"
		gender = FEMALE

	himecut
		name = "Hime Cut"
		icon_state = "himecut"
		gender = FEMALE

	braid
		name = "Floorlength Braid"
		icon_state = "braid"
		gender = FEMALE

	mbraid
		name = "Medium Braid"
		icon_state = "shortbraid"
		gender = FEMALE

	braid2
		name = "Long Braid"
		icon_state = "hbraid"
		gender = FEMALE

	braid3
		name = "Long Braid 2"
		icon_state = "longbraid"
		gender = FEMALE

	odango
		name = "Odango"
		icon_state = "odango"
		gender = FEMALE

	ombre
		name = "Ombre"
		icon_state = "ombre"
		gender = FEMALE

	updo
		name = "Updo"
		icon_state = "updo"
		gender = FEMALE

	skinhead
		name = "Skinhead"
		icon_state = "skinhead"

	balding
		name = "Balding Hair"
		icon_state = "e"
		gender = MALE // turnoff!

	familyman
		name = "The Family Man"
		icon_state = "thefamilyman"
		gender = MALE

	mahdrills
		name = "Drillruru"
		icon_state = "drillruru"
		gender = FEMALE

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "dandypompadour"
		gender = MALE

	poofy
		name = "Poofy"
		icon_state = "poofy"
		gender = FEMALE

	crono
		name = "Chrono"
		icon_state = "toriyama"
		gender = MALE

	vegeta
		name = "Vegeta"
		icon_state = "toriyama2"
		gender = MALE

	cia
		name = "CIA"
		icon_state = "cia"
		gender = MALE

	mulder
		name = "Mulder"
		icon_state = "mulder"
		gender = MALE

	scully
		name = "Scully"
		icon_state = "scully"
		gender = FEMALE

	nitori
		name = "Nitori"
		icon_state = "nitori"
		gender = FEMALE

	joestar
		name = "Joestar"
		icon_state = "joestar"
		gender = MALE

	volaju
		name = "Volaju"
		icon_state = "volaju"

	longeralt2
		name = "Long Hair Alt 2"
		icon_state = "longeralt2"

	shortbangs
		name = "Short Bangs"
		icon_state = "shortbangs"

	halfshaved
		name = "Half-Shaved Emo"
		icon_state = "halfshaved"

	bun
		name = "Bun"
		icon_state = "bun"

	doublebun
		name = "Double-Bun"
		icon_state = "doublebun"

	Mia
		name = "Mia"
		icon_state = "mia"
		gender = FEMALE

	bald
		name = "Bald"
		icon_state = "bald"


/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair

	icon = 'icons/mob/hair_facial.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

	shaved
		name = "Shaved"
		icon_state = "shaved"
		gender = NEUTER

	watson
		name = "Watson Mustache"
		icon_state = "watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "elvis"
	abe
		name = "Abraham Lincoln Beard"
		icon_state = "abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "chin"

	hip
		name = "Hipster Beard"
		icon_state = "hip"

	gt
		name = "Goatee"
		icon_state = "gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "jensen"

	volaju
		name = "Volaju"
		icon_state = "volaju"

	dwarf
		name = "Dwarf Beard"
		icon_state = "dwarf"
