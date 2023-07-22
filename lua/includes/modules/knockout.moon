--  Guard to prevent re-execution
if lookup = package.loaded['knockout'] then return lookup

--  Send file to clients
AddCSLuaFile!

--  Save local reference to `include`
include = include

--  Create the replacement environment and save a local reference to the
--  default environment
environment = include 'includes/modules/knockout/environment.lua'
garry = _G

--  Add environments to the cached return value table
package.loaded.knockout = environment
package.loaded.garry = garry

--  Add the default `require` function as `stock_require` in the cached
--  return value table
package.loaded.stock_require = require

--  Switch to the replacement environment
setfenv 1, environment

--  Create the searchers table and metadata cache
package.loaders = include 'includes/modules/knockout/searchers.lua'
package.metadata = include 'includes/modules/knockout/metadata.lua'

--- # `require: function` (shared)
---
--- ## Description
---
--- Return the cached return value of a given module. If the values do not
--- exist within `package.loaded`, the module is executed. If the module does
--- not have a return value, it is implicitly cached as `true`.
---
--- Outside of `package.loaded` which is mirrored between the `knockout` and
--- default global environment, all `package` keyvalues exist only within
--- the `knockout` environment.
---
--- Functionality is dependent on the searcher that successfully resolves the
--- module based on name. There are four searcher functions by default and
--- exist within the `package.loaders` array. Each function is expected to
--- return a structure representing the file's metadata including a generated
--- loader. If the searcher fails, it returns `nil` and then an error message.
---
--- The default search process go as follows:
---
--- 1.  Is there a function in `package.preload` associated with the given
---     name? If so, it's the loader.
--- 2.  Is there a binary module associated with the given name? If so,
---     use a wrapped call to the stock require function as a loader.
--- 3.  Is there a module within `includes/modules/?.lua`? If so, the loader is
---     the loader will execute within the default global environment and the
---     return values are dependent on whatever the module returns or adds to
---     `package.loaded`.
--- 4.  Is there a module that can be found using `package.path`? If so,
---     the loader will execute within the `knockout` environment. The default
---     global environment must be accessed through either
---     `package.loaded.garry`, or more idiomatically,
---     `local garry = require 'garry'`.
---
--- Step 1 is for the off-chance a module needs to be executed in a special
--- way and is inline with Lua 5.1, which also has a `package.preload` table.
---
--- Step 2 is required because binary modules must be executed with the default
--- `require` function.
---
--- Step 3 is for backwards compatability and convenience for people using
--- modules written the old way for Garry's Mod.
---
--- Step 4 is the primary reasoning for this environment, as it allows users
--- to execute modules in a fashion idiomatic to Lua 5.1 and within a Lua 5.1
--- styled environment.
---
--- ## Parameters
---
--- 1.  param `name: string`
---     The name of the module (not a filepath)
---
--- ## Returns
---
--- 1.  `any`
---     Whatever the module returned or `true` indicating successful execution
---
--- ## Warning
---
--- * `require` will not function until `includes/mmodules/knockout.lua` is
---   executed at least once, as this file monkey patches `require`!
--- * Errors will be thrown for modules that cannot be resolved, or modules
---   that produce their own errors upon execution.
---
--- ## See
---
--- * `includes/modules/knockout/metadata.moon` for the implementation of
---   `package.metadata`, including its metamagic
--- * `includes/modules/knockout/searchers.moon` for the implementation of
---   `package.loaders`, including its metamagic
--- * `includes/modules/knockout/searchers/*.moon` for details about each
---   specific searcher
require = (name) ->
  if lookup = package.loaded[name] then return lookup
  value = package.metadata[name].loader!
  package.loaded[name] = value
  return value

environment.require = require
garry.require = require

environment
