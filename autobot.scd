(

r = Routine.new({

	/////////////////
	// setup steps //
	/////////////////

	ScoreClock.beginScore;
	ScoreClock.tempo = exprand(0.9, 1.1);



	///////////////////
	// pattern steps //
	///////////////////

	SynthDef(\panobird, {
		|freq=440, out=0, dur=0.5, pan = 0, gate=1, amp=0.2, volTweak=1|
		var sig, sig2, env;

		sig = Klang.ar(`[ [freq, freq * 2.1, freq * 4.9, freq*0.99, freq * 2.03, freq * 4.88], [0.6, 0.3, 0.1, 0.6, 0.3, 0.1], [0, 0, 0, pi*0.1, pi*0.5, pi*0.9] ]);
		// sig = Saw.ar(freq);
		// sig = GrainFM.ar(carfreq:freq, modfreq:freq*0.11);


		sig = LPF.ar(sig, (pan.abs).linexp(-1,1,1000, 10000));

		sig = Pan2.ar(sig, pan, 1);
		env = EnvGen.kr(Env.adsr(attackTime: 0.01, decayTime: 0.1, sustainLevel: 0.3, releaseTime:0.2), gate:gate, doneAction: 2);

		// if(~reverbBus.isKindOf(Bus), {out=~reverbBus.index});
		Out.ar(out, sig * env * amp * volTweak);

	}).load;



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
		\instrument, \panobird,
		\amp, 0.05,
		\pos, Pbrown(-1,1,0.1,inf), // drifting position from far left to far right
		\pan, Pkey(\pos), // send pan based on \pos
		\volTweak, (1-(Pkey(\pos).abs)).pow(4), // make things louder in the center
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
		\dur, Pwrand([(0.1+Pkey(\wiggleRoom).keep(1)), Rest(0.1)], [5, 1].normalizeSum, inf),
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

	~score.recordNRT(outputFilePath: ("".resolveRelative ++ "wav/temp.wav").standardizePath, headerFormat: "WAV", action: {0.exit});


}); // end Routine r

);

r.play;