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

-- Create and export `require`
require = (name) ->
  if lookup = package.loaded[name] then return lookup
  value = package.metadata[name].loader!
  package.loaded[name] = value
  return value

environment.require = require
garry.require = require

--  Return the environment to the caller
environment
