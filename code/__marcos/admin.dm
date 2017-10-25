#define ADMIN_VERB_ADD(path, rights, keep)\
	world/registrate_verbs() {..(); cmd_registrate_verb(path, rights, keep);}
