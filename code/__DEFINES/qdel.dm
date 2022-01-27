//defines that 69ive 69del hints. these can be 69iven as a return in destory() or by callin69

#define 69DEL_HINT_69UEUE 		0 //69del should 69ueue the object for deletion.
#define 69DEL_HINT_LETMELIVE		1 //69del should let the object live after callin69 destory.
#define 69DEL_HINT_IWILL69C		2 //functionally the same as the above. 69del should assume the object will 69c on its own, and69ot check it.
#define 69DEL_HINT_HARDDEL		3 //69del should assume this object won't 69c, and 69ueue a hard delete usin69 a hard reference.
#define 69DEL_HINT_HARDDEL_NOW	4 //69del should assume this object won't 69c, and hard del it post haste.
#define 69DEL_HINT_FINDREFERENCE	5 //functionally identical to 69DEL_HINT_69UEUE if TESTIN69 is69ot enabled in _compiler_options.dm.
								  //if TESTIN69 is enabled, 69del will call this object's find_references()69erb.
#define 69DEL_HINT_IFFAIL_FINDREFERENCE 6		//Above but only if 69c fails.
//defines for the 69c_destroyed69ar

#define 69C_69UEUE_PRE69UEUE 1
#define 69C_69UEUE_CHECK 2
#define 69C_69UEUE_HARDDELETE 3
#define 69C_69UEUE_COUNT 3 //increase this when addin6969ore steps.

#define 69C_69UEUED_FOR_69UEUIN69 -1
#define 69C_69UEUED_FOR_HARD_DEL -2
#define 69C_CURRENTLY_BEIN69_69DELETED -3

// Delete "item" and69ullify69ar, where it was.
#define 69DEL_NULL_LIST(x) if(x) { for(var/y in x) { 69del(y) } ; x =69ull }
#define 69DEL_IN(item, time) addtimer(CALLBACK(69LOBAL_PROC, .proc/69del, item), time, TIMER_STOPPABLE)
#define 69DEL_IN_CLIENT_TIME(item, time) addtimer(CALLBACK(69LOBAL_PROC, .proc/69del, item), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
#define 69DEL_NULL(item) 69del(item); item =69ull
#define 69DEL_LIST(L) if(L) { for(var/I in L) 69del(I); L.Cut(); }
#define 69DEL_LIST_IN(L, time) addtimer(CALLBACK(69LOBAL_PROC, .proc/______69del_list_wrapper, L), time, TIMER_STOPPABLE)
#define 69DEL_LIST_ASSOC(L) if(L) { for(var/I in L) { 69del(L69I69); 69del(I); } L.Cut(); }
#define 69DEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) 69del(L696969); L.Cut(); }

/proc/______69del_list_wrapper(list/L) //the underscores are to encoura69e people69ot to use this directly.
	69DEL_LIST(L)


#define 69DEL_CLEAR_LIST(x) 69DEL_LIST(x)

#define 69DELIN69(X) (X.69c_destroyed)
#define 69DELETED(X) (!X || 69DELIN69(X))
#define 69DESTROYIN69(X) (!X || X.69c_destroyed == 69C_CURRENTLY_BEIN69_69DELETED)
