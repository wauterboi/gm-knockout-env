AddCSLuaFile!

include = include
add_client_file = AddCSLuaFile

setfenv 1, package.loaded.knockout

include_searcher = (name) ->
  filepath = string.format 'includes/modules/knockout/searchers/%s.lua', name
  add_client_file filepath
  include filepath

{index, include_searcher name for index, name in ipairs{
  'preload'
  'binary'
  'stock'
  'path'
}}
