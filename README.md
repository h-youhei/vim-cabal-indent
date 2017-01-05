# vim-cabal-indent

## section
start at head of line even after fields

increase next line indent level

```
executable foo
  main-is: Main.hs

test-suite tests
```

## field element
align element
```
build-depends: base,
               container,
               QuickCheck
```

## field
set indent properly even after aligned elements

```
build-depends: base,
               QuickCheck
ghc-options: -Wall
```
