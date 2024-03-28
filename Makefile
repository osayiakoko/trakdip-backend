.PHONY: install
install:
	poetry install --no-root

.PHONY: runserver
runserver:
	poetry run python ./src/api/manage.py runserver

.PHONY: migrations
migrations:
	poetry run python ./src/api/manage.py makemigrations

.PHONY: migrate
migrate:
	poetry run python ./src/api/manage.py migrate

.PHONY: superuser
superuser:
	poetry run python ./src/api/manage.py createsuperuser

.PHONY: collectstatic
collectstatic: poetry run python ./src/api/manage.py collectstatic

.PHONY: run
run: 
	install migrations migrate runserver

.PHONY: shell
shell:
	poetry run python ./src/api/manage.py shell

.PHONY: provisionsuperuser
provisionsuperuser:
	poetry run python ./src/api/manage.py provisionsuperuser
