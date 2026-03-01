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

.PHONY: clean
clean:
	rm -f tests/outputs/*
