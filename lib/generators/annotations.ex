defmodule PhxSwaggerAnnotations.Swagger.Annotations do
    def value(_, _, default \\ nil)
    def value(nil, _, default), do: default
    def value(%{value: true}, _, default), do: default
    def value(%{value: opts}, key, default), do: Keyword.get(opts, key, default)
end

