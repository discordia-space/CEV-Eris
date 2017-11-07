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
ADMIN_VERB_ADD(/client/proc/validate_hairs, R_DEBUG, null)
/client/proc/validate_hairs()
	set name = "Validate hairs"
	set category = "Debug"

	var/list/variants = list(
		"hair"   = /datum/sprite_accessory/hair,
		"facial" = /datum/sprite_accessory/facial_hair
	)
	var/input = input("Select list") as null|anything in variants
	if(!input)
		return
	usr << "[capitalize(input)]:"
	for(var/path in subtypesof(variants[input]))
		var/datum/sprite_accessory/hair = path
		var/name = initial(hair.name)
		var/icon_state = initial(hair.icon_state)
		var/icon = initial(hair.icon)
		if(icon_state in icon_states(icon))
			usr << SPAN_NOTICE("[name]: icon exist")
		else
			usr << SPAN_WARNING("[name]: icon NOT exist!")
*/
/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/hair

	icon = 'icons/mob/hair.dmi'	  // default icon for all hairs

/datum/sprite_accessory/hair/bald
	name = "Bald"
	icon_state = "bald"
	gender = MALE

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "afro"

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "bigafro"
	gender = MALE

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "afro2"

/datum/sprite_accessory/hair/test
	name = "Asymmetrical Bob"
	icon_state = "asymmbob"
	gender = FEMALE

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "balding"
	gender = MALE

/datum/sprite_accessory/hair/bedhead
	name = "Bedhead"
	icon_state = "bedhead"

/datum/sprite_accessory/hair/bedhead2
	name = "Bedhead 2"
	icon_state = "bedheadv2"

/datum/sprite_accessory/hair/bedhead3
	name = "Bedhead 3"
	icon_state = "bedheadv3"

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "beehive"
	gender = FEMALE

/datum/sprite_accessory/hair/beehive2
	name = "Beehive 2"
	icon_state = "beehive2"
	gender = FEMALE

/datum/sprite_accessory/hair/birdnest
	name = "Birdnest"
	icon_state = "birdnest"

/datum/sprite_accessory/hair/birdnest2
	name = "Birdnest 2"
	icon_state = "birdnest2"

/datum/sprite_accessory/hair/blackswordsman
	name = "Mercenary"
	icon_state = "blackswordsman"

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "bobcut"
	gender = FEMALE

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "bobcurl"
	gender = FEMALE

/datum/sprite_accessory/hair/bowl1
	name = "Bowl 1"
	icon_state = "bowlcut1"
	gender = MALE

/datum/sprite_accessory/hair/bowl2
	name = "Bowl 2"
	icon_state = "bowlcut2"
	gender = MALE

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon_state = "braid"
	gender = FEMALE

/datum/sprite_accessory/hair/braid2
	name = "Long Braid"
	icon_state = "hbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/buisness
	name = "Buisness Hair"
	icon_state = "business"

/datum/sprite_accessory/hair/buisness2
	name = "Buisness Hair 2"
	icon_state = "business2"

/datum/sprite_accessory/hair/buisness3
	name = "Buisness Hair 3"
	icon_state = "business3"

/datum/sprite_accessory/hair/buisness4
	name = "Buisness Hair 4"
	icon_state = "business4"

/datum/sprite_accessory/hair/bun
	name = "Bun"
	icon_state = "bun"

/datum/sprite_accessory/hair/bun_casual
	name = "Casual Bun"
	icon_state = "bunalt"

/datum/sprite_accessory/hair/bun2
	name = "Bun 2"
	icon_state = "bun2"

/datum/sprite_accessory/hair/bun3
	name = "Bun 3"
	icon_state = "bun3"

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "buzzcut"
	gender = MALE

/datum/sprite_accessory/hair/chop
	name = "Chop"
	icon_state = "chop"

/datum/sprite_accessory/hair/cia
	name = "CIA"
	icon_state = "cia"

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "combover"
	gender = MALE

/datum/sprite_accessory/hair/cofeehouse
	name = "Coffee House"
	icon_state = "coffeehouse"
	gender = MALE

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "crewcut"
	gender = MALE

/datum/sprite_accessory/hair/crono
	name = "Chrono"
	icon_state = "toriyama"

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "curls"

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "cuthair"

/datum/sprite_accessory/hair/dandypomp
	name = "Dandy Pompadour"
	icon_state = "dandypompadour"

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "devilock"
	gender = MALE

/datum/sprite_accessory/hair/doublebun
	name = "Double-Bun"
	icon_state = "doublebun"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "dreads"

/datum/sprite_accessory/hair/eighties
	name = "80's"
	icon_state = "80s"

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "emo"

/datum/sprite_accessory/hair/fag
	name = "Flow Hair"
	icon_state = "flowhair"

/datum/sprite_accessory/hair/familyman
	name = "The Family Man"
	icon_state = "thefamilyman"
	gender = MALE

/datum/sprite_accessory/hair/father
	name = "Father"
	icon_state = "father"
	gender = MALE

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "feather"

/datum/sprite_accessory/hair/femcut
	name = "Cut Hair Alt"
	icon_state = "femc"

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "flair"

/datum/sprite_accessory/hair/fringeemo
	name = "Emo Fringe"
	icon_state = "emofringe"

/datum/sprite_accessory/hair/fringetail
	name = "Fringetail"
	icon_state = "fringetail"

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "gelled"

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "gentle"

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "halfbang"

/datum/sprite_accessory/hair/halfbangalt
	name = "Half-banged Hair Alt"
	icon_state = "halfbang_alt"

/datum/sprite_accessory/hair/halfshaved
	name = "Half-Shaved"
	icon_state = "halfshaved"

/datum/sprite_accessory/hair/halfshavedemo
	name = "Half-Shaved Emo"
	icon_state = "halfshaved_emo"

/datum/sprite_accessory/hair/hamasaki
	name = "Hamaski Hair"
	icon_state = "hamasaki"

/datum/sprite_accessory/hair/hbangs
	name = "Combed Hair"
	icon_state = "hbangs"

/datum/sprite_accessory/hair/hbangsalt
	name = "Combed Hair Alt"
	icon_state = "hbangs_alt"

/datum/sprite_accessory/hair/highpony
	name = "High Ponytail"
	icon_state = "highponytail"
	gender = FEMALE

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "himecut"

/datum/sprite_accessory/hair/himecutalt
	name = "Hime Cut Alt"
	icon_state = "himecut_alt"
	gender = FEMALE

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hitop"
	gender = MALE

/datum/sprite_accessory/hair/jensen
	name = "Adam Jensen Hair"
	icon_state = "jensen"
	gender = MALE

/datum/sprite_accessory/hair/joestar
	name = "Joestar"
	icon_state = "joestar"
	gender = MALE

/datum/sprite_accessory/hair/kagami
	name = "Pigtails"
	icon_state = "kagami"
	gender = FEMALE

/datum/sprite_accessory/hair/kare
	name = "Kare"
	icon_state = "kare"

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "kusanagi"

/datum/sprite_accessory/hair/ladylike
	name = "Ladylike"
	icon_state = "ladylike"
	gender = FEMALE

/datum/sprite_accessory/hair/ladylike2
	name = "Ladylike alt"
	icon_state = "ladylike2"
	gender = FEMALE

/datum/sprite_accessory/hair/longemo
	name = "Long Emo"
	icon_state = "emolong"
	gender = FEMALE

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "vlong"

/datum/sprite_accessory/hair/longeralt2
	name = "Long Hair Alt"
	icon_state = "longeralt2"

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "longest"

/datum/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "vlongfringe"

/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "longfringe"

/datum/sprite_accessory/hair/longovereye
	name = "Overeye Long"
	icon_state = "longovereye"

/datum/sprite_accessory/hair/manbun
	name = "Man Bun"
	icon_state = "manbun"

/datum/sprite_accessory/hair/mahdrills
	name = "Drillruru"
	icon_state = "drillruru"

/datum/sprite_accessory/hair/mbraid
	name = "Medium Braid"
	icon_state = "shortbraid"

/datum/sprite_accessory/hair/mbraidalt
	name = "Medium Braid Alt"
	icon_state = "mediumbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/messy_bun
	name = "Messy Bun"
	icon_state = "messybun"
	gender = FEMALE

/datum/sprite_accessory/hair/modern
	name = "Modern"
	icon_state = "modern"

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "mohawk"

/datum/sprite_accessory/hair/mulder
	name = "Mulder"
	icon_state = "mulder"

/datum/sprite_accessory/hair/nia
	name = "Nia"
	icon_state = "nia"

/datum/sprite_accessory/hair/nitori
	name = "Nitori"
	icon_state = "nitori"
	gender = FEMALE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "odango"
	gender = FEMALE

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "ombre"

/datum/sprite_accessory/hair/oxton
	name = "Oxton"
	icon_state = "oxton"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "parted"

/datum/sprite_accessory/hair/pixie
	name = "Pixie"
	icon_state = "pixie"
	gender = FEMALE

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "pompadour"
	gender = MALE

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail 1"
	icon_state = "ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "ponytail2"
	gender = FEMALE

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "ponytail3"

/datum/sprite_accessory/hair/ponytail4
	name = "Ponytail 4"
	icon_state = "ponytail4"
	gender = FEMALE

/datum/sprite_accessory/hair/ponytail5
	name = "Ponytail 5"
	icon_state = "ponytail5"

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "ponytail6"

/datum/sprite_accessory/hair/ponytail7
	name = "Ponytail 7"
	icon_state = "ponytail7"

/datum/sprite_accessory/hair/poofy
	name = "Poofy"
	icon_state = "poofy"

/datum/sprite_accessory/hair/poofy2
	name = "Poofy Alt"
	icon_state = "poofy2"

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "quiff"
	gender = MALE

/datum/sprite_accessory/hair/ramona
	name = "Ramona"
	icon_state = "ramona"

/datum/sprite_accessory/hair/reversemohawk
	name = "Reverse Mohawk"
	icon_state = "reversemohawk"
	gender = MALE

/datum/sprite_accessory/hair/ronin
	name = "Ronin"
	icon_state = "ronin"
	gender = MALE

/datum/sprite_accessory/hair/rows
	name = "Rows"
	icon_state = "rows1"

/datum/sprite_accessory/hair/rows2
	name = "Rows Alt"
	icon_state = "rows2"

/datum/sprite_accessory/hair/rows3
	name = "Rows Bun"
	icon_state = "rows3"

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "sargeant"
	gender = MALE

/datum/sprite_accessory/hair/scully
	name = "Scully"
	icon_state = "scully"
	gender = FEMALE

/datum/sprite_accessory/hair/shavedmohawk
	name = "Shaved Mohawk"
	icon_state = "shavedmohawk"
	gender = MALE

/datum/sprite_accessory/hair/shavedpart
	name = "Shaved Part"
	icon_state = "shavedpart"
	gender = MALE

/datum/sprite_accessory/hair/short
	name = "Short Hair"
	icon_state = "short"

/datum/sprite_accessory/hair/short2
	name = "Short Hair 2"
	icon_state = "short2"

/datum/sprite_accessory/hair/short3
	name = "Short Hair 3"
	icon_state = "short3"

/datum/sprite_accessory/hair/shortbangs
	name = "Short Bangs"
	icon_state = "shortbangs"

/datum/sprite_accessory/hair/shortovereye
	name = "Overeye Short"
	icon_state = "shortovereye"

/datum/sprite_accessory/hair/shoulderlength
	name = "Shoulder-length Hair"
	icon_state = "shoulderlen"

/datum/sprite_accessory/hair/sidepart
	name = "Sidepart Hair"
	icon_state = "sidepart"

/datum/sprite_accessory/hair/sideponytail
	name = "Side Ponytail"
	icon_state = "stail"
	gender = FEMALE

/datum/sprite_accessory/hair/sideponytail2
	name = "One Shoulder"
	icon_state = "oneshoulder"

/datum/sprite_accessory/hair/sideponytail3
	name = "Tress Shoulder"
	icon_state = "tressshoulder"

/datum/sprite_accessory/hair/sideponytail4
	name = "Side Ponytail 2"
	icon_state = "ponytailf"

/datum/sprite_accessory/hair/sideswept
	name = "Side Swipe"
	icon_state = "sideswipe"

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "skinhead"

/datum/sprite_accessory/hair/smessy
	name = "Messy Hair"
	icon_state = "smessy"

/datum/sprite_accessory/hair/sleeze
	name = "Sleeze"
	icon_state = "sleeze"

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "spikey"

/datum/sprite_accessory/hair/stylo
	name = "Stylo"
	icon_state = "stylo"

/datum/sprite_accessory/hair/spikyponytail
	name = "Spiky Ponytail"
	icon_state = "spikyponytail"

/datum/sprite_accessory/hair/topknot
	name = "Top Knot"
	icon_state = "topknot"

/datum/sprite_accessory/hair/thinning
	name = "Thinning"
	icon_state = "thinning"
	gender = MALE

/datum/sprite_accessory/hair/thinningrear
	name = "Thinning Rear"
	icon_state = "thinningrear"
	gender = MALE

/datum/sprite_accessory/hair/thinningfront
	name = "Thinning Front"
	icon_state = "thinningfront"
	gender = MALE

/datum/sprite_accessory/hair/undercut
	name = "Undercut"
	icon_state = "undercut"
	gender = MALE

/datum/sprite_accessory/hair/unkept
	name = "Unkept"
	icon_state = "unkept"

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "updo"
	gender = FEMALE

/datum/sprite_accessory/hair/vegeta
	name = "Vegeta"
	icon_state = "toriyama2"
	gender = MALE

/datum/sprite_accessory/hair/veryshortovereye
	name = "Overeye Very Short"
	icon_state = "veryshortovereye"

/datum/sprite_accessory/hair/veryshortovereyealternate
	name = "Overeye Very Short, Alternate"
	icon_state = "veryshortovereyealternate"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "volaju"

/datum/sprite_accessory/hair/wisp
	name = "Wisp"
	icon_state = "wisp"
	gender = FEMALE

/datum/sprite_accessory/hair/zieglertail
	name = "Zieglertail"
	icon_state = "ziegler"

/datum/sprite_accessory/hair/zone
	name = "Zone Braid"
	icon_state = "zone"
	gender = FEMALE



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

/datum/sprite_accessory/facial_hair/shaved
	name = "Shaved"
	icon_state = "shaved"
	gender = NEUTER

/datum/sprite_accessory/facial_hair/watson
	name = "Watson Mustache"
	icon_state = "watson"

/datum/sprite_accessory/facial_hair/hogan
	name = "Hulk Hogan Mustache"
	icon_state = "hogan" //-Neek

/datum/sprite_accessory/facial_hair/vandyke
	name = "Van Dyke Mustache"
	icon_state = "vandyke"

/datum/sprite_accessory/facial_hair/chaplin
	name = "Square Mustache"
	icon_state = "chaplin"

/datum/sprite_accessory/facial_hair/selleck
	name = "Selleck Mustache"
	icon_state = "selleck"

/datum/sprite_accessory/facial_hair/neckbeard
	name = "Neckbeard"
	icon_state = "neckbeard"

/datum/sprite_accessory/facial_hair/fullbeard
	name = "Full Beard"
	icon_state = "fullbeard"

/datum/sprite_accessory/facial_hair/longbeard
	name = "Long Beard"
	icon_state = "longbeard"

/datum/sprite_accessory/facial_hair/vlongbeard
	name = "Very Long Beard"
	icon_state = "wise"

/datum/sprite_accessory/facial_hair/elvis
	name = "Elvis Sideburns"
	icon_state = "elvis"

/datum/sprite_accessory/facial_hair/abe
	name = "Abraham Lincoln Beard"
	icon_state = "abe"

/datum/sprite_accessory/facial_hair/chinstrap
	name = "Chinstrap"
	icon_state = "chin"

/datum/sprite_accessory/facial_hair/hip
	name = "Hipster Beard"
	icon_state = "hip"

/datum/sprite_accessory/facial_hair/gt
	name = "Goatee"
	icon_state = "gt"

/datum/sprite_accessory/facial_hair/jensen
	name = "Adam Jensen Beard"
	icon_state = "jensen"

/datum/sprite_accessory/facial_hair/volaju
	name = "Volaju"
	icon_state = "volaju"

/datum/sprite_accessory/facial_hair/dwarf
	name = "Dwarf Beard"
	icon_state = "dwarf"

/datum/sprite_accessory/facial_hair/threeOclock
	name = "3 O'clock Shadow"
	icon_state = "3oclock"

/datum/sprite_accessory/facial_hair/threeOclockstache
	name = "3 O'clock Shadow and Moustache"
	icon_state = "3oclockmoustache"

/datum/sprite_accessory/facial_hair/fiveOclock
	name = "5 O'clock Shadow"
	icon_state = "5oclock"

/datum/sprite_accessory/facial_hair/fiveOclockstache
	name = "5 O'clock Shadow and Moustache"
	icon_state = "5oclockmoustache"

/datum/sprite_accessory/facial_hair/sevenOclock
	name = "7 O'clock Shadow"
	icon_state = "7oclock"

/datum/sprite_accessory/facial_hair/sevenOclockstache
	name = "7 O'clock Shadow and Moustache"
	icon_state = "7oclockmoustache"

/datum/sprite_accessory/facial_hair/mutton
	name = "Mutton Chops"
	icon_state = "mutton"

/datum/sprite_accessory/facial_hair/muttonmu
	name = "Mutton Chops and Moustache"
	icon_state = "muttonmu"

/datum/sprite_accessory/facial_hair/walrus
	name = "Walrus Moustache"
	icon_state = "walrus"