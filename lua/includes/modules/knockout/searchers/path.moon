exists = file.Exists
compile = CompileFile

setfenv 1, package.loaded.knockout

package.path = table.concat {
  '?.lua'
  '?/init.lua'
}, ';'

(name) ->
  fragment = string.gsub name, '%.', '/'
  filepaths = string.gsub filepaths, '?', fragment

  log = for filepath in string.gmatch filepaths, '([^;]+);'
    if exists filepath, 'LUA'
      return {
        :filepath
        loader: ->
          setfenv(compile(filepath), knockout)!
        type: 'path'
      }
    else
      string.format 'no file `%s` found for module `%s`', filepath, name

  nil, table.concat log, '\n'
