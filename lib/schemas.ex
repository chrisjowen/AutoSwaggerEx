defmodule PhxSwaggerAnnotations.Swagger do
  alias PhxSwaggerAnnotations.Swagger.Requests
  alias PhxSwaggerAnnotations.Swagger.Responses
  defmacro __using__(_) do
    quote do
      use PhoenixSwagger
      def swagger_definitions do
        Map.merge(Requests.schema(), Responses.schema())
      end
    end
  end
end

