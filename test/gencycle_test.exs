defmodule RecycleTest do
  use ExUnit.Case, async: true

  defmodule Dummy do
    use Recycle, interval: 500

    @impl true
    def init_user_state(opts), do: Enum.into(opts, %{})

    @impl true
    def handle_user_cycle(%{report_to: pid, n: n} = state) do
      send(pid, {:checking_in, n})
      {:continue, %{state | n: n + 1}}
    end
  end

  test "Cycles can be started and stopped" do
    assert {:ok, cycle} = Dummy.start(a: 1)
    ref = Process.monitor(cycle)

    await(fn ->
      assert Process.alive?(cycle)
    end)

    Dummy.stop(cycle)

    assert_receive {:DOWN, ^ref, :process, _, :normal}
  end

  test "Cycles report here" do
    assert {:ok, cycle} = Dummy.start(report_to: self(), n: 1)
    assert_receive {:checking_in, 1}, 3_000
    assert_receive {:checking_in, 2}, 3_000
    Dummy.stop(cycle)
  end

  defp await(fun), do: await(1_000, fun)

  defp await(0, fun), do: fun.()

  defp await(timeout, fun) do
    try do
      fun.()
    rescue
      ExUnit.AssertionError ->
        :timer.sleep(10)
        await(max(0, timeout - 10), fun)
    end
  end
end
