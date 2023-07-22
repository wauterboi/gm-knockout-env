AddCSLuaFile!

include = include
add_client_file = AddCSLuaFile

setfenv 1, package.loaded.knockout

include_searcher = (name) ->
  filepath = string.format 'includes/modules/knockout/searchers/%s.lua', name
  add_client_file filepath
  include filepath

--- # `package.loaders: table` (shared)
---
--- ## Description
---
--- An array of searcher functions ordered from highest precedence to lowest.
--- Searcher functions must return either a module metadata structure or
--- `nil` and an error message.
---
--- ## See
---
--- * `includes/modules/knockout/metadata.moon` for the implementation of
---   `package.metadata`, including its metamagic and expected metadata
---   structure
{index, include_searcher name for index, name in ipairs{
  'preload'
  'binary'
  'stock'
  'path'
}}
