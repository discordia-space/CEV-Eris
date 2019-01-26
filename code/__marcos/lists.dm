#define listequal(A, B) (A.len == B.len && !length(A^B))

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)

#define LAZYINITLIST(L) if (!L) L = list()

#define UNSETEMPTY(L) if (L && !L.len) L = null
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!L.len) { L = null; } }
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= L.len ? L[I] : null) : L[I]) : null)
#define LAZYLEN(L) length(L)
#define LAZYCLEARLIST(L) if(L) L.Cut()

//Sets the value of a key in an assoc list
#define LAZYASET(L,K,V) if(!L) { L = list(); } L[K] = V;

//Adds value to the existing value of a key
#define LAZYAPLUS(L,K,V) if(!L) { L = list(); } if (!L[K]) { L[K] = 0; } L[K] += V;

//Subtracts value from the existing value of a key
#define LAZYAMINUS(L,K,V) if(!L) { L = list(); } if (!L[K]) { L[K] = 0; } L[K] -= V;