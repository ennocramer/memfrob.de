GB := gutenberg

RSYNC := rsync
RSYNC_OPTIONS = -azh --delete-after --delete-excluded --progress

STAGING_DOMAIN := design.memfrob.de
STAGING_URL := https://$(STAGING_DOMAIN)/
STAGING := root@memfrob.de:/srv/$(STAGING_DOMAIN)

PRODUCTION_DOMAIN := memfrob.de
PRODUCTION_URL := https://$(PRODUCTION_DOMAIN)/
PRODUCTION := root@memfrob.de:/srv/$(PRODUCTION_DOMAIN)

.PHONY: serve
serve:
	$(GB) serve

.PHONY: build-staging
build-staging:
	$(GB) build -u $(STAGING_URL)

.PHONY: build-production
build-production:
	$(GB) build -u $(PRODUCTION_URL)

.PHONY: deploy-staging
deploy-staging: build-staging
	$(RSYNC) $(RSYNC_OPTIONS) public/* $(STAGING)

.PHONY: deploy-production
deploy-production: build-production
	$(RSYNC) $(RSYNC_OPTIONS) public/* $(PRODUCTION)
