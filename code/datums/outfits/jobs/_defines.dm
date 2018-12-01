#define OUTFIT_JOB_NAME(job_name) ("Job - " + job_name)

#define BACKPACK_OVERRIDE_CHEMISTRY \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/chemistry; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/chem; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/chem;

#define BACKPACK_OVERRIDE_ENGINEERING \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/industrial; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/eng; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/satchel;

#define BACKPACK_OVERRIDE_MEDICAL \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/medic; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/norm; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/satchel;

#define BACKPACK_OVERRIDE_RESEARCH \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/norm; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/satchel;

#define BACKPACK_OVERRIDE_SECURITY \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/security; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/sec; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/satchel;

#define BACKPACK_OVERRIDE_VIROLOGY \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/medic; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/norm; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/viro;

#define BACKPACK_OVERRIDE_GARDENER \
backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/hydroponics; \
backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/hyd; \
//backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/hyd;
