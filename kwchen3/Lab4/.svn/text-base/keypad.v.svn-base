module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   assign valid= ~(g&(a|c))&((a|b|c)&(d|e|f|g));
   assign number[3] = f & (b|c);
   assign number[2] = e | (f&a);
   assign number[1] = (d&(b|c))| (e&c)| (f&a) ;
   assign number[0] = ((d|f)&(a|c))|(e&b);

endmodule // keypad
