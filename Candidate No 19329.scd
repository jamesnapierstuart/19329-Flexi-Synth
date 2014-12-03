
(

/*

"FLEXI SYNTH"
CANDIDATE NUMBER: 19329
COMPUTER MUSIC
ASSIGNMENT 1 (SOUND SYNTHESIZER WITH GUI)
UNIVERSITY OF SUSSEX
MARCH 2013

BUILT ON SUPERCOLLIDER 3.6
MAC OSX VERSION 10.7.5

*/



/*
DECLARE VARIABLES
*/

var w, titlecv, paramcv1, paramcv2, paramtitles1, paramtitles2, topcvs, fxcv, panelscv, osccv, filtencv, lfocv, title, playb, bigbuttonfont, smlfont, paramfont, presetbs, outtext, bshowfx, osc1type, osc2type, filttype, lfo1types, lfo2types, lfotext, lfotypetext, filttext, osc1ftext, osc2ftext, envsliders, envtext, o1ftypetext, o2typetext, outknob, oscknobs, filtknobs, lfoknobs, verbknobs, fxtext, verbtext, matrixcv, matrixsrc1types, matrixsrc2types, matrixsrc3types, matrixdest1types, matrixdest2types, matrixdest3types, matrixknobs, matrixtext, matrixtext2, matrixnumtext, presetDict, preset, presetText, myPath, osc1menu, osc2menu, filtmenu, lfo1menu, lfo2menu, lfoselect, lfoselect2, lfofiltselect, matrixsrc1menu, matrixsrc2menu, matrixdest1menu, matrixdest2menu, matrixdest3menu,  matrixsrc3menu, gate, sound;
/*
CREATE THE SYNTH
*/

SynthDef(\flexisynth, {

	arg osc1 = 0, osc2=0, osc1freq = 0, osc2freq=0, modfreq =0, modfreq2=0, filt = 0, cutofffreq = 0, modcutofffreq = 0, rq = 0, lfo1type = 0, lfo2type=0, lfo1rate=0, lfo2rate=0, amp = 0, lfoselect=0, lfoselect2=0, lfofiltselect=0, attack = 0, decay = 0, sustain = 0, release = 0, gate = 0, mix=0, roomsize=0;

	var sound, filttypes, wavetypes1, wave1, wavetypes2, wave2, lfo1types, lfo2types, lfo1, lfo2, lfoarray, env;


	// Wavetypes for LFO1 (Uses .ar as the select function requires it)
	lfo1types = [
		SinOsc.ar(0), // Off function
		SinOsc.ar(lfo1rate),
		Saw.ar(lfo1rate),
		Pulse.ar(lfo1rate)];

	// Wavetypes for LFO2 (Uses .ar as the select function requires it)
	lfo2types = [
		SinOsc.ar(0), // Off function
		SinOsc.ar(lfo2rate),
		Saw.ar(lfo2rate),
		Pulse.ar(lfo2rate)];


	// Chooses which LFO wavetype
	lfo1 = Select.ar(lfo1type, lfo1types);
	lfo2 = Select.ar(lfo2type, lfo2types);

	// Store LFO types into two arrays
	lfoarray = [
		SinOsc.ar(0), // Off function
		lfo1,
		lfo2];

	// Wavetypes for oscillator 1, modulate by chosen LFO with mod frequency1
	wavetypes1 = [
		SinOsc.ar(0), // Off function
		SinOsc.ar(Select.ar(lfoselect, lfoarray).range(osc1freq, modfreq)),
		Saw.ar(Select.ar(lfoselect, lfoarray).range(osc1freq, modfreq)),
		Pulse.ar(Select.ar(lfoselect, lfoarray).range(osc1freq, modfreq))];


	// Wavetypes for oscillator 1, modulate by chosen LFO with mod frequency2
	wavetypes2 = [
		SinOsc.ar(0), // Off function
		SinOsc.ar(Select.ar(lfoselect2, lfoarray).range(osc2freq, modfreq2)),
		Saw.ar(Select.ar(lfoselect2, lfoarray).range(osc2freq, modfreq2)),
		Pulse.ar(Select.ar(lfoselect2, lfoarray).range(osc2freq, modfreq2))];

	// Choose which wavetype
	wave1 = Select.ar(osc1, wavetypes1);
	wave2 = Select.ar(osc2, wavetypes2);

	// Store array of filters with chosen LFO and the combination of chosen wave types.
	filttypes = [
		wave1 + wave2, // Off bypass the filter completely.
		RLPF.ar(wave1 + wave2, Select.ar(lfofiltselect, lfoarray).range(cutofffreq, modcutofffreq), rq),
		RHPF.ar(wave1 + wave2, Select.ar(lfofiltselect, lfoarray).range(cutofffreq, modcutofffreq), rq)];


	// Create ADSR envelope
	env = EnvGen.kr(Env.adsr(attack, decay, sustain, release), gate);

	// Store selection from filter array into sound
	sound = Select.ar(filt, filttypes);

	//Output the sound multiplied by the envelope and amplitude
	Out.ar(0, Pan2.ar(FreeVerb.ar((sound*env*amp), mix, roomsize)))

}).add;

/*
CREATE THE GUI
*/

// Set fonts
bigbuttonfont = Font("HOBO Std", 30);
smlfont = Font("HOBO Std", 12);
paramfont = Font("HOBO Std", 20);

// Set window and composite views
w = Window("Flexi Synth", Rect(350, 300, 1000, 650));
titlecv = CompositeView(w, Rect(0, 0, 1000, 80));
topcvs = Array.fill(4, {arg i; CompositeView(w, Rect(20 + (i*230), 10, 200, 50))});
fxcv =CompositeView(w, Rect(2, 650, 996, 148));
panelscv = Array.fill(3, {arg i; CompositeView(w, Rect(5 + (i*331), 85, 328, 505))});
osccv = Array.fill(2, {arg i; CompositeView(panelscv[0], Rect(2, 2 + (i*251), 324, 249))});
filtencv = Array.fill(2, {arg i; CompositeView(panelscv[1], Rect(2, 2 + (i*251), 324, 249))});
lfocv = Array.fill(2, {arg i; CompositeView(panelscv[2], Rect(2, 2 + (i*251), 324, 249))});
matrixcv = Array.fill(3, {arg i; CompositeView(lfocv[1], Rect(2, 80 + (i*55), 320, 30))});
paramcv1 = Array.fill(3, {arg i; CompositeView(w, Rect(10 + (i*331), 90, 318, 40))});
paramcv2 = Array.fill(3, {arg i; CompositeView(w, Rect(10 + (i*331), 341, 318, 40))});
paramtitles1 = Array.fill(3, {arg i; StaticText(w, Rect(50 + (i*331), 90, 318, 40))});
paramtitles2 = Array.fill(3, {arg i; StaticText(w, Rect(50 + (i*331), 341, 318, 40))});
paramtitles1[0].string = "         OSCILLATOR 1";
paramtitles1[1].string = "               FILTER";
paramtitles1[2].string = "                 LFOs";
paramtitles2[0].string = "         OSCILLATOR 2";
paramtitles2[1].string = "             ENVELOPE";
paramtitles2[2].string = "               MATRIX";

// Set up Pop Up Menus
osc1type = PopUpMenu(osccv[0], Rect(100, 70, 110, 20));
osc2type = PopUpMenu(osccv[1], Rect(100, 70, 110, 20));
filttype = PopUpMenu(filtencv[0], Rect(100, 70, 110, 20));
lfo1types = PopUpMenu(lfocv[0], Rect(40, 70, 100, 20));
lfo2types = PopUpMenu(lfocv[0], Rect(190, 70, 100, 20));
matrixsrc1types = PopUpMenu(lfocv[1], Rect(20, 85, 100, 20));
matrixsrc2types = PopUpMenu(lfocv[1], Rect(20, 140, 100, 20));
matrixsrc3types = PopUpMenu(lfocv[1], Rect(20, 195, 100, 20));
matrixdest1types = PopUpMenu(lfocv[1], Rect(210, 85, 100, 20));
matrixdest2types = PopUpMenu(lfocv[1], Rect(210, 140, 100, 20));
matrixdest3types = PopUpMenu(lfocv[1], Rect(210, 195, 100, 20));

// Set items for Pop Up Menus
osc1type.items_(["OFF", "SINE", "SAW", "SQUARE"]);
osc2type.items_(["OFF", "SINE", "SAW", "SQUARE"]);
filttype.items_(["OFF", "LPF", "HPF"]);
lfo1types.items_(["OFF", "SINE", "SAW", "SQUARE"]);
lfo2types.items_(["OFF", "SINE", "SAW", "SQUARE"]);
matrixsrc1types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
matrixsrc2types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
matrixsrc3types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
matrixdest1types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
matrixdest2types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
matrixdest3types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);

// Set up text
o1ftypetext = Array.fill(2, {arg i; StaticText(w, Rect(150 + (i*330), 135, 200, 20))});
lfotypetext = Array.fill(2, {arg i; StaticText(lfocv[0], Rect(70 + (i*150), 50, 200, 20))});
o2typetext = StaticText(osccv[1], Rect(140, 50, 200, 20));
o2typetext.string = "TYPE";
o2typetext.stringColor = Color.black;
o2typetext.font_(smlfont);

title = StaticText(topcvs[0], Rect(5, 3, 200, 50));
title.string = "FLEXI SYNTH";
title.stringColor = Color.yellow(0.2, 0.9);
title.font_(bigbuttonfont);

presetText = StaticText(topcvs[2], Rect(50, 0, 200, 50));
presetText.string = "PRESET:" + "Default";
presetText.stringColor = Color.red(0.4);
presetText.font_(smlfont);

osc1ftext = StaticText(osccv[0], Rect(140, 170, 100, 50));
osc1ftext.string = "PITCH";
osc1ftext.stringColor = Color.black;
osc1ftext.font_(smlfont);

osc2ftext = StaticText(osccv[1], Rect(140, 170, 100, 50));
osc2ftext.string = "PITCH";
osc2ftext.stringColor = Color.black;
osc2ftext.font_(smlfont);

lfotext = StaticText(lfocv[0], Rect(50, 170, 300, 50));
lfotext.string = "  LFO1 RATE                        LFO2 RATE";
lfotext.stringColor = Color.black;
lfotext.font_(smlfont);

filttext = StaticText(filtencv[0], Rect(80, 170, 300, 50));
filttext.string = " CUTOFF             RESONANCE";
filttext.stringColor = Color.black;
filttext.font_(smlfont);

envtext =StaticText(filtencv[1], Rect(70, 200, 200, 50));
envtext.string = "A               D               S               R";
envtext.stringColor = Color.black;
envtext.font_(smlfont);

matrixtext = StaticText(lfocv[1], Rect(60, 30, 300, 50));
matrixtext.string = "SRC                    MOD                 DEST";
matrixtext.stringColor = Color.black;
matrixtext.font_(smlfont);

matrixtext2 = StaticText(lfocv[1], Rect(150, 60, 40, 20));
matrixtext2.string = "FREQ";
matrixtext2.stringColor = Color.black;
matrixtext2.font_(smlfont);


matrixnumtext = Array.fill(3, {arg i; StaticText(lfocv[1], Rect(10, 60 + (i*55), 20, 20))});
matrixnumtext[0].string = "1.";
matrixnumtext[1].string = "2.";
matrixnumtext[2].string = "3.";

fxtext = Array.fill(2, {arg i; StaticText(fxcv, Rect(400 + (i*110), 115, 3000, 30))});
fxtext[0].string = "        MIX";
fxtext[1].string = "      ROOM SIZE";
verbtext = StaticText(fxcv, Rect(460, 5, 80, 30));
verbtext.string = "REVERB";
verbtext.font_(paramfont);
verbtext.stringColor = Color.red(0.1);

// Place buttons and set texts
presetbs = Array.fill(3, {arg i; Button(topcvs[3], Rect(-2 + (i*68), -10, 69, 70))});
presetbs[0].states_([["DEFUALT", Color.white, Color.red(0.4, 0.7)]]);
presetbs[1].states_([["LOAD", Color.white, Color.red(0.4, 0.7)]]);
presetbs[2].states_([["SAVE", Color.white, Color.red(0.4, 0.7)]]);

bshowfx = Button(w, Rect(5, 595, 200, 50));
bshowfx.states_([["REVERB FX", Color.white, Color.grey]]);

playb = Button(topcvs[1], Rect(-10, -10, 220, 70));
playb.font_(bigbuttonfont);
playb.states_([["Play", Color.white, Color.green(0.4, 0.4)], ["Stop", Color.white, Color.red(0.4, 0.4)]]);

//Place out knob set text
outknob = Knob(titlecv, Rect(930, 10, 50, 50));
outtext = StaticText(titlecv, Rect(930, 53, 70, 30));
outtext.string = "OUTPUT";
outtext.font_(smlfont);
outtext.stringColor = Color.white;

// Place knobs and sliders
oscknobs = Array.fill(2, {arg i; Knob(w, Rect(140, 210 + (i*250), 50, 50))});
filtknobs = Array.fill(2, {arg i; Knob(w, Rect(420 + (i*100), 210, 50, 50))});
lfoknobs = Array.fill(2, {arg i; Knob(w, Rect(730 + (i*150), 210, 50, 50))});
matrixknobs = Array.fill(3, {arg i; Knob(lfocv[1], Rect(150, 82 + (i*55), 30, 28))});
envsliders = Array.fill(4, {arg i; Slider(filtencv[1], Rect(60 + (i*60), 60, 30, 150))});
verbknobs = Array.fill(2, {arg i; Knob(fxcv, Rect(400 + (i*120), 40, 80, 80))});

// Colour composite view arrays and set text:
titlecv.background = Color.grey(0.3);
fxcv.background = Color.grey(0.3);

topcvs.do { arg cv;
	cv.background = Color.grey;
};
presetbs.do { arg b;
	b.font_(smlfont);
};
panelscv.do { arg cv;
	cv.background = Color.grey;
};
osccv.do { arg cv;
	cv.background = Color.grey(0.3);
};
filtencv.do { arg cv;
	cv.background = Color.grey(0.3);
};
lfocv.do { arg cv;
	cv.background = Color.grey(0.3);
};
paramcv1.do { arg cv;
	cv.background = Color.grey(0.5);
};
paramcv2.do { arg cv;
	cv.background = Color.grey(0.5);
};
matrixcv.do { arg cv;
	cv.background = Color.grey(0.5);
};
paramtitles1.do { arg cv;
	cv.stringColor = Color.red(0.4);
	cv.font_(paramfont);
};
paramtitles2.do { arg cv;
	cv.stringColor = Color.red(0.4);
	cv.font_(paramfont);
};
o1ftypetext.do { arg cv;
	cv.string = "TYPE";
	cv.stringColor = Color.black;
	cv.font_(smlfont);
};
lfotypetext.do { arg cv;
	cv.string = "TYPE";
	cv.stringColor = Color.black;
	cv.font_(smlfont);
};
matrixnumtext.do { arg cv;
	cv.stringColor = Color.red(0.4, 0.6);
	cv.font_(smlfont);
};
fxtext.do { arg cv;
	cv.stringColor = Color.black;
	cv.font_(smlfont);
};
oscknobs.do { arg cv;
	cv.mode = \vert;
	cv.value = 0;
};
lfoknobs.do { arg cv;
	cv.mode = \vert;
	cv.value = 0;
};
filtknobs.do { arg cv;
	cv.mode = \vert;
	cv.value = 0;
};
verbknobs.do { arg cv;
	cv.mode = \vert;
	cv.value = 0;
};
matrixknobs.do { arg cv;
	cv.mode = \vert;
};
envsliders.do { arg cv;
	cv.value = 0;
};

outknob.mode = \vert;
outknob.value = 0;

// Declare menu and select variables and those not delcared yet:
osc1menu = 0;
osc2menu = 0;
filtmenu = 0;
lfo1menu = 0;
lfo2menu = 0;
lfoselect = 0;
lfoselect2 = 0;
lfofiltselect = 0;
matrixsrc1menu = 0;
matrixsrc2menu = 0;
matrixdest1menu = 0;
matrixdest2menu = 0;
matrixdest3menu = 0;
matrixsrc3menu = 0;
gate = 0;

// Set values for presetDict:
presetDict = ();
presetDict.osc1ch = 0;
presetDict.osc2ch = 0;
presetDict.osc1freq = 0;
presetDict.osc2freq = 0;
presetDict.modfreq = 0;
presetDict.modfreq2 = 0;
presetDict.osc1wavetpeitems = ["OFF", "SINE", "SAW", "SQUARE"];
presetDict.osc2wavetpeitems = ["OFF", "SINE", "SAW", "SQUARE"];
presetDict.filt = 0;
presetDict.filttypeitems = ["OFF", "LPF", "HPF"];
presetDict.cutofffreq = 0;
presetDict.modcutofffreq = 0;
presetDict.rq = 0;
presetDict.envslidersattack = 0;
presetDict.envslidersdecay = 0;
presetDict.envsliderssustain = 0;
presetDict.envslidersrelease = 0;
presetDict.gate = 0;
presetDict.lfo1types = ["OFF", "SINE", "SAW", "SQUARE"];
presetDict.lfo2types = ["OFF", "SINE", "SAW", "SQUARE"];
presetDict.lfo1rate = 0;
presetDict.lfo2rate = 0;
presetDict.lfoselect = 0;
presetDict.lfoselect2 = 0;
presetDict.lfofiltselect = 0;
presetDict.matrixsrc1types = ["OFF", "LFO1 RATE", "LFO2 RATE"];
presetDict.matrixsrc2types = ["OFF", "LFO1 RATE", "LFO2 RATE"];
presetDict.matrixsrc3types = ["OFF", "LFO1 RATE", "LFO2 RATE"];
presetDict.matrixdest1types = ["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"];
presetDict.matrixdest2types = ["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"];
presetDict.matrixdest3types = ["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"];
presetDict.matrixknobs1 = 0;
presetDict.matrixknobs2 = 0;
presetDict.matrixknobs3 = 0;
presetDict.osc1menu = 0;
presetDict.osc2menu = 0;
presetDict.filtmenu = 0;
presetDict.lfo1menu = 0;
presetDict.lfo2menu = 0;
presetDict.matrixsrc1menu = 0;
presetDict.matrixsrc2menu = 0;
presetDict.matrixsrc3menu = 0;
presetDict.matrixdest1menu = 0;
presetDict.matrixdest2menu = 0;
presetDict.matrixdest3menu = 0;
presetDict.verbmix = 0;
presetDict.verbsize = 0;
presetDict.outlevel = 0;

/*
ASSIGN THE SYNTH
*/

sound = Synth(\flexisynth, [\osc1, osc1menu, \osc1freq, oscknobs[0].value.linexp(0, 1, 30, 5000), \osc2, osc2menu, \osc2freq, oscknobs[1].value.linexp(0, 1, 30, 5000), \lfo1type, lfo1menu, \lfo1rate, lfoknobs[0].value*20, \lfo2type, lfo2menu, \lfo2rate, lfoknobs[1].value*20, \lfoselect, lfoselect, \lfoselect2, lfoselect2, \lfofiltselect, lfofiltselect, \filt, filtmenu, \modfreq,  oscknobs[0].value.linexp(0, 1, 30, 5000), \modfreq2, oscknobs[1].value.linexp(0, 1, 30, 5000), \cuttofffreq, filtknobs[0].value.linlin(0, 1, 20, 20000), \modcutofffreq,  filtknobs[0].value.linlin(0, 1, 20, 20000), \rq, (1-(filtknobs[1].value*0.9) + 0.01), \attack, envsliders[0].value, \decay, envsliders[1].value, \sustain, envsliders[2].value, \release, envsliders[3].value*10, \gate, 0, \mix, verbknobs[0].value, \roomsize, verbknobs[1].value, \amp, outknob.value*0.5]);




/*
MENU ACTIONS
*/

// Oscillator 1 menu implementation
osc1type.action_({ arg menu;

	if(menu.item == "OFF") {
		sound.set(\osc1, 0);
		osc1menu = 0;
		osc1type.items_(["OFF", "SINE", "SAW", "SQUARE"]);
		presetDict.osc1ch = 0;
		presetDict.osc1menu = 0;
		presetDict.osc1wavetpeitems = ["OFF", "SINE", "SAW", "SQUARE"];

	};
	if(menu.item == "SINE") {
		sound.set(\osc1, 1);
		osc1menu = 1;
		osc1type.items_(["SINE", "SAW", "SQUARE", "OFF"]);
		presetDict.osc1ch = 1;
		presetDict.osc1menu = 1;
		presetDict.osc1wavetpeitems = ["SINE", "SAW", "SQUARE", "OFF"];
	};
	if(menu.item == "SAW") {
		sound.set(\osc1, 2);
		osc1menu = 2;
		osc1type.items_(["SAW", "SQUARE", "OFF", "SINE"]);
		presetDict.osc1ch = 2;
		presetDict.osc1menu = 2;
		presetDict.osc1wavetpeitems = ["SAW", "SQUARE", "OFF", "SINE"];
	};
	if(menu.item == "SQUARE") {
		sound.set(\osc1, 3);
		osc1menu = 3;
		osc1type.items_(["SQUARE", "OFF", "SINE", "SAW"]);
		presetDict.osc1ch = 3;
		presetDict.osc1menu = 3;
		presetDict.osc1wavetpeitems = ["SQUARE", "OFF", "SINE", "SAW"];
	};
});

// Oscillator 2 menu implementation
osc2type.action_({ arg menu;

	if(menu.item == "OFF") {
		sound.set(\osc2, 0);
		osc2menu = 0;
		osc2type.items_(["OFF", "SINE", "SAW", "SQUARE"]);
		presetDict.osc2ch = 0;
		presetDict.osc2menu = 0;
		presetDict.osc2wavetpeitems = ["OFF", "SINE", "SAW", "SQUARE"];
	};
	if(menu.item == "SINE") {
		sound.set(\osc2, 1);
		osc2menu = 1;
		osc2type.items_(["SINE", "SAW", "SQUARE", "OFF"]);
		presetDict.osc2ch = 1;
		presetDict.osc2menu = 1;
		presetDict.osc2wavetpeitems = ["SINE", "SAW", "SQUARE", "OFF"];
	};
	if(menu.item == "SAW") {
		sound.set(\osc2, 2);
		osc2menu = 2;
		osc2type.items_(["SAW", "SQUARE", "OFF", "SINE"]);
		presetDict.osc2ch = 2;
		presetDict.osc2menu = 2;
		presetDict.osc2wavetpeitems = ["SAW", "SQUARE", "OFF", "SINE"];
	};
	if(menu.item == "SQUARE") {
		sound.set(\osc2, 3);
		osc2menu = 3;
		osc2type.items_(["SQUARE", "OFF", "SINE", "SAW"]);
		presetDict.osc2ch = 3;
		presetDict.osc2menu = 3;
		presetDict.osc2wavetpeitems = ["SQUARE", "OFF", "SINE", "SAW"];
	};
});

// Filter menu implementation
filttype.action_({ arg menu;

	if(menu.item == "OFF") {
		sound.set(\filt, 0);
		filtmenu = 0;
		filttype.items_(["OFF", "LPF", "HPF"]);
		presetDict.filt = 0;
		presetDict.filtmenu = 0;
		presetDict.filttypeitems = ["OFF", "LPF", "HPF"];
	};
	if(menu.item == "LPF") {
		sound.set(\filt, 1);
		filtmenu = 1;
		filttype.items_(["LPF", "HPF", "OFF"]);
		presetDict.filt = 1;
		presetDict.filtmenu = 1;
		presetDict.filttypeitems = ["LPF", "HPF", "OFF"];
	};
	if(menu.item =="HPF") {
		sound.set(\filt, 2);
		filtmenu = 2;
		filttype.items_(["HPF", "OFF", "LPF"]);
		presetDict.filt = 2;
		presetDict.filtmenu = 2;
		presetDict.filttypeitems = ["HPF", "OFF", "LPF"];
	};
});

// Change to cases

// LFO1 menu implementation
lfo1types.action_({ arg menu;

	case

	{ (menu.item == "OFF")} {
		sound.set(\lfo1type, 0);
		lfo1menu = 0;
		lfoselect = 0;
		lfo1types.items_(["OFF", "SINE", "SAW", "SQUARE"]);
		presetDict.lfo1menu = 0;
		presetDict.lfoselect = 0;
		presetDict.lfo1types = ["OFF", "SINE", "SAW", "SQUARE"];
	}
	{ (menu.item == "SINE") } {
		sound.set(\lfo1type, 1, \lfo1rate, lfoknobs[0].value*20);
		lfo1menu = 1;
		lfoselect = 1;
		lfo1types.items_(["SINE", "SAW", "SQUARE", "OFF"]);
		presetDict.lfo1menu = 1;
		presetDict.lfoselect = 1;
		presetDict.lfo1types = ["SINE", "SAW", "SQUARE", "OFF"];
	}
	{ (menu.item == "SAW") } {
		sound.set(\lfo1type, 2, \lfo1rate, lfoknobs[0].value*20);
		lfo1menu = 2;
		lfoselect = 1;
		lfo1types.items_(["SAW", "SQUARE", "OFF", "SINE"]);
		presetDict.lfo1menu = 2;
		presetDict.lfoselect = 1;
		presetDict.lfo1types = ["SAW", "SQUARE", "OFF", "SINE"];
	}
	{ (menu.item == "SQUARE") } {
		sound.set(\lfo1type, 3, \lfo1rate, lfoknobs[0].value*20);
		lfo1menu = 3;
		lfoselect = 1;
		lfo1types.items_(["SQUARE", "OFF", "SINE", "SAW"]);
		presetDict.lfo1menu = 3;
		presetDict.lfoselect = 1;
		presetDict.lfo1types = ["SQUARE", "OFF", "SINE", "SAW"];
	}
});

// LFO2 menu implementation
lfo2types.action_({ arg menu;

	case

	{ (menu.item == "OFF") } {
		sound.set(\lfo2type, 0);
		lfo2menu = 0;
		lfoselect2 = 0;
		lfo2types.items_(["OFF", "SINE", "SAW", "SQUARE"]);
		presetDict.lfo2menu = 0;
		presetDict.lfoselect2 = 0;
		presetDict.lfo2types = ["OFF", "SINE", "SAW", "SQUARE"];
	}
	{ (menu.item == "SINE") } {
		sound.set(\lfo2type, 1, \lfo2rate, lfoknobs[0].value*20);
		lfo2menu = 1;
		lfoselect2 = 2;
		lfo2types.items_(["SINE", "SAW", "SQUARE", "OFF"]);
		presetDict.lfo2menu = 1;
		presetDict.lfoselect2 = 2;
		presetDict.lfo2types = ["SINE", "SAW", "SQUARE", "OFF"];
	}
	{ (menu.item == "SAW") } {
		sound.set(\lfo2type, 2, \lfo2rate, lfoknobs[0].value*20);
		lfo2menu = 2;
		lfoselect2 = 2;
		lfo2types.items_(["SAW", "SQUARE", "OFF", "SINE"]);
		presetDict.lfo2menu = 2;
		presetDict.lfoselect2 = 2;
		presetDict.lfo2types = ["SAW", "SQUARE", "OFF", "SINE"];
	}
	{ (menu.item == "SQUARE") } {
		sound.set(\lfo2type, 3, \lfo2rate, lfoknobs[0].value*20);
		lfo2menu = 3;
		lfoselect2 = 2;
		lfo2types.items_(["SQUARE", "OFF", "SINE", "SAW"]);
		presetDict.lfo2menu = 3;
		presetDict.lfoselect2 = 2;
		presetDict.lfo2types = ["SQUARE", "OFF", "SINE", "SAW"];
	};
});

// Matrix src1 menu implementation
matrixsrc1types.action_({ arg menu;

	if(menu.item == "OFF") {
		matrixsrc1menu = 0;
		presetDict.matrixsrc1menu = 0;
		sound.set(\lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \modfreq, oscknobs[0].value+30, \modfreq2, oscknobs[1].value+30);
		matrixsrc1types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
		presetDict.matrixsrc1types = ["OFF", "LFO1 RATE", "LFO2 RATE"];

	};
	if(menu.item == "LFO1 RATE") {
		matrixsrc1menu = 1;
		presetDict.matrixsrc1menu = 1;
		matrixsrc1types.items_(["LFO1 RATE", "LFO2 RATE", "OFF"]);
		presetDict.matrixsrc1types = ["LFO1 RATE", "LFO2 RATE", "OFF"];
	};
	if(menu.item == "LFO2 RATE") {
		matrixsrc1menu = 2;
		presetDict.matrixsrc1menu = 2;
		matrixsrc1types.items_(["LFO2 RATE", "OFF", "LFO1 RATE"]);
		presetDict.matrixsrc1types = ["LFO2 RATE", "OFF", "LFO1 RATE"];
	};
});

// Matrix src2 menu implementation
matrixsrc2types.action_({ arg menu;


	if(menu.item == "OFF") {
		matrixsrc2menu = 0;
		presetDict.matrixsrc2menu = 0;
		sound.set(\lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \modfreq, oscknobs[0].value+30, \modfreq2, oscknobs[1].value+30);
		matrixsrc2types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
		presetDict.matrixsrc2types = ["OFF", "LFO1 RATE", "LFO2 RATE"];
	};
	if(menu.item == "LFO1 RATE") {
		matrixsrc2menu = 1;
		presetDict.matrixsrc2menu = 1;
		matrixsrc2types.items_(["LFO1 RATE", "LFO2 RATE", "OFF"]);
		presetDict.matrixsrc2types = ["LFO1 RATE", "LFO2 RATE", "OFF"];
	};
	if(menu.item == "LFO2 RATE") {
		matrixsrc2menu = 2;
		presetDict.matrixsrc2menu = 2;
		matrixsrc2types.items_(["LFO2 RATE", "OFF", "LFO1 RATE"]);
		presetDict.matrixsrc2types = ["LFO2 RATE", "OFF", "LFO1 RATE"];
	};
});

// Matrix src3 menu implementation
matrixsrc3types.action_({ arg menu;

		if(menu.item == "OFF") {
		matrixsrc3menu = 0;
		presetDict.matrixsrc3menu = 0;
		sound.set(\lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \modfreq, oscknobs[0].value+30, \modfreq2, oscknobs[1].value+30);
		matrixsrc3types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
		presetDict.matrixsrc3types = ["OFF", "LFO1 RATE", "LFO2 RATE"];
	};
	if(menu.item == "LFO1 RATE") {
		matrixsrc3menu = 1;
		presetDict.matrixsrc3menu = 1;
		matrixsrc3types.items_(["LFO1 RATE", "LFO2 RATE", "OFF"]);
		presetDict.matrixsrc3types = ["LFO1 RATE", "LFO2 RATE", "OFF"];
	};
	if(menu.item == "LFO2 RATE") {
		matrixsrc3menu = 2;
		presetDict.matrixsrc3menu = 2;
		matrixsrc3types.items_(["LFO2 RATE", "OFF", "LFO1 RATE"]);
		presetDict.matrixsrc3types = ["LFO2 RATE", "OFF", "LFO1 RATE"];
	};
});

// Matrix dest1 menu implementation
matrixdest1types.action_({ arg menu;

		if(menu.item == "OFF") {
		matrixdest1menu = 0;
		sound.set(\lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \modfreq, oscknobs[0].value+30, \modfreq2, oscknobs[1].value+30);
		presetDict.matrixdest1menu = 0;
		matrixdest1types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
		presetDict.matrixdest1types = ["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"];
	};
		if(menu.item == "OSC1 PITCH") {
		matrixdest1menu = 1;
		presetDict.matrixdest1menu = 1;
		matrixdest1types.items_(["OSC1 PITCH", "OSC2 PITCH", "CUTOFF", "OFF"]);
		presetDict.matrixdest1types = ["OSC1 PITCH", "OSC2 PITCH", "CUTOFF", "OFF"];
	};
		if(menu.item == "OSC2 PITCH") {
		matrixdest1menu = 2;
		presetDict.matrixdest1menu = 2;
		matrixdest1types.items_(["OSC2 PITCH", "CUTOFF", "OFF", "OSC1 PITCH"]);
		presetDict.matrixdest1types = ["OSC2 PITCH", "CUTOFF", "OFF", "OSC1 PITCH"];

	};
	if(menu.item == "CUTOFF") {
		matrixdest1menu = 3;
		presetDict.matrixdest1menu = 3;
		matrixdest1types.items_(["CUTOFF", "OFF", "OSC1 PITCH", "OSC2 PITCH"]);
		presetDict.matrixdest1types = ["CUTOFF", "OFF", "OSC1 PITCH", "OSC2 PITCH"];
	};
});

// Matrix dest2 menu implementation
matrixdest2types.action_({ arg menu;

		if(menu.item == "OFF") {
		matrixdest2menu = 0;
		sound.set(\lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \modfreq, oscknobs[0].value+30, \modfreq2, oscknobs[1].value+30);
		presetDict.matrixdest2menu = 0;
		matrixdest2types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
		presetDict.matrixdest2types = ["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"];
	};
		if(menu.item == "OSC1 PITCH") {
		matrixdest2menu = 1;
		presetDict.matrixdest2menu = 1;
		matrixdest2types.items_(["OSC1 PITCH", "OSC2 PITCH", "CUTOFF", "OFF"]);
		presetDict.matrixdest2types = ["OSC1 PITCH", "OSC2 PITCH", "CUTOFF", "OFF"];
	};
		if(menu.item == "OSC2 PITCH") {
		matrixdest2menu = 2;
		presetDict.matrixdest2menu = 2;
		matrixdest2types.items_(["OSC2 PITCH", "CUTOFF", "OFF", "OSC1 PITCH"]);
		presetDict.matrixdest2types = ["OSC2 PITCH", "CUTOFF", "OFF", "OSC1 PITCH"];
	};
	if(menu.item == "CUTOFF") {
		matrixdest2menu = 3;
		presetDict.matrixdest2menu = 3;
		matrixdest2types.items_(["CUTOFF", "OFF", "OSC1 PITCH", "OSC2 PITCH"]);
		presetDict.matrixdest2types = ["CUTOFF", "OFF", "OSC1 PITCH", "OSC2 PITCH"];
	};
});


// Matrix dest3 menu implementation
matrixdest3types.action_({ arg menu;

		if(menu.item == "OFF") {
		matrixdest3menu = 0;
		sound.set(\lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \modfreq, oscknobs[0].value+30, \modfreq2, oscknobs[1].value+30);
		presetDict.matrixdest3menu = 0;
		matrixdest3types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
		presetDict.matrixdest3types = ["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"];
	};
		if(menu.item == "OSC1 PITCH") {
		matrixdest3menu = 1;
		presetDict.matrixdest3menu = 1;
		matrixdest3types.items_(["OSC1 PITCH", "OSC2 PITCH", "CUTOFF", "OFF"]);
		presetDict.matrixdest3types = ["OSC1 PITCH", "OSC2 PITCH", "CUTOFF", "OFF"];
	};
		if(menu.item == "OSC2 PITCH") {
		matrixdest3menu = 2;
		presetDict.matrixdest3menu = 2;
		matrixdest3types.items_(["OSC2 PITCH", "CUTOFF", "OFF", "OSC1 PITCH"]);
		presetDict.matrixdest3types = ["OSC2 PITCH", "CUTOFF", "OFF", "OSC1 PITCH"];
	};
	if(menu.item == "CUTOFF") {
		matrixdest3menu = 3;
		presetDict.matrixdest3menu = 3;
		matrixdest3types.items_(["CUTOFF", "OFF", "OSC1 PITCH", "OSC2 PITCH"]);
		presetDict.matrixdest3types = ["CUTOFF", "OFF", "OSC1 PITCH", "OSC2 PITCH"];
	};
});

/*
Knob actions:
*/

outknob.action_({
	sound.set(\amp, outknob.value*0.5);
	presetDict.outlevel = outknob.value;
});
// OSC1 Frequency
oscknobs[0].action_({
	sound.set(\osc1freq, oscknobs[0].value.linexp(0, 1, 30, 5000));
	presetDict.osc1freq = oscknobs[0].value;
});
// OSC2 Frequency
oscknobs[1].action_({
	sound.set(\osc2freq, oscknobs[1].value.linexp(0, 1, 30, 5000));
	presetDict.osc2freq = oscknobs[1].value;
});
// Filter Cutoff
filtknobs[0].action_({
	sound.set(\cutofffreq, filtknobs[0].value.linlin(0, 1, 20, 20000));
	presetDict.cutofffreq = filtknobs[0].value;
});
// Filter resonance
filtknobs[1].action_({
	sound.set(\rq, (1-(filtknobs[1].value*0.9) + 0.01));
	presetDict.rq = filtknobs[1].value;
});

// LFO1 Rate (use * 20 since logical max lfo rate)
lfoknobs[0].action_({
	sound.set(\lfo1rate, lfoknobs[0].value*20);
	presetDict.lfo1rate = lfoknobs[0].value;
});
// LFO2 Rate
lfoknobs[1].action_({
	sound.set(\lfo2rate, lfoknobs[1].value*20);
	presetDict.lfo2rate = lfoknobs[1].value;
});
// Verb Mix
verbknobs[0].action_({
	sound.set(\mix, verbknobs[0].value);
	presetDict.verbmix = verbknobs[0].value;
});
// Verb roomsize
verbknobs[1].action_({
	sound.set(\roomsize, verbknobs[1].value);
	presetDict.verbsize= verbknobs[1].value;
});
// Envelope Attack
envsliders[0].action_({
	sound.set(\attack, envsliders[0].value);
	presetDict.envslidersattack = envsliders[0].value;
});
// Envelope Decay
envsliders[1].action_({
	sound.set(\decay, envsliders[1].value);
	presetDict.envslidersdecay = envsliders[1].value;
});
// Envelope Sustain
envsliders[2].action_({
	sound.set(\sustain, envsliders[2].value);
	presetDict.envsliderssustain = envsliders[2].value;
});
// Envelope Release
envsliders[3].action_({
	sound.set(\release, envsliders[3].value*10);
	presetDict.envslidersrelease = envsliders[3].value;
});

// SRC AND DEST 1 MATRIX KNOB 1:
matrixknobs[0].action_({ arg knob;

	case

	// If src1 0 or dest1 0 set lfoselect to 0
	{ (matrixsrc1menu == 0).or(matrixdest1menu == 0) } {
		sound.set(\lfoselect, 0, \modfreq, oscknobs[0].value+30);
		presetDict.matrixknobs1 = matrixknobs[0].value;
	}

	// If src1 = LFO1 rate and dest1 = OSC1 Pitch and lfo1 = anything but off and osc1 = anything but off
	{ (matrixsrc1menu == 1) && (matrixdest1menu == 1) && (lfo1menu != 0) && (osc1menu != 0) } {
		sound.set(\lfoselect, 1, \modfreq, matrixknobs[0].value.linexp(0, 1, 30, 5000));
		presetDict.matrixknobs1 = matrixknobs[0].value;
	}

	// If src1 = LFO2 rate and dest1 = OSC1 Pitch and lfo2 = anything but off and osc1 anything but off
	{ (matrixsrc1menu == 2) && (matrixdest1menu == 1) && (lfo2menu != 0) && (osc1menu != 0) } {
		sound.set(\lfoselect, 2, \modfreq, matrixknobs[0].value*5000);
		presetDict.matrixknobs1 = matrixknobs[0].value;
	}

	// If src1 = LFO1 rate and dest1 = OSC2 Pitch and lfo2 = anything but off and osc1 anything but off
	{ (matrixsrc1menu == 1) && (matrixdest1menu == 2) && (lfo1menu != 0) && (osc2menu != 0) } {
		sound.set(\lfoselect2, 1, \modfreq2, matrixknobs[0].value*5000);
		presetDict.matrixknobs1 = matrixknobs[0].value;
	}

	{ (matrixsrc1menu == 2) && (matrixdest1menu == 2) && (lfo2menu != 0) && (osc2menu != 0) } {
		sound.set(\lfoselect2, 2, \modfreq2, matrixknobs[0].value*5000);
		presetDict.matrixknobs1 = matrixknobs[0].value;
	}

	// And osc1 or osc2 is not null filter
	{ (matrixsrc1menu == 1) && (matrixdest1menu == 3) && (lfo1menu != 0) && (filtmenu != 0) } {
		sound.set(\lfofiltselect, 1, \modcutofffreq, matrixknobs[0].value*10000);
		presetDict.matrixknobs1 = matrixknobs[0].value;
	}

	{ (matrixsrc1menu == 2) && (matrixdest1menu == 3) && (lfo2menu != 0) && (filtmenu != 0) } {
		sound.set(\lfofiltselect, 2, \modcutofffreq, matrixknobs[0].value*10000);
		presetDict.matrixknobs1 = matrixknobs[0].value;
	};
});

// SRC AND DEST 2 MATRIX KNOB 2:
matrixknobs[1].action_({ arg knob;

	case

	// If src1 0 or dest1 0 set lfoselect to 0
	{ (matrixsrc2menu == 0).or(matrixdest2menu == 0) } {
		sound.set(\lfoselect, 0, \modfreq, oscknobs[0].value+30);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	}

	// If src1 = LFO1 rate and dest1 = OSC1 Pitch and lfo1 = anything but off and osc1 = anything but off
	{ (matrixsrc2menu == 1) && (matrixdest2menu == 1) && (lfo1menu != 0) && (osc1menu != 0) } {
		sound.set(\lfoselect, 1, \modfreq, matrixknobs[1].value*5000);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	}

	// If src1 = LFO2 rate and dest1 = OSC1 Pitch and lfo2 = anything but off and osc1 anything but off
	{ (matrixsrc2menu == 2) && (matrixdest2menu == 1) && (lfo2menu != 0) && (osc1menu != 0) } {
		sound.set(\lfoselect, 2, \modfreq, matrixknobs[1].value*5000);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	}

	// Point of the various selects means we can have more than one at a time.
	// If src1 = LFO1 rate and dest1 = OSC2 Pitch and lfo2 = anything but off and osc1 anything but off
	{ (matrixsrc2menu == 1) && (matrixdest2menu == 2) && (lfo1menu != 0) && (osc2menu != 0) } {
		sound.set(\lfoselect2, 1, \modfreq2, matrixknobs[1].value*5000);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	}

	{ (matrixsrc2menu == 2) && (matrixdest2menu == 2) && (lfo2menu != 0) && (osc2menu != 0) } {
		sound.set(\lfoselect2, 2, \modfreq2, matrixknobs[1].value*5000);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	}

	// And osc1 or osc2 is not null filter
	{ (matrixsrc2menu == 1) && (matrixdest2menu == 3) && (lfo1menu != 0) && (filtmenu != 0) } {
		sound.set(\lfofiltselect, 1, \modcutofffreq, matrixknobs[1].value*10000);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	}

	{ (matrixsrc2menu == 2) && (matrixdest2menu == 3) && (lfo2menu != 0) && (filtmenu != 0) } {
		sound.set(\lfofiltselect, 2, \modcutofffreq, matrixknobs[1].value*10000);
		presetDict.matrixknobs2 = matrixknobs[1].value;
	};
});

// SRC AND DEST 3 MATRIX KNOB 3:
matrixknobs[2].action_({ arg knob;

	case

	{ (matrixsrc3menu == 0).or(matrixdest3menu == 0) } {
		sound.set(\lfoselect, 0, \modfreq, oscknobs[0].value);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	}

	// If src1 = LFO1 rate and dest1 = OSC1 Pitch and lfo1 = anything but off and osc1 = anything but off
	{ (matrixsrc3menu == 1) && (matrixdest3menu == 1) && (lfo1menu != 0) && (osc1menu != 0) } {
		sound.set(\lfoselect, 1, \modfreq, matrixknobs[2].value*5000);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	}

	// If src1 = LFO2 rate and dest1 = OSC1 Pitch and lfo2 = anything but off and osc1 anything but off
	{ (matrixsrc3menu == 2) && (matrixdest3menu == 1) && (lfo2menu != 0) && (osc1menu != 0) } {
		sound.set(\lfoselect, 2, \modfreq, matrixknobs[2].value*5000);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	}

	// Point of the various selects means we can have more than one at a time.
	// If src1 = LFO1 rate and dest1 = OSC2 Pitch and lfo2 = anything but off and osc1 anything but off
	{ (matrixsrc3menu == 1) && (matrixdest3menu == 2) && (lfo1menu != 0) && (osc2menu != 0) } {
		sound.set(\lfoselect2, 1, \modfreq2, matrixknobs[2].value*5000);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	}

	{ (matrixsrc3menu == 2) && (matrixdest3menu == 2) && (lfo2menu != 0) && (osc2menu != 0) } {
		sound.set(\lfoselect2, 2, \modfreq2, matrixknobs[2].value*5000);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	}

	// And osc1 or osc2 is not null filter
	{ (matrixsrc3menu == 1) && (matrixdest3menu == 3) && (lfo1menu != 0) && (filtmenu != 0) } {
		sound.set(\lfofiltselect, 1, \modcutofffreq, matrixknobs[2].value*10000);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	}

	{ (matrixsrc3menu == 2) && (matrixdest3menu == 3) && (lfo2menu != 0) && (filtmenu != 0) } {
		sound.set(\lfofiltselect, 2, \modcutofffreq, matrixknobs[2].value*10000);
		presetDict.matrixknobs3 = matrixknobs[2].value;
	};
});


/*
BUTTON ACTIONS
*/

// Show FX Button
bshowfx.action_({arg b;

	// IF shorter window then make bigger
	if(w.bounds == Rect(350, 300, 1000, 650))  {
		w.bounds = Rect(350, 150, 1000, 800);
	}
	// Else If bigger window make shorter
	{
		w.bounds = Rect(350, 300, 1000, 650);
	}
});

// Play Button
playb.action_({arg playb;

	// If play button clicked play, sound put gate to 1
	if(playb.value == 1) {
		sound.set(\gate, 1);
		presetDict.gate = 1;
	};

	// Else if stop button clicked stop, sound put gate to 0
	if(playb.value == 0) {
		sound.set(\gate, 0);
		presetDict.gate = 0;
	};
});

// Default Button
presetbs[0].action_({ arg pb;


	// For the GUI objects
	oscknobs[0].value = 0;
	oscknobs[1].value = 0;
	filtknobs[0].value = 0;
	filtknobs[1].value = 0;
	lfoknobs[0].value = 0;
	lfoknobs[1].value = 0;
	envsliders[0].value = 0;
	envsliders[1].value = 0;
	envsliders[2].value = 0;
	envsliders[3].value = 0;
	matrixknobs[0].value = 0;
	matrixknobs[1].value = 0;
	matrixknobs[2].value = 0;
	verbknobs[0].value = 0;
	verbknobs[1].value = 0;
	outknob.value = 0;
	osc1type.items_(["OFF", "SINE", "SAW", "SQUARE"]);
	osc2type.items_(["OFF", "SINE", "SAW", "SQUARE"]);
	filttype.items_(["OFF", "LPF", "HPF"]);
	lfo1types.items_(["OFF", "SINE", "SAW", "SQUARE"]);
	lfo2types.items_(["OFF", "SINE", "SAW", "SQUARE"]);
	matrixsrc1types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
	matrixsrc2types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
	matrixsrc3types.items_(["OFF", "LFO1 RATE", "LFO2 RATE"]);
	matrixdest1types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
	matrixdest2types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
	matrixdest3types.items_(["OFF", "OSC1 PITCH", "OSC2 PITCH", "CUTOFF"]);
	presetText.string = "PRESET:" + "Default";
	osc1menu = 0;
	osc2menu = 0;
	filtmenu = 0;
	lfo1menu = 0;
	lfo2menu = 0;
	lfoselect = 0;
	lfoselect2 = 0;
	lfofiltselect = 0;
	matrixsrc1menu = 0;
	matrixsrc2menu = 0;
	matrixsrc3menu = 0;
	matrixdest1menu = 0;
	matrixdest2menu = 0;
	matrixdest3menu = 0;
	gate = 0;

	// For the Sound
	sound.set(\osc1, 0, \osc1freq, 0, \osc2, 0, \osc2freq, 0, \lfo1type, 0, \lfo1rate, 0, \lfo2type, 0, \lfo2rate, 0, \lfoselect, 0, \lfoselect2, 0, \lfofiltselect, 0, \filt, 0, \modfreq,  0, \modfreq2, 0, \cuttofffreq, 0, \modcutofffreq,  0, \rq, 0, \attack, 0, \decay, 0, \sustain, 0, \release, 0, \gate, 0, \mix, 0, \roomsize, 0, \amp, 0);

});

// Load Button
presetbs[1].action_({ arg pb;

	Dialog.openPanel({arg path;
	preset = Object.readArchive(path);

		// Set the GUI objects to place
	oscknobs[0].value_(preset.osc1freq);
	oscknobs[1].value_(preset.osc2freq);
	filtknobs[0].value_(preset.cutofffreq);
	filtknobs[1].value_(preset.rq);
	lfoknobs[0].value_(preset.lfo1rate);
	lfoknobs[1].value_(preset.lfo2rate);
	matrixknobs[0].value_(preset.matrixknobs1);
	matrixknobs[1].value_(preset.matrixknobs2);
	matrixknobs[2].value_(preset.matrixknobs3);
	envsliders[0].value_(preset.envslidersattack);
	envsliders[1].value_(preset.envslidersdecay);
	envsliders[2].value_(preset.envsliderssustain);
	envsliders[3].value_(preset.envslidersrelease);
	verbknobs[0].value_(preset.verbmix);
	verbknobs[1].value_(preset.verbsize);
	outknob.value = preset.outlevel;
	osc1type.items_(preset.osc1wavetpeitems);
	osc2type.items_(preset.osc2wavetpeitems);
	filttype.items_(preset.filttypeitems);
	lfo1types.items_(preset.lfo1types);
	lfo2types.items_(preset.lfo2types);
	lfoselect = preset.lfoselect;
	lfoselect2 = preset.lfoselect2;
	lfofiltselect = preset.lfofiltselect;
	filtmenu = preset.filt;
	matrixsrc1types.items_(preset.matrixsrc1types);
	matrixsrc2types.items_(preset.matrixsrc2types);
	matrixsrc3types.items_(preset.matrixsrc3types);
	matrixdest1types.items_(preset.matrixdest1types);
	matrixdest2types.items_(preset.matrixdest2types);
	matrixdest3types.items_(preset.matrixdest3types);
	osc1menu = preset.osc1menu;
	osc2menu = preset.osc2menu;
	filtmenu = preset.filtmenu;
	lfo1menu = preset.lfo1menu;
	lfo2menu = preset.lfo2menu;
	lfoselect = preset.lfoselect;
	lfoselect2 = preset.lfoselect2;
	lfofiltselect = preset.lfofiltselect;
	matrixsrc1menu = preset.matrixsrc1menu;
	matrixsrc2menu = preset.matrixscr2menu;
	matrixsrc3menu = preset.matrixscr3menu;
	matrixdest1menu = preset.matrixdest1menu;
	matrixdest2menu = preset.matrixdest2menu;
	matrixdest3menu = preset.matrixdest3menu;


		// Set the sound to the load file so multiplication here
		sound.set(\osc1, preset.osc1ch.value, \osc1freq, preset.osc1freq.value.linexp(0, 1, 30, 5000), \osc2, preset.osc2ch.value, \osc2freq, preset.osc2freq.value.linexp(0, 1, 30, 5000), \lfo1type, preset.lfo1menu.value, \lfo1rate, preset.lfo1rate.value*20, \lfo2type, preset.lfo2menu.value, \lfo2rate, preset.lfo2rate.value*20, \lfoselect, preset.lfoselect.value, \lfoselect2, preset.lfoselect2.value, \lfofiltselect, preset.lfofiltselect.value, \filt, preset.filt.value, \modfreq,  preset.modfreq.value*5000, \modfreq2, preset.modfreq2.value*5000, \cuttofffreq, preset.cutofffreq.value.linlin(0, 1, 20, 20000), \modcutofffreq, preset.modcutofffreq.value.linlin(0, 1, 20, 20000), \rq, (1-(preset.rq.value*0.9)+0.01), \attack, preset.envslidersattack.value, \decay, preset.envslidersdecay.value, \sustain, preset.envsliderssustain.value, \release, preset.envslidersrelease.value*10, \gate, preset.gate.value, \amp, preset.outlevel.value*0.5, \mix, preset.verbmix.value, \roomsize, preset.verbsize.value);


		// Set the top preset name
		myPath = PathName.new(path);
		presetText.string = "Preset:" + myPath.fileName;
})});

// Save Button
presetbs[2].action_({ arg pb;
	// If save pressed
	Dialog.savePanel({ arg path;
		presetDict.writeArchive(path);
		myPath = PathName.new(path);
		presetText.string = "Preset:" + myPath.fileName;
})});

// Show Window
w.front;
// Free synth when closed
w.onClose_({ sound.free });

)




