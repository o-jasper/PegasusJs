package = 'pegasusJs'
version = '0.9.0-1'

source = {
  url = 'git://github.com/o-jasper/pegasusJs.git',
  tag = 'ZEROWWW'
}

description = {
  summary = 'PegasusJs allows you to easily effectively expose lua functions server side to javascript on the client side',
  homepage = 'https://github.com/EvandroLG/pegasus.lua',
  maintainer = 'Jasper den Ouden <o.jasper@omg-i-am-still-using-gmail.com>',
  license = 'MIT <http://opensource.org/licenses/MIT>'
}

dependencies = {  -- TODO not yet bothering with versions..
  "lua >= 5.1",
  "pegasus",
  "json",
}

build = {
  type = "builtin",
  modules = {
    ['pegasusJs.init']     = "src/pegasusJs/init.lua",
    ['pegasusJs.callback_gen_js'] = "src/pegasusJs/callback_gen_js.lua",
    ['pegasusJs.gen_js'] = "src/pegasusJs/gen_js.lua",    
  }
}
