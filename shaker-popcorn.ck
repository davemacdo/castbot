0 => float pos;

// A shakery version of a random walker
class ShakeWalk extends Shakers {

	0 => float pos;

	// sound chain 
	this => dac;

	// possible shaker presets
	[0,1] @=> int shaktype[];

	// pick a random preset from above
	shaktype[Math.random2(0,shaktype.cap() - 1)] => this.preset;
	128 => this.objects;

	// set default tempo
	120 => float tempo;
	(60/tempo)::second => dur pulse;

	// rhythm values [trip-8th, 2x-quint-16th, 16th, quint-16th, trip-16th, sept]
	[0.33333333333, 0.25, 0.2, 0.166666667, .142857143] @=> float rhythmvals[]; 
	rhythmvals[Math.random2(0,(rhythmvals.cap()-1))] => float rhythm;

	// Returns a float between 0 and 1 for a given "here" value.
	fun float getprobcos (float here, float maxpoint){
	    (-0.5*Math.cos(Math.PI*(here/maxpoint)))+0.5 => float prob;
	    return prob;
	}

	// Send the shakewalk on its merry way!
	fun void go (float length) {
		while ( this.pos < length ) {
			if ( Math.randomf() < getprobcos(this.pos,(length/2)) ){1.0 => this.noteOn;}
			this.pulse * this.rhythm => now;

			this.pos + (this.pulse * this.rhythm)/second => pos;
		}
	}

}

// // Determine length of piece
Math.random2 (45,60) => int length;

// shorter for tests
// 5 => int length;

// // Pick tempo
Math.random2f( 100 , 130 ) => float tempo;

// // instantiate shakewalks
3 => int shakernum;
ShakeWalk s[shakernum];

// // Settings for shakewalks
for (0 => int i; i < s.cap(); i++){
	tempo => s[i].tempo;
}

// // Wind 'em up and set 'em loose!
for (0 => int i; i < s.cap(); i++){
	spork ~ s[i].go(length);
}

// // ROLL TAPE!
length + 3 => int lengthwdecay;
Machine.add ( me.dir()+"rec.ck" + ":" + lengthwdecay ) => int recID;


// // infinite loop to maintain parent shred
// // while (true) 1::second => now;

lengthwdecay::second => now; 
// Machine.remove( recID ); // removed this for RPi compatibility
<<< Std.atoi(me.arg(0) ) >>>;
Machine.remove( Std.atoi(me.arg(0)) );
