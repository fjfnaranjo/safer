.PHONY: check
check:
	@shellcheck -e SC1091 -e SC2016 -s sh safer

.PHONY: test
test:
	@./safer_test

.PHONY: pack
pack:
	@install -Dm755 safer "dist/safer-$${SAFER_VERSION:-0.0-dev}/bin/safer"
	@install -Dm644 safer.1 "dist/safer-$${SAFER_VERSION:-0.0-dev}/share/man/man1/safer.1"
	@sed -i "s/0.0-dev/$${SAFER_VERSION:-0.0-dev}/" "dist/safer-$${SAFER_VERSION:-0.0-dev}/bin/safer"
	@tar czf "dist/safer-$${SAFER_VERSION:-0.0-dev}.tar.gz" -C dist "safer-$${SAFER_VERSION:-0.0-dev}"

.PHONY: update-install-docs
update-install-docs:
	@test -n "$$SAFER_OLD_VERSION" && test -n "$$SAFER_VERSION"
	@sed -i 's/release-$$SAFER_OLD_VERSION/release-$$SAFER_VERSION/g' README.md web/index.html
	@sed -i 's/safer-$$SAFER_OLD_VERSION/safer-$$SAFER_VERSION/g' README.md web/index.html

.PHONY: clean
clean:
	rm -f tests/outputs/*
	rm -rf dist
