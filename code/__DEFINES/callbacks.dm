#define GLOBAL_PROC "some_magic_bullshit"
/// A shorthand for the callback datum, [documented here](datum/callback.html)
#define CALLBACK new /datum/callback
#define INVOKE_ASYNC world.ImmediateInvokeAsync
/// like CALLBACK but specifically for verb callbacks
#define VERB_CALLBACK new /datum/callback/verb_callback

#define CALLBACK_NEW(typepath, args) CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___callbacknew), typepath, args)


