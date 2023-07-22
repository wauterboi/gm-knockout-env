AddCSLuaFile!

setfenv 1, package.loaded.knockout

--- # `package.metadata: table` (shared)
---
--- ## Description
---
--- This table acts as a cache for module metadata. It is extended with
--- metamagic to make caching easier. Specifically, upon a cache miss, it will
--- attempt to retrieve the metadata for a module by performing an iterative
--- search using the searcher functions in the `package.loaders` array in
--- the `knockout` environment. If that fails, an error is thrown.
---
--- Module metadata contains:
---
--- * `filepath: string?`: the filepath (not applicable for modules found
---   via `package.preload` or the binary searcher)
--- * `loader: function`: the function responsible for executing the module
---   source code
--- * `type: string`: a name given to the searcher results purely for reference
---
--- ## Warning
---
--- * Errors will be thrown for modules that cannot be resolved, or modules
---   that produce their own errors upon execution.
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
