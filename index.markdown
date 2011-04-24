---
layout: default
title: lorem-ipsum
---

lorem-ipsum is an automatic text-generator written in Ruby that can be used to
generate an arbitrary amount of dummy text. The principles behind how it works
is fairly simple:

1. Read a lot of reference text.
2. Calculate some basic statistics from the reference text
3. Randomly generate text that conforms to those statistics.

Obviously, the quality of the output text depends on the quality of the 
statistics used to analyze the text. Currently, lorem-ipsum analyzes how long
words are on average and counts the n-graphs found in the text it has read.

