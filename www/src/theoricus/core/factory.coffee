Model = require 'theoricus/mvc/model'
View = require 'theoricus/mvc/view'
Controller = require 'theoricus/mvc/controller'

module.exports = class Factory

  controllers: {}

  ###
  @param [theoricus.Theoricus] @the   Shortcut for app's instance
  ###
  constructor:( @the )->

  _is =( src, comparison )->
    while src = src.__proto__
      return true if src instanceof comparison
      src = src.__proto__
    return false

  @model=@::model=( name, init = {}, fn )->
    # console.log "Factory.model( '#{name}' )"

    classname = name.camelize()
    classpath = "app/models/#{name}".toLowerCase()

    require ['app/models/app_model', classpath], ( AppModel, NewModel )=>

      model = new NewModel

      # FIXME: This will throw an error on browser: "Uncaught TypeError: Expecting a function in instanceof check, but got #<Main>"
      # 
      # unless (model = new NewModel) instanceof Model
      #   msg = "#{classpath} is not a Model instance - you probably forgot to "
      #   msg += "extend thoricus/mvc/Model"
      #   console.error msg

      # defaults to AppModel if given model is  is not found
      # (cant see any sense on this, will probably be removed later)
      model = new AppModel unless model?

      model.classpath = classpath
      model.classname = classname
      model[prop] = value for prop, value of init

      fn model

  ###
  Returns an instantiated [theoricus.mvc.View] View

  @param [String] path  path to the view file
  @param [theoricus.core.Process] process process responsible for the view
  ###
  view:( path, process = null, fn )->
    # console.log "Factory.view( '#{path}' )"

    classname = (parts = path.split '/').pop().camelize()
    namespace = parts[parts.length - 1]
    classpath = "app/views/#{path}"
    
    require ['app/views/app_view', classpath], ( AppView, View )=>
      unless (view = new View) instanceof View
        msg = "#{classpath} is not a View instance - you probably forgot to "
        msg += "extend thoricus/mvc/View"
        console.error msg

      # defaults to AppView if given view is not found
      # (cant see any sense on this, will probably be removed later)
      view = new AppView unless view?

      view._boot @the
      view.classpath = classpath
      view.classname = classname
      view.namespace = namespace
      view.process  = process if process?

      fn view


  ###
  Returns an instantiated [theoricus.mvc.Controller] Controller

  @param [String] name  controller name
  ###
  controller:( name, fn )->
    # console.log "Factory.controller( '#{name}' )"

    classname = name.camelize()
    classpath = "app/controllers/#{name}"

    if @controllers[ classpath ]?
      fn @controllers[ classpath ]
    else
      require [classpath], ( Controller )=>

        unless (controller = new Controller) instanceof Controller
          msg = "#{classpath} is not a Controller instance - you probably "
          msg += "forgot to extend thoricus/mvc/Controller"
          console.error msg

        controller.classpath = classpath
        controller.classname = classname
        controller._boot @the

        @controllers[ classpath ] = controller
        fn @controllers[ classpath ]

  ###
  Returns an AMD compiled template

  @param [String] path  path to the template
  ###
  @template=@::template=( path, fn )->
    # console.log "Factory.template( #{path} )"
    require ['templates/' + path], ( template )-> fn template



  ### Returns an AMD compiled style
  
  @param [String] path  path to the style
  ###
  @template=@::template=( path, fn )->
    # console.log "Factory.template( #{path} )"
    require ['templates/' + path], ( template )-> fn template