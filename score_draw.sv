
module score_draw (
					input	logic clk,
					input	logic resetN,
					input logic	[10:0] pixelX,
					input logic	[10:0] pixelY,
					input logic [4:0] ones,
					input logic [4:0] tens,
					input logic [4:0] hundreds,
					input logic [4:0] thousands,
					
					output	logic	drawingRequest,
					output	logic	[7:0] RGBout
);

/*`include "defines.inc"*/

localparam  logic [10:0] topLeftXScore = 16;
localparam  logic [10:0] topLeftXOnes = topLeftXScore + 110;
localparam  logic [10:0] topLeftXTens = topLeftXOnes + 18;
localparam  logic [10:0] topLeftXHundreds = topLeftXTens + 18;
localparam  logic [10:0] topLeftXThousands = topLeftXHundreds + 18;

localparam int SCORE_WIDTH = 50;
localparam int SCORE_HEIGHT = 12;
localparam int NUMBER_HEIGHT = 16;
localparam int NUMBER_WIDTH = 8;

logic [0:11] [0:49] score_bitmap = {
{50'b00000000000000000000000000000000000000000000000000},
{50'b00000000000000000000000000000000000000000000000000},
{50'b01111110001111110001111110011111110011111111000000},
{50'b11111111011111111011111111011111111011111111000111},
{50'b11100111011100111011100111011100111011100000000111},
{50'b11100000011100000011100111011100111011100000000111},
{50'b11111110011100000011100111011111110011111100000000},
{50'b01111111011100000011100111011111110011111100000000},
{50'b00000111011100000011100111011100111011100000000111},
{50'b11100111011100111011100111011100111011100000000111},
{50'b11111111011111111011111111011100111011111111000111},
{50'b01111110001111110001111110011100111011111111000000}
};

logic [0:9][0:NUMBER_HEIGHT-1] [0:NUMBER_WIDTH-1] numbers_bitmap = {
{
{8'b00000000},
{8'b00000000},
{8'b00111100},
{8'b01111110},
{8'b11100111},
{8'b11100111},
{8'b11100111},
{8'b11100111},
{8'b11100111},
{8'b11100111},
{8'b01111110},
{8'b00111100},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b00011100},
{8'b00111100},
{8'b01111100},
{8'b00011100},
{8'b00011100},
{8'b00011100},
{8'b00011100},
{8'b00011100},
{8'b00011100},
{8'b00011100},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b01111110},
{8'b11111111},
{8'b11100111},
{8'b00000111},
{8'b00001110},
{8'b00011100},
{8'b00111000},
{8'b01110000},
{8'b11111111},
{8'b11111111},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b01111110},
{8'b11111111},
{8'b11100111},
{8'b00000111},
{8'b00111110},
{8'b00111110},
{8'b00000111},
{8'b11100111},
{8'b11111111},
{8'b01111110},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b00001110},
{8'b00011110},
{8'b00111110},
{8'b01111110},
{8'b11101110},
{8'b11111111},
{8'b11111111},
{8'b00001110},
{8'b00001110},
{8'b00001110},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b11111111},
{8'b11111111},
{8'b11100000},
{8'b11111110},
{8'b11111111},
{8'b00000111},
{8'b00000111},
{8'b11100111},
{8'b11111111},
{8'b01111110},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b01111110},
{8'b11111111},
{8'b11100111},
{8'b11100000},
{8'b11111110},
{8'b11111111},
{8'b11100111},
{8'b11100111},
{8'b11111111},
{8'b01111110},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b11111111},
{8'b11111111},
{8'b00000111},
{8'b00000111},
{8'b00001110},
{8'b00011100},
{8'b00011100},
{8'b00111000},
{8'b00111000},
{8'b00111000},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b01111110},
{8'b11111111},
{8'b11100111},
{8'b11100111},
{8'b01111110},
{8'b01111110},
{8'b11100111},
{8'b11100111},
{8'b11111111},
{8'b01111110},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
},

{
{8'b00000000},
{8'b00000000},
{8'b01111110},
{8'b11111111},
{8'b11100111},
{8'b11100111},
{8'b11111111},
{8'b01111111},
{8'b00000111},
{8'b11100111},
{8'b11111111},
{8'b01111110},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
}

};

logic signed [11:0] diffY;
logic signed [11:0] diffXScore;
logic signed [11:0] diffXOnes;
logic signed [11:0] diffXTens;
logic signed [11:0] diffXHundreds;
logic signed [11:0] diffXThousands;


assign diffY = pixelY >> 1;
assign diffXScore = (pixelX - topLeftXScore) >> 1;
assign diffXOnes = (pixelX - topLeftXOnes) >> 1;
assign diffXTens = (pixelX - topLeftXTens) >> 1;
assign diffXHundreds = (pixelX - topLeftXHundreds) >> 1;
assign diffXThousands = (pixelX - topLeftXThousands) >> 1;


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
	end else begin
	
		drawingRequest = 0;
		
		// score:
		if(0 <= diffXScore && diffXScore < SCORE_WIDTH && diffY < SCORE_HEIGHT) begin
			drawingRequest = score_bitmap[diffY][diffXScore];
		end else if(0 <= diffXOnes && diffXOnes < NUMBER_WIDTH && diffY < NUMBER_HEIGHT) begin // ones
			drawingRequest = numbers_bitmap[thousands][diffY][diffXOnes];
		end else if(0 <= diffXTens && diffXTens < NUMBER_WIDTH && diffY < NUMBER_HEIGHT) begin // tens
			drawingRequest = numbers_bitmap[hundreds][diffY][diffXTens];
		end else if(0 <= diffXHundreds && diffXHundreds < NUMBER_WIDTH && diffY < NUMBER_HEIGHT) begin // hundreds
			drawingRequest = numbers_bitmap[tens][diffY][diffXHundreds];
		end else if(0 <= diffXThousands && diffXThousands < NUMBER_WIDTH && diffY < NUMBER_HEIGHT) begin // thousands
			drawingRequest = numbers_bitmap[ones][diffY][diffXThousands];
		end
		
		RGBout = 8'hFF;
	end
end

endmodule
