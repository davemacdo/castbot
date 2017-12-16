(

r = Routine.new({
	var baseFreq = exprand(50,200);

	/////////////////
	// setup steps //
	/////////////////

	ScoreClock.beginScore;
	ScoreClock.tempo = exprand(1, 2);


	///////////////////
	// pattern steps //
	///////////////////

	4.do({ |i|
		p = Pbind(
			\instrument, \klang,
			\foo, 0,
			\freq, Pwrand([[baseFreq*2, baseFreq*2.02], [baseFreq*3, baseFreq*3.03], [baseFreq*4, baseFreq*4.04], [baseFreq*1.9, baseFreq*1.82]], [6, 3, 3, 1].normalizeSum, inf),
			\dur, (1/(i+0.7.pow(i))),
			\do, Penvir((keepGoing: true),
				Pfunc ({ |e|
					var go = ~keepGoing; // refers to Penvir's environment
					if ( (e.freq[0] == (baseFreq*1.9)),
						{ ~keepGoing = nil; } // return nill NEXT time, not now
					);
					go;
				}),
			),
		).play(ScoreClock);
	});


	////////////////////
	// make the score //
	////////////////////

	~score = ScoreClock.makeScore(60, 2);

	//////////////////
	// render audio //
	//////////////////

	~score.recordNRT(outputFilePath: ("/Users/david/Dropbox/castbot/wav/temp.wav").standardizePath, headerFormat: "WAV", action: {0.exit});


}); // end Routine r

);

r.play;