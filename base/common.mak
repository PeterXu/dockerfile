ifndef KIND
	$(error "Error: KIND is undefined.")
endif

KIND := $(strip $(KIND))

## =========
## for build
ifeq ($(KIND),build)
ifndef NAME
	$(error "Error: NAME is undefined.")
endif

NAME := $(strip $(NAME))
TEMPDIR := templates 			# dockerfile path
TEMPDIR := $(strip $(TEMPDIR))
TEMPS := $(shell ls $(TEMPDIR))	# dockerfile name (tag name)

# for alpine default TAG=alpine, or TAG=latest
ifndef TAG
TAG := latest
ifeq ($(TEMP),alpine)
TAG := $(TEMP)
endif
endif
endif

## =======
## for run
ifeq ($(KIND),run)
ACTIONS := $(strip pull up start stop restart rm pull-up stop-rm down config)
ifndef NAME
NAME := $(strip all)
endif
endif

## =====================
## help for docker build
define help_build
	@echo '[Usage]: Options available:'
	@for item in $(1); do \
		[ "$$item" = "alpine" ] && tag="$$item" || tag="latest"; \
		printf "  make build TEMP=%-10s [TAG=%s]\n" $$item $$tag; \
		printf "  make push  TEMP=%-10s [TAG=%s]" $$item $$tag; \
		echo ""; \
	done
endef

## ===================
## help for docker run
define help_run
	@echo '[Usage]: Options available:'
	@for item in $(1); do \
		printf "  make %-8s YAML=  [NAME=all]\n" $$item; \
	done
	@echo ''
endef


.PHONY: all help check-version

all: help

## ====
## help
help:
ifeq ($(KIND),build)
	$(call help_build,$(TEMPS))
endif
ifeq ($(KIND),run)
	$(call help_run,$(ACTIONS))
endif


## =============
## check-version
check-version:
ifeq ($(KIND),build)
ifndef TEMP
	$(error "Error: TEMP is undefined.")
endif
endif
ifeq ($(KIND),run)
ifndef YAML
	$(error "Error: YAML is undefined.")
endif
endif



## ==========================
## for docker build/push/pull
ifeq ($(KIND),build)

build: check-version
	@echo "[INFO] build <$(NAME):$(TAG)> ..."; 
	@docker build -f $(TEMPDIR)/$(TEMP) -t $(NAME):$(TAG) .;

push: check-version
	@echo "[INFO] $@ <$(NAME):$(TAG)> ...";
	@docker push $(NAME):$(TAG);

endif


## ============================================
## for docker-compose pull/run/start/stop/restart/rm
ifeq ($(KIND),run)

# do_docker action,yaml,service
define do_docker
	@for item in $(3); do \
		[ "$$item" = "all" ] && srv="" || srv="$$item"; 	 \
		[ ! -f "$$yml" ] && yml=`find . -name $(2)`; 	 \
		[ ! -f "$$yml" ] && yml=`find . -name $(2).yml`; \
		if [ ! -f "$$yml" ]; then \
			echo "Error: \"$(2)\" not exist!"; \
		 	break; \
		fi; \
		cmd="docker-compose -f $$yml $(1) $$srv"; \
		echo "[INFO] $$cmd"; \
		eval "$$cmd"; \
		break; \
	done
	@echo
endef

pull: check-version
	$(call do_docker,$@,$(YAML),$(NAME))

up: check-version
	$(call do_docker,$@ -d,$(YAML),$(NAME))

start: check-version
	$(call do_docker,$@,$(YAML),$(NAME))

stop: check-version
	$(call do_docker,$@,$(YAML),$(NAME))

restart: check-version
	$(call do_docker,$@,$(YAML),$(NAME))

rm: check-version
	$(call do_docker,$@ -f,$(YAML),$(NAME))

down: check-version
	$(call do_docker,$@,$(YAML),$(NAME))


pull-up: pull up
stop-rm: stop rm

endif

