
module	New_Mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
					
		   // smiley 
					input		logic	MarioDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] marioRGB, 
					     
		  // add the box here 
					input    logic [7:0] paddleRGB,
					input    logic paddleDrawingRequest,
					
		  ////////////////////////
		  // background 
					input    logic tileDrawingRequest, // box of numbers
					input		logic	[7:0] tilesRGB,   
					input		logic	[7:0] backGroundRGB, 
					input		logic	[10:0]pixelX,
					input		logic	[10:0]pixelY,	
					input    logic [7:0] score_RGB,
					input    logic scoreDrawingRequest,
					input    logic boarderDrawingRequest,
					input    logic livesDrawingRequest,
					input    logic [7:0] livesRGB,
					input    logic resultDrawingRequest,
					input    logic [7:0] resultRGB,
					
				   output	logic	[7:0] RGBOut,
					output	logic	hitBottomBoarder,
					output	logic [10:0] pixelX_col,
					output	logic [10:0] pixelY_col

);


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
	pixelX_col <= pixelX;
	pixelY_col <= pixelY;
	hitBottomBoarder <= 1'b0;
		if(MarioDrawingRequest && boarderDrawingRequest && pixelY==445) begin
		hitBottomBoarder <= 1'b1;
		end
		if(resultDrawingRequest==1'b1) begin
		RGBOut <= resultRGB;
		end
			
		else if (MarioDrawingRequest == 1'b1 && tileDrawingRequest ==1'b1 )   begin
			pixelX_col <= pixelX;
			pixelY_col <= pixelY;
			RGBOut <= marioRGB;  //first priority 
		end

		 else if (MarioDrawingRequest == 1'b1 && tileDrawingRequest ==1'b0 ) begin  
		 RGBOut <= marioRGB;  //first priority 
		 end
		 // add logic for box here 
		 else if (paddleDrawingRequest == 1'b1) begin
					RGBOut<= paddleRGB;
					end
				else if (tileDrawingRequest == 1'b1) begin
						RGBOut <= tilesRGB;
						end 
				else if (scoreDrawingRequest==1'b1) begin
					RGBOut<= score_RGB;
					end
				else if (livesDrawingRequest==1'b1) begin
							RGBOut <= livesRGB;
							end
						else begin
							RGBOut <= backGroundRGB ; // last priority 
							end
		end  
	end

endmodule


