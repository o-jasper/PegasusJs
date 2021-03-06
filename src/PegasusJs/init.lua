local PegasusJs = {}

PegasusJs.__index = PegasusJs

-- from_path        Path used to send data across.
--                    Default: "PegasusJs"
-- funs             List of initial functions. The given table is used.
--                    Defaults to a new empty.
-- has_callbacks    Whether callbacks are provided for asynchronous use on
--                    the javascript side.
-- script_name      Path of script itself. default index,js
PegasusJs.script_name = "index.js"

PegasusJs.has_callbacks = true

function PegasusJs.new(init_tab)
   init_tab.from_path = init_tab[1] or init_tab.from_path or "PegasusJs"
   init_tab[1] = nil
   init_tab.funs = init_tab.funs or {}
   init_tab.script_path = init_tab.script_path or (init_tab.from_path .. "/index.js")
   return setmetatable(init_tab, PegasusJs)
end

function PegasusJs:add(tab)
   for name, fun in pairs(tab) do self.funs[name] = fun end
end

local gen_js = require "PegasusJs.gen_js"
local callback_gen_js = require "PegasusJs.callback_gen_js"

-- As user, you dont need to touch it, it is put in
-- `self.from_path .. ."/index.js" defaultly, and `self.script_path` otherwise.
function PegasusJs:_script()
   local ret = gen_js.depend_js
   if self.has_callbacks then
      ret = ret .. callback_gen_js.depend_js
   end
   for name, _ in pairs(self.funs) do
      if string.find(name, "^[%w_]+$") then  -- Everything with js-accepted names.
         ret = ret .. gen_js.bind_js(self.from_path,  name)
         if self.has_callbacks then
            ret = ret .. callback_gen_js.bind_js(self.from_path,  name)
         end
      end
   end
   return ret
end

local json = require "json"

function PegasusJs:respond(request, response)
   local n = #(self.from_path)
   local req_path = request:path()
   if req_path and string.sub(req_path, 1, n) == self.from_path then
      local name = string.match(req_path, "([^/]+)/?$")
      local fun = self.funs[name or "<noname>"]  -- The function.
      if fun then
         request:headers()  -- Currently at least, pegasus needs asking this first.
         local body = request:receiveBody()

         local decoded = nil
         pcall( function() decoded = json.decode(body).d end )
         if decoded == nil then
            return "decode_failed: " .. body
         end
         if type(decoded) ~= "table" then return "Wrong call: " .. name end
         local ret = fun(decoded[1], decoded[2], decoded[3], decoded[4], decoded[5],
                         decoded[6], decoded[7], decoded[8], decoded[9], decoded[10])
         assert(type(ret) ~= "function", "Returned not-json-able, " .. req_path)
         local result = json.encode(ret)

         response:addHeader('Cache-Control', 'no-cache')  -- Dont cache, want it fresh.
         response:addHeader('Content-Type', 'text/json'):write(result)
         return true
      elseif name == self.script_name then
         response:addHeader('Cache-Control', 'no-cache') -- Suppose a end-data might be nicer.
         response:addHeader('Content-Type', 'text/javascript'):write(self:_script())
         return true
      else
         return "no_fun:" .. name
      end
   end
   -- If it doesnt apply, then the user comes with his/her own response.
end

return PegasusJs
