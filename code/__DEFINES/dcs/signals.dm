// All signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// global signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

//////////////////////////////////////////////////////////////////

///from base of atom/setDir(): (old_dir, new_dir)
#define COMSIG_ATOM_DIR_CHANGE "atom_dir_change"
