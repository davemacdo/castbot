0 => float pos;

/// tuning setup
Math.random2(100,400) => float baseFreq; // starting frequency
[3.5,5.0,5.5,7.0] @=> float divopts[];
divopts[Math.random2(0, (divopts.cap()-1) )] => float divs; // number of even divisions of the octave

// A modalbarry version of a random walker
class ModalWalk extends ModalBar {

	0 => float pos;

	// sound chain 
	this => NRev r => dac;
	0.02 => r.mix;

	// possible modalbar presets
	[0] @=> int bartype[];

	// pick a random preset from above
	bartype[Math.random2(0,bartype.cap() - 1)] => this.preset;

	// default stick hardness
	0.2 => this.stickHardness;

	// set default tempo
	120 => float tempo;
	(60/tempo)::second => dur pulse;

	// rhythm values [dotted-quarter, quarter, quint-quarter, dotted-eighth, sept-eighth]
	[1.5, 1, 0.8, 0.75, 0.66666666667, 0.571428571] @=> float rhythmvals[]; 
	rhythmvals[Math.random2(0,(rhythmvals.cap()-1))] => float rhythm;

	// Returns a float between 0 and 1 for a given "here" value.
	fun float getprobcos (float here, float maxpoint){
	    (-0.5*Math.cos(Math.PI*(here/maxpoint)))+0.5 => float prob;
	    return prob;
	}

	// Send the ModalWalk on its merry way!
	fun void go (float length) {

		while ( this.pos < length ) {
			if ( Math.randomf() < getprobcos(this.pos,(length/2)) ){1.0 => this.strike;}
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
 Math.random2f( 60 , 80 ) => float tempo;
// Math.random2f( 100 , 130 ) => float tempo;

// // instantiate ModalWalks
5 => int barnum;
ModalWalk b[barnum];

// // Settings for ModalWalks
for (0 => int i; i < b.cap(); i++){
	tempo => b[i].tempo;
	// 220 * (1 + i) => b[i].freq;

	(i +1)/divs => float exp;
	Math.pow (2, exp) => float mult;
	baseFreq * mult => b[i].freq;

}

// // Wind 'em up and set 'em loose!
for (0 => int i; i < b.cap(); i++){
	spork ~ b[i].go(length);
}

// // ROLL TAPE!
length + 3 => int lengthwdecay;
Machine.add ( me.dir()+"rec.ck" + ":" + lengthwdecay ) => int recID;


// // infinite loop to maintain parent shred
// // while (true) 1::second => now;

lengthwdecay::second => now; 
// Machine.remove( recID ); // removed this for RPi compatibility
Machine.remove( Std.atoi(me.arg(0)) );
