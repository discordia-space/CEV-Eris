/**
 * @file hooks.dm
 * Implements hooks, a simple way to run code on pre-defined events.
 */

/** @page hooks Code hooks
 * @section hooks Hooks
 * A hook is defined under /hook in the type tree.
 *
 * To add some code to be called by the hook, define a proc under the type, as so:
 * @code
	hook/foo/proc/bar()
		var/bar = FALSE
		if(bar != TRUE)
			return TRUE //Sucessful
		else
			return FALSE //Error, or runtime.
 * @endcode
 * All hooks must return nonzero on success, as runtimes will force return null.
 */

/**
 * Calls a hook, executing every piece of code that's attached to it.
 * * hook Identifier of the hook to call.
 * * (any) if all hooked code runs successfully, 0 (FALSE) otherwise.
 */
/proc/callHook(hook, list/args=null)
	var/hook_path = text2path("/hook/[hook]")
	if(!hook_path)
		error("Invalid hook '/hook/[hook]' called.")
		return FALSE

	var/caller = new hook_path
	var/success = TRUE
	for(var/P in typesof("[hook_path]/proc"))
		var/returnval = call(caller, P)(arglist(args))

		if(isnull(returnval))
			success = FALSE
	return success
