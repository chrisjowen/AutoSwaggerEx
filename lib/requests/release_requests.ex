defmodule PhxSwaggerAnnotations.Swagger.Requests.ReleaseRequests do
  use PhoenixSwagger

  def create do
    swagger_schema do
      description("Create A Release")

      properties do
        name(:string, "Name of the release", required: true)
      end
    end
  end

  def transition do
    swagger_schema do
      description("Transition Between Release States")

      properties do
        phase(:string, "Phase of the Release to be Transition",
          example: "AWAITING_GREEN_CHANNEL",
          required: true
        )

        message(:string, "Message note for the release transition",
          example: "",
          required: false
        )

        on_behalf_of(:string, "PSID of the User who triggers the Transition",
          example: "",
          required: false
        )
      end
    end
  end
end
