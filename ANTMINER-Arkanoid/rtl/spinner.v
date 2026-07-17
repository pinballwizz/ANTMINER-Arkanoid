//----------------------------------------------------------------
//
//               Arkanoid 2-bit Gray-Code Spinner
//                      PinballWiz 2026
//
//----------------------------------------------------------------
module spinner(
input clk, // 48 MHz
input reset,
input joy_left,
input joy_right,
input btn_fast,
output reg [1:0] spinner // 2-bit Gray-code output
);
//----------------------------------------------------------------
// Arkanoid MCU Gray-code sequence: 00, 01, 11, 10

reg [1:0] gray = 2'b00;

// Speed divider
reg [15:0] div_fast;
reg [16:0] div_slow;
wire tick;
assign tick = btn_fast ? (div_fast == 16'd0) : (div_slow == 17'd0);

always @(posedge clk) begin
if (reset)
div_slow <= 0;
else if (reset)
div_fast <= 0;
else
div_slow <= div_slow + 1'b1;
div_fast <= div_fast + 1'b1;
end
//----------------------------------------------------------------
// Advance Gray-code forward/backward
always @(posedge clk) begin

if (reset) begin
gray <= 2'b00;
end else if (tick) begin

case (gray)
2'b00: begin
if (joy_right && !joy_left) gray <= 2'b01;
else if (joy_left && !joy_right) gray <= 2'b10;
end

2'b01: begin
if (joy_right && !joy_left) gray <= 2'b11;
else if (joy_left && !joy_right) gray <= 2'b00;
end

2'b11: begin
if (joy_right && !joy_left) gray <= 2'b10;
else if (joy_left && !joy_right) gray <= 2'b01;
end

2'b10: begin
if (joy_right && !joy_left) gray <= 2'b00;
else if (joy_left && !joy_right) gray <= 2'b11;
end
endcase
end
end
//-----------------------------------------------------------------
// Output to Arkanoid core
always @(posedge clk) begin
spinner <= gray;
end
//-----------------------------------------------------------------
endmodule