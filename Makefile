.PHONY: publish, build, rebuild, clean, requirements

-include vars.txt

BUCKET_NAME ?= lambda-layer-build-bucket
LAYER_NAME ?= general
RUNTIMES ?= python3.6 python3.7
LAYER_VERSION ?= $(shell date +%Y-%m-%d)
REQUIRE_REBUILD := $(shell [ -z "$(shell docker image ls | grep build-$(LAYER_NAME)-layer)" ] && echo build-image)

$(LAYER_NAME).zip: build

clean:
	-rm -v *.zip requirements.txt
	-docker image rm build-$(LAYER_NAME)-layer

requirements:
	$(shell cat requirements/${LAYER_NAME}.txt > requirements.txt)

publish: 
	aws s3 cp $(LAYER_NAME).zip s3://$(BUCKET_NAME)/
	aws lambda publish-layer-version \
          --layer-name $(LAYER_NAME) \
          --description "${LAYER_NAME}:${LAYER_VERSION}" \
          --content S3Bucket=$(BUCKET_NAME),S3Key=$(LAYER_NAME).zip \
          --compatible-runtimes $(RUNTIMES)

build-image:
	docker build -t build-$(LAYER_NAME)-layer .

build: clean requirements build-image
ifdef $(LAYER_NAME)_prep_args
	$(eval PREP_ARGS := $($(LAYER_NAME)_prep_args))
else
	$(eval PREP_ARGS := "")
endif
	@docker run --rm -e PREP_ARGS=$(PREP_ARGS) -iv$(PWD):/host build-$(LAYER_NAME)-layer sh -c "/var/task/prep.sh && chown -v $(shell id -u):$(shell id -g) /tmp/build.zip && cp -va /tmp/build.zip /host/$(LAYER_NAME).zip"