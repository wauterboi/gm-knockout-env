exists = file.Exists
compile = CompileFile

setfenv 1, package.loaded.knockout

(name) ->
  fragment = string.gsub name, '%.', '/'
  filepath = string.gsub 'include/modules/?.lua', '?', fragment
  if exists filepath, 'LUA'
    {
      :filepath
      loader: ->
        compile(filepath)! or package.loaded[name] or true
      type: 'stock'
    }
