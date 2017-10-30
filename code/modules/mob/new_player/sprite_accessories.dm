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

	afro
		name = "Afro"
		icon_state = "afro"

	afro_large
		name = "Big Afro"
		icon_state = "bigafro"
		gender = MALE

	afro2
		name = "Afro 2"
		icon_state = "afro2"

	test
		name = "Asymmetrical Bob"
		icon_state = "asymmbob"
		gender = FEMALE

	balding
		name = "Balding Hair"
		icon_state = "balding"
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

	birdnest
		name = "Birdnest"
		icon_state = "birdnest"

	birdnest2
		name = "Birdnest 2"
		icon_state = "birdnest2"

	blackswordsman
		name = "Mercenary"
		icon_state = "blackswordsman"

	bob
		name = "Bob"
		icon_state = "bobcut"
		gender = FEMALE

	bobcurl
		name = "Bobcurl"
		icon_state = "bobcurl"
		gender = FEMALE

	bowl1
		name = "Bowl 1"
		icon_state = "bowlcut1"
		gender = MALE

	bowl2
		name = "Bowl 2
		con_state = "bowlcut2"
		gender = MALE

	braid
		name = "Floorlength Braid"
		icon_state = "braid"
		gender = FEMALE

	braid2
		name = "Long Braid"
		icon_state = "hbraid"
		gender = FEMALE

	buisness
		name = "Buisness Hair"
		icon_state = "business"

	buisness2
		name = "Buisness Hair 2"
		icon_state = "business2"

	buisness3
		name = "Buisness Hair 3"
		icon_state = "business3"

	buisness4
		name = "Buisness Hair 4"
		icon_state = "business4"

	bun
		name = "Bun"
		icon_state = "bun"

	bun_casual
		name = "Casual Bun"
		icon_state = "bunalt"

	bun2
		name = "Bun 2"
		icon_state = "bun2"

	bun3
		name = "Bun 3"
		icon_state = "bun3"

	buzz
		name = "Buzzcut"
		icon_state = "buzzcut"
		gender = MALE

	chop
		name = "Chop"
		icon_state = "chop"

	cia
		name = "CIA"
		icon_state = "cia"

	combover
		name = "Combover"
		icon_state = "combover"
		gender = MALE

	cofeehouse
		name = "Coffee House"
		icon_state = "coffeehouse"
		gender = MALE

	crew
		name = "Crewcut"
		icon_state = "crewcut"
		gender = MALE

	crono
		name = "Chrono"
		icon_state = "toriyama"

	curls
		name = "Curls"
		icon_state = "curls"

	cut
		name = "Cut Hair"
		icon_state = "cuthair"

	dandypomp
		name = "Dandy Pompadour"
		icon_state = "dandypompadour"

	devillock
		name = "Devil Lock"
		icon_state = "devilock"
		gender = MALE

	doublebun
		name = "Double-Bun"
		icon_state = "doublebun"

	dreadlocks
		name = "Dreadlocks"
		icon_state = "dreads"

	eighties
		name = "80's"
		icon_state = "80s"

	emo
		name = "Emo"
		icon_state = "emo"

	fag
		name = "Flow Hair"
		icon_state = "flowhair"

	familyman
		name = "The Family Man"
		icon_state = "thefamilyman"
		gender = MALE

	father
		name = "Father"
		icon_state = "father"
		gender = MALE

	feather
		name = "Feather"
		icon_state = "feather"

	femcut
		name = "Cut Hair Alt"
		icon_state = "femc"

	flair
		name = "Flaired Hair"
		icon_state = "flair"

	fringeemo
		name = "Emo Fringe"
		icon_state = "emofringe"

	fringetail
		name = "Fringetail"
		icon_state = "fringetail"

	gelled
		name = "Gelled Back"
		icon_state = "gelled"

	gentle
		name = "Gentle"
		icon_state = "gentle"

	halfbang
		name = "Half-banged Hair"
		icon_state = "halfbang"

	halfbangalt
		name = "Half-banged Hair Alt"
		icon_state = "halfbang_alt"

	halfshaved
		name = "Half-Shaved"
		icon_state = "halfshaved"

	halfshavedemo
		name = "Half-Shaved Emo"
		icon_state = "halfshaved_emo"

	hamasaki
		name = "Hamaski Hair"
		icon_state = "hamasaki"

	hbangs
		name = "Combed Hair"
		icon_state = "hbangs"

	hbangsalt
		name = "Combed Hair Alt"
		icon_state = "hbangs_alt"

	highpony
		name = "High Ponytail"
		icon_state = "highponytail"
		gender = FEMALE

	himecut
		name = "Hime Cut"
		icon_state = "himecut"

	himecutalt
		name = "Hime Cut Alt"
		icon_state = "himecut_alt"
		gender = FEMALE

	hitop
		name = "Hitop"
		icon_state = "hitop"
		gender = MALE

	jensen
		name = "Adam Jensen Hair"
		icon_state = "jensen"
		gender = MALE

	joestar
		name = "Joestar"
		icon_state = "joestar"
		gender = MALE

	kagami
		name = "Pigtails"
		icon_state = "kagami"
		gender = FEMALE

	kare
		name = "Kare"
		icon_state = "kare"

	kusangi
		name = "Kusanagi Hair"
		icon_state = "kusanagi"

	ladylike
		name = "Ladylike"
		icon_state = "ladylike"
		gender = FEMALE

	ladylike2
		name = "Ladylike alt"
		icon_state = "ladylike2"
		gender = FEMALE

	longemo
		name = "Long Emo"
		icon_state = "emolong"
		gender = FEMALE

	longer
		name = "Long Hair"
		icon_state = "vlong"

	longeralt2
		name = "Long Hair Alt"
		icon_state = "longeralt2"

	longest
		name = "Very Long Hair"
		icon_state = "longest"

	longestalt
		name = "Longer Fringe"
		icon_state = "vlongfringe"

	longfringe
		name = "Long Fringe"
		icon_state = "longfringe"

	longovereye
		name = "Overeye Long"
		icon_state = "longovereye"

	manbun
		name = "Man Bun"
		icon_state = "manbun"

	mahdrills
		name = "Drillruru"
		icon_state = "drillruru"

	mbraid
		name = "Medium Braid"
		icon_state = "shortbraid"

	mbraidalt
		name = "Medium Braid Alt"
		icon_state = "mediumbraid"
		gender = FEMALE

	messy_bun
		name = "Messy Bun"
		icon_state = "messybun"
		gender = FEMALE

	modern
		name = "Modern"
		icon_state = "modern"

	mohawk
		name = "Mohawk"
		icon_state = "mohawk"

	mulder
		name = "Mulder"
		icon_state = "mulder"

	nia
		name = "Nia"
		icon_state = "nia"

	nitori
		name = "Nitori"
		icon_state = "nitori"
		gender = FEMALE

	odango
		name = "Odango"
		icon_state = "odango"
		gender = FEMALE

	ombre
		name = "Ombre"
		icon_state = "ombre"

	oxton
		name = "Oxton"
		icon_state = "oxton"

	parted
		name = "Parted"
		icon_state = "parted"

	pixie
		name = "Pixie"
		icon_state = "pixie"
		gender = FEMALE

	pompadour
		name = "Pompadour"
		icon_state = "pompadour"
		gender = MALE

	ponytail1
		name = "Ponytail 1"
		icon_state = "ponytail"

	ponytail2
		name = "Ponytail 2"
		icon_state = "ponytail2"
		gender = FEMALE

	ponytail3
		name = "Ponytail 3"
		icon_state = "ponytail3"

	ponytail4
		name = "Ponytail 4"
		icon_state = "ponytail4"
		gender = FEMALE

	ponytail5
		name = "Ponytail 5"
		icon_state = "ponytail5"

	ponytail6
		name = "Ponytail 6"
		icon_state = "ponytail6"

	ponytail7
		name = "Ponytail 7"
		icon_state = "ponytail7"

	poofy
		name = "Poofy"
		icon_state = "poofy"

	poofy2
		name = "Poofy Alt"
		icon_state = "poofy2"

	quiff
		name = "Quiff"
		icon_state = "quiff"
		gender = MALE

	ramona
		name = "Ramona"
		icon_state = "ramona"

	reversemohawk
		name = "Reverse Mohawk"
		icon_state = "reversemohawk"
		gender = MALE

	ronin
		name = "Ronin"
		icon_state = "ronin"
		gender = MALE

	rows
		name = "Rows"
		icon_state = "rows1"

	rows2
		name = "Rows Alt"
		icon_state = "rows2"

	rows3
		name = "Rows Bun"
		icon_state = "rows3"

	sargeant
		name = "Flat Top"
		icon_state = "sargeant"
		gender = MALE

	scully
		name = "Scully"
		icon_state = "scully"
		gender = FEMALE

	shavedmohawk
		name = "Shaved Mohawk"
		icon_state = "shavedmohawk"
		gender = MALE

	shavedpart
		name = "Shaved Part"
		icon_state = "shavedpart"
		gender = MALE

	short
		name = "Short Hair"
		icon_state = "short"

	short2
		name = "Short Hair 2"
		icon_state = "short2"

	short3
		name = "Short Hair 3"
		icon_state = "short3"

	shortbangs
		name = "Short Bangs"
		icon_state = "shortbangs"

	shortovereye
		name = "Overeye Short"
		icon_state = "shortovereye"

	shoulderlength
		name = "Shoulder-length Hair"
		icon_state = "shoulderlen"

	sidepart
		name = "Sidepart Hair"
		icon_state = "sidepart"

	sideponytail
		name = "Side Ponytail"
		icon_state = "stail"
		gender = FEMALE

	sideponytail2
		name = "One Shoulder"
		icon_state = "oneshoulder"

	sideponytail3
		name = "Tress Shoulder"
		icon_state = "tressshoulder"

	sideponytail4
		name = "Side Ponytail 2"
		icon_state = "ponytailf"

	sideswept
		name = "Side Swipe"
		icon_state = "sideswipe"

	skinhead
		name = "Skinhead"
		icon_state = "skinhead"

	smessy
		name = "Messy Hair"
		icon_state = "smessy"

	sleeze
		name = "Sleeze"
		icon_state = "sleeze"

	spiky
		name = "Spiky"
		icon_state = "spikey"

	stylo
		name = "Stylo"
		icon_state = "stylo"

	spikyponytail
		name = "Spiky Ponytail"
		icon_state = "spikyponytail"

	topknot
		name = "Top Knot"
		icon_state = "topknot"

	thinning
		name = "Thinning"
		icon_state = "thinning"
		gender = MALE

	thinningrear
		name = "Thinning Rear"
		icon_state = "thinningrear"
		gender = MALE

	thinningfront
		name = "Thinning Front"
		icon_state = "thinningfront"
		gender = MALE

	undercut
		name = "Undercut"
		icon_state = "undercut"
		gender = MALE

	unkept
		name = "Unkept"
		icon_state = "unkept"

	updo
		name = "Updo"
		icon_state = "updo"
		gender = FEMALE

	vegeta
		name = "Vegeta"
		icon_state = "toriyama2"
		gender = MALE

	veryshortovereye
		name = "Overeye Very Short"
		icon_state = "veryshortovereye"

	veryshortovereyealternate
		name = "Overeye Very Short, Alternate"
		icon_state = "veryshortovereyealternate"

	volaju
		name = "Volaju"
		icon_state = "volaju"

	wisp
		name = "Wisp"
		icon_state = "wisp"
		gender = FEMALE

	zieglertail
		name = "Zieglertail"
		icon_state = "ziegler"

	zone
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

	threeOclock
		name = "3 O'clock Shadow"
		icon_state = "3oclock"

	threeOclockstache
		name = "3 O'clock Shadow and Moustache"
		icon_state = "3oclockmoustache"

	fiveOclock
		name = "5 O'clock Shadow"
		icon_state = "5oclock"

	fiveOclockstache
		name = "5 O'clock Shadow and Moustache"
		icon_state = "5oclockmoustache"

	sevenOclock
		name = "7 O'clock Shadow"
		icon_state = "7oclock"

	sevenOclockstache
		name = "7 O'clock Shadow and Moustache"
		icon_state = "7oclockmoustache"

	mutton
		name = "Mutton Chops"
	icon_state = "mutton"

	muttonmu
		name = "Mutton Chops and Moustache"
		icon_state = "muttonmu"

	walrus
		name = "Walrus Moustache"
		icon_state = "walrus"