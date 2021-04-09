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
	corrector wordFrequencies: wordFrequencies.
	
]

{ #category : #tests }
AISpellingCorrectorTest >> testCorrectionsFor [
	self
		assert: (corrector correctionsFor: 'somthing')
		equals: #(something soothing) asOrderedCollection.
]

{ #category : #tests }
AISpellingCorrectorTest >> testCorrectionsForMoreErrors [
	self
		assert: (corrector correctionsFor: 'smthing')
		equals: #(something nothing thing sitting smiling soothing sting smoothing) asOrderedCollection.
]

{ #category : #tests }
AISpellingCorrectorTest >> testIsKnownWord [
	self assert: (corrector isKnownWord: 'something').
]

{ #category : #tests }
AISpellingCorrectorTest >> testIsUnknownWord [
	self deny: (corrector isKnownWord: 'somthing').
]

{ #category : #tests }
AISpellingCorrectorTest >> testProbabilityOf [
	self assert: (corrector probabilityOf: 'nothing') closeTo: 0.2743099787685775.
]

{ #category : #tests }
AISpellingCorrectorTest >> testSizeOfWordsOneEditDistanceAwayFrom [
	self assert: (corrector wordsOneEditDistanceAwayFrom: 'somthing') size equals: 442.
]

{ #category : #tests }
AISpellingCorrectorTest >> testSizeOfWordsTwoEditDistanceAwayFrom [
	self assert: (corrector wordsTwoEditDistanceAwayFrom: 'somthing') size equals: 90902.
]
