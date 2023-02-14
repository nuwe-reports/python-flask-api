build:
	@ docker compose build

down:
	@ docker compose down

up: build migrate
	@ docker compose up -d

migrate: build
	@ docker compose run --rm skeleton-py-flask-api python manage.py migrate

deps:
	@ docker compose run --rm skeleton-py-flask-api poetry install

bash:
	@ docker compose run --rm skeleton-py-flask-api /bin/sh

test:
	@ docker compose run --rm skeleton-py-flask-api python -m pytest --json-report --json-report-file=output.json --json-report-indent=4

coverage: build migrate
	@ docker-compose run --rm skeleton-py-flask-api /bin/ash -c "coverage run --source='api' --omit='api/tests/*' -m pytest && pytest --json-report --json-report-file=output.json --json-report-indent=4"
	@ docker compose run --rm skeleton-py-flask-api coverage report
	@ docker compose run --rm skeleton-py-flask-api coverage xml
	@ docker compose run --rm skeleton-py-flask-api coverage html
