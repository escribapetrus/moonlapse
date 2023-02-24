defmodule Moonlapse.UserServer do
  @moduledoc """
  - When the app starts, a `genserver` should be launched which will:
    - Have 2 elements as state:
        - A random number (let's call it the `min_number`), [0 - 100]
        - A timestamp (which indicates the last time someone queried the genserver, defaults to `nil` for the first query)


  """

  alias Moonlapse.Accounts

  use GenServer
  require Logger

  defstruct [:min_number, :timestamp]

  @users_limit 2
  @refresh_interval 1000 * 60

  def start_link(_args), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  @doc """
  - Queries the database for all users with more points than `min_number` but only retrieve a max of 2 users.
  - Updates the genserver state `timestamp` with the current timestamp
  - Returns the users just retrieved from the database, as well as the timestamp of the **previous `handle_call`**
  """
  def query_users, do: GenServer.call(__MODULE__, :query_users)

  @impl true
  def init(:ok) do
    rand = :rand.uniform(101) - 1
    schedule_refresh()
    {:ok, %__MODULE__{min_number: rand, timestamp: DateTime.utc_now()}}
  end

  @impl true
  def handle_call(:query_users, _from, %{min_number: min_number, timestamp: timestamp} = state) do
    Logger.info("#{__MODULE__}: Fetching users!")
    users = Accounts.get_users_by(%{min_points: min_number, limit: @users_limit})

    {:reply, {users, timestamp}, %{state | timestamp: DateTime.utc_now()}}
  end

  # - Run every minute and when it runs:
  #     - Should update every user's points in the database (using a random number generator [0-100] for each)
  #     - Refresh the `min_number` of the genserver state with a new random number
  @impl true
  def handle_info(:refresh, state) do
    Logger.info("#{__MODULE__}: Refreshing points and min_number")
    Accounts.update_all_user_points()
    rand = :rand.uniform(101) - 1

    schedule_refresh()
    {:noreply, %{state | min_number: rand}}
  end

  defp schedule_refresh(), do: Process.send_after(self(), :refresh, @refresh_interval)
end
