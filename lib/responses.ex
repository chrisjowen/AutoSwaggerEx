
defmodule PhxSwaggerAnnotations.Swagger.Responses do
  alias PhxSwaggerAnnotations.Swagger.EctoToSwagger

  @examples %{
    Release: %{
      version: "0.0.2",
      updated_at: "2020-04-16T05:21:44.796509",
      start: "2020-04-13T10:32:49.550886",
      tda_id: "",
      sign_offs: [],
      require_tda: false,
      remarks: "",
      related_releases: [],
      phase: "AWAITING_GREEN_CHANNEL",
      nature_of_change: "Label Change",
      id: 2,
      expected_release_date: "2020-04-16T18:30:00.000000",
      evidences: [],
      dispensations: [],
      deleted: false,
      criticality: "minor",
      change_request_no: "12345",
      archive: "",
      app_id: 1
    }
  }

  def schema() do
    schemas = Enum.reduce(Schemas.list(), %{}, fn {module, _}, map ->
      Map.merge(map, EctoToSwagger.generate(module))
    end)
    schemas
    |> Enum.map(&merge_examples/1)
    |> Enum.into(%{})
  end

  def merge_examples({key, value} = item) do
    case Map.get(@examples, key, nil) do
      nil -> item
      example -> {key, Map.put(value, :example, example)}
    end
  end




end

