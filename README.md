# Spelling Correction

![Build status](https://github.com/pharo-ai/spelling-correction/workflows/CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/pharo-ai/spelling-correction/badge.svg?branch=master)](https://coveralls.io/github/pharo-ai/spelling-correction?branch=master)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/pharo-ai/spelling-correction/master/LICENSE)

A spelling correction algorithm that can identify and fix spelling mistakes.

## How to install it?

To install `spelling-correction`, go to the Playground (Ctrl+OW) in your [Pharo](https://pharo.org/) image and execute the following Metacello script (select it and press Do-it button or Ctrl+D):

```Smalltalk
Metacello new
  baseline: 'AISpellingCorrection';
  repository: 'github://pharo-ai/spelling-correction/src';
  load.
```

## How to depend on it?

If you want to add a dependency on `spelling-correction` to your project, include the following lines into your baseline method:

```Smalltalk
spec
  baseline: 'AISpellingCorrection'
  with: [ spec repository: 'github://pharo-ai/spelling-correction/src' ].
```

If you are new to baselines and Metacello, check out the [Baselines](https://github.com/pharo-open-documentation/pharo-wiki/blob/master/General/Baselines.md) tutorial on Pharo Wiki.

## How to use it?

```Smalltalk
corrector := AISpellingCorrector new.
```
```Smalltalk
languageFile := 'pharo-local/iceberg/pharo-ai/spelling-correction/data/english.json' asFileReference.
corrector loadLanguageModelFrom: languageFile.
```
```Smalltalk
corrector isKnownWord: 'something'.
corrector isKnownWord: 'somthing'.
```
```Smalltalk
corrector correctionsFor: 'somthing'.
```
