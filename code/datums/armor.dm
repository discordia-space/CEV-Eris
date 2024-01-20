
#define ARMORID "armor-[blunt]-[slash]-[pointy]-[bullet]-[energy]-[electric]-[bomb]-[bio]-[chem]-[rad]"

/proc/getArmor(blunt = 0, slash = 0, pointy = 0, bullet = 0, energy = 0, electric = 0, bomb = 0, bio = 0, chem = 0, rad = 0)
	. = locate(ARMORID)
	if(!.)
		. = new /datum/armor(blunt, slash, pointy, bullet, energy, electric, bomb, bio, chem, rad)

/datum/armor
	var/blunt
	var/slash
	var/pointy
	var/bullet
	var/energy
	var/electric
	var/bomb
	var/chem
	var/bio
	var/rad

/datum/armor/New(blunt = 0, slash = 0, pointy = 0, bullet = 0, energy =0, electric = 0, bomb =0, bio = 0, chem = 0, rad = 0)
	src.blunt = blunt
	src.slash = slash
	src.pointy = pointy
	src.bullet = bullet
	src.energy =energy
	src.electric = electric
	src.bomb =bomb
	src.chem = chem
	src.bio = bio
	src.rad = rad
	tag = ARMORID

/datum/armor/proc/modifyRating(blunt = 0,slash = 0, pointy = 0, bullet = 0, energy = 0, electric = 0, bomb =0, bio = 0, chem = 0, rad = 0)
	return getArmor(src.blunt+blunt,src.slash + slash, src.pointy + pointy, src.bullet+bullet, src.energy+energy, src.electric+electric, src.bomb+bomb, src.bio+bio, src.chem+chem,src.rad+rad)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(blunt+modifier, slash+modifier, pointy+modifier, bullet+modifier, energy+modifier, electric+modifier, bomb+modifier, bio+modifier, chem+modifier, rad+modifier)

/datum/armor/proc/setRating(blunt, slash, pointy, bullet, energy, electric, bomb, bio, chem, rad)
  return getArmor((isnull(blunt) ? src.blunt : blunt),\
				  (isnull(slash) ? src.slash : slash),\
				  (isnull(pointy) ? src.pointy : pointy),\
				  (isnull(bullet) ? src.bullet : bullet),\
				  (isnull(energy) ? src.energy : energy),\
				  (isnull(electric) ? src.electric : electric),\
				  (isnull(bomb) ? src.bomb : bomb),\
				  (isnull(bio) ? src.bio : bio),\
				  (isnull(chem) ? src.chem : chem),\
				  (isnull(rad) ? src.rad : rad))

/datum/armor/proc/getRating(rating)
	return vars[rating]

/datum/armor/proc/getList()
	return list(ARMOR_BLUNT = blunt, ARMOR_SLASH = slash, ARMOR_POINTY = pointy, ARMOR_BULLET = bullet, ARMOR_ENERGY = energy, ARMOR_ELECTRIC = electric, ARMOR_BOMB = bomb, ARMOR_BIO = bio, ARMOR_CHEM = chem, ARMOR_RAD = rad)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(blunt+AA.blunt, slash+AA.slash, pointy+AA.pointy, bullet+AA.bullet, energy+AA.energy, electric+AA.electric, bomb+AA.bomb, bio+AA.bio, chem+AA.chem, rad+AA.rad)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(blunt-AA.blunt,slash-AA.slash,pointy-AA.pointy, bullet-AA.bullet, energy-AA.energy, electric-AA.electric, bomb-AA.bomb, bio-AA.bio, chem-AA.chem, rad-AA.rad)


#undef ARMORID
