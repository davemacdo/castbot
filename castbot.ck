// Pick the machine
["shaker-popcorn.ck","modal-popcorn.ck"] @=> string repertoire[];
Math.random2 (0,repertoire.cap()-1) => int selection;
<<< "Now playing: " + repertoire[selection] >>>;

//Machine.add ( me.dir()+"rec.ck" ) => int recID;
Machine.add ( me.dir()+repertoire[selection]+":"+me.id() ) => int soundID;

while (true) {
	1::second => now;
}