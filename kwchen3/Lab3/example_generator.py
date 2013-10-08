## Virtues of a programmer (from Programming Perl, Wall, Schwartz and
## Christiansen)
## 
## Laziness - The quality that makes you go to great effort to reduce
## overall energy expenditure. It makes you write labor-saving programs
## that other people will find useful, and document what you wrote so you
## don't have to answer so many questions about it. 
## 
## 
## This function generates a circuit (albeit a slow one) to compute whether
## a bus is all zeros.
## 
## python example_generator.py

width = 8;

print "   input [%s:0] in;" % (width - 1)
print "   wire  [%s:1] chain;" % (width - 1)
print ""
print "   or o1(chain[1], in[1], in[0]);"
for i in range(2, width):
    print "   or o%d(chain[%d], in[%d], chain[%d]);" % (i, i, i, i-1)

print "   not n0(zero, chain[%d]);" % (width - 1);

