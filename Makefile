build:
	echo "Building Moonlapse"
	docker-compose up -d
	mix deps.get
	mix ecto.setup

run:
	echo "Running Moonlapse"
	mix phx.server

clean:
	echo "Cleaning up Moonlapse" 
	mix ecto.drop
	docker-compose down
	rm -rf _build deps

