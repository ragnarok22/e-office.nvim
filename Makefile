.PHONY: help run lint format format-check test check smoke clean

NVIM := nvim

# Show available targets
help:
	@echo "e-office.nvim"
	@echo ""
	@echo "  make run           Run the plugin in a minimal Neovim instance"
	@echo "  make lint          Run luacheck linter"
	@echo "  make format        Auto-format with stylua"
	@echo "  make format-check  Check formatting without writing"
	@echo "  make test          Run plenary tests"
	@echo "  make check         Run lint + format-check + test"
	@echo "  make smoke         Quick headless load test"
	@echo "  make clean         Remove swap files"

# Run the plugin in a minimal Neovim instance
run:
	$(NVIM) -u tests/minimal_init.lua -c "lua require('e_office').setup({ auto_start = true })"

# Run luacheck linter
lint:
	luacheck lua/ plugin/

# Run stylua formatter
format:
	stylua lua/ plugin/

# Check formatting without writing
format-check:
	stylua --check lua/ plugin/

# Run tests with plenary
test:
	$(NVIM) --headless -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory lua/tests {minimal_init = 'tests/minimal_init.lua'}" \
		-c "qa"

# Run all checks (lint + format check + test)
check: lint format-check test

# Quick smoke test: load plugin headlessly
smoke:
	$(NVIM) --headless -u NONE --cmd "set rtp+=." \
		-c "lua require('e_office').setup({}); print('OK: plugin loaded')" \
		-c "qa"

clean:
	find . -name "*.swp" -delete
	find . -name "*.swo" -delete
