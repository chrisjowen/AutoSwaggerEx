defmodule AutoSwaggerEx.Generators.Schema do
  use PhoenixSwagger


  def generate({module, opts}),  do: generate(module, opts)
  def generate(module, opts \\ []) when is_atom(module) do
      name = module_name(module)
      plural = Inflex.pluralize(name)
      ignore = Keyword.get(opts, :ignore, [])

      fields =
        module.__schema__(:fields)
        |> Enum.map(&{&1, module.__schema__(:type, &1)})

      assocs =
        module.__schema__(:associations)
        |> Enum.map(&{&1, module.__schema__(:association, &1)})

      %{
        "#{name}Response" => %{
          "title" => "#{name}Response",
          "description" => "A single #{name}Response",
          "type" => "object",
          "properties" => properties(ignore, fields, assocs)
        },
        "#{plural}Response" => %{
          "description" => "A collection of #{name}Response",
          "items" => %{"$ref" => "#/definitions/#{name}Response"},
          "title" => "#{plural}Response",
          "type" => "array"
        }
      }
  end

  defp module_name(module), do: (module |> to_string() |> String.split(".") |> List.last())

  defp properties(ignored, fields, assocs) do
    field_properties =
      fields
      |> Enum.filter(fn {field, _} -> !Enum.member?(ignored, field) end)
      |> Enum.map(fn {field, type} ->
        {Atom.to_string(field),
         %{
           "type" => convert_type(type)
         }}
      end)

    assocs_properties =
      assocs
      |> Enum.filter(fn {field, _} -> !Enum.member?(ignored, field) end)
      |> Enum.map(fn {field, type} ->
        property =
          case type do
            %Ecto.Association.BelongsTo{queryable: schema} ->
              %{
                "$ref" => "#/definitions/#{module_name(schema)}Response",
                "type" => "object",
              }
            %Ecto.Association.Has{queryable: schema} ->
              %{
                "$ref" => "#/definitions/#{module_name(schema)}Response",
                "type" => "array",
              }
            _ -> %{"type" => "array"}
          end

        {Atom.to_string(field), property}
      end)

    field_properties ++ assocs_properties
    |> Enum.into(%{})
  end

  defp convert_type(type) do
    case type do
      :id -> "integer"
      Elixir.Comeonin.Ecto.Password -> "string"
      :naive_datetime -> "string"
      {:array, _inner_type} -> "array"
      _ -> Atom.to_string(type)
    end
  end
end
