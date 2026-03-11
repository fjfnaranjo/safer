.PHONY: check
check:
	@shellcheck -e SC1091 -e SC2016 -s sh safer
	@shellcheck -e SC1091 -e SC2016 -s sh safer_test

.PHONY: test
test:
	@./safer_test

.PHONY: test-verbose
test-verbose:
	@./safer_test verbose

.PHONY: pack
pack:
	@install -Dm755 safer "dist/safer-$${SAFER_VERSION:-0.0-dev}/bin/safer"
	@sed -i "s/0.0-dev/$${SAFER_VERSION:-0.0-dev}/" "dist/safer-$${SAFER_VERSION:-0.0-dev}/bin/safer"
	@install -Dm644 safer.1 "dist/safer-$${SAFER_VERSION:-0.0-dev}/share/man/man1/safer.1"
	@mkdir -p "dist/safer-$${SAFER_VERSION:-0.0-dev}/share/safer"
	@cp -R share/tools "dist/safer-$${SAFER_VERSION:-0.0-dev}/share/safer"
	@cp -R share/images "dist/safer-$${SAFER_VERSION:-0.0-dev}/share/safer"
	@tar czf "dist/safer-$${SAFER_VERSION:-0.0-dev}.tar.gz" -C dist "safer-$${SAFER_VERSION:-0.0-dev}"

.PHONY: update-install-docs
update-install-docs:
	@test -n "${SAFER_OLD_VERSION}" && test -n "${SAFER_VERSION}"
	@sed -i 's/release-${SAFER_OLD_VERSION}/release-${SAFER_VERSION}/g' README.md web/index.html
	@sed -i 's/safer-${SAFER_OLD_VERSION}/safer-${SAFER_VERSION}/g' README.md web/index.html

.PHONY: clean
clean:
	@rm -rf tests/outputs
	@rm -rf dist
