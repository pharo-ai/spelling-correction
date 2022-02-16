Class {
	#name : #AISpellingCorrector,
	#superclass : #Object,
	#instVars : [
		'wordFrequencies',
		'vocabulary',
		'totalWordCount'
	],
	#category : #'AI-SpellingCorrection'
}

{ #category : #correction }
AISpellingCorrector >> correctionsFor: aWord [
	"Propose corrections for a given word"
	
	| corrections |
	
	corrections := (self wordsOneEditDistanceAwayFrom: aWord)
		select: [ :correction | self isKnownWord: correction ].
		
	corrections ifEmpty: [
		corrections := (self wordsTwoEditDistanceAwayFrom: aWord)
			select: [ :correction | self isKnownWord: correction ] ].
		
	corrections := corrections asOrderedCollection sorted: [ :a :b |
		(self probabilityOf: a) > (self probabilityOf: b) ].
	
	^ corrections 
]

{ #category : #initialization }
AISpellingCorrector >> initializeWordFrequencies: aDictionary [
	"Initialize spelling corrector with a dictionary of word frequencies"
	
	wordFrequencies := aDictionary.
	vocabulary := aDictionary keys asSet.
	totalWordCount := aDictionary values sum.
]

{ #category : #correction }
AISpellingCorrector >> isKnownWord: aWord [
	"Answer true if aWord can be found in the vocabulary"
	^ vocabulary includes: aWord
]

{ #category : #'file in/out' }
AISpellingCorrector >> loadLanguageModelFrom: aFileReference [

	"Load a dictionary of word frequencies from a JSON file"

	| frequencies |
	self flag: 'not tested'.
	frequencies := aFileReference readStreamDo: [ :readStream | 
		               STONJSON fromStream: readStream ].

	self initializeWordFrequencies: frequencies
]

{ #category : #'language model' }
AISpellingCorrector >> probabilityOf: aWord [
	"Probability of a word calculated as a relative frequency of this word in a text on which the corrector was trained. Unknown words have probability 0"
	^ (wordFrequencies at: aWord) / totalWordCount
	
]

{ #category : #'file in/out' }
AISpellingCorrector >> saveLanguageModelTo: aFileReference [

	"Save word frequencies into a JSON file"

	self flag: 'not tested'.
	aFileReference writeStreamDo: [ :writeStream | 
		STONJSON put: wordFrequencies onStream: writeStream ]
]

{ #category : #training }
AISpellingCorrector >> trainOn: aText [
	"Train on a large text by extracting words from it"
	
	| bagOfWords |
	
	bagOfWords := (aText substrings flatCollect: [ :each |
		'[a-z]+' asRegex matchesIn: each asLowercase collect: #value ]) asBag.
	
	totalWordCount := bagOfWords size.
	vocabulary := bagOfWords asSet.
	wordFrequencies := bagOfWords valuesAndCounts.
	
	
	
	
]

{ #category : #'similar words' }
AISpellingCorrector >> wordsOneEditDistanceAwayFrom: aWord [
	"Answer words that are only one edit away from aWord. An edit can be a deletion (remove one letter), a transposition (swap two adjacent letters), a replacement (change one letter to another) or an insertion (add a letter). For example, 'somthing' and 'somEthing' are one edit distance away from each other"
	
	| splits deletes transposes replaces inserts |
	
	splits := (0 to: aWord size) collect: [ :i |
		{
			aWord first: i .
			aWord last: (aWord size - i)
		} ].
	
	deletes := splits allButLast collect: [ :split |
		split first, split second allButFirst ].
	
	transposes := (splits allButLast: 2) collect: [ :split |
		split first,
		split second second asString,
		split second first asString,
		(split second allButFirst: 2) ].
	
	replaces := splits allButLast flatCollect: [ :split |
		Character alphabet asArray collect: [ :letter |
			split first, letter asString, split second allButFirst ] ].
	
	inserts := splits flatCollect: [ :split |
		Character alphabet asArray collect: [ :letter |
			split first, letter asString, split second ] ].

	^ (deletes, transposes, replaces, inserts) asSet
]

{ #category : #'similar words' }
AISpellingCorrector >> wordsTwoEditDistanceAwayFrom: aWord [
	"Answer words that are two simple edits away from aWord. An edit can be a deletion (remove one letter), a transposition (swap two adjacent letters), a replacement (change one letter to another) or an insertion (add a letter). For example, 'smthing' and 'smething' are two edits away from each other -- delete 'o' and insert 'e'"
	
	^ (self wordsOneEditDistanceAwayFrom: aWord) flatCollect: [ :oneEdit |
		self wordsOneEditDistanceAwayFrom: oneEdit ]
]
