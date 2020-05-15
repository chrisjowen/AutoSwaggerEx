defmodule Test.Router do
  use Phoenix.Router
  import Plug.Conn
  import Phoenix.Controller


  scope "/test", Test do
    get("/", TestController, :index)
  end
end
