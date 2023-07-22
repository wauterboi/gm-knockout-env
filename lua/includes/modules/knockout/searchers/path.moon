exists = file.Exists
compile = CompileFile

setfenv 1, package.loaded.knockout

package.path = table.concat {
  '?.lua'
  '?/init.lua'
  'luarocks/share/lua/5.1/?.lua'
  'luarocks/share/lua/5.1/?/init.lua'
  'luarocks/lib/lua/5.1/?.lua'
}, ';'

(name) ->
  fragment = string.gsub name, '%.', '/'
  filepaths = string.gsub package.path, '?', fragment

  log = for filepath in string.gmatch filepaths, '([^;]+);'
    if exists filepath, 'LUA'
      return {
        :filepath
        loader: ->
          setfenv(compile(filepath), package.loaded.knockout)!
        type: 'path'
      }
    else
      string.format 'path: no file `%s` found for module `%s`', filepath, name

  nil, table.concat log, '\n'
