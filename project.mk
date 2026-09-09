RESOLVER = 02packages,https://cpan.openbedrock.net/orepan2

.PHONY: install
install: $(TARBALL)
	cpm install -L $(HOME) --progress plain --resolver $(RESOLVER) \
	   --verbose --show-build-log-on-failure $< 2>&1 | tee install.log
