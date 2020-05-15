defmodule AutoSwagger  do
  use PhoenixSwagger
  import AutoSwagger.Generators.Operation

  defmacro __using__(opts) do
    quote do
      use PhoenixSwagger
      use Rubbergloves.Annotatable, [:swagger]
      alias AutoSwagger.Generators
      require AutoSwagger.Generators.Operation

      @router Keyword.get(unquote(opts), :router)
      @before_compile {unquote(__MODULE__), :__before_compile__}

      def swagger_defenitions do
        Keyword.get(unquote(opts), :ecto, [])
        ecto =  Keyword.get(unquote(opts), :ecto, [])
                |> Enum.reduce(%{}, &(Map.merge(&2, Generators.Schema.generate(&1))))
        schemas = Keyword.get(unquote(opts), :schemas, %{})
        Map.merge(ecto, schemas)
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      @annotations
      |> Enum.each(fn {method, annotations} ->
        annotation = Enum.find(annotations, &(&1.annotation == :swagger))
        AutoSwagger.Generators.Operation.generate(method, @router.__routes__(),annotation)
      end)
    end
  end

end
