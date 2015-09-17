# lypaste

This is a simple paste service for markdown documents with LaTeX
math. You can use it at
[paste.learnyou.org](http://paste.learnyou.org). It is written in
Haskell, and licensed under the [GNU AGPLv3+](LICENSE).

## Building and installing

You'll need a UNIX-like system, as well as
[stack](https://github.com/commercialhaskell/stack/wiki/Downloads),
[Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git),
and
[PostgreSQL](https://wiki.postgresql.org/wiki/Detailed_installation_guides).

```
git clone git://github.com/learnyou/lypaste.git
cd lypaste
make setup && make db_setup
```

You can build the development version with `make build`, and run it with
`make rundev`. You can build the production version (with more
optimizations, but longer compile times) using `make prod`.

`make` is equivalent to running `make build && make rundev`

In addition, if you use Emacs and ETags, you might be interested in the
`etags-regenerate.sh` script, which watches for changes in Git-tracked
Haskell files, and regenerates the `TAGS` file.

## Contact

* Email: `peter@harpending.org`
* IRC: `pharpend` on FreeNode. The channel for this project is `#lysa`.
