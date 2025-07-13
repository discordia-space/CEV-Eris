Any time you make a change to the schema files, remember to increment the database schema version. Generally increment the minor number, major should be reserved for significant changes to the schema. Both values go up to 255.

Make sure to also update `DB_MAJOR_VERSION` and `DB_MINOR_VERSION`, which can be found in `code/__DEFINES/subsystem.dm`.

The latest database version is 1.0; The query to update the schema revision table is:

```sql
INSERT INTO `schema_revision` (`major`, `minor`) VALUES (1, 0);
```


In any query remember to add a prefix to the table names if you use one.

-----------------------------------------------------
Version 1.0 16 March 2025, by Flleeppyy
Add `byond_build` and `byond_version` to the `connection_log` table.

```sql
ALTER TABLE `connection_log` ADD COLUMN `byond_version` varchar(8) DEFAULT NULL, ADD COLUMN `byond_build` varchar(255) DEFAULT NULL;
```
-----------------------------------------------------
