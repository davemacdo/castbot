// Determine length of piece
20 + Math.random2 (3,9) => int length;

// Number of shakers
3 => int shakernum;
int shakerID[shakernum];

// Set tempo
Math.random2f( 100 , 130 ) => float tempo;
(60/tempo) => float pulsedur;

for (0 => int i; i < shakernum; i++){
	Machine.add ( me.dir()+"shaker-disintegrate.ck:"+length+":"+pulsedur ) => shakerID[i];
}

Machine.add ( me.dir()+"rec.ck:"+length ) => int recID;

length::second => now;

// clean up the mess
for (0 => int i; i < shakernum; i++){
	Machine.remove(shakerID[i]);
}
Machine.remove(recID);
