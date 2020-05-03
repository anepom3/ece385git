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

    logic Reset_h, Clk, Play;
    logic [7:0] keycode_0;
	  logic [7:0] keycode_1;
    logic [9:0] ShooterX_comb, ShooterY_comb;
    logic [2:0] ShooterMove_comb;
    logic [9:0] BulletX_comb, BulletY_comb;
    logic [1:0] ShooterFace_comb;
    logic [9:0] ZombieX0_comb, ZombieY0_comb, ZombieX1_comb, ZombieY1_comb, ZombieX2_comb, ZombieY2_comb;
    logic [1:0] Zombie0Face_comb, Zombie1Face_comb, Zombie2Face_comb;
    logic zombie_0_live, zombie_1_live, zombie_2_live;
    logic zombie_dead_0, zombie_dead_1, zombie_dead_2;
    logic zombie_0_is_killed, zombie_1_is_killed, zombie_2_is_killed;

    logic is_shot_comb;
    logic is_ball_comb;
    logic remove_bullet_comb;
    logic bullet_status;

    logic [0:14][0:19][0:1] barrier;
    logic [3:0] level;
    logic [1:0] event_screen;
    logic [3:0] player_health;
    logic new_level;
    logic [9:0] zombie_0_speed, zombie_1_speed, zombie_2_speed;
    logic [9:0] zombie_0_delay_spawn, zombie_1_delay_spawn, zombie_2_delay_spawn;

    logic enemies;
    logic [7:0] score;

    assign Clk = CLOCK_50;

    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
        Play <= ~(KEY[1]);
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

                         .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                         .ShooterFace(ShooterFace_comb));
    // Top-left 1.66s
    Zombie zombie_0_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                         .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                         .Zombie_Spawn_X(10'd64), .Zombie_Spawn_Y(10'd96),
                         .delay_spawn(10'd100), .Zombie_Speed(10'd1),
                         .new_level,
                         .is_dead(zombie_dead_0), .is_killed(zombie_0_is_killed),
                         .ZombieX(ZombieX0_comb), .ZombieY(ZombieY0_comb),
                         .ZombieFace(Zombie0Face_comb), .is_alive(zombie_0_live));

    // Top-right 4.1s
    Zombie zombie_1_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                        .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                        .Zombie_Spawn_X(10'd544), .Zombie_Spawn_Y(10'd96),
                        .new_level,
                        .delay_spawn(zombie_1_delay_spawn), .Zombie_Speed(10'd2),
                        .is_dead(zombie_dead_1), .is_killed(zombie_1_is_killed),
                        .ZombieX(ZombieX1_comb), .ZombieY(ZombieY1_comb),
                        .ZombieFace(Zombie1Face_comb), .is_alive(zombie_1_live));
    // Bottom-left 5s
    Zombie zombie_2_inst(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS),.barrier,
                         .ShooterX(ShooterX_comb), .ShooterY(ShooterY_comb),
                         .Zombie_Spawn_X(10'd64), .Zombie_Spawn_Y(10'd384),
                         .new_level,
                         .delay_spawn(zombie_2_delay_spawn), .Zombie_Speed(zombie_2_speed),
                         .is_dead(zombie_dead_2), .is_killed(zombie_2_is_killed),
                         .ZombieX(ZombieX2_comb), .ZombieY(ZombieY2_comb),
                         .ZombieFace(Zombie2Face_comb), .is_alive(zombie_2_live));

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
                                  .ZombieX_0(ZombieX0_comb), .ZombieY_0(ZombieY0_comb),
                                  .ZombieX_1(ZombieX1_comb), .ZombieY_1(ZombieY1_comb),
                                  .ZombieX_2(ZombieX2_comb), .ZombieY_2(ZombieY2_comb),

                                  .BulletX(BulletX_comb), .BulletY(BulletY_comb),

                                  .barrier(barrier), .is_shot(is_shot_comb), .bullet_status,

                                  // Outputs
                                   .remove_bullet(remove_bullet_comb),
                                  .zombie_dead_0(zombie_dead_0), .zombie_dead_1(zombie_dead_1),.zombie_dead_2(zombie_dead_2),
                                  .zombie_dead_3(),.zombie_dead_4(),.zombie_dead_5(),
                                  .zombie_dead_6(),.zombie_dead_7(),.zombie_dead_8(),
                                  .zombie_dead_9(),

                                  .shooter_take_damage());

    KeycodeHandler keycodehandler_inst(.keycode0(keycode_0), .keycode1(keycode_1),
                                        .ShooterMove(ShooterMove_comb), .is_shot(is_shot_comb));

    color_mapper color_instance(.Clk(Clk), .ShooterX(ShooterX_comb),.ShooterY(ShooterY_comb),
                                .ShooterFace(ShooterFace_comb),
                                .Zombie0X(ZombieX0_comb),.Zombie0Y(ZombieY0_comb),
                                .Zombie1X(ZombieX1_comb),.Zombie1Y(ZombieY1_comb),
                                .Zombie2X(ZombieX2_comb),.Zombie2Y(ZombieY2_comb),
                                .Zombie0Face(Zombie0Face_comb),
                                .Zombie1Face(Zombie1Face_comb),
                                .Zombie2Face(Zombie2Face_comb),
                                .zombie_0_live,
                                .zombie_1_live,
                                .zombie_2_live,
                                .is_ball(is_ball_comb),
                                .barrier(barrier),
                                .event_screen(event_screen),
                                .level(level),
                                .DrawX(DrawX_comb), .DrawY(DrawY_comb),

                                .VGA_R, .VGA_G, .VGA_B);
    Barrier barriers (.level_sel(level), .barrier(barrier));

    // Enemies enemies_inst (.zombie_killed_0(zombie_0_is_killed), .zombie_killed_1(zombie_1_is_killed), .zombie_killed_2(zombie_2_is_killed),
    //                       .enemies, .score);

    assign enemies = ~(zombie_0_is_killed & zombie_1_is_killed & zombie_2_is_killed);

    Game_state states(
                      .Clk, .Reset_h, .Play,
                      .enemies, .player_health(4'd1),
                      .level,
                      .event_screen,
                      .new_level,
                      .zombie_0_speed, .zombie_1_speed, .zombie_2_speed,
                      .zombie_0_delay_spawn, .zombie_1_delay_spawn, .zombie_2_delay_spawn);

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode_0[3:0], HEX0);
    HexDriver hex_inst_1 (keycode_0[7:4], HEX1);
    HexDriver hex_inst_2 (keycode_1[3:0], HEX2);
    HexDriver hex_inst_3 (keycode_1[7:4], HEX3);
    HexDriver enemies_test ({3'b0,enemies}, HEX4);
    HexDriver is_killed_test ({3'b0,1'b1}, HEX5);

endmodule
