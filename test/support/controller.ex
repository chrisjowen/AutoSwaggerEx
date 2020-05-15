defmodule Test.TestController do
  import Plug.Conn
  use Phoenix.Controller, namespace: Test
  use AutoSwaggerEx, router: Test.Router, ecto: [{Test.Schema, []}]


  @swagger true
  def index(conn, params) do
    :no_op
  end

end
