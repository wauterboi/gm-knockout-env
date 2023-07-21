stock_require = package.loaded.stock_require
has_binary = util.IsBinaryModuleInstalled

setfenv 1, package.loaded.knockout

(name) ->
  if has_binary name
    {
      filepath: nil
      loader: ->
        stock_require name
        package.loaded[name] or true
      type: 'binary'
    }
  else
    nil, string.format 'no binary found for module `%s`', name
