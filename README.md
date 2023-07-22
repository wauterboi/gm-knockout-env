# Quick Start

Entering the environment for the very first time:

```
setfenv 1, include 'includes/modules/knockout.lua'
print "You're in."
garry = require 'garry' -- How to access the default global environment
```

Entering after the fact:

```
setfenv 1, require 'knockout'
print "You're in."
garry = require 'garry' -- How to access the default global environment
```

# `require: function` (shared)
                                                                            
## Description
                                                                            
Return the cached return value of a given module. If the values do not
exist within `package.loaded`, the module is executed. If the module does
not have a return value, it is implicitly cached as `true`.
                                                                            
Outside of `package.loaded` which is mirrored between the `knockout` and
default global environment, all `package` keyvalues exist only within
the `knockout` environment.
                                                                            
Functionality is dependent on the searcher that successfully resolves the
module based on name. There are four searcher functions by default and
exist within the `package.loaders` array. Each function is expected to
return a structure representing the file's metadata including a generated
loader. If the searcher fails, it returns `nil` and then an error message.
                                                                            
The default search process go as follows:
                                                                            
1.  Is there a function in `package.preload` associated with the given
    name? If so, it's the loader.
2.  Is there a binary module associated with the given name? If so,
    use a wrapped call to the stock require function as a loader.
3.  Is there a module within `includes/modules/?.lua`? If so, the loader is
    the loader will execute within the default global environment and the
    return values are dependent on whatever the module returns or adds to
    `package.loaded`.
4.  Is there a module that can be found using `package.path`? If so,
    the loader will execute within the `knockout` environment. The default
    global environment must be accessed through either
    `package.loaded.garry`, or more idiomatically,
    `local garry = require 'garry'`.
                                                                            
Step 1 is for the off-chance a module needs to be executed in a special
way and is inline with Lua 5.1, which also has a `package.preload` table.
                                                                            
Step 2 is required because binary modules must be executed with the default
`require` function.
                                                                            
Step 3 is for backwards compatability and convenience for people using
modules written the old way for Garry's Mod.
                                                                            
Step 4 is the primary reasoning for this environment, as it allows users
to execute modules in a fashion idiomatic to Lua 5.1 and within a Lua 5.1
styled environment.
                                                                            
## Parameters
                                                                            
1.  param `name: string`
    The name of the module (not a filepath)
                                                                            
## Returns
                                                                            
1.  `any`
    Whatever the module returned or `true` indicating successful execution
                                                                            
## Warning
                                                                            
* `require` will not function until `includes/mmodules/knockout.lua` is
  executed at least once, as this file monkey patches `require`!
* Errors will be thrown for modules that cannot be resolved, or modules
  that produce their own errors upon execution.
                                                                            
## See
                                                                            
* `includes/modules/knockout/metadata.moon` for the implementation of
  `package.metadata`, including its metamagic
* `includes/modules/knockout/searchers.moon` for the implementation of
  `package.loaders`, including its metamagic
* `includes/modules/knockout/searchers/*.moon` for details about each
  specific searcher

# `package.metadata: table` (shared)

## Description

This table acts as a cache for module metadata. It is extended with
metamagic to make caching easier. Specifically, upon a cache miss, it will
attempt to retrieve the metadata for a module by performing an iterative
search using the searcher functions in the `package.loaders` array in
the `knockout` environment. If that fails, an error is thrown.

Module metadata contains:

* `filepath: string?`: the filepath (not applicable for modules found
  via `package.preload` or the binary searcher)
* `loader: function`: the function responsible for executing the module
  source code
* `type: string`: a name given to the searcher results purely for reference

## Warning

* Errors will be thrown for modules that cannot be resolved, or modules
  that produce their own errors upon execution.

# `package.loaders: table` (shared)

## Description

An array of searcher functions ordered from highest precedence to lowest.
Searcher functions must return either a module metadata structure or
`nil` and an error message.

## See

* `includes/modules/knockout/metadata.moon` for the implementation of
  `package.metadata`, including its metamagic and expected metadata
  structure
