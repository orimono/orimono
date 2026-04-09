.PHONY: infra infra-down up down build init-config

init-config:
	@for svc in loom shutter tsumu; do \
		cfg="$$svc/cmd/config.json"; \
		tpl="$$svc/cmd/config.json.template"; \
		if [ ! -f "$$cfg" ] && [ -f "$$tpl" ]; then \
			cp "$$tpl" "$$cfg"; \
			echo "  → created $$cfg from template"; \
		fi; \
	done

infra:
	docker compose up -d
	@echo "Waiting for postgres..."
	@until docker compose exec postgres pg_isready -U postgres > /dev/null 2>&1; do sleep 1; done
	@echo "Infrastructure ready."

infra-down:
	docker compose down

up: init-config infra
	overmind start

down:
	-overmind stop
	docker compose down

build:
	go build ./loom/... ./shutter/... ./tsumu/...

restart-%:
	overmind restart $*
