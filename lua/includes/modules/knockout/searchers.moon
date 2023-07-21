AddCSLuaFile!

include = include

setfenv 1, package.loaded.knockout

include_searcher = (name) ->
  include string.format 'includes/modules/knockout/searchers/%s.lua', name

{include_searcher name for name in *{'preload', 'binary', 'stock', 'path'}}
