---
--- Migration script: remove the storage.old_extended_collision_area flag.
--- The "Extended collision area" setting was removed in 2.4.0 (turbines are
--- marked tall instead of using collision-rect entities), so the flag is
--- obsolete. The collision-rect entities themselves are removed by the engine
--- when their prototypes disappear.

log("start migration to 2.4.0")
storage.old_extended_collision_area = nil
log("migration to 2.4.0 finished")
