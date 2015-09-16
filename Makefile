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

# For some reason, yesod devel isn't properly rebuilding the
# development version, so we're using the vanilla lypaste executable.
rundev:
	stack exec -- lypaste

test:
	stack build ${DEVFLAGS} --test

prod:
	stack build

clean:
	stack clean

really_clean:
	rm -rf .stack-work
