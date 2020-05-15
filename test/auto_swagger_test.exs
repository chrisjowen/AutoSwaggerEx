defmodule AutoSwaggerTest do
  use ExUnit.Case
  alias Test.TestController

  test "greets the world" do
    TestController.swagger_defenitions |> IO.inspect
  end
end
