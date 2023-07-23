AddCSLuaFile!

--  Create knockoff Lua 5.1 environment
environment = {
  :_VERSION
  :assert
  :collectgarbage
  :dofile
  :error
  :getfenv
  :getmetatable
  :ipairs
  :next
  :pairs
  :pcall
  :print
  :rawequal
  :rawget
  :rawset
  :select
  :setfenv
  :setmetatable
  :tonumber
  :tostring
  :type
  :unpack
  :xpcall
  loadfile: CompileFile
  loadstring: CompileString
  coroutine: {key, coroutine[key] for key in *{
    'create'
    'resume'
    'running'
    'status'
    'wrap'
    'yield'
  }}
  math: {key, math[key] for key in *{
    'abs'
    'acos'
    'asin'
    'atan'
    'atan2'
    'ceil'
    'cos'
    'cosh'
    'deg'
    'exp'
    'floor'
    'fmod'
    'frexp'
    'huge'
    'ldexp'
    'log'
    'log10'
    'max'
    'min'
    'modf'
    'pi'
    'pow'
    'rad'
    'random'
    'randomseed'
    'sin'
    'sinh'
    'sqrt'
    'tan'
    'tanh'
  }}
  os: {key, os[key] for key in *{
    'clock'
    'date'
    'difftime'
    'time'
  }}
  debug: {key, debug[key] for key in *{
    'debug'
    'getfenv'
    'gethook'
    'getinfo'
    'getlocal'
    'getmetatable'
    'getregistry'
    'getupvalue'
    'setfenv'
    'sethook'
    'setmetatable'
    'traceback'
  }}
  package: {
    loaded: package.loaded
  }
  string: {key, string[key] for key in *{
    'byte'
    'char'
    'dump'
    'find'
    'format'
    'gmatch'
    'gsub'
    'len'
    'lower'
    'match'
    'rep'
    'reverse'
    'sub'
    'upper'
  }}
  table: {key, table[key] for key in *{
    'concat'
    'insert'
    'maxn'
    'remove'
    'sort'
  }}
}

environment._G = environment

environment
