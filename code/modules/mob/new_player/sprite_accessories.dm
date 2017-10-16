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

/datum/sprite_accessory/hair/short
	name = "Short Hair"	  // try to capatilize the names please~
	icon_state = "shorthair" // you do not need to define _s or _l sub-states, game automatically does this for you

/datum/sprite_accessory/hair/shorthair2
	name = "Short Hair 2"
	icon_state = "shorthair2"

/datum/sprite_accessory/hair/cut
	name = "Cut Hair"
	icon_state = "CutHair"

/datum/sprite_accessory/hair/long
	name = "Shoulder-length Hair"
	icon_state = "ShoulderlengthHair"

/datum/sprite_accessory/hair/longer
	name = "Long Hair"
	icon_state = "vlong"

/datum/sprite_accessory/hair/long_over_eye
	name = "Long Over Eye"
	icon_state = "longovereye"

/datum/sprite_accessory/hair/longest
	name = "Very Long Hair"
	icon_state = "longest"

/datum/sprite_accessory/hair/longfringe
	name = "Long Fringe"
	icon_state = "longfringe"

/datum/sprite_accessory/hair/longestalt
	name = "Longer Fringe"
	icon_state = "vlongfringe"

/datum/sprite_accessory/hair/gentle
	name = "Gentle"
	icon_state = "gentle"

/datum/sprite_accessory/hair/halfbang
	name = "Half-banged Hair"
	icon_state = "halfbang"

/datum/sprite_accessory/hair/halfbang2
	name = "Half-banged Hair 2"
	icon_state = "halfbang2"

/datum/sprite_accessory/hair/ponytail1
	name = "Ponytail"
	icon_state = "ponytail"

/datum/sprite_accessory/hair/ponytail2
	name = "Ponytail 2"
	icon_state = "ponytail2"

/datum/sprite_accessory/hair/ponytail3
	name = "Ponytail 3"
	icon_state = "ponytail3"

/datum/sprite_accessory/hair/sidetail
	name = "Side Pony"
	icon_state = "sidetail"

/datum/sprite_accessory/hair/sidetail2
	name = "Side Pony 2"
	icon_state = "sidetail2"

/datum/sprite_accessory/hair/sideponytail
	name = "Side Pony tail"
	icon_state = "poofy"

/datum/sprite_accessory/hair/oneshoulder
	name = "One Shoulder"
	icon_state = "oneshoulder"

/datum/sprite_accessory/hair/tressshoulder
	name = "Tress Shoulder"
	icon_state = "tressshoulder"

/datum/sprite_accessory/hair/parted
	name = "Parted"
	icon_state = "parted"

/datum/sprite_accessory/hair/pompadour
	name = "Pompadour"
	icon_state = "pompadour"
	gender = MALE

/datum/sprite_accessory/hair/bigpompadour
	name = "Big Pompadour"
	icon_state = "bigpompadour"
	gender = MALE

/datum/sprite_accessory/hair/quiff
	name = "Quiff"
	icon_state = "quiff"
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

/datum/sprite_accessory/hair/messy
	name = "Messy"
	icon_state = "messy"

/datum/sprite_accessory/hair/beehive
	name = "Beehive"
	icon_state = "beehive"
	gender = FEMALE

/datum/sprite_accessory/hair/bobcurl
	name = "Bobcurl"
	icon_state = "bobcurl"
	gender = FEMALE

/datum/sprite_accessory/hair/bob
	name = "Bob"
	icon_state = "bobcut"
	gender = FEMALE

/datum/sprite_accessory/hair/bowl
	name = "Bowl"
	icon_state = "bowlcut"
	gender = MALE

/datum/sprite_accessory/hair/buzz
	name = "Buzzcut"
	icon_state = "buzzcut"
	gender = MALE

/datum/sprite_accessory/hair/crew
	name = "Crewcut"
	icon_state = "crewcut"
	gender = MALE

/datum/sprite_accessory/hair/combover
	name = "Combover"
	icon_state = "combover"
	gender = MALE

/datum/sprite_accessory/hair/devillock
	name = "Devil Lock"
	icon_state = "devilock"

/datum/sprite_accessory/hair/dreadlocks
	name = "Dreadlocks"
	icon_state = "dreads"

/datum/sprite_accessory/hair/curls
	name = "Curls"
	icon_state = "curls"

/datum/sprite_accessory/hair/afro
	name = "Afro"
	icon_state = "afro"

/datum/sprite_accessory/hair/afro2
	name = "Afro 2"
	icon_state = "afro2"

/datum/sprite_accessory/hair/afro_large
	name = "Big Afro"
	icon_state = "bigafro"
	gender = MALE

/datum/sprite_accessory/hair/sargeant
	name = "Flat Top"
	icon_state = "sargeant"
	gender = MALE

/datum/sprite_accessory/hair/emo
	name = "Emo"
	icon_state = "emo"

/datum/sprite_accessory/hair/fag
	name = "Flow Hair"
	icon_state = "FlowHair"

/datum/sprite_accessory/hair/feather
	name = "Feather"
	icon_state = "feather"

/datum/sprite_accessory/hair/hitop
	name = "Hitop"
	icon_state = "hitop"
	gender = MALE

/datum/sprite_accessory/hair/mohawk
	name = "Mohawk"
	icon_state = "Mohawk"

/datum/sprite_accessory/hair/jensen
	name = "Jensen Hair"
	icon_state = "jensen"
	gender = MALE

/datum/sprite_accessory/hair/gelled
	name = "Gelled Back"
	icon_state = "gelled"
	gender = FEMALE

/datum/sprite_accessory/hair/spiky
	name = "Spiky"
	icon_state = "spikey"

/datum/sprite_accessory/hair/spiky2
	name = "Spiky 2"
	icon_state = "crono"

/datum/sprite_accessory/hair/spiky3
	name = "Spiky 3"
	icon_state = "vegeta"

/datum/sprite_accessory/hair/protagonist
	name = "Slightly long"
	icon_state = "protagonist"

/datum/sprite_accessory/hair/kusangi
	name = "Kusanagi Hair"
	icon_state = "kusanagi"

/datum/sprite_accessory/hair/kagami
	name = "Kagami Hair"
	icon_state = "kagami"
	gender = FEMALE

/datum/sprite_accessory/hair/pigtail
	name = "Pigtails"
	icon_state = "pigtails"
	gender = FEMALE

/datum/sprite_accessory/hair/pigtail2
	name = "Pigtails 2"
	icon_state = "nitori"
	gender = FEMALE

/datum/sprite_accessory/hair/himecut
	name = "Hime Cut"
	icon_state = "himecut"
	gender = FEMALE

/datum/sprite_accessory/hair/antenna
	name = "Ahoge"
	icon_state = "antenna"

/datum/sprite_accessory/hair/lowbraid
	name = "Low Braid"
	icon_state = "hbraid"
	gender = FEMALE

/datum/sprite_accessory/hair/not_floorlength_braid
	name = "High Braid"
	icon_state = "braid2"
	gender = FEMALE

/datum/sprite_accessory/hair/braid
	name = "Floorlength Braid"
	icon_state = "braid"
	gender = FEMALE

/datum/sprite_accessory/hair/odango
	name = "Odango"
	icon_state = "odango"
	gender = FEMALE

/datum/sprite_accessory/hair/ombre
	name = "Ombre"
	icon_state = "ombre"
	gender = FEMALE

/datum/sprite_accessory/hair/updo
	name = "Updo"
	icon_state = "updo"
	gender = FEMALE

/datum/sprite_accessory/hair/skinhead
	name = "Skinhead"
	icon_state = "skinhead"

datum/sprite_accessory/hair/longbangs
	name = "Long Bangs"
	icon_state = "lbangs"

/datum/sprite_accessory/hair/balding
	name = "Balding Hair"
	icon_state = "BaldingHair"
	gender = MALE // turnoff!

/datum/sprite_accessory/hair/CIA
	name = "CIA"
	icon_state = "cia"

/datum/sprite_accessory/hair/bun
	name = "Bun Head"
	icon_state = "bun"

/datum/sprite_accessory/hair/braidtail
	name = "Braided Tail"
	icon_state = "braidtail"

/datum/sprite_accessory/hair/drillhair
	name = "Drill Hair"
	icon_state = "drillhair"

/datum/sprite_accessory/hair/keanu
	name = "Keanu Hair"
	icon_state = "edgeworth"

/datum/sprite_accessory/hair/swept2
	name = "Swept Back Hair 2"
	icon_state = "joestar"

/datum/sprite_accessory/hair/business3
	name = "Business Hair 3"
	icon_state = "cia"

/datum/sprite_accessory/hair/business4
	name = "Business Hair 4"
	icon_state = "mulder"

/datum/sprite_accessory/hair/hedgehog
	name = "Hedgehog Hair"
	icon_state = "blackswordsman"

/datum/sprite_accessory/hair/bob
	name = "Bob Hair"
	icon_state = "schierke"

/datum/sprite_accessory/hair/bob2
	name = "Bob Hair 2"
	icon_state = "scully"

/datum/sprite_accessory/hair/long
	name = "Long Hair 1"
	icon_state = "nia"

datum/sprite_accessory/hair/long2
	name = "Long Hair 2"
	icon_state = "long2"

/datum/sprite_accessory/hair/megaeyebrows
	name = "Mega Eyebrows"
	icon_state = "megaeyebrows"

datum/sprite_accessory/hair/highponytail
	name = "High Ponytail"
	icon_state = "highponytail"

datum/sprite_accessory/hair/longponytail
	name = "Long Ponytail"
	icon_state = "longstraightponytail"

/datum/sprite_accessory/hair/flair
	name = "Flaired Hair"
	icon_state = "flair"

/datum/sprite_accessory/hair/big_tails
	name = "Big tails"
	icon_state = "long_d_tails"
	gender = FEMALE

/datum/sprite_accessory/hair/long_bedhead
	name = "Long bedhead"
	icon_state = "long_bedhead"
	gender = FEMALE

/datum/sprite_accessory/hair/fluttershy
	name = "Fluttershy"
	icon_state = "fluttershy"
	gender = FEMALE

/datum/sprite_accessory/hair/judge
	name = "Judge"
	icon_state = "judge"
	gender = FEMALE

/datum/sprite_accessory/hair/long_braid
	name = "Long braid"
	icon_state = "long_braid"
	gender = FEMALE

/datum/sprite_accessory/hair/elize
	name = "Elize"
	icon_state = "elize"
	gender = FEMALE

/datum/sprite_accessory/hair/elize2
	name = "Elize2"
	icon_state = "elize_2"
	gender = FEMALE

/datum/sprite_accessory/hair/undercut_fem
	name = "Female undercut"
	icon_state = "undercut_fem"
	gender = FEMALE

/datum/sprite_accessory/hair/emo_right
	name = "Emo right"
	icon_state = "emo_r"

/datum/sprite_accessory/hair/applejack
	name = "Applejack"
	icon_state = "applejack"
	gender = FEMALE

/datum/sprite_accessory/hair/rosa
	name = "Rosa"
	icon_state = "rosa"
	gender = FEMALE

//TC trap powah
/datum/sprite_accessory/hair/dave
	name = "Dave"
	icon_state = "dave"

/datum/sprite_accessory/hair/aradia
	name = "Aradia"
	icon_state = "aradia"

/datum/sprite_accessory/hair/nepeta
	name = "Nepeta"
	icon_state = "nepeta"

/datum/sprite_accessory/hair/kanaya
	name = "Kanaya"
	icon_state = "kanaya"

/datum/sprite_accessory/hair/terezi
	name = "Terezi"
	icon_state = "terezi"

/datum/sprite_accessory/hair/vriska
	name = "Vriska"
	icon_state = "vriska"

/datum/sprite_accessory/hair/equius
	name = "Equius"
	icon_state = "equius"

/datum/sprite_accessory/hair/gamzee
	name = "Gamzee"
	icon_state = "gamzee"

/datum/sprite_accessory/hair/feferi
	name = "Feferi"
	icon_state = "feferi"

/datum/sprite_accessory/hair/rose
	name = "Rose"
	icon_state = "rose"

/datum/sprite_accessory/hair/ramona
	name = "Ramona"
	icon_state = "ramona"

/datum/sprite_accessory/hair/dirk
	name = "Dirk"
	icon_state = "dirk"

/datum/sprite_accessory/hair/jade
	name = "Jade"
	icon_state = "jade"

/datum/sprite_accessory/hair/roxy
	name = "Roxy"
	icon_state = "roxy"

/datum/sprite_accessory/hair/side_tail3
	name = "Side tail 3"
	icon_state = "stail"

/datum/sprite_accessory/hair/familyman
	name = "Big Flat Top"
	icon_state = "thefamilyman"

/datum/sprite_accessory/hair/dubsman
	name = "Dubs Hair "
	icon_state = "dubs"

/datum/sprite_accessory/hair/objection
	name = "Swept Back Hair"
	icon_state = "objection"

/datum/sprite_accessory/hair/metal
	name = "Metal"
	icon_state = "80s"

/datum/sprite_accessory/hair/mentalist
	name = "Mentalist"
	icon_state = "mentalist"

/datum/sprite_accessory/hair/fujisaki
	name = "fujisaki"
	icon_state = "fujisaki"

/datum/sprite_accessory/hair/akari
	name = "Twin Buns"
	icon_state = "akari"

/datum/sprite_accessory/hair/fujiyabashi
	name = "Fujiyabashi"
	icon_state = "fujiyabashi"

/datum/sprite_accessory/hair/shinobu
	name = "Shinibu"
	icon_state = "shinobu"

datum/sprite_accessory/hair/twincurl
	name = "Twincurl"
	icon_state = "twincurl"
	gender = FEMALE

/datum/sprite_accessory/hair/rapunzel
	name = "Rapunzel"
	icon_state = "rapunzel"
	gender = FEMALE

datum/sprite_accessory/hair/quadcurls
	name = "Quadcurls "
	icon_state = "quadcurls"
	gender = FEMALE

datum/sprite_accessory/hair/twincurl2
	name = "Twincurl 2"
	icon_state = "twincurl2"
	gender = FEMALE

datum/sprite_accessory/hair/birdnest
	name = "Birdnest "
	icon_state = "birdnest"

datum/sprite_accessory/hair/unkept
	name = "Unkept"
	icon_state = "unkept"

datum/sprite_accessory/hair/fastline
	name = "Fastline"
	icon_state = "fastline"
	gender = MALE

/*
///////////////////////////////////
/  =---------------------------=  /
/  ==BlueBay ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/hair/kare
	name = "Kare"
	icon_state = "kare"

/datum/sprite_accessory/hair/zone
	name = "Zone"
	icon_state = "zone"

/datum/sprite_accessory/hair/ziegler
	name = "Ziegler"
	icon_state = "ziegler"

/datum/sprite_accessory/hair/wisp
	name = "Wisp"
	icon_state = "Wisp"

/datum/sprite_accessory/hair/volaju
	name = "Volaju"
	icon_state = "volaju"

/datum/sprite_accessory/hair/veryshortovereye
	name = "Very Short Over Eye 1"
	icon_state = "veryshortovereye"

/datum/sprite_accessory/hair/veryshortovereyealternate
	name = "Very Short Over Eye 2"
	icon_state = "veryshortovereyealternate"

/datum/sprite_accessory/hair/ponytail6
	name = "Ponytail 6"
	icon_state = "ponytail6"

/datum/sprite_accessory/hair/ponytail7
	name = "Ponytail 7"
	icon_state = "ponytail7"
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
