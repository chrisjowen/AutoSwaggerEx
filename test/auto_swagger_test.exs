defmodule AutoSwaggerExTest do
  use ExUnit.Case
  alias Test.TestController

  test "greets the world" do
    TestController.swagger_definitions |> IO.inspect
  end
end
