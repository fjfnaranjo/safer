.PHONY: check
check:
	@shellcheck -e SC1091 -e SC2016 -s sh safer
