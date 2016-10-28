APPLICATION := getopt

REBAR=$(shell which rebar3)
ERL := erl
EPATH := -pa ebin

DIALYZER=dialyzer
DIALYZER_OPTS=-Wno_return -Wrace_conditions -Wunderspecs -Wno_undefined_callbacks --fullpath

.PHONY: all clean compile console dialyze doc test

all: compile

clean:
	@$(REBAR) clean

compile:
	@$(REBAR) compile

console:
	$(ERL) -sname $(APPLICATION) $(EPATH)

dialyze: compile
	@$(DIALYZER) $(DIALYZER_OPTS) -r ./

doc:
	@$(REBAR) doc

test:
	@erl -make
	@$(ERL) -sname $(APPLICATION) $(EPATH) -noinput -s getopt_test test -s init stop

check: test
	$(REBAR) eunit -v

push:
	git push github master
	git push gitlab master

push-tags:
	git push github --tags
	git push gitlab --tags

push-all: push push-tags

publish: clean
	rebar3 hex publish

