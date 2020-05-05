//-------------------------------------------------------------------------
//      finalproject.sv                                                  --
//      Anthony Nepomuceno																 --
//		  Tyler Mongoven                                                   --
//      Spring 2020                                                      --
//                                                                       --
//      Based of lab8.sv                                                 --
//      Spring 2020                                                      --
//                                                                       --
//      Spring 2020 Distribution                                         --
//                                                                       --
//      For use with ECE 385 Final Project                               --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module finalproject( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
             // VGA Interface
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );

    logic Reset_h, Clk, Play, Level_9;
    logic [7:0] keycode_0;
	  logic [7:0] keycode_1;
    logic [9:0] ShooterX_comb, ShooterY_comb;
    logic [2:0] ShooterMove_comb;
    logic [9:0] BulletX_comb, BulletY_comb;
    logic [1:0] ShooterFace_comb;
    logic [9:0] ZombieX0_comb, ZombieY0_comb, ZombieX1_comb, ZombieY1_comb, ZombieX2_comb, ZombieY2_comb, ZombieX3_comb, ZombieY3_comb, ZombieX4_comb, ZombieY4_comb;
    logic [9:0] ZombieX5_comb, ZombieY5_comb, ZombieX6_comb, ZombieY6_comb, ZombieX7_comb, ZombieY7_comb, ZombieX8_comb, ZombieY8_comb, ZombieX9_comb, ZombieY9_comb;
    logic [1:0] Zombie0Face_comb, Zombie1Face_comb, Zombie2Face_comb, Zombie3Face_comb, Zombie4Face_comb;
    logic [1:0] Zombie5Face_comb, Zombie6Face_comb, Zombie7Face_comb, Zombie8Face_comb, Zombie9Face_comb;
    logic zombie_0_live, zombie_1_live, zombie_2_live, zombie_3_live, zombie_4_live;
    logic zombie_5_live, zombie_6_live, zombie_7_live, zombie_8_live, zombie_9_live;
    logic zombie_dead_0, zombie_dead_1, zombie_dead_2, zombie_dead_3, zombie_dead_4;
    logic zombie_dead_5, zombie_dead_6, zombie_dead_7, zombie_dead_8, zombie_dead_9;
    logic zombie_0_is_killed, zombie_1_is_killed, zombie_2_is_killed, zombie_3_is_killed, zombie_4_is_killed;
    logic zombie_5_is_killed, zombie_6_is_killed, zombie_7_is_killed, zombie_8_is_killed, zombie_9_is_killed;

    logic is_shot_comb;
    logic is_ball_comb;
    logic remove_bullet_comb;
    logic bullet_status;
    logic shooter_take_damage_comb;

    logic [0:14][0:19][0:1] barrier;
    logic [3:0] level;
    logic [1:0] event_screen;
    logic [3:0] player_health;
    logic new_level;
    logic new_game;
    logic [9:0] zombie_0_speed, zombie_1_speed, zombie_2_speed, zombie_3_speed, zombie_4_speed;
    logic [9:0] zombie_5_speed, zombie_6_speed, zombie_7_speed, zombie_8_speed, zombie_9_speed;
    logic [9:0] zombie_0_delay_spawn, zombie_1_delay_spawn, zombie_2_delay_spawn, zombie_3_delay_spawn, zombie_4_delay_spawn;
    logic [9:0] zombie_5_delay_spawn, zombie_6_delay_spawn, zombie_7_delay_spawn, zombie_8_delay_spawn, zombie_9_delay_spawn;

    logic enemies;
    logic [7:0] score;

    assign Clk = CLOCK_50;


    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
        Play <= ~(KEY[1]);
        Level_9 <= ~(KEY[2]);
    end

    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;

	 logic [9:0] DrawX_comb, DrawY_comb;

    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),
                            .OTG_ADDR(OTG_ADDR),
                            .OTG_RD_N(OTG_RD_N),
                            .OTG_WR_N(OTG_WR_N),
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );

     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR),
                             .sdram_wire_ba(DRAM_BA),
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),
                             .sdram_wire_cs_n(DRAM_CS_N),
                             .sdram_wire_dq(DRAM_DQ),
                             .sdram_wire_dqm(DRAM_DQM),
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N),
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_0_export(keycode_0),
									           .keycode_1_export(keycode_1),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );

    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    // VGA controller sends necessary signals to the system.
    VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), .VGA_CLK(VGA_CLK),
                                           .VGA_HS, .VGA_VS,
                                           .VGA_BLANK_N, .VGA_SYNC_N,
                                           .DrawX(DrawX_comb), .DrawY(DrawY_comb));

    // VGA vertical sync is used as frame clk.
    Shooter shooter_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),
                         .ShooterMove(ShooterMove_comb),.barrier,
                         .new_level, .new_game,
                         .shooter_take_damage(shooter_take_damage_comb), .player_health(player_health),
                         .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                         .ShooterFace(ShooterFace_comb));
    // Top-left
    Zombie zombie_0_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                         .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                         .Zombie_Spawn_X(10'd64), .Zombie_Spawn_Y(10'd96),
                         .delay_spawn(zombie_0_delay_spawn), .Zombie_Speed(zombie_0_speed),
                         .new_level,
                         .is_dead(zombie_dead_0), .is_killed(zombie_0_is_killed),
                         .ZombieX(ZombieX0_comb), .ZombieY(ZombieY0_comb),
                         .ZombieFace(Zombie0Face_comb), .is_alive(zombie_0_live));
    // Top-right
    Zombie zombie_1_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd544), .Zombie_Spawn_Y(10'd96),
                        .new_level,
                        .delay_spawn(zombie_1_delay_spawn), .Zombie_Speed(zombie_1_speed),
                        .is_dead(zombie_dead_1), .is_killed(zombie_1_is_killed),
                        .ZombieX(ZombieX1_comb), .ZombieY(ZombieY1_comb),
                        .ZombieFace(Zombie1Face_comb), .is_alive(zombie_1_live));
    // Bottom-left
    Zombie zombie_2_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                         .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                         .Zombie_Spawn_X(10'd64), .Zombie_Spawn_Y(10'd384),
                         .new_level,
                         .delay_spawn(zombie_2_delay_spawn), .Zombie_Speed(zombie_2_speed),
                         .is_dead(zombie_dead_2), .is_killed(zombie_2_is_killed),
                         .ZombieX(ZombieX2_comb), .ZombieY(ZombieY2_comb),
                         .ZombieFace(Zombie2Face_comb), .is_alive(zombie_2_live));
    // Bottom-Right
    Zombie zombie_3_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd544), .Zombie_Spawn_Y(10'd384),
                        .new_level,
                        .delay_spawn(zombie_3_delay_spawn), .Zombie_Speed(zombie_3_speed),
                        .is_dead(zombie_dead_3), .is_killed(zombie_3_is_killed),
                        .ZombieX(ZombieX3_comb), .ZombieY(ZombieY3_comb),
                        .ZombieFace(Zombie3Face_comb), .is_alive(zombie_3_live));
    // Left
    Zombie zombie_4_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd64), .Zombie_Spawn_Y(10'd224),
                        .new_level,
                        .delay_spawn(zombie_4_delay_spawn), .Zombie_Speed(zombie_4_speed),
                        .is_dead(zombie_dead_4), .is_killed(zombie_4_is_killed),
                        .ZombieX(ZombieX4_comb), .ZombieY(ZombieY4_comb),
                        .ZombieFace(Zombie4Face_comb), .is_alive(zombie_4_live));
    // Right
    Zombie zombie_5_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd544), .Zombie_Spawn_Y(10'd224),
                        .new_level,
                        .delay_spawn(zombie_5_delay_spawn), .Zombie_Speed(zombie_5_speed),
                        .is_dead(zombie_dead_5), .is_killed(zombie_5_is_killed),
                        .ZombieX(ZombieX5_comb), .ZombieY(ZombieY5_comb),
                        .ZombieFace(Zombie5Face_comb), .is_alive(zombie_5_live));
    // Middle-Top-Left
    Zombie zombie_6_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd192), .Zombie_Spawn_Y(10'd96),
                        .new_level,
                        .delay_spawn(zombie_6_delay_spawn), .Zombie_Speed(zombie_6_speed),
                        .is_dead(zombie_dead_6), .is_killed(zombie_6_is_killed),
                        .ZombieX(ZombieX6_comb), .ZombieY(ZombieY6_comb),
                        .ZombieFace(Zombie6Face_comb), .is_alive(zombie_6_live));
    // Middle-Top-Right
    Zombie zombie_7_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd416), .Zombie_Spawn_Y(10'd96),
                        .new_level,
                        .delay_spawn(zombie_7_delay_spawn), .Zombie_Speed(zombie_7_speed),
                        .is_dead(zombie_dead_7), .is_killed(zombie_7_is_killed),
                        .ZombieX(ZombieX7_comb), .ZombieY(ZombieY7_comb),
                        .ZombieFace(Zombie7Face_comb), .is_alive(zombie_7_live));
    // Middle-Bottom-Left
    Zombie zombie_8_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd192), .Zombie_Spawn_Y(10'd384),
                        .new_level,
                        .delay_spawn(zombie_8_delay_spawn), .Zombie_Speed(zombie_8_speed),
                        .is_dead(zombie_dead_8), .is_killed(zombie_8_is_killed),
                        .ZombieX(ZombieX8_comb), .ZombieY(ZombieY8_comb),
                        .ZombieFace(Zombie8Face_comb), .is_alive(zombie_8_live));
    // Middle-Bottom-Right
    Zombie zombie_9_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd416), .Zombie_Spawn_Y(10'd384),
                        .new_level,
                        .delay_spawn(zombie_9_delay_spawn), .Zombie_Speed(zombie_9_speed),
                        .is_dead(zombie_dead_9), .is_killed(zombie_9_is_killed),
                        .ZombieX(ZombieX9_comb), .ZombieY(ZombieY9_comb),
                        .ZombieFace(Zombie9Face_comb), .is_alive(zombie_9_live));


    ball ball_inst (.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),
                    .DrawX(DrawX_comb), .DrawY(DrawY_comb),
                    .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                    .ShooterFace(ShooterFace_comb),
                    .barrier(barrier),  .is_shot(is_shot_comb),
                    .remove_bullet(remove_bullet_comb),

                    // Outputs
                    .BallX(BulletX_comb), .BallY(BulletY_comb),
                    .is_ball(is_ball_comb), .bullet_status
                    );

    collisions collisions_handler(.ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                                  .ZombieX_0(ZombieX0_comb), .ZombieY_0(ZombieY0_comb),.ZombieX_1(ZombieX1_comb), .ZombieY_1(ZombieY1_comb),
                                  .ZombieX_2(ZombieX2_comb), .ZombieY_2(ZombieY2_comb),.ZombieX_3(ZombieX3_comb), .ZombieY_3(ZombieY3_comb),
                                  .ZombieX_4(ZombieX4_comb), .ZombieY_4(ZombieY4_comb),.ZombieX_5(ZombieX5_comb), .ZombieY_5(ZombieY5_comb),
                                  .ZombieX_6(ZombieX6_comb), .ZombieY_6(ZombieY6_comb),.ZombieX_7(ZombieX7_comb), .ZombieY_7(ZombieY7_comb),
                                  .ZombieX_8(ZombieX8_comb), .ZombieY_8(ZombieY8_comb),.ZombieX_9(ZombieX9_comb), .ZombieY_9(ZombieY9_comb),

                                  .BulletX(BulletX_comb), .BulletY(BulletY_comb),

                                  .barrier(barrier), .is_shot(is_shot_comb), .bullet_status,

                                  // Outputs
                                   .remove_bullet(remove_bullet_comb),
                                  .zombie_dead_0(zombie_dead_0), .zombie_dead_1(zombie_dead_1),.zombie_dead_2(zombie_dead_2),
                                  .zombie_dead_3(zombie_dead_3),.zombie_dead_4(zombie_dead_4),.zombie_dead_5(zombie_dead_5),
                                  .zombie_dead_6(zombie_dead_6),.zombie_dead_7(zombie_dead_7),.zombie_dead_8(zombie_dead_8),.zombie_dead_9(zombie_dead_9),

                                  .shooter_take_damage(shooter_take_damage_comb));

    KeycodeHandler keycodehandler_inst(.keycode0(keycode_0), .keycode1(keycode_1),
                                        .ShooterMove(ShooterMove_comb), .is_shot(is_shot_comb));

    color_mapper color_instance(.Clk(Clk), .ShooterX(ShooterX_comb),.ShooterY(ShooterY_comb),
                                .ShooterFace(ShooterFace_comb),
                                .Zombie0X(ZombieX0_comb),.Zombie0Y(ZombieY0_comb), .Zombie1X(ZombieX1_comb),.Zombie1Y(ZombieY1_comb),
                                .Zombie2X(ZombieX2_comb),.Zombie2Y(ZombieY2_comb), .Zombie3X(ZombieX3_comb),.Zombie3Y(ZombieY3_comb),
                                .Zombie4X(ZombieX4_comb),.Zombie4Y(ZombieY4_comb), .Zombie5X(ZombieX5_comb),.Zombie5Y(ZombieY5_comb),
                                .Zombie6X(ZombieX6_comb),.Zombie6Y(ZombieY6_comb), .Zombie7X(ZombieX7_comb),.Zombie7Y(ZombieY7_comb),
                                .Zombie8X(ZombieX8_comb),.Zombie8Y(ZombieY8_comb), .Zombie9X(ZombieX9_comb),.Zombie9Y(ZombieY9_comb),
                                .Zombie0Face(Zombie0Face_comb), .Zombie1Face(Zombie1Face_comb),
                                .Zombie2Face(Zombie2Face_comb), .Zombie3Face(Zombie3Face_comb),
                                .Zombie4Face(Zombie4Face_comb), .Zombie5Face(Zombie5Face_comb),
                                .Zombie6Face(Zombie6Face_comb), .Zombie7Face(Zombie7Face_comb),
                                .Zombie8Face(Zombie8Face_comb), .Zombie9Face(Zombie9Face_comb),
                                .zombie_0_live, .zombie_1_live, .zombie_2_live, .zombie_3_live, .zombie_4_live,
                                .zombie_5_live, .zombie_6_live, .zombie_7_live, .zombie_8_live, .zombie_9_live,
                                .is_ball(is_ball_comb),
                                .barrier(barrier),
                                .event_screen(event_screen),
                                .level(level),
                                .player_health(player_health),
                                .DrawX(DrawX_comb), .DrawY(DrawY_comb),

                                .VGA_R, .VGA_G, .VGA_B);
    Barrier barriers (.level_sel(level), .barrier(barrier));

    // Enemies enemies_inst (.zombie_killed_0(zombie_0_is_killed), .zombie_killed_1(zombie_1_is_killed), .zombie_killed_2(zombie_2_is_killed),
    //                       .enemies, .score);

    assign enemies = ~(zombie_0_is_killed & zombie_1_is_killed & zombie_2_is_killed & zombie_3_is_killed & zombie_4_is_killed & zombie_5_is_killed & zombie_6_is_killed & zombie_7_is_killed & zombie_8_is_killed & zombie_9_is_killed);

    // assign player_health = {3'b0, ~shooter_take_damage_comb};

    Game_state states(
                      .Clk, .Reset_h, .Play, .Level_9_B(Level_9),
                      .enemies, .player_health(player_health),
                      .level,
                      .event_screen,
                      .new_level, .new_game,
                      .zombie_0_speed, .zombie_1_speed, .zombie_2_speed, .zombie_3_speed, .zombie_4_speed,
                      .zombie_5_speed, .zombie_6_speed, .zombie_7_speed, .zombie_8_speed, .zombie_9_speed,
                      .zombie_0_delay_spawn, .zombie_1_delay_spawn, .zombie_2_delay_spawn, .zombie_3_delay_spawn, .zombie_4_delay_spawn,
                      .zombie_5_delay_spawn, .zombie_6_delay_spawn, .zombie_7_delay_spawn, .zombie_8_delay_spawn, .zombie_9_delay_spawn);

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode_0[3:0], HEX0);
    HexDriver hex_inst_1 (keycode_0[7:4], HEX1);
    HexDriver hex_inst_2 (keycode_1[3:0], HEX2);
    HexDriver hex_inst_3 (keycode_1[7:4], HEX3);
    HexDriver enemies_test (player_health, HEX4);
    HexDriver is_killed_test (level, HEX5);

endmodule
