// simple is_type and similar inline helpers

#define in_range(source, user) (get_dist(source, user) <= 1 && (get_step(source, 0)?:z) == (get_step(user, 0)?:z))

/// Within given range, but not counting z-levels
#define IN_GIVEN_RANGE(source, other, given_range) (get_dist(source, other) <= given_range && (get_step(source, 0)?:z) == (get_step(other, 0)?:z))

#define isatom(A) (isloc(A))

#define isdatum(thing) (istype(thing, /datum))

#define isweakref(D) (istype(D, /datum/weakref))


#define islist(A) istype(A, /list)

#define ismob(A) istype(A, /mob)

#define isobserver(A) istype(A, /mob/observer)

#define isghost(A) istype(A, /mob/observer/ghost)

#define isEye(A) istype(A, /mob/observer/eye)

#define isangel(A) istype(A, /mob/observer/eye/angel)

#define isnewplayer(A) istype(A, /mob/new_player)

#define isbst(A) istype(A, /mob/living/carbon/human/bst)

#define ismech(A) istype(A, /mob/living/exosuit)

//++++++++++++++++++++++++++++++++++++++++++++++

#define isliving(A) istype(A, /mob/living)
//---------------------------------------------------

#define iscarbon(A) istype(A, /mob/living/carbon)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isroach(A) istype(A, /mob/living/carbon/superior_animal/roach)

#define isgolem(A) istype(A, /mob/living/carbon/superior_animal/golem)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define ishuman(A) istype(A, /mob/living/carbon/human)
//---------------------------------------------------

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define iscat(A) istype(A, /mob/living/simple_animal/cat)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define issuperioranimal(A) istype(A, /mob/living/carbon/superior_animal)

#define isburrow(A) istype(A, /obj/structure/burrow)
//---------------------------------------------------

#define issilicon(A) istype(A, /mob/living/silicon)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)

#define isblitzshell(A) istype(A, /mob/living/silicon/robot/drone/blitzshell)

//-----------------Objects
#define ismovable(A) istype(A, /atom/movable)

#define isobj(A) istype(A, /obj)

#define isHUDobj(A) istype(A, /obj/screen)

#define isitem(A) istype(A, /obj/item)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isgun(A) istype(A, /obj/item/gun)

#define istool(A) istype(A, /obj/item/tool)

#define isCoil(A) istype(A, /obj/item/stack/cable_coil)

#define isstructure(A) (istype(A, /obj/structure))

#define ismachinery(A) (istype(A, /obj/machinery))

#define isProjectile(A) (istype(A, /obj/item/projectile))

#define isWrench(A) istype(A, /obj/item/tool/wrench)

#define isWelder(A) istype(A, /obj/item/tool/weldingtool)

#define isWirecutter(A) istype(A, /obj/item/tool/wirecutters)

#define isScrewdriver(A) istype(A, /obj/item/tool/screwdriver)

#define isMultitool(A) istype(A, /obj/item/tool/multitool)

#define isCrowbar(A) istype(A, /obj/item/tool/crowbar)
