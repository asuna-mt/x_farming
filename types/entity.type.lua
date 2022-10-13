---https://github.com/sumneko/lua-language-server/wiki

---Entity definition
---@class EntityDef
---@field initial_properties ObjectProperties A table of object properties. The properties in this table are applied to the object once when it is spawned. `dtime_s` is the time passed since the object was unloaded, which can be used for updating the entity state.
---@field on_activate fun(self: table, staticdata: string, dtime_s: integer|number) Function receive a "luaentity" table as `self`. Called when the object is instantiated.
---@field on_deactivate fun(self: table, removal: boolean): nil Function receive a "luaentity" table as `self`. Called when the object is about to get removed or unloaded. `removal`: boolean indicating whether the object is about to get removed. Calling `object:remove()` on an active object will call this with `removal=true`. The mapblock the entity resides in being unloaded will call this with `removal=false`. Note that this won't be called if the object hasn't been activated in the first place. In particular, `minetest.clear_objects({mode = "full"})` won't call this, whereas `minetest.clear_objects({mode = "quick"})` might call this.
---@field on_step fun(self: table, dtime: integer|number, moveresult?: table) Function receive a "luaentity" table as `self`. Called on every server tick, after movement and collision processing. `dtime`: elapsed time since last call. `moveresult`: table with collision info (only available if physical=true).
---@field on_punch fun(self: table, puncher: ObjectRef|nil, time_from_last_punch: number|integer|nil, tool_capabilities: ToolCapabilitiesDef|nil, dir: Vector, damage: number|integer): boolean|nil Function receive a "luaentity" table as `self`. Called when somebody punches the object. Note that you probably want to handle most punches using the automatic armor group system. Can return `true` to prevent the default damage mechanism.
---@field on_death fun(self: table, killer: ObjectRef|nil): nil Function receive a "luaentity" table as `self`. Called when the object dies.
---@field on_rightclick fun(self: table, clicker: ObjectRef): nil Function receive a "luaentity" table as `self`. Called when `clicker` pressed the 'place/use' key while pointing to the object (not neccessarily an actual rightclick). `clicker`: an `ObjectRef` (may or may not be a player)
---@field on_attach_child fun(self: table, child: ObjectRef): nil Function receive a "luaentity" table as `self`. `child`: an `ObjectRef` of the child that attaches
---@field on_detach_child fun(self: table, child: ObjectRef): nil Function receive a "luaentity" table as `self`. `child`: an `ObjectRef` of the child that detaches
---@field on_detach fun(self: table, parent: ObjectRef|nil) Function receive a "luaentity" table as `self`. `parent`: an `ObjectRef` (can be `nil`) from where it got detached. This happens before the parent object is removed from the world.
---@field get_staticdata fun(self: table) Function receive a "luaentity" table as `self`. Should return a string that will be passed to `on_activate` when the object is instantiated the next time.

---Entity definition
---@class ObjectProperties
