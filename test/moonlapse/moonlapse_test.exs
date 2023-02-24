defmodule MoonlapseTest do
  use Moonlapse.DataCase

  test "rand_points/1 generates a random number between 0 and max" do
    for x <- 10..100//10 do
      rand = Moonlapse.rand_points(x)
      
      assert rand >= 0 and rand <= x
    end
  end
end
