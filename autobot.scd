(
ScoreClock.beginScore;
ScoreClock.tempo = exprand(1, 2);

~baseFreq = exprand(50,200);

4.do({ |i|
	p = Pbind(
		\instrument, \klang,
		\foo, 0,
		\freq, Pwrand([[~baseFreq*2, ~baseFreq*2.02], [~baseFreq*3, ~baseFreq*3.03], [~baseFreq*4, ~baseFreq*4.04], [~baseFreq*1.9, ~baseFreq*1.82]], [6, 3, 3, 1].normalizeSum, inf),
		\dur, (1/(i+2.pow(i))),
		\do, Pfunc { |e| if (e.freq[0] == (~baseFreq*1.9)) { nil }{ e.postln; } },
	).play(ScoreClock);
});

~score = ScoreClock.makeScore(60, 2);
// ~score.score.do(_.postln;);
~score.recordNRT(outputFilePath: (Document.current.dir ++ "/wav/temp.wav").standardizePath, headerFormat: "WAV");

0.exit;
)
