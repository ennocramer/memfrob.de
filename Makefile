GB := gutenberg

RSYNC := rsync
RSYNC_OPTIONS = -azh --delete-after --delete-excluded --progress

CURL := curl
CURL_OPTIONS := --silent --show-error --fail
FONTELLO_HOST := http://fontello.com

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

.PHONY: update-picnic
update-picnic:
	git clone -q https://github.com/franciscop/picnic _work
	tar -c -f - -C _work/src plugins themes vendor/compass-breakpoint | tar -x -C sass --include='*.scss'
	rm -rf _work

.PHONY: update-fontello
update-fontello:
	mkdir _work
	$(CURL) $(CURL_OPTIONS) --output _work/session --form "config=@fontello.json" ${FONTELLO_HOST}
	$(CURL) $(CURL_OPTIONS) --output _work/font.zip ${FONTELLO_HOST}/`cat _work/session`/get
	unzip -d _work _work/font.zip
	tar -c -f - -C _work/fontello-* css font | tar -x -C static
	rm -rf _work
