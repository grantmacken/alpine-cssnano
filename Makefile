include .env

TARGET=postcss

.PHONY: bld
bld:
	@echo '$(DOCKER_IMAGE)'
	@export DOCKER_BUILDKIT=1;
	@docker buildx build -o type=docker \
  --target=$(TARGET) \
  --tag='docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(CONTAINER_NAME):$(VERSION)' \
  .

.PHONY: run
run: build/main.css

.PHONY: clean
clean:
	@echo '## $@ ##'
	@rm build/*

build/%.css: fixtures/%.css
	@echo '## $(notdir $@) ##'
	@mkdir -p build
	@cat $< | docker run \
  --rm \
  --init \
  --name $(CONTAINER_NAME) \
  --interactive \
  docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(CONTAINER_NAME):$(VERSION) > $@
	@echo  " orginal size: [ $$(wc -c $< | cut -d' ' -f1) ] "
	@echo  "   build size: [ $$(wc -c $@ | cut -d' ' -f1) ]"

.PHONY: help
help:
	@docker run \
  --rm \
  --name $(CONTAINER_NAME) \
  --interactive \
  docker.pkg.github.com/$(REPO_OWNER)/$(REPO_NAME)/$(CONTAINER_NAME):$(VERSION)

