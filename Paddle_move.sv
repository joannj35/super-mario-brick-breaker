
module	Paddle_move	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  
					input	logic	Left,  
					input	logic	Right,  
					input logic Turbo,
					 

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 0;
parameter int LEFT_SPEED = -150;
parameter int RIGHT_SPEED = 150;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int topLeftY_FixedPoint;



//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity or  colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
end
	
//////////--------------------------------------------------------------------------------------------------------------=
//  calculation X Axis speed using and position calculate regarding X_direction key or  colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	else begin
	
		if(Right==1'b1) begin
			Xspeed <= RIGHT_SPEED;
			end
		else if(Left==1'b1) begin
			Xspeed <= LEFT_SPEED;
			end
		else if (Right==1'b0 & Left==1'b0) begin 
		Xspeed<= 0;
		 end
		if(Right==1'b1 && Turbo)
			Xspeed<=RIGHT_SPEED*2;
		else if(Left==1'b1 && Turbo)
			Xspeed <= LEFT_SPEED*2;

			
		if (startOfFrame == 1'b1 )//&& Yspeed != 0) 
	
				        topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
			
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
