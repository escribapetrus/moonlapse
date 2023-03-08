defmodule Moonlapse.UserPoints do
  @moduledoc """
  Manages user points.

  Allow us to query the database to fetch users with more points that the current minimum.

  User points and minimum points are updated every minute. User points updates are asynchronous,
  and therefore may not be updated at the exact moment of fetching.
  """

  alias Moonlapse.Accounts

  use GenServer
  require Logger

  defstruct [:min_points, :timestamp, locked?: false]

  @default_users_limit 2
  @refresh_interval 1000 * 60

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  @doc """
  Queries the database for all users with more points than min_points,
  and updates the timestamp.

  Returns the users retrieved from the database (limit 2), and the previous timestamp
  """
  def query_users(n \\ @default_users_limit), do: GenServer.call(__MODULE__, {:query_users, n})

  @impl true
  def init([]) do
    Process.flag(:trap_exit, true)
    schedule_refresh()
    points = Moonlapse.rand_points(Moonlapse.points_limit())
    {:ok, %__MODULE__{min_points: points, timestamp: DateTime.utc_now()}}
  end

  @impl true
  def handle_call(
        {:query_users, n},
        _from,
        %{min_points: min_points, timestamp: timestamp} = state
      ) do
    Logger.info("#{__MODULE__}: Fetching users.")
    users = Accounts.get_users_by(%{min_points: min_points, limit: n})
    now = DateTime.utc_now()

    {:reply, {users, timestamp}, %{state | timestamp: now}}
  end

  @impl true
  def handle_info(:refresh, %{locked?: false} = state) do
    Logger.info("#{__MODULE__}: Refreshing points and min_points.")
    schedule_refresh()
    spawn_link(fn -> Accounts.update_all_user_points() end)
    min_points = Moonlapse.rand_points(Moonlapse.points_limit())

    {:noreply, %{state | min_points: min_points, locked?: true}}
  end

  @impl true
  def handle_info(:refresh, %{locked?: true} = state) do
    Logger.info("#{__MODULE__}: Database is locked due to ongoing user updates.")
    schedule_refresh()

    {:noreply, state}
  end

  def handle_info({:EXIT, _pid, :normal}, state) do
    Logger.info("#{__MODULE__}: Finished refreshing users.")
    {:noreply, %{state | locked?: false}}
  end

  defp schedule_refresh(), do: Process.send_after(self(), :refresh, @refresh_interval)
end
