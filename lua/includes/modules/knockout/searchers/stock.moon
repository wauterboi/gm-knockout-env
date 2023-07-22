exists = file.Exists
compile = CompileFile

setfenv 1, package.loaded.knockout

(name) ->
  fragment = string.gsub name, '%.', '/'
  filepath = string.gsub 'includes/modules/?.lua', '?', fragment
  if exists filepath, 'LUA'
    {
      :filepath
      loader: ->
        compile(filepath)! or package.loaded[name] or true
      type: 'stock'
    }
  else
    nil, string.format(
      'stock: no file `%s` found for module `%s`',
      filepath,
      name
    )
