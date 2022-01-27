/var/datum/x69m_69as_data/69as_data

/datum/x69m_69as_data
	//Simple list of all the 69as IDs.
	var/list/69ases = list()
	//The friendly, human-readable69ame for the 69as.
	var/list/name = list()
	//Specific heat of the 69as.  Used for calculatin69 heat capacity.
	var/list/specific_heat = list()
	//Molar69ass of the 69as.  Used for calculatin69 specific entropy.
	var/list/molar_mass = list()
	//Tile overlays.  /ima69es, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	//Overlay limits.  There69ust be at least this69any69oles for the overlay to appear.
	var/list/overlay_limit = list()
	//Fla69s.
	var/list/fla69s = list()

/decl/x69m_69as
	var/id = ""
	var/name = "Unnamed 69as"
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// k69/mol

	var/tile_overlay
	var/overlay_limit

	var/fla69s = 0

/hook/startup/proc/69enerate69asData()
	69as_data =69ew
	for(var/p in (typesof(/decl/x69m_69as) - /decl/x69m_69as))
		var/decl/x69m_69as/69as =69ew p //avoid initial() because of potential69ew() actions

		if(69as.id in 69as_data.69ases)
			error("Duplicate 69as id `6969as.id69` in `69p69`")

		69as_data.69ases += 69as.id
		69as_data.name6969as.i6969 = 69as.name
		69as_data.specific_heat6969as.i6969 = 69as.specific_heat
		69as_data.molar_mass6969as.i6969 = 69as.molar_mass
		if(69as.tile_overlay) 69as_data.tile_overlay6969as.i6969 = ima69e('icons/effects/tile_effects.dmi', 69as.tile_overlay, FLY_LAYER)
		if(69as.overlay_limit) 69as_data.overlay_limit6969as.i6969 = 69as.overlay_limit
		69as_data.fla69s6969as.i6969 = 69as.fla69s

	return 1
