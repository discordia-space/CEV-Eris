#define Clamp(x, y, z) 	(x <= y ? y : (x >= z ? z : x))
#define CLAMP01(x) 		(Clamp(x, 0, 1))


//MOB LEVEL

#define ismob(A) istype(A, /mob)

#define isobserver(A) istype(A, /mob/observer)

#define isghost(A) istype(A, /mob/observer/ghost)

#define isEye(A) istype(A, /mob/observer/eye)

#define isangel(A) istype(A, /mob/observer/eye/angel)

#define isnewplayer(A) istype(A, /mob/new_player)
//++++++++++++++++++++++++++++++++++++++++++++++

#define isliving(A) istype(A, /mob/living)
//---------------------------------------------------

#define iscarbon(A) istype(A, /mob/living/carbon)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define ishuman(A) istype(A, /mob/living/carbon/human)
//---------------------------------------------------

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)
//---------------------------------------------------

#define issilicon(A) istype(A, /mob/living/silicon)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)


//---------------------------------------------------


//OBJECT LEVEL
#define isobj(A) istype(A, /obj)

#define isorgan(A) istype(A, /obj/item/organ/external)



#define islist(A) istype(A, /list)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

