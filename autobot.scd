(

r = Routine.new({
	var baseFreq = exprand(50,200);

	/////////////////
	// setup steps //
	/////////////////

	ScoreClock.beginScore;
	ScoreClock.tempo = exprand(0.9, 1.1);


	///////////////////
	// pattern steps //
	///////////////////



	// make a census dictionary if it doesn't exist
	if (~census.isKindOf(Dictionary).not,
		{~census = Dictionary.newFrom([\panobird, 0]);},
		{~census.atFail(\panobird,{ ~census.add(\panobird -> 0); })} // if it exists, make sure it has a panobird key
	);


	~panobird = Pbind(
		\iteration, Pseries(0,1,inf), // count iterations
		\instrument, \klang,
		\amp, 0.05,
		\pos, Pbrown(-1,1,0.1,inf), // drifting position from far left to far right
		\pan, Pkey(\pos), // send pan based on \pos
		\volTweak, 1-(Pkey(\pos).abs), // make things louder in the center
		\counter, Penvir( (side: nil), //
			Pfunc({ |e|
				var in = if (e.pos.isPositive, {true},{false});
				if (in == ~side,
					{ ~side },
					{ ~side = in; 0;} // return 0 if the panobird crossed the 0 boundary
				);
			})
		),
		\scale, Scale.whole,
		\octave, 7,
		\degree, Penvir( (note:1),
			Pfunc({ |e|
				if (e.counter == 0,
					{ ~note = ~note + [-1, 1].choose; }, // step up or down if the panobird flipped
					{ ~note; }
				);
				if (e.iteration == 0,
					{ ~note = 0; }, // if it's the first iteration, pick a random starting point
					{ ~note; }
				);
			})
		),
		\wiggleRoom, Pgauss(0, 0.002, inf),
		\dur, Pwrand([0.1+(Pkey(\wiggleRoom)), Rest(0.1)], [5, 1].normalizeSum, inf),
		\kill, Pfunc ({ |e|
			if ( ((e.pos < -0.97) || (e.pos > 0.97)),
				{ // if the panobird gets too close to the edge, it's gone
					postln("panobird down (" ++ e.iteration ++ ")"); // report the loss
					~census.put(\panobird, (~census.at(\panobird) - 1)); // remove from count
					postln(~census.getPairs); // report the census
					nil; },
				{e}
			);
		}),
	);




	// flock of panobirds
	(
		40.do({
			~census.atFail(\panobird,{ ~census.add(\panobird -> 0) });
			~census.put(\panobird, (~census.at(\panobird) + 1));
			~panobird.play(ScoreClock);
		});

	);


	////////////////////
	// make the score //
	////////////////////

	~score = ScoreClock.makeScore(5 * 60, 2);

	//////////////////
	// render audio //
	//////////////////

	~score.recordNRT(outputFilePath: ("/Users/david/Dropbox/castbot/wav/temp.wav").standardizePath, headerFormat: "WAV", action: {0.exit});


}); // end Routine r

);

r.play;