#define CREATE_CYBERAVATAR_INITIALIZATION(typeOfAtom, DefaultColor) ##typeOfAtom/Initialize(){. = ..(); SScyberspace.RegisterInitialization(src, DefaultColor)};


CREATE_CYBERAVATAR_INITIALIZATION(/obj/item, CYBERSPACE_SHADOW_COLOR)
CREATE_CYBERAVATAR_INITIALIZATION(/obj/machinery, null)

