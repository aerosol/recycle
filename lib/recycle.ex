defmodule Recycle do
  @moduledoc """
  Convienience wrapper around `:gen_cycle` behaviour for periodic, supervised 
  task execution.

  Interval is expressed in milliseconds.

  Usage:

      defmodule EveryMinute do
        use Recycle, interval: :timer.seconds(60)

        @impl true
        def init_user_state(_opts) do
          %{work: fn -> do_work() end}
        end

        @impl true
        def handle_user_cycle(%{work: fun} = state) do
          fun.()
          {:hibernate, state}
        end
      end
  """

  @callback init_user_state(list) :: any()
  @callback handle_user_cycle(any()) ::
              {:continue, any()}
              | {:continue_hibernated, any()}
              | {:stop, any()}

  defmacro __using__(use_opts) do
    quote do
      @behaviour :gen_cycle
      @behaviour Recycle
      require Logger

      def start(opts) do
        :gen_cycle.start_supervised(
          __MODULE__,
          Keyword.merge(unquote(use_opts), opts)
        )
      end

      @impl true
      def init_cycle(opts) do
        i = Keyword.fetch!(opts, :interval)

        Logger.info("Initializing cycle: #{__MODULE__} (interval: #{i}ms)")

        {:ok, {i, %{user_state: init_user_state(opts), skip_one_cycle: true}}}
      end

      @impl true
      def handle_cycle(%{skip_one_cycle: true} = state) do
        {:continue, %{state | skip_one_cycle: false}}
      end

      def handle_cycle(%{user_state: user_state} = state) do
        {op, user_state} = handle_user_cycle(user_state)
        {op, %{state | user_state: user_state}}
      end

      @impl true
      def handle_info(:stop, _state) do
        {:stop, :normal}
      end

      def handle_info(any, state) do
        Logger.warn("Unexpected message #{inspect(any)}")
        {:continue, state}
      end

      def stop(pid) when is_pid(pid) do
        send(pid, :stop)
      end

      defoverridable handle_info: 2
    end
  end
end
