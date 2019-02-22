REBAR3=./rebar3

##
## define the default release path in order to
## manage the core system. The release must be generated
## before try to start using `make rel`.
## TODO: Check if after creation release could be
## moved to another dir for easy access.
##
RELEASE_PATH=_build/default/rel/dasherl_custom_app/bin

##
## define the main script that controls 
## the management of the release.
##
DASHERL_CUSTOM_APP=dasherl_custom_app

.PHONY: dasherl_example compile all doc test

all: compile

compile:
	$(REBAR3) compile

clean:
	$(REBAR3) clean

rel:
	$(REBAR3) release

live:
	@sh $(RELEASE_PATH)/$(DASHERL_CUSTOM_APP) console

stop:
	@sh $(RELEASE_PATH)/$(DASHERL_CUSTOM_APP) stop
