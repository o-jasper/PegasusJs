-- Callback version of `gen_js`

local Public = {}

Public.depend_js = [[
function httpGet_callback(url, data, callback) {
    var req = new XMLHttpRequest();
    if(callback) {
       req.onreadystatechange = function() {
          //alert(req.readyState + " ... " + req.status);
          if(req.readyState == 4 && req.status == 200) {
              callback(req.responseText);
          }
       }
    }
    req.open("POST", url, true);

    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("Content-length", data.length + 2);
    req.setRequestHeader("Cache-Control", "no-cache");

    req.send(data);
}
]]

-- Returns the string implementing it on the javascript side.
function Public.bind_js(url, name)
   return string.format([[
function callback_%s(arg_list, callback){
    //alert("work..." + arg_list);
    var the_callback = null
    if( callback ){
       the_callback = function(responseText) { callback(JSON.parse(responseText)); };
    }
    httpGet_callback("%s/%s/", JSON.stringify({d:arg_list}), the_callback);
}
]],
      name, url, name)
end

return Public
