Class {
	#name : #BaselineOfAISpellingCorrection,
	#superclass : #BaselineOf,
	#category : #BaselineOfAISpellingCorrection
}

{ #category : #baselines }
BaselineOfAISpellingCorrection >> baseline: spec [
	<baseline>
	spec for: #common do: [	
		"Packages"
		spec 
			package: 'AI-SpellingCorrection';
			package: 'AI-SpellingCorrection-Tests' with: [ spec requires: #('AI-SpellingCorrection') ] ].
]
