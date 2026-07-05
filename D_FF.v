//D Flipflop with asynchronous reset
module async_d(
  input d,
  input clk,
  input rst,
  output q,
);
  always@(posedge clk) // Asynchronous reset
    if(!rst)
      q<=1'b0;
  else
    q<=d;
  end
endmodule

//D Flipflop with synchronous reset
module sync_d(
  input clk,
  input rst,
  input d,
  output reg q
);
  always@(posedge clk or negedge rst) begin
      if(!rst)
      q<=1'b0;
  else
    q<=d;
  end
endmodule

// D Flip-Flop with Enable and Active-Low Asynchronous Reset
module enable_d(
    input clk,
    input rst,
    input en,
    input d,
    output reg q
);

always @(posedge clk or negedge rst) begin
    if (!rst)
        q <= 1'b0;
    else if (en)
        q <= d;
end

endmodule
