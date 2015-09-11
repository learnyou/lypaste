DEVFLAGS=--flag lypaste:dev -j 5 

all: build rundev

setup:
	stack setup
	stack build yesod-bin .

db_setup:
	@echo "You can ignore the error messages."
	sudo -u postgres createuser -s lypaste
	sudo -u postgres createdb lypaste -U lypaste

build:
	stack build ${DEVFLAGS}

rundev:
	stack exec -- yesod devel

test:
	stack build ${DEVFLAGS} --test

prod:
	stack build
