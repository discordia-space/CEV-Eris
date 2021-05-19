
#define ARMORID "armor-[melee]-[bullet]-[energy]-[bomb]-[bio]-[rad]"

/proc/getArmor(melee = 0, bullet = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	. = locate(ARMORID)
	if(!.)
		. = new /datum/armor(melee, bullet, energy, bomb, bio, rad)

/datum/armor
	var/melee
	var/bullet
	var/energy
	var/bomb
	var/bio
	var/rad

/datum/armor/New(melee = 0, bullet = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	src.melee = melee
	src.bullet = bullet
	src.energy = energy
	src.bomb = bomb
	src.bio = bio
	src.rad = rad
	tag = ARMORID

/datum/armor/proc/modifyRating(melee = 0, bullet = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	return getArmor(src.melee+melee, src.bullet+bullet, src.energy+energy, src.bomb+bomb, src.bio+bio, src.rad+rad)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(melee+modifier, bullet+modifier, energy+modifier, bomb+modifier, bio+modifier, rad+modifier)

/datum/armor/proc/setRating(melee, bullet, energy, bomb, bio, rad)
  return getArmor((isnull(melee) ? src.melee : melee),\
				  (isnull(bullet) ? src.bullet : bullet),\
				  (isnull(energy) ? src.energy : energy),\
				  (isnull(bomb) ? src.bomb : bomb),\
				  (isnull(bio) ? src.bio : bio),\
				  (isnull(rad) ? src.rad : rad))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list(ARMOR_MELEE = melee, ARMOR_BULLET = bullet, ARMOR_ENERGY = energy, ARMOR_BOMB = bomb, ARMOR_BIO = bio, ARMOR_RAD = rad)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(melee+AA.melee, bullet+AA.bullet, energy+AA.energy, bomb+AA.bomb, bio+AA.bio, rad+AA.rad)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(melee-AA.melee, bullet-AA.bullet, energy-AA.energy, bomb-AA.bomb, bio-AA.bio, rad-AA.rad)


#undef ARMORID
