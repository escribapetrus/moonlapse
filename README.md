# Moonlapse

Moonlapse is an app that stores, updates and provides user scores.

It provides an API that fetches the two top scorers among all users. 

## Building and running

You can build and run in one step by running `make`

If you want to build and run step by step:

- Start the database with `docker-compose up -d`

- Start the Phoenix server:
  - Install dependencies with `mix deps.get`
  - Create, migrate, and seed the database with `mix ecto.setup`
  - Start application with `mix phx.server` (or inside IEx with `iex -S mix phx.server`)

## Using the application

Visit [`localhost:4000`](http://localhost:4000) on your browser.

## How it works

Moonlapse is composed of:

- API layer 
- UserPoints server
- Accounts backend

The **API layer** queries the UserPoints server, fetching the top user scores 
and the timestamp of the previous request.

The **UserPoints server** keeps track of the current minimum points and timestamp,
and allows us to query the database for users with more points than the minimum. 
It is implementes as a GenServer, and initialized with the Moonlapse application 
supervision tree.

The server is refreshed every minute, updating user points and minimum points.
User updates are asynchronous, therefore server queries may not be consistent
with the latest update.

The **Accounts backend** provides the user schema (database table) and
functions to fetch and update users.

## Observation

The name of the application is just the name of a song. 
It has no special meaning in this context.
