setfenv 1, package.loaded.knockout
package.preload = {}

(name) ->
  if loader = package.preload[name]
    {
      :loader
      filepath: nil
      type: 'preload'
    }
  else
    nil, string.format 'preload: no per-module loader for `%s`', name
