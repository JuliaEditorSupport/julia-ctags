# julia-ctags

This adds [Julia language](https://julialang.org/) support to [CTAGS](https://ctags.io/).

To obtain the ctags configuration file run
```julialang
] add JuliaCtags
get_config()
```
which will create a file called `julia_ctags` in the current directory.

To create CTAGS for Julia itself run
```
ctags -R -e --options=path-to-this-ctags-file --totals=yes path-to-julia/base
```
(the `-e` is to make Emacs compatible ETAGS, leave off if using
another editor).

To make tags for all the packages in the package directory
```
ctags -R -e --options=path-to-this-ctags-file --totals=yes --exclude=`.*` --exclude=.git --languages=julia ~/.julia/v0.6
```

To then use it in the one-true-editor (emacs) add this to your
`.emacs`:
```
;; CTAGS ETAGS
; https://www.emacswiki.org/emacs/EtagsTable
(require 'etags-table)
(setq etags-table-alist
      '(
        (".*\\.jl$" "/home/mauro/julia/julia-0.6/TAGS" "/home/mauro/.julia/v0.6/TAGS")
        ))
(setq tags-case-fold-search nil) ; case sensitive search
```
(needs installation of `etags-table`, maybe there is a better way to
do this?)

This used to be in the main julia
[repo](https://github.com/JuliaLang/julia/blob/10ebd63343a3c57ea40ccfb62efcee78c2869885/contrib/ctags),
see there for original contributors.

# TODO

- add example to use tags-file in the other one-true-editor (VIM), and
  maybe other, lesser one-true-editors.
- make a PR against https://github.com/universal-ctags/ctags
