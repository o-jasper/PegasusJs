PegasusJs allows you to easily effectively expose lua functions server
side to javascript on the client side',

# How to use
You load this completely separately to [Pegasus](http://evandrolg.github.io/pegasus.lua/),
and feed the `request` and `response` `server:start` to the `:respond`
method of this thing. If it returns `nil`/`false`, then you can
do your own thing.

Depends on `json` package, there is an example in `examples/PegasusJs.lua`.

### Api:

`local PegasusJs = require "PegasusJs"` to get the lib, assuming it is
available to `package.path`.

`local pjs = PegasusJs.new(from_path, fun_table, has_callbacks)`
makes a new one, `from_path` the path of which all sub-paths are used.
`fun_table` is an initial set of functions. `{}` if `nil`.
`has_callbacks` whether it has callbacks.

`pjs:add(tab)` where tab is a table mapping javascript names to functions.

`pjs:script()` returns the string that is the javascript side bindings 
that implement it on that side. The page in some way must include this
javascript.

`pjs:respond(request, response)` returns false if the path was itis supposed
to ignore(i.e, not in from_path earlier. true if the path corresponds to a
function correctly, and "incorrect" or perhaps some description otherwise.

#### Provides to javascript:
If `name` has a function, then `name(...)` is the same function in javascript.

If callbacks are enabled, then `callback_<name>(args, callback_function)` is
*also* provided.

### Files:

`src/PegasusJs/` has `gen_js.lua`, where javascript is generated.
`callback_gen_js` the callback version. `init.lua` is the main file
implementing `:respond` and otherwise putting things together.

### Install:
Via the rockspec: It'd be called 'pegasusjs' afaict. However, i was too
lazy to log in.

Manually:

1. Make a directory, add `src/` here to `package.path`, i.e in `~/.init.lua`,
2. Or have a directory in `package.path`, like `~/.lualibs/` already, and
   from there symlink: `ln -s $to_project/src/PegasusJs`

Similar for windows, just use (1) and find the `~/.init.lua` file.
Nevermind, just stop using windows.

## TODO

* Make other backends than pegasus work? There is a "luvit harness" which i made
  for [page_html](https://github.com/o-jasper/page_html) but might be applicable
  here too.

* Lack of tests, just the example right now. Seems fine.
  (not lower standards than dependency)

* It does not work on pegasus.lua `develop` branch, likely will need work
  as that moves forward.
  
  Including potential "plugins".

* Perhaps other servers can use the same concept.
  [same concept idea suggestion to Tox](https://github.com/irungentoo/toxcore/issues/1403).

## Lua Ring

* [lua_Searcher](https://github.com/o-jasper/lua_Searcher) sql formulator including
  search term, and Sqlite bindings.

* [page_html](https://github.com/o-jasper/page_html) provide some methods on an object,
  get a html page.(with js)

* [storebin](https://github.com/o-jasper/storebin) converts trees to binary, same
  interfaces as json package.(plus `file_encode`, `file_decode`)
  
* [PegasusJs](https://github.com/o-jasper/PegasusJs), easily RPCs javascript to
  lua. In pegasus.

* [tox_comms](https://github.com/o-jasper/tox_comms/), lua bindings to Tox and
  bare bot.
