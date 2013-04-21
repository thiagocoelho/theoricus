path = require "path"
fork = require( "child_process" ).fork

module.exports = class Server
  @polvo = null

  constructor:( @the, options )->

    @polvo_path = path.join @the.root, 'node_modules', 'polvo', 'bin', 'polvo'
    fork @polvo_path, ['-ws'], cwd: @the.app_root