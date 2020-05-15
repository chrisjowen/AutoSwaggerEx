defmodule PhxSwaggerAnnotations.Swagger.AutoSwagger do
  use PhoenixSwagger
  alias PhxSwaggerAnnotations.Swagger.Annotations
  alias PhxSwaggerAnnotations.Swagger.RouteBuilder

  defmacro __using__(opts) do
    quote do
      use PhoenixSwagger

      @router Keyword.get(unquote(opts), :router)
      @routes @router.__routes__()
      use Rubbergloves.Annotatable, [:swagger]
      import PhxSwaggerAnnotations.Swagger.AutoSwagger
      require PhxSwaggerAnnotations.Swagger.AutoSwagger
      alias PhxSwaggerAnnotations.Swagger.AutoSwagger
      @before_compile {unquote(__MODULE__), :__before_compile__}
      alias PhxSwaggerAnnotations.Swagger.Utils.Annotations
      alias PhxSwaggerAnnotations.Swagger.Utils.RouteBuilder
    end
  end

  defmacrop make_swagger_function(method, annotation) do
    quote bind_quoted: [method: method, annotation: annotation] do
      def unquote(:"swagger_path_#{method}")(iroute) do
        import PhoenixSwagger.Path
        alias PhoenixSwagger.Path

        annotation = unquote(Macro.escape(annotation))
        route = RouteBuilder.get_route(@routes, __MODULE__, unquote(method))

        controller = RouteBuilder.controller_name(route.plug)
        {path, parameters} = RouteBuilder.route_params(route.path)
        query_params = RouteBuilder.get_query_parameters(annotation, parameters)
        body_param = RouteBuilder.get_body_param(annotation, route.verb)
        description = "#{controller}Controller##{unquote(method)}"

        params = query_params ++
                 body_param ++
                 Annotations.value(annotation, :parameters, [])

        %Path.PathObject{
          path: path,
          verb: route.verb,
          operation: %Path.OperationObject{
            parameters: params,
            consumes: Annotations.value(annotation, :consumes, ["application/json"]),
            produces: Annotations.value(annotation, :produces, ["application/json"]),
            description: Annotations.value(annotation, :description, description),
            security: Annotations.value(annotation, :security, [%{Bearer: []}])
          }
        }
        |> PhoenixSwagger.Path.response(401, "Authorization Error")
        |> RouteBuilder.add_success_type(annotation)
        |> PhoenixSwagger.ensure_tag(__MODULE__)
        |> PhoenixSwagger.ensure_verb_and_path(iroute)
        |> PhoenixSwagger.Path.nest()
        |> PhoenixSwagger.to_json()
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @annotations
      |> Enum.each(fn {method, annotations} ->
        annotation = Enum.find(annotations, &(&1.annotation == :swagger))
        make_swagger_function(method, annotation)
      end)
    end
  end
end
