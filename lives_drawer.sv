
module lives_drawer (
					input	logic clk,
					input	logic resetN,
					input logic	[10:0] pixelX,
					input logic	[10:0] pixelY,
					input logic [3:0] lives,
					
					output	logic	drawingRequest,
					output	logic	[7:0] RGBout
);


localparam int BITMAP_WIDTH = 8;
localparam int BITMAP_HEIGHT = 16;
localparam int HEART_SIZE = 16;

logic [0:HEART_SIZE-1] [0:HEART_SIZE-1] [7:0] heart_colors = {
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00 },
{8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00 },
{8'hA5, 8'hA5, 8'hCE, 8'hCE, 8'hCE, 8'hA5, 8'hA5, 8'h00, 8'h00, 8'hA5, 8'hA5, 8'hCE, 8'hCE, 8'hCE, 8'hA5, 8'hA5 },
{8'hA5, 8'hCE, 8'hCE, 8'hBB, 8'hBB, 8'hCE, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hCE, 8'hBB, 8'hBB, 8'hCE, 8'hCE, 8'hA5 },
{8'hA5, 8'hCE, 8'hCE, 8'hBB, 8'hBB, 8'hCE, 8'hCE, 8'hA5, 8'hA5, 8'hCE, 8'hCE, 8'hBB, 8'hBB, 8'hCE, 8'hCE, 8'hA5 },
{8'hA5, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hA5 },
{8'h00, 8'hA5, 8'hCE, 8'hA5, 8'hA5, 8'hA5, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hA5, 8'hA5, 8'hA5, 8'hCE, 8'hA5, 8'h00 },
{8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00 },
{8'h00, 8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'hA5, 8'hCE, 8'hA5, 8'hA5, 8'hA5, 8'hA5, 8'hCE, 8'hA5, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA5, 8'hCE, 8'hCE, 8'hCE, 8'hCE, 8'hA5, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA5, 8'hCE, 8'hCE, 8'hA5, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hA5, 8'hA5, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 },
{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00 }
};

logic [0:BITMAP_HEIGHT - 1][0:BITMAP_WIDTH - 1] x_bitmap = {
{8'b00000000},
{8'b00000000},
{8'b11100111},
{8'b11100111},
{8'b01111110},
{8'b01111110},
{8'b00111100},
{8'b00111100},
{8'b01111110},
{8'b01111110},
{8'b11100111},
{8'b11100111},
{8'b00000000},
{8'b00000000},
{8'b00000000},
{8'b00000000}
};


logic [0:9][0:BITMAP_HEIGHT - 1] [0:BITMAP_WIDTH - 1] numbers_bitmap = {
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
logic signed [11:0] diffXHeart;
logic signed [11:0] diffXX;
logic signed [11:0] diffXLives;

localparam  logic [10:0] topLeftXHeart = 560;
localparam  logic [10:0] topLeftXX = topLeftXHeart + 34;
localparam  logic [10:0] topLeftXLives = topLeftXX + 18;

assign diffY = pixelY >> 1;
assign diffXHeart = (pixelX - topLeftXHeart) >> 1;
assign diffXX = (pixelX - topLeftXX) >> 1;
assign diffXLives = (pixelX - topLeftXLives) >> 1;

// collect collision info
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
	end else begin
		drawingRequest = 0;
		
		// heart
		if(0 <= diffXHeart && diffXHeart < HEART_SIZE && diffY < HEART_SIZE) begin
			RGBout = heart_colors[diffY][diffXHeart];
			drawingRequest = RGBout != 8'h11;
		end else if(0 <= diffXX && diffXX < BITMAP_WIDTH && diffY < BITMAP_HEIGHT) begin
			RGBout = 8'hFF;
			drawingRequest = x_bitmap[diffY][diffXX];
		end else if(0 <= diffXLives && diffXLives < BITMAP_WIDTH && diffY < BITMAP_HEIGHT) begin
			RGBout = 8'hFF;
			drawingRequest = numbers_bitmap[lives][diffY][diffXLives];
		end
	end
end

endmodule
