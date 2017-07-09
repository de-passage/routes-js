module.exports =
  class Router
    constructor: (@app, @prefix) ->
      @prefix ?= ""
      @routes = []

    resources: (name, controller, options) ->
      routes = [
        ["get", "new", "/#{name}/new", -> "/#{name}/new"]
        ["post", "create", "/#{name}", -> "/#{name}"]
        ["get", "show", "/#{name}/:id", (id) -> "/#{name}/#{id}"]
        ["get", "index", "/#{name}", -> "/#{name}"]
        ["get", "edit", "/#{name}/:id/edit", (id) -> "/#{name}/#{id}/edit"]
        ["put", "update", "/#{name}/:id", (id) -> "/#{name}/#{id}?_method=PUT"]
        ["delete", "destroy", "/#{name}/:id", (id) -> "/#{name}/#{id}?_method=DELETE"]
      ]
      for route in routes
        if typeof controller[route[1]] is "function"
          @addRoute "#{route[1]}_#{name}", route[0], route[2], routes[3], controller[route[1]]

    addRoute: (alias, method, endpoint, adapter, middleware) ->
      if @app?
        @app.locals.path ?= {}
        @app.locals.path[alias] = endpoint
        @app[method](@prefix + endpoint, middleware)
      else
        @routes.push [alias, method, endpoint, adapter, middleware]



