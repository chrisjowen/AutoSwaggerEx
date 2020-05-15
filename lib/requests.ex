defmodule PhxSwaggerAnnotations.Swagger.Requests do
  use PhoenixSwagger
  alias PhxSwaggerAnnotations.Swagger.Requests.ReleaseRequests

  def schema() do
    %{
      ReleaseCreateRequest: ReleaseRequests.create,
      ReleaseTransitionRequest: ReleaseRequests.transition
    }
  end
end
