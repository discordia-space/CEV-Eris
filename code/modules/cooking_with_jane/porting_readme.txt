Things to keep in mind when porting to eris:

- Cooking has to be initialized with initialize_cooking_recipes() in /datum/global_init/New().
It has to be ran AFTER initialize_chemical_reagents() and initialize_chemical_reactions()!

- The CtrlShiftClickOn, CtrlShiftClick, CtrlClickOn and CtrlClick procs need to be updated to
recieve the params value from the ClickOn function. This is needed for the stove and grill
to function.

- Any atom used as an ingredient in cooking needs a 'food_quality' variable.

- Any atom produced by cooking needs a 'food_quality' variable AND a 'cooking_description_modifier' variable.

- Modify slicable food to inherit the food quality of their parent.

- The function call createCookingCatalogs() has to be added at the end of the
/hook/startup/proc/createCatalogs() function.

- Add # exclusion to the sanitizeFileName function.

- The statment hard_drive.store_file(new/datum/computer_file/program/cook_catalog()) should be
added to any PDA's install_default_programs() proc if they should have it at round start
