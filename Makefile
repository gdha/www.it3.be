SHELL = /bin/bash
SITE = ./_site
OFFICIAL = $(shell grep ^url _config.yml | grep -q 4000 && echo 0 || echo 1)

all: build

build:
	@echo -e "\033[1m== Validating configuration ==\033[0;0m"
ifeq ($(OFFICIAL),0)
	@echo -e "\033[1mERROR:\033[0;0m Please define the correct url in _config.yml"
	exit 1
else
	@echo "_config.yml has the correct url"
	@echo -e "\033[1m== Building website ==\033[0;0m"
	jekyll build
endif

upload: build
	lftp -e 'mirror -R $(SITE) /wwwroot ; bye' it3.be.apache52.cloud.telenet.be

server:
	@echo -e "\033[1m== Building website ==\033[0;0m"
	echo -e "\033[1m== Use http://localhost:4000/ ==033[0;0m"
	jekyll server

