Class {
	#name : #AISpellingCorrectorTest,
	#superclass : #TestCase,
	#instVars : [
		'corrector',
		'totalWordCount'
	],
	#category : #'AI-SpellingCorrection-Tests'
}

{ #category : #running }
AISpellingCorrectorTest >> setUp [
	| wordFrequencies |
	super setUp.
	
	wordFrequencies := { 
		'nothing' -> 646 .
		'sitting' -> 269 .
		'smoothing' -> 9 .
		'something' -> 683 .
		'smiling' -> 161.
		'sting' -> 10 .
		'thing' -> 303 .
		'soothing' -> 16 .
		'king' -> 238 .
		'queen' -> 20
	} asDictionary.
	
	totalWordCount := wordFrequencies values sum.
	
	corrector := AISpellingCorrector new.
	corrector initializeWordFrequencies: wordFrequencies.
	
]

{ #category : #tests }
AISpellingCorrectorTest >> testCorrectionsForWithAWordWithFewMistakes [

	self
		assertCollection: (corrector correctionsFor: 'somthing')
		hasSameElements: #( something soothing )
]

{ #category : #tests }
AISpellingCorrectorTest >> testCorrectionsForWithAWordWithMoreMistakes [

	self
		assertCollection: (corrector correctionsFor: 'smthing')
		hasSameElements:
			#( something nothing thing sitting smiling soothing sting smoothing )
				
]

{ #category : #tests }
AISpellingCorrectorTest >> testFit [

	| expectedFrequencies expectedVocabulary |
	expectedFrequencies := { 
		                       ('ai' -> 1).
		                       ('am' -> 2).
		                       ('doing' -> 1).
		                       ('hello' -> 1).
		                       ('i' -> 2).
		                       ('in' -> 1).
		                       ('inria' -> 1).
		                       ('on' -> 1).
		                       ('pharo' -> 1).
		                       ('repository' -> 1).
		                       ('some' -> 1).
		                       ('testing' -> 1).
		                       ('the' -> 1).
		                       ('world' -> 1) } asDictionary.

	expectedVocabulary := #( 'doing' 'some' 'pharo' 'repository'
	                         'on' 'world' 'hello' 'i' 'testing' 'am' 'inria'
	                         'the' 'in' 'ai' ).

	corrector fit:
		'Hello World, I am in INRIA. I am doing some testing on the pharo-ai repository'.

	self assert: corrector totalWordCount equals: 16.
	self
		assertCollection: corrector vocabulary
		hasSameElements: expectedVocabulary.
	self assert: corrector wordFrequencies equals: expectedFrequencies .
]

{ #category : #tests }
AISpellingCorrectorTest >> testInitializeWordFrequencies [

	| wordFrequencies |
	wordFrequencies := { 
		                   
		                   ('sitting' -> 269).
		('nothing' -> 646).
		                   ('smoothing' -> 9).
		                   ('something' -> 683).
		                   ('smiling' -> 161).
		                   ('sting' -> 10).
		                   ('thing' -> 303).
		                   ('soothing' -> 16).
		                   ('king' -> 238).
		                   ('queen' -> 20) } asDictionary.

	self assert: corrector wordFrequencies equals: wordFrequencies.
	self
		assertCollection: corrector vocabulary
		hasSameElements: wordFrequencies keys asSet.
	self assert: totalWordCount equals: wordFrequencies values sum
]

{ #category : #tests }
AISpellingCorrectorTest >> testIsKnownWord [

	self assert: (corrector isKnownWord: 'something')
]

{ #category : #tests }
AISpellingCorrectorTest >> testIsUnknownWord [
	self deny: (corrector isKnownWord: 'somthing').
]

{ #category : #tests }
AISpellingCorrectorTest >> testProbabilityOf [

	self
		assert: (corrector probabilityOf: 'nothing')
		closeTo: 0.2743099787685775
]

{ #category : #tests }
AISpellingCorrectorTest >> testSizeOfWordsOneEditDistanceAwayFrom [
self flag:'the value of assertion cannot be obtained before running the code'.
	self
		assert: (corrector wordsOneEditDistanceAwayFrom: 'somthing') size
		equals: 442
]

{ #category : #tests }
AISpellingCorrectorTest >> testSizeOfWordsTwoEditDistanceAwayFrom [
self flag:
		'the value of assertion cannot be obtained before running the code'.
	
	self
		assert: (corrector wordsTwoEditDistanceAwayFrom: 'somthing') size
		equals: 90902
]
