AddCSLuaFile!

setfenv 1, package.loaded.knockout

--  Create metadata cache
metadata = do
  metatable = {}

  metatable.__index = (name) =>
    log = for searcher in *package.loaders
      meta, err = searcher name
      print name, meta
      if meta
        @[name] = meta
        return meta
      else
        err

    error(
      string.format(
        'unable to resolve module `%s`:\n%s',
        name,
        table.concat log, '\n'
      )
    )

  setmetatable {}, metatable

metadata
