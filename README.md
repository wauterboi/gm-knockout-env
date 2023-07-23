# Introduction

This project aims to accomplish the following goals:

1.  Implement an alternative "opt-in" global environment that imitates a Lua
    5.1 environment
2.  Overhaul the `package` library and `require` function to provide reverse
    compatibility and additional functionality similar with Lua 5.1
    with Lua 5.1
3.  Organize existing Garry's Mod functionality into useful modules with
    a better naming scheme and supplemental functions from the community

# Quick start

The Knockout environment is created and the `require` function is detoured by
executing `includes/modules/knockout.lua`. This file places the environment
in `packages.loaded.knockout` and returns it as well. This means you can
execute this file and switch to the environment in one fell swoop:

```
setfenv(1, include 'includes/modules/knockout.lua')
```

You only have to include it once. After it executes, `require` is updated, so
you can arbitrarily switch to the `knockout` environment like this:

```
setfenv(1, require 'knockout')
```

Most of the time, you won't really need to switch to the `knockout`
environment after executing though. What you will really want to do is execute
modules within the environment. That's done with the now detoured `require`:

```
require 'knockout'  -- this is the old `require`
require 'asdf'      -- this is the new `require`
```

When called like this, `require` will do the following:

1.  Check `package.preload`. If there is a function associated with the given
    name, it will be responsible for executing the module. If it doesn't set
    the environment, the module will execute within the default environment
    by default.
2.  Check for binary modules using `util.IsBinaryModuleInstalled` from the
    default environment. If true, it will use the old require function to
    execute it.
3.  Check for stock modules (i.e. those that come with the game) by looking
    in `includes/modules`. If there's a module there, it will be compiled and
    executed within the default environment.
4.  Check for the module using `package.path`, which is a string value
    containing a semicolon-delimited list of search paths. If it can find a
    file, it will be compiled and executed within the `knockout` environment.
    **This is probably the functionality you are looking for if you're using
    this addon.**

`package.path` defaults to the following (without the newlines - those are for
show):

```
?.lua;
?/init.lua;
luarocks/share/lua/5.1/?.lua;
luarocks/share/lua/5.1/?/init.lua;
luarocks/lib/lua/5.1/?.lua;
```

This means it'll look for 'asdf' by looking for:

* `asdf.lua`
* `asdf/init.lua`
* `luarocks/share/lua/5.1/asdf.lua`
* `luarocks/share/lua/5.1/asdf/init.lua`
* `luarocks/lib/lua/5.1/asdf.lua`

These are relative to `garrysmod/garrysmod/lua` and do not support leading
forward slashes. You're free to modify this path to your needs, however you
probably shouldn't remove anything from it.

Also, in Lua 5.1 fashion, you have to use periods in place of slashes and drop
the file extension. For example, don't do `a/s/d/f.lua` - do `a.s.d.f`.

# Installation

~~Extract the latest release to your Garry's Mod addons folder.~~ No releases,
yet.

# Building from source

## Prerequisites

* Unix-like environment (i.e. some distribution of Linux)
* `moonc` executable (i.e. from LuaRocks)
* `make`

## Makefile

* Run `make` to build Lua files from Moonscript files.
* Run `make clean` to delete all Lua files.

# Quick start

First, we need to make sure `includes/modules/knockout.lua` executes at least
once before using `require` as intended. This is because `require` needs to be
replaced. You can do that with either `include 'includes/modules/knockout.lua'`
or `require 'knockout'`. Once this is done, `require` will be replaced in both
the default and `knockout` environment.

Even better, you can do that and switch to the environment in one fell swoop
with `setfenv(1, include 'includes/modules/knockout.lua')`.

Now, we can take advantage of `package.path` in the `knockout` environment. By
default, it's set to the following (without newlines - those are for show):

```
?.lua;
?/init.lua;
luarocks/share/lua/5.1/?.lua;
luarocks/share/lua/5.1/?/init.lua;
luarocks/lib/lua/5.1/?.lua
```

What this means is if we write `require 'asdf'`, it will look in the following
directories:

* `garrysmod/garrysmod/lua/asdf.lua`
* `garrysmod/garrysmod/lua/asdf/init.lua`
* `garrysmod/garrysmod/lua/luarocks/share/lua/5.1/asdf.lua`
* `garrysmod/garrysmod/lua/luarocks/share/lua/5.1/asdf/init.lua`
* `garrysmod/garrysmod/lua/luarocks/lib/lua/5.1/asdf.lua`

Anything found via these search paths will automatically execute within the
`knockout` environment. You're also free to modify this string value as you
wish.

Of course, the game needs `require` for other things, like binary modules.
Don't worry, `require` still works as expected for binary modules and
traditional Garry's Mod lua modules. (those found in `includes/modules`)

In fact, `require` checks in this order:

* `package.preload` (these functions override how specific modules run)
* binary modules (these modules are executed in the global environment)
* stock modules (`includes/modules/?.lua` - these modules are executed in the
  global environment for reverse compatibility)
* `package.path` (these modules are executed in the knockout environment)

You can also add your own searcher functions in `package.loaders` and also
completely override how specific modules are required using `package.preload`.
See the above section titled "How does it work?" for more info.

# API

## Globals

### `require: shared function`

Get the cached return values of a module (i.e. `package.loaded[name]`). If they
aren't already cached, the module will be executed. If the module doesn't
return anything, it is implied to be `true` and cached so the module doesn't
re-execute.

#### Parameters

1.  `name: string`: The name of module

#### Returns

2.  `any`: Whatever the module returns after execution

#### Warning

* Errors will be thrown if the module cannot be found by any of the searcher
  functions in `package.loaders`.

## `package: shared table`

A custom reimplementation of the module system in Garry's Mod with loose
inspiration from Lua 5.1. It does not serve as an exact replica as it aims for
reverse compatbility and extra functionality. Most notably, searcher functions
return cached metadata. See `package.metadata` for more information on the
metadata structure.

### `package.loaded: shared table`

Cache for module return values.

#### Keyvalues

* `[string]: any`: Module names point to module return values (if cached)

### `package.loaders: shared table`

Array of module searchers. Each searcher will accept a module name and either
return a structure representing module metadata or `nil` and an error message.
By default, the first searcher is the "preload" searcher, the second is the
binary searcher, the third is the "stock" searcher, and the last is the "path"
searcher. These are described in detail above in the "Quick Start" section.

### `package.metadata: shared table`

Cache for metadata structures. Metadata structures have the following
keyvalues:

* `['filepath']: string?`: A filepath to the module (if given by the searcher -
  the "preload" and "binary" searchers do not do this)
* `['loader']: function`: A function that is responsible for executing the
  module. Creating these loader functions should delay compilation or execution
  of the module until this loader is actually called. This is to prevent errors
  on the server when client modules are being handled.
* `['type']: string`: This is a string purely for identification, i.e., for
  error messages or for users analyzing `package.metadata`. The searchers that
  come with this addon include "preload", "binary", "stock", and "path".
  Developers that want to create their own searcher functions are free to use
  whatever string they want.

If lookup in this table fails, it will automatically attempt to search for the
module and build the metadata structure for caching. If this fails, an error is
thrown.

#### Keyvalues

`[string]: table`: Module names point to metadata structures

#### Warning

* An error will be thrown if the module cannot be resolved.

### `package.preload: shared table`

Overriding functions for module loading. If a function is placed here, it will
be treated as the module's loader and be responsible for the entire compilation
and execution process. This includes setting the environment of the module, if
desired. Note that modules resolved via the `preload` table will not be given
a filepath.

`[string]: function`: Module names point to custom per-module loaders

### `package.path: shared string`

A string representing a semicolon delimited list of search paths used by the
path searcher. The question mark character is used as a placeholder for module
names. By default the value is set to the following (without newlines):

```
?.lua;
?/init.lua;
luarocks/share/lua/5.1/?.lua;
luarocks/share/lua/5.1/?/init.lua;
luarocks/lib/lua/5.1/?.lua;
```

The path searcher also replaces the period characters with proper directory
separators, i.e. 'a.s.d.f' will become 'a/s/d/f' before replacing the `?`
characters. This is unique to the path searcher - the other searchers don't
do this.

This string can be modified, however it is best to simply add content to it.
Removing search paths can cause addons relying on it to fail or locate modules
incorrectly.

#### Warning

* Do NOT use leading forward slashes. The function uses `file.Exists` from the
  default global environment and that function does not support it.
