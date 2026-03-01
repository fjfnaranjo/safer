.PHONY: check
check:
	@shellcheck -e SC1091 -e SC2016 -s sh safer

.PHONY: test
test:
	@./safer -d tests/outputs 00-basic-script a_tool_image:latest
	@sed -i 's|'"$(CURDIR)"'|CWD|g' tests/outputs/00-basic-script
	@diff tests/refs/00-basic-script tests/outputs/00-basic-script
	@SAFER_DIR=tests/outputs ./safer 00_01_basic_script a_tool_image:latest
	@sed -i 's|'"$(CURDIR)"'|CWD|g' tests/outputs/00_01_basic_script
	@diff tests/refs/00-basic-script tests/outputs/00_01_basic_script
	@./safer -d tests/outputs -p 10443 01-port a_tool_image:latest
	@sed -i 's|'"$(CURDIR)"'|CWD|g' tests/outputs/01-port
	@diff tests/refs/01-port tests/outputs/01-port

.PHONY: pack
pack:
	install -Dm755 safer "dist/safer-$${SAFER_VERSION:-0.0-dev}/bin/safer"
	install -Dm644 safer.1 "dist/safer-$${SAFER_VERSION:-0.0-dev}/share/man/man1/safer.1"
	sed -i "s/0.0-dev/$${SAFER_VERSION:-0.0-dev}/" "dist/safer-$${SAFER_VERSION:-0.0-dev}/bin/safer"
	tar czf "dist/safer-$${SAFER_VERSION:-0.0-dev}.tar.gz" -C dist "safer-$${SAFER_VERSION:-0.0-dev}"

.PHONY: clean
clean:
	rm -f tests/outputs/*
	rm -rf dist
