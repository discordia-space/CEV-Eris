//Caliber Defines
#define CAL_357 ".357"
#define CAL_CLRIFLE ".25 Caseless"
#define CAL_SRIFLE ".20"
#define CAL_PISTOL ".35"
#define CAL_LRIFLE ".30"
#define CAL_MAGNUM ".40 magnum"
#define CAL_ANTIM ".60 Anti Material"
#define CAL_SHOTGUN "Shotgun Shell"
#define CAL_70 ".70"
#define CAL_CAP "plastic cap"
#define CAL_ROCKET "rocket propelled grenade"
#define CAL_DART "chemical dart"
#define CAL_FLARE "flare shell"
#define CAL_GRENADE "grenade"
#define CAL_CBOLT "crossbow bolt"

//Gun loading types
#define SINGLE_CASING 	1	//The gun only accepts ammo_casings. ammo_magazines should never have this as their mag_type.
#define SPEEDLOADER 	2	//Transfers casings from the mag to the gun when used.
#define MAGAZINE 		4	//The magazine item itself goes inside the gun

#define MAG_WELL_GENERIC	0	//Undefined guns
#define MAG_WELL_L_PISTOL	1	//Unused
#define MAG_WELL_PISTOL		2   //.35 Pistols
#define MAG_WELL_H_PISTOL	4	//.35 High cap Pistols
#define MAG_WELL_SMG		8	//.35 smgs
#define MAG_WELL_RIFLE		16	//.30 and .20 rifle mags
#define MAG_WELL_IH			32	//.25 IH guns
#define MAG_WELL_PAN		64	//.30 Lmgs with pan mags
#define MAG_WELL_RIFLE_D	128	//.30 and .20 drum mags
#define MAG_WELL_RIFLE_L	256 //.20 long rifle mags
#define MAG_WELL_BOX		512	//.30 Lmgs with box mags
#define MAG_WELL_DART		1024//Dartgun mag

#define SLOT_BARREL "barrel"
#define SLOT_GRIP "grip"
#define SLOT_TRIGGER "trigger"
#define SLOT_MUZZLE "muzzle"
#define SLOT_SCOPE "scope"
#define SLOT_UNDERBARREL "underbarrel"
#define SLOT_MECHANICS "mechanics"
#define SLOT_BAYONET "bayonet slot"
