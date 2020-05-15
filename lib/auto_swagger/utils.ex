defmodule AutoSwaggerEx.Utils do
  alias AutoSwaggerEx.Annotations
  alias PhoenixSwagger.Path
  use PhoenixSwagger

  def add_success_type(po, annotation) do
    case Annotations.value(annotation, :response) do
      output when output in [nil, :object] -> Path.response(po, 200, "OK")
      output -> Path.response(po, 200, "OK", Schema.ref(output))
    end
  end

  def route_params(path) do
      path
      |> String.split("/", trim: true)
      |> Enum.reduce({"", []}, fn part, {path, parameters} ->
        cleaned = String.replace(part, ":", "")

        cond do
          cleaned != part -> {"#{path}/{#{cleaned}}", parameters ++ [cleaned]}
          true -> {"#{path}/#{cleaned}", parameters}
        end
      end)
  end

  def controller_name(path) do
    path
    |> Atom.to_string()
    |> String.replace("Elixir.AutoSwaggerExWeb.", "")
    |> String.replace("Controller", "")
  end

  def get_route(routes, controller, method) do
    routes
    |> Enum.find(fn r ->
      r.plug == controller && r.opts == method
    end)
  end

  def get_query_parameters(annotation, parameters) do
    parameters
    |> Enum.map(fn p ->
        Annotations.value(annotation, :parameters, [])
        |> Enum.find(fn p -> p.name == p end)
        |> case do
          nil ->
            %Path.Parameter{
              description: p,
              in: "parameter",
              name: p,
              required: true,
              type: "string"
            }
          param -> param
        end
    end)
  end

  def get_body_param(annotation, verb) do
    case {Annotations.value(annotation, :request), verb} do
      {nil, verb} when verb in [:post, :put] ->
        [
          %Path.Parameter{
            description: "TODO: Add Input Parameters to Swagger",
            in: "body",
            name: "Request Body",
            required: false,
            schema: "object"
          }
        ]

      {nil, _} ->
        []

      {input, _} ->
        schema =
          case input do
            :object -> :object
            _ -> Schema.ref(input)
          end

        [
          %Path.Parameter{
            description: "Request Body",
            in: "body",
            name: "Request Body",
            required: false,
            schema: schema
          }
        ]
    end
  end
end
