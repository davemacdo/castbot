// sound chain
Shakers shak => dac;
0 => float gen;

// possible shaker presets
[0,1,2,4,7,8,11,12,13,14,15,16,17,18,19,20,21] @=> int shaktype[];

// pick a random preset from above
shaktype[Math.random2(0,shaktype.cap() - 1)] => shak.preset;



fun void shake () {
    while ( true ){
        //11 => shak.preset;
        128 => shak.objects;
        
        if ( Math.randomf() > gen*0.005 ){1.0 => shak.noteOn;}

        0.1::second => now;

        gen + 1 => gen;
    }
}


spork ~ shake();

// infinite loop to maintain parent shred
while (true) 1::second => now;
