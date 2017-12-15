(

r = Routine.new({

	/////////////////
	// setup steps //
	/////////////////

	~botStep = 0;
	ScoreClock.beginScore;
	ScoreClock.tempo = exprand(1, 2);
	~baseFreq = exprand(50,200);

	~botStep.yield; ~botStep = ~botStep + 1;

	///////////////////
	// pattern steps //
	///////////////////

	4.do({ |i|
		p = Pbind(
			\instrument, \klang,
			\foo, 0,
			\freq, Pwrand([[~baseFreq*2, ~baseFreq*2.02], [~baseFreq*3, ~baseFreq*3.03], [~baseFreq*4, ~baseFreq*4.04], [~baseFreq*1.9, ~baseFreq*1.82]], [6, 3, 3, 1].normalizeSum, inf),
			\dur, (1/(i+2.pow(i))),
			\do, Pfunc { |e| if (e.freq[0] == (~baseFreq*1.9)) { nil }{ e.postln; } },
		).play(ScoreClock);
	});

	~botStep.yield; ~botStep = ~botStep + 1;

	////////////////////
	// make the score //
	////////////////////

	~score = ScoreClock.makeScore(60, 2);

	~botStep.yield; ~botStep = ~botStep + 1;

	//////////////////
	// render audio //
	//////////////////

	~score.recordNRT(outputFilePath: ("/Users/david/Dropbox/castbot/wav/temp.wav").standardizePath, headerFormat: "WAV");

	~botStep.yield; ~botStep = ~botStep + 1;

	//////////////////
	// exit program //
	//////////////////

	("done after" + ~botStep + "steps").postln;
	// 10.wait; // Waiting allows audio to render, but sclang doesn't quit.
	0.exit;

}); // end Routine r

);

r.nextN(5);