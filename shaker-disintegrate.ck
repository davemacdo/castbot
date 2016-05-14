// sound chain
Shakers shak => dac;
0 => float gen;

// duration
Std.atof(me.arg(0)) => float length;

// pulse
(Std.atof(me.arg(1)))::second => dur pulse;


// possible shaker presets (only the raspy ones)
[0,1,2,8,9,11,20,21] @=> int shaktype[];

// pick a random preset from above
shaktype[Math.random2(0,shaktype.cap() - 1)] => shak.preset;

// rhythm values [trip-8th, 2x-quint-16th, 16th, quint-16th, trip-16th, sept]
[0.4, 0.33333333333, 0.25, 0.2, 0.166666667, .142857143] @=> float rhythmvals[]; 
rhythmvals[Math.random2(0,(rhythmvals.cap()-1))] => float rhythm;

fun void shake () {
	while ( true ){
		//11 => shak.preset;
		128 => shak.objects;
		
		if ( Math.randomf() > gen*0.005 ){1.0 => shak.noteOn;}

		pulse*rhythm => now;

		gen + 1 => gen;
	}
}


spork ~ shake();

// infinite loop to maintain parent shred
// while (true) 1::second => now;
length::second => now;
