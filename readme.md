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
I've been using the turbo pascal version of Coco / R for a long time.
Sometimes it was necessary to change the code.
If the sources changed, I recompiled it.
But after some Windows update, I found that Turbo Pascal go to a better place and stopped running. 
In general, I think many people's languages from Niklaus Emil Wirth cause dislike.

In general, I believe that there are few such people who have made a comparable contribution to the development of programming and computer science languages.

It is easy to find a complex and often incomprehensible solution to a problem. 
It is difficult to make a simple, clean and understandable solution.

When you see such a decision, it becomes clear that this is the work of the Master with a capital letter.
First, I ported the code from Turbo Pascal. But I discovered that in almost 20 years
a lot of water has flowed under the bridge and the COCO/R code has also been improved well.

The last version I found was C ++, C #, Java.
Then I decided to port the code and chose C #.
In spirit, this is the language closest to Delphi,
probably due to the fact that they have one chief architect.

1. The most important improvements in my opinion are the support for LL (k) grammar.
2. The utf-8 support is also very useful.
3. Great attention is paid to the good quality of the generated code.
4. Also attention was paid to the separate CocoLib unit.
I developed this library when I was using the Turbo Pascal version.
I usually always include it unchanged in my projects.
using Coco / r.

You can see an example of use in the protobuf-delphi project.
