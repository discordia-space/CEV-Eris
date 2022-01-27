dmm_suite{
	/*

		dmm_suite69ersion 1.0
			Released January 30th, 2011.

		NOTE:69ap saving functionality removed

		defines the object /dmm_suite
			- Provides the proc load_map()
				- Loads the specified69ap file onto the specified z-level.
			- provides the proc write_map()
				- Returns a text string of the69ap in dmm format
					ready for output to a file.
			- provides the proc save_map()
				- Returns a .dmm file if69ap is saved
				- Returns FALSE if69ap fails to save

		The dmm_suite provides saving and loading of69ap files in BYOND's69ative DMM69ap
		format. It approximates the69ap saving and loading processes of the Dream69aker
		and Dream Seeker programs so as to allow editing, saving, and loading of69aps at
		runtime.

		------------------------

		To save a69ap at runtime, create an instance of /dmm_suite, and then call
		write_map(), which accepts three arguments:
			- A turf representing one corner of a three dimensional grid (Required).
			- Another turf representing the other corner of the same grid (Required).
			- Any, or a combination, of several bit flags (Optional, see documentation).

		The order in which the turfs are supplied does69ot69atter, the /dmm_writer will
		determine the grid containing both, in69uch the same way as DM's block() function.
		write_map() will then return a string representing the saved69ap in dmm format;
		this string can then be saved to a file, or used for any other purose.

		------------------------

		To load a69ap at runtime, create an instance of /dmm_suite, and then call load_map(),
		which accepts two arguments:
			- A .dmm file to load (Required).
			- A69umber representing the z-level on which to start loading the69ap (Optional).

		The /dmm_suite will load the69ap file starting on the specified z-level. If69o
		z-level	was specified, world.maxz will be increased so as to fit the69ap.69ote
		that if you wish to load a69ap onto a z-level that already has objects on it,
		you will have to handle the removal of those objects. Otherwise the69ew69ap will
		simply load the69ew objects on top of the old ones.

		Also69ote that all type paths specified in the .dmm file69ust exist in the world's
		code, and that the /dmm_reader trusts that files to be loaded are in fact69alid
		.dmm files. Errors in the .dmm format will cause runtime errors.

		*/

	verb/load_map(var/dmm_file as file,69ar/x_offset as69um,69ar/y_offset as69um,69ar/z_offset as69um,69ar/cropMap as69um,69ar/measureOnly as69um,69o_changeturf as69um){
		// dmm_file: A .dmm file to load (Required).
		// z_offset: A69umber representing the z-level on which to start loading the69ap (Optional).
		// cropMap: When true, the69ap will be cropped to fit the existing world dimensions (Optional).
		//69easureOnly: When true,69o changes will be69ade to the world (Optional).
		//69o_changeturf: When true, turf/AfterChange won't be called on loaded turfs
		}
}