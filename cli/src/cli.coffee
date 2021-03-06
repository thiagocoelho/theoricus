optimist = require 'optimist'

module.exports = class Cli

  constructor:( @version )->
    @usage = "#{'Theoricus'} " + "v#{@version}\n".grey
    @usage += "Tiny MV(C) implementation for client side projects.\n\n".grey

    @usage += "#{'Usage:'}\n"
    @usage += "  the [#{'options'.green}] [#{'params'.green}]"

    @examples = """\n
    Examples:

      #{'• Creating new app'.grey}
        the -n <app-name>
        the -n <app-name> --src <gh-user>/<gh-repo>#<repo-branch>

      #{'• Generating models, views and controllers'.grey}
        the -g model <model-name>
        the -g view <controller-name>/<view-name>
        the -g controller <controller-name>
        the -g mvc <controller-name>
          #{' * Models and views names are singular, controllers are plural'.grey}

      #{'• Destroying models, views and controllers'.grey}
        the -d model <model-name>
        the -d view <controller-name>/<view-name>
        the -d controller <controller-name>
        the -d mvc <controller-name>
        the -d mvc <controller-name> --rf
          #{' * Models and views names are singular, controllers are plural'.grey}

    """

    @argv = (@opts = optimist.usage( @usage )
      .alias('n', 'new')
      .describe('n', 'Creates a new app')

      .alias('g', 'generate')
      .describe('g', 'Generates a new model, view or controller')

      .alias('d', 'destroy')
      .describe('d', 'Destroys a new model, view, or controller')

      .alias('s', 'start')
      .describe('s', 'Starts app in dev mode at localhost')

      .alias('c', 'compile')
      .describe('c', 'Compiles app in dev mode')

      .alias('r', 'release')
      .describe('r', 'Releases app for production')

      .alias('p', 'preview')
      .describe('p', 'Releases app for production at localhost')

      .alias('v', 'version')
      .describe('v', 'Shows theoricus version')

      .alias('h', 'help')
      .describe('h', 'Shows this help screen')

      .describe('rf', 'Use with -d [view|mvc] for deleting the whole view folder')
      .describe('src', 'Use with -n for use a specific theoricus version')
      # .describe('gitsub', 'Use with --src for automatic git submodule setup')

    ).argv