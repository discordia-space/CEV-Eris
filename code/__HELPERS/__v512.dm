// v513 ships with "arctan()" builtin
#if DM_VERSION < 513
proc/arctan(x)
	var/y = arcsin(x/sqrt(1+x*x))
	return y
#endif
