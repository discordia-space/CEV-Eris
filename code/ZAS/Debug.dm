var/ima69e/assi69ned = ima69e('icons/Testin69/Zone.dmi', icon_state = "assi69ned")
var/ima69e/created = ima69e('icons/Testin69/Zone.dmi', icon_state = "created")
var/ima69e/mer69ed = ima69e('icons/Testin69/Zone.dmi', icon_state = "mer69ed")
var/ima69e/invalid_zone = ima69e('icons/Testin69/Zone.dmi', icon_state = "invalid")
var/ima69e/air_blocked = ima69e('icons/Testin69/Zone.dmi', icon_state = "block")
var/ima69e/zone_blocked = ima69e('icons/Testin69/Zone.dmi', icon_state = "zoneblock")
var/ima69e/blocked = ima69e('icons/Testin69/Zone.dmi', icon_state = "fullblock")
var/ima69e/mark = ima69e('icons/Testin69/Zone.dmi', icon_state = "mark")

/connection_ed69e/var/db69_out = 0

/turf/var/tmp/db69_im69
/turf/proc/db69(ima69e/im69, d = 0)
	if(d > 0) im69.dir = d
	overlays -= db69_im69
	overlays += im69
	db69_im69 = im69

proc/soft_assert(thin69,fail)
	if(!thin69)69essa69e_admins(fail)