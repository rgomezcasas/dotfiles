.PHONY: prep lint lint-fix static-analysis validate nix-lint install-hooks

prep: lint static-analysis validate nix-lint

lint:
	@bash scripts/ci/lint

lint-fix:
	@bash scripts/ci/lint --fix

static-analysis:
	@bash scripts/ci/static_analysis

validate:
	@bash scripts/ci/validate_scripts

nix-lint:
	@if command -v nixfmt >/dev/null 2>&1; then \
		find config/nix -name '*.nix' -exec nixfmt --check {} + && echo "Nix lint OK"; \
	else \
		echo "Nix lint skipped (nixfmt not found)"; \
	fi

install-hooks:
	@git config core.hooksPath .githooks
	@echo "Git hooks installed (core.hooksPath=.githooks)"
