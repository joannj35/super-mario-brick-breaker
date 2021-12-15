
module	Mario_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	Y_direction,  //change the direction in Y to up  
					input	logic	toggleX, 	//toggle the X direction 
					input logic collision,  //collision if smiley hits an object
					input	logic	[3:0] HitEdgeCode, //one bit per edge 
					input logic win,
					input logic Turbo,
					output logic [3:0] lives,
					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 317;
parameter int INITIAL_Y = 411;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int MAX_Y_SPEED = 350;
const int  Y_ACCEL = 0;
const int	FIXED_POINT_MULTIPLIER	=	64;
const int   Y_RANDOM = 320;

// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
logic [3:0] COUNTER=3;
int X_RANDOM=40;
int RANDOM_X_SPEED=1;
int LIVES_IN=3;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation Y Axis speed using gravity or  colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end 
	
	else begin
	// colision Calcultaion 
			
		//hit bit map has  one bit per edge:  Left-Top-Right-Bottom	 
		
	
		if ((collision && HitEdgeCode [2] == 1 ))  // hit top border of brick  
				if (Yspeed < 0) // while moving up
						Yspeed <= -Yspeed ; 
			
			if ((collision && HitEdgeCode [0] == 1 ))// || (collision && HitEdgeCode [1] == 1 ))   hit bottom border of brick  
				if (Yspeed > 0 )//  while moving down
						Yspeed <= -Yspeed ; 

		// perform  position and speed integral only 30 times per second 
		
		if (startOfFrame == 1'b1) begin 
		
				topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed; // position interpolation 
				
				if (Yspeed < MAX_Y_SPEED )//  limit the spped while going down 
						Yspeed <= Yspeed  - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 
		
								
				if (Y_direction) begin 
						if (Yspeed == 0 ) 
								Yspeed <= (Yspeed+150)  ;  // chjange spped to go up 
				end 
				
		end
			if(toggleX) begin
		Yspeed	<= -150;
		topLeftY_FixedPoint	<= Y_RANDOM * FIXED_POINT_MULTIPLIER;
	end
	if(LIVES_IN==0)
		Yspeed <=0;
		if(win==1'b1)
		Yspeed <=0;
	if(Turbo && (Yspeed==150 || Yspeed==-150))
		Yspeed<=2*Yspeed;
	if(!Turbo && (Yspeed==300 || Yspeed ==-300))
		Yspeed<=Yspeed/2;
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
	
				if(X_RANDOM > 580) //Reviving Mario in a random position
				X_RANDOM = 40;
			X_RANDOM = X_RANDOM + 1;
			
	if(RANDOM_X_SPEED==1)
		RANDOM_X_SPEED=-1;
	else if(RANDOM_X_SPEED==-1)
		RANDOM_X_SPEED=1;
		//  an edge input is tested here as it a very short instance   
	if (Y_direction) begin // button was pushed to go upwards 
				if (Xspeed == 0 ) //  while moving right
					Xspeed <= (Xspeed+150)  ;  // chjange spped to go up 
				end ;  
				
	// collisions with the sides 			
					if (collision && HitEdgeCode [3] == 1) begin  
						if (Xspeed < 0 ) // while moving left
							Xspeed <= -Xspeed ; // positive move right 
				end
			
				if (collision && HitEdgeCode [1] == 1 ) begin  // hit right border of brick  
					if (Xspeed > 0 ) //  while moving right
							Xspeed <= -Xspeed  ;  // negative move left    
				end	
		   
			
		if (startOfFrame == 1'b1 )//&& Yspeed != 0) 
	
				        topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		if(toggleX) begin
	
	COUNTER=COUNTER-1'b1;
	Xspeed	<= 150*RANDOM_X_SPEED;
	topLeftX_FixedPoint	<= X_RANDOM * FIXED_POINT_MULTIPLIER;
	if(COUNTER==0) begin
		LIVES_IN--;
		COUNTER=4;
		end
	
	end 
		if(LIVES_IN==0)
			Xspeed <=0;
		if(win==1'b1)
			Xspeed <=0;
		if(Turbo && (Xspeed==150 || Xspeed==-150))
			Xspeed<=2*Xspeed;
		if(!Turbo && (Xspeed==300 || Xspeed ==-300))
			Xspeed<=Xspeed/2;
	lives<=LIVES_IN;				
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
