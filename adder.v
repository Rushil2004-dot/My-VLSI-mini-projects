module Half_adder(
  input a,b;
  output sum, carry;
);
  assign sum<=a+b;
  assign carry<=a.b+b.a;
  end
endmodule
