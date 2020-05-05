// This file handles the following:
// 1. All the collisions of the ball with zombies, barriers,
//    and walls.
// 2. Zombies taking damage (is_dead conditions).
// 3. Shooter taking damage.
module collisions (
                    input logic [9:0]   ShooterX, ShooterY,

                    input logic [9:0]   ZombieX_0, ZombieY_0,
                    input logic [9:0]   ZombieX_1, ZombieY_1,
                    input logic [9:0]   ZombieX_2, ZombieY_2,
                    input logic [9:0]   ZombieX_3, ZombieY_3,
                    input logic [9:0]   ZombieX_4, ZombieY_4,
                    input logic [9:0]   ZombieX_5, ZombieY_5,
                    input logic [9:0]   ZombieX_6, ZombieY_6,
                    input logic [9:0]   ZombieX_7, ZombieY_7,
                    input logic [9:0]   ZombieX_8, ZombieY_8,
                    input logic [9:0]   ZombieX_9, ZombieY_9,

                    input logic [9:0]   BulletX, BulletY,

                    input logic [0:14][0:19][0:1] barrier,

                    input logic is_shot, bullet_status,

                    output logic remove_bullet,

                    output logic zombie_dead_0,zombie_dead_1,zombie_dead_2,
                    output logic zombie_dead_3,zombie_dead_4,zombie_dead_5,
                    output logic zombie_dead_6,zombie_dead_7,zombie_dead_8,
                    output logic zombie_dead_9,

                    output logic shooter_take_damage
  );

  parameter [9:0] Half = 10'd15;
  parameter [9:0] Full = 10'd31;
  parameter [9:0] Bullet_Size = 10'd4;
  parameter [9:0] BulletX_Min = 10'd32;       // Leftmost point on the X axis
  parameter [9:0] BulletX_Max = 10'd607;     // Rightmost point on the X axis
  parameter [9:0] BulletY_Min = 10'd64;       // Topmost point on the Y axis
  parameter [9:0] BulletY_Max = 10'd447;     // Bottommost point on the Y axis

  logic [9:0] Zombie_X_Max_0;
  logic [9:0] Zombie_Y_Max_0;
  logic [9:0] Zombie_X_Max_1;
  logic [9:0] Zombie_Y_Max_1;
  logic [9:0] Zombie_X_Max_2;
  logic [9:0] Zombie_Y_Max_2;
  logic [9:0] Zombie_X_Max_3;
  logic [9:0] Zombie_Y_Max_3;
  logic [9:0] Zombie_X_Max_4;
  logic [9:0] Zombie_Y_Max_4;

  logic [9:0] Zombie_X_Max_5;
  logic [9:0] Zombie_Y_Max_5;
  logic [9:0] Zombie_X_Max_6;
  logic [9:0] Zombie_Y_Max_6;
  logic [9:0] Zombie_X_Max_7;
  logic [9:0] Zombie_Y_Max_7;
  logic [9:0] Zombie_X_Max_8;
  logic [9:0] Zombie_Y_Max_8;
  logic [9:0] Zombie_X_Max_9;
  logic [9:0] Zombie_Y_Max_9;

  logic shooter_damage0;
  logic shooter_damage1;
  logic shooter_damage2;
  logic shooter_damage3;
  logic shooter_damage4;
  logic shooter_damage5;
  logic shooter_damage6;
  logic shooter_damage7;
  logic shooter_damage8;
  logic shooter_damage9;

  always_comb begin

    Zombie_X_Max_0 = ZombieX_0 + Full;
    Zombie_Y_Max_0 = ZombieY_0 + Full;
    Zombie_X_Max_1 = ZombieX_1 + Full;
    Zombie_Y_Max_1 = ZombieY_1 + Full;
    Zombie_X_Max_2 = ZombieX_2 + Full;
    Zombie_Y_Max_2 = ZombieY_2 + Full;
    Zombie_X_Max_3 = ZombieX_3 + Full;
    Zombie_Y_Max_3 = ZombieY_3 + Full;
    Zombie_X_Max_4 = ZombieX_4 + Full;
    Zombie_Y_Max_4 = ZombieY_4 + Full;

    Zombie_X_Max_5 = ZombieX_5 + Full;
    Zombie_Y_Max_5 = ZombieY_5 + Full;
    Zombie_X_Max_6 = ZombieX_6 + Full;
    Zombie_Y_Max_6 = ZombieY_6 + Full;
    Zombie_X_Max_7 = ZombieX_7 + Full;
    Zombie_Y_Max_7 = ZombieY_7 + Full;
    Zombie_X_Max_8 = ZombieX_8 + Full;
    Zombie_Y_Max_8 = ZombieY_8 + Full;
    Zombie_X_Max_9 = ZombieX_9 + Full;
    Zombie_Y_Max_9 = ZombieY_9 + Full;

    shooter_take_damage = 1'b0;

    remove_bullet = 1'b0;
    zombie_dead_0 = 1'b0;
    zombie_dead_1 = 1'b0;
    zombie_dead_2 = 1'b0;
    zombie_dead_3 = 1'b0;
    zombie_dead_4 = 1'b0;
    zombie_dead_5 = 1'b0;
    zombie_dead_6 = 1'b0;
    zombie_dead_7 = 1'b0;
    zombie_dead_8 = 1'b0;
    zombie_dead_9 = 1'b0;

    shooter_take_damage = shooter_damage0 | shooter_damage1 | shooter_damage2 |
                        shooter_damage3 | shooter_damage4 | shooter_damage5 |
                        shooter_damage6 | shooter_damage7 | shooter_damage8 |
                        shooter_damage9;
    if(is_shot || bullet_status)
    begin
        // If Bullet is hitting zombie_0
        if((BulletX >= ZombieX_0) && (BulletX <= Zombie_X_Max_0)
           && (BulletY >= ZombieY_0) && (BulletY <= Zombie_Y_Max_0))
           begin
             remove_bullet = 1'b1;
             zombie_dead_0 = 1'b1;
           end
       // If Bullet is hitting zombie_1
       if((BulletX >= ZombieX_1) && (BulletX <= Zombie_X_Max_1)
          && (BulletY >= ZombieY_1) && (BulletY <= Zombie_Y_Max_1))
          begin
            remove_bullet = 1'b1;
            zombie_dead_1 = 1'b1;
          end
      // If Bullet is hitting zombie_2
      if((BulletX >= ZombieX_2) && (BulletX <= Zombie_X_Max_2)
         && (BulletY >= ZombieY_2) && (BulletY <= Zombie_Y_Max_2))
         begin
           remove_bullet = 1'b1;
           zombie_dead_2 = 1'b1;
         end
      // If Bullet is hitting zombie_3
      if((BulletX >= ZombieX_3) && (BulletX <= Zombie_X_Max_3)
        && (BulletY >= ZombieY_3) && (BulletY <= Zombie_Y_Max_3))
        begin
          remove_bullet = 1'b1;
          zombie_dead_3 = 1'b1;
        end
      // If Bullet is hitting zombie_4
      if((BulletX >= ZombieX_4) && (BulletX <= Zombie_X_Max_4)
        && (BulletY >= ZombieY_4) && (BulletY <= Zombie_Y_Max_4))
        begin
           remove_bullet = 1'b1;
           zombie_dead_4 = 1'b1;
         end
       // If Bullet is hitting zombie_5
       if((BulletX >= ZombieX_5) && (BulletX <= Zombie_X_Max_5)
          && (BulletY >= ZombieY_5) && (BulletY <= Zombie_Y_Max_5))
          begin
            remove_bullet = 1'b1;
            zombie_dead_5 = 1'b1;
          end
      // If Bullet is hitting zombie_6
      if((BulletX >= ZombieX_6) && (BulletX <= Zombie_X_Max_6)
         && (BulletY >= ZombieY_6) && (BulletY <= Zombie_Y_Max_6))
         begin
           remove_bullet = 1'b1;
           zombie_dead_6 = 1'b1;
         end
       // If Bullet is hitting zombie_7
       if((BulletX >= ZombieX_7) && (BulletX <= Zombie_X_Max_7)
          && (BulletY >= ZombieY_7) && (BulletY <= Zombie_Y_Max_7))
          begin
            remove_bullet = 1'b1;
            zombie_dead_7 = 1'b1;
          end
      // If Bullet is hitting zombie_8
      if((BulletX >= ZombieX_8) && (BulletX <= Zombie_X_Max_8)
         && (BulletY >= ZombieY_8) && (BulletY <= Zombie_Y_Max_8))
         begin
           remove_bullet = 1'b1;
           zombie_dead_8 = 1'b1;
         end
       // If Bullet is hitting zombie_9
       if((BulletX >= ZombieX_9) && (BulletX <= Zombie_X_Max_9)
          && (BulletY >= ZombieY_9) && (BulletY <= Zombie_Y_Max_9))
          begin
            remove_bullet = 1'b1;
            zombie_dead_9= 1'b1;
          end
    end
    // If bullet is hitting barriers
    if(barrier[BulletY>>5][BulletX>>5])
       begin
         remove_bullet = 1'b1;
       end

    // If bullet is hitting wall
    if( BulletY + Bullet_Size >= BulletY_Max )  // Ball is at the bottom edge, BOUNCE!
        remove_bullet = 1'b1;  // 2's complement.
    else if ( BulletY <= BulletY_Min + Bullet_Size )  // Ball is at the top edge, BOUNCE!
        remove_bullet = 1'b1;
    if( BulletX + Bullet_Size >= BulletX_Max )  // Ball is at the right edge, BOUNCE!
        remove_bullet = 1'b1;  // 2's complement.
    else if ( BulletX <= BulletX_Min + Bullet_Size )  // Ball is at the left edge, BOUNCE!
        remove_bullet = 1'b1;

  end

  // If Zombie is hitting shooter, then the shooter will take damage.
  // These instantiations are checking overlap for all the zombies.
  zombie_shooter zombie_0  (.ShooterX, .ShooterY,.ZombieX(ZombieX_0), .ZombieY(ZombieY_0), .shooter_take_damage(shooter_damage0));
  zombie_shooter zombie_1  (.ShooterX, .ShooterY,.ZombieX(ZombieX_1), .ZombieY(ZombieY_1), .shooter_take_damage(shooter_damage1));
  zombie_shooter zombie_2  (.ShooterX, .ShooterY,.ZombieX(ZombieX_2), .ZombieY(ZombieY_2), .shooter_take_damage(shooter_damage2));
  zombie_shooter zombie_3  (.ShooterX, .ShooterY,.ZombieX(ZombieX_3), .ZombieY(ZombieY_3), .shooter_take_damage(shooter_damage3));
  zombie_shooter zombie_4  (.ShooterX, .ShooterY,.ZombieX(ZombieX_4), .ZombieY(ZombieY_4), .shooter_take_damage(shooter_damage4));
  zombie_shooter zombie_5  (.ShooterX, .ShooterY,.ZombieX(ZombieX_5), .ZombieY(ZombieY_5), .shooter_take_damage(shooter_damage5));
  zombie_shooter zombie_6  (.ShooterX, .ShooterY,.ZombieX(ZombieX_6), .ZombieY(ZombieY_6), .shooter_take_damage(shooter_damage6));
  zombie_shooter zombie_7  (.ShooterX, .ShooterY,.ZombieX(ZombieX_7), .ZombieY(ZombieY_7), .shooter_take_damage(shooter_damage7));
  zombie_shooter zombie_8  (.ShooterX, .ShooterY,.ZombieX(ZombieX_8), .ZombieY(ZombieY_8), .shooter_take_damage(shooter_damage8));
  zombie_shooter zombie_9  (.ShooterX, .ShooterY,.ZombieX(ZombieX_9), .ZombieY(ZombieY_9), .shooter_take_damage(shooter_damage9));
endmodule // collisions

// This module checks to see if the shooter is overlapping with a zombie.
module zombie_shooter (input logic [9:0]   ShooterX, ShooterY,
                       input logic [9:0]   ZombieX, ZombieY,
                       output logic shooter_take_damage);
  parameter [9:0] Half = 10'd15;
  parameter [9:0] Full = 10'd31;
  parameter [9:0] Quarter = 10'd7;


  logic [9:0] Zombie_BR_X;
  logic [9:0] Zombie_BR_Y;

  logic [9:0] Zombie_TR_X;
  logic [9:0] Zombie_TR_Y;

  logic [9:0] Zombie_BL_X;
  logic [9:0] Zombie_BL_Y;

  logic [9:0] Zombie_TL_X;
  logic [9:0] Zombie_TL_Y;

  logic [9:0] Inner_0_X;
  logic [9:0] Inner_0_Y;
  logic [9:0] Inner_1_X;
  logic [9:0] Inner_1_Y;
  logic [9:0] Inner_2_X;
  logic [9:0] Inner_2_Y;
  logic [9:0] Inner_3_X;
  logic [9:0] Inner_3_Y;

  logic shooter_take_damage_comb;

  assign shooter_take_damage = shooter_take_damage_comb;

  always_comb begin

    Zombie_BR_X = ZombieX + Full;
    Zombie_BR_Y = ZombieY + Full;

    Zombie_TR_X = ZombieX + Full;
    Zombie_TR_Y = ZombieY;

    Zombie_BL_X = ZombieX;
    Zombie_BL_Y = ZombieY + Full;

    Zombie_TL_X = ZombieX;
    Zombie_TL_Y = ZombieY;

    Inner_0_X = ShooterX + Half;
    Inner_0_Y = ShooterY + Half;
    Inner_1_X = ShooterX + Half + 10'd1;
    Inner_1_Y = ShooterY + Half;
    Inner_2_X = ShooterX + Half;
    Inner_2_Y = ShooterY + Half + 10'd1;
    Inner_3_X = ShooterX + Half + 10'd1;
    Inner_3_Y = ShooterY + Half + 10'd1;


    /*
    **** **** **** **** **** **** **** ****
    **** **** **** **** **** **** **** ****
    **** **** **** **** **** **** **** ****
    **** **** **** **** **** **** **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** 0000 0000 0000 0000 **** ****
    **** **** **** **** **** **** **** ****
    **** **** **** **** **** **** **** ****
    **** **** **** **** **** **** **** ****
    **** **** **** **** **** **** **** ****
    */
    shooter_take_damage_comb = 1'b0;
    if((Zombie_TL_X >= ShooterX - Half) && (Zombie_TL_X <= ShooterX + Half) && (Zombie_TL_Y >= ShooterY - Half) && (Zombie_TL_Y <= ShooterY + Half))
    begin
      shooter_take_damage_comb = 1'b1;
    end

    // if((Zombie_BR_X == Inner_0_X) && (Zombie_BR_Y == Inner_0_Y))
    // begin
    //   shooter_take_damage_comb = 1'b1;
    // end
    // if((Zombie_TR_X == Inner_2_X) && (Zombie_TR_Y == Inner_2_Y))
    // begin
    //   shooter_take_damage_comb = 1'b1;
    // end
    // if((Zombie_BL_X == Inner_1_X) && (Zombie_BL_Y == Inner_1_Y))
    // begin
    //   shooter_take_damage_comb = 1'b1;
    // end
    // if((Zombie_TL_X == Inner_3_X) && (Zombie_TL_Y == Inner_3_Y))
    // begin
    //   shooter_take_damage_comb = 1'b1;
    // end
  end
endmodule // zombie_shooter
