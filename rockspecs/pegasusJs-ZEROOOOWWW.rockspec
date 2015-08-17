package = 'PegasusJs'
version = '0.9.0-1'

source = {
  url = 'git://github.com/o-jasper/PegasusJs.git',
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
    ['PegasusJs.init']     = "src/PegasusJs/init.lua",
    ['PegasusJs.callback_gen_js'] = "src/PegasusJs/callback_gen_js.lua",
    ['PegasusJs.gen_js'] = "src/PegasusJs/gen_js.lua",    
  }
}
