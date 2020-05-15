defmodule AutoSwagger.Generators.Operation  do
  use PhoenixSwagger
  alias AutoSwagger.Annotations
  alias AutoSwagger.Utils


  defmacro generate(method, routes, annotation) do
    quote bind_quoted: [method: method, annotation: annotation, routes: routes] do
      def unquote(:"swagger_path_#{method}")(iroute) do
        import PhoenixSwagger.Path
        alias PhoenixSwagger.Path

        annotation = unquote(Macro.escape(annotation))
        route = Utils.get_route(unquote(Macro.escape(routes)), __MODULE__, unquote(method))

        controller = Utils.controller_name(route.plug)
        {path, parameters} = Utils.route_params(route.path)
        query_params = Utils.get_query_parameters(annotation, parameters)
        body_param = Utils.get_body_param(annotation, route.verb)
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
        |> Utils.add_success_type(annotation)
        |> PhoenixSwagger.ensure_tag(__MODULE__)
        |> PhoenixSwagger.ensure_verb_and_path(iroute)
        |> PhoenixSwagger.Path.nest()
        |> PhoenixSwagger.to_json()
      end
    end
  end

end
