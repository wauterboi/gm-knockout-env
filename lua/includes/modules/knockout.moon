-- if lookup = package.loaded['knockout'] then return lookup

AddCSLuaFile!

include = include

environment = include 'includes/modules/knockout/environment.lua'
garry = _G

package.loaded.knockout = environment
package.loaded.garry = garry
package.loaded.stock_require = require

setfenv 1, environment

package.metadata = include 'includes/modules/knockout/metadata.lua'
package.loaders = include 'includes/modules/knockout/searchers.lua'

require = (name) ->
  if lookup = package.loaded[name] then return lookup
  value = package.metadata[name].loader!
  package.loaded[name] = value
  return value

environment.require = require
garry.require = require

environment
