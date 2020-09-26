Oz Coco/R
========

Coco/R is a compiler generator, which takes an attributed grammar of a source language
and generates a scanner and a parser for this language. 
The scanner works as a deterministic finite automaton. 
The parser uses recursive descent. LL(1) conflicts can be resolved by a multi-symbol 
lookahead or by semantic checks. 
Thus the class of accepted grammars is LL(k) for an arbitrary k.

Why this project appeared
--------------------------
I have been using the turbo pascal version for a long time.
Sometimes it was necessary to change the code.
If the sources changed, I recompiled it.
But after some Windows update, I found
that Turbo Pascal ordered to live a long time and stopped running.
In general, it seems to me that there is some conspiracy against the languages
from Niklaus Wirth. I don't understand where this hatred comes from.

First, I ported the code from Turbo Pascal. But I discovered that in almost 20 years
a lot of water has flowed under the bridge and the COCO/R code has also been improved well.
The most important improvement I consider to be the resolution option is LL (k).
The utf-8 support is also very helpful.

The last version I found was C ++, C #, Java.
Then I decided to port the code and chose C #.
In spirit, this is the language closest to Delphi,
probably due to the fact that they have one chief architect.
