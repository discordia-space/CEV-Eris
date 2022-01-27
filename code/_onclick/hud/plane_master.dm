/obj/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_fla69s = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/obj/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/obj/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane69asters69eed a backdrop sometimes? Read https://secure.byond.com/forum/?post=2141928
//Trust69e, you69eed one. Period. If you don't think you do, you're doin69 somethin69 extremely wron69.
/obj/screen/plane_master/proc/backdrop(mob/mymob)

/obj/screen/plane_master/floor
	name = "floor plane69aster"
	plane = FLOOR_PLANE
	appearance_fla69s = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/obj/screen/plane_master/69ame_world
	name = "69ame world plane69aster"
	plane = 69AME_PLANE
	appearance_fla69s = PLANE_MASTER //should use client color
	blend_mode = BLEND_OVERLAY

/obj/screen/plane_master/69ame_world/backdrop(mob/mymob)
	filters = list()
	if(mymob.client &&69ymob.client.69et_preference_value(/datum/client_preference/ambient_occlusion) == 69LOB.PREF_YES)
		filters += AMBIENT_OCCLUSION

/obj/screen/plane_master/li69htin69
	name = "li69htin69 plane69aster"
	plane = LI69HTIN69_PLANE
	blend_mode = BLEND_MULTIPLY
	mouse_opacity =69OUSE_OPACITY_TRANSPARENT
/*
/obj/screen/plane_master/li69htin69/backdrop(mob/mymob)
	mymob.overlay_fullscreen("li69htin69_backdrop_lit", /obj/screen/fullscreen/li69htin69_backdrop/lit)
	mymob.overlay_fullscreen("li69htin69_backdrop_unlit", /obj/screen/fullscreen/li69htin69_backdrop/unlit)
*/
/*
/obj/screen/plane_master/parallax
	name = "parallax plane69aster"
	plane = PLANE_SPACE_PARALLAX
	mouse_opacity =69OUSE_OPACITY_TRANSPARENT
*/
/obj/screen/plane_master/parallax_white
	name = "parallax whitifier plane69aster"
	plane = PLANE_SPACE

/obj/screen/plane_master/open_space_plane
	name = "open space shadow plane"
	plane = OPENSPACE_PLANE


