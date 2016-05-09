Machine.add ( me.dir()+"shaker-test.ck" ) => int shakerID;
Machine.add ( me.dir()+"rec.ck" ) => int recID;

// Math.random2(3,9) => int length;

20 + Math.random2 (3,9) => int length;

length::second => now;

Machine.remove(shakerID);
Machine.remove(recID);
