// MAP SHIMS
// This file contains shims that allow for path changes without updating map.
// It's a temporary solution, and mappers are advised to remove such shims on any map update.

// To create a new shim, use this template:
/*
/obj/old_path
	parent_type = /obj/new_path
*/

/obj/item/clothing/glasses/science
	parent_type = /obj/item/clothing/glasses/powered/science

/obj/item/clothing/glasses/meson
	parent_type = /obj/item/clothing/glasses/powered/meson

/obj/item/clothing/glasses/thermal/plain/monocle
	parent_type = /obj/item/clothing/glasses/powered/thermal/plain/monocle
