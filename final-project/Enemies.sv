module Enemies (input Clk, Reset,
                input logic zombie_killed_0, zombie_killed_1, zombie_killed_2,
                output logic enemies,
                output logic [7:0] score
  );

  logic zombie_killed_0_hold, zombie_killed_1_hold, zombie_killed_2_hold;
  logic zombie_killed_0_re, zombie_killed_1_re, zombie_killed_2_re;
  logic enemies_comb;
  logic [7:0] score_comb;

  always_ff @ (posedge Clk)
  begin
      if (Reset)
      begin
          enemies <= 1'b1;
          score <= 8'd0;
          zombie_killed_0_hold <= 0;
          zombie_killed_1_hold <= 0;
          zombie_killed_2_hold <= 0;
      end
      else
      begin
        zombie_killed_0_hold <= zombie_killed_0;
        zombie_killed_1_hold <= zombie_killed_1;
        zombie_killed_2_hold <= zombie_killed_2;
        zombie_killed_0_re <= (zombie_killed_0 == 1'b1) && (zombie_killed_0_hold == 1'b0);
        zombie_killed_1_re <= (zombie_killed_1 == 1'b1) && (zombie_killed_1_hold == 1'b0);
        zombie_killed_2_re <= (zombie_killed_2 == 1'b1) && (zombie_killed_2_hold == 1'b0);
        enemies <= enemies_comb;
        score <= score_comb;
      end
  end

  always_comb begin
    enemies_comb = enemies;
    score_comb = score;

    if((zombie_killed_0 == 1) && (zombie_killed_1 == 1) && (zombie_killed_2 == 1)) //set enemies to 0 if all zombies are killed
      enemies_comb = 1'b0;

    // increment score by 1 for each zombie that is killed <-- change to (score_comb = score + level) instead?
    if(zombie_killed_0_re) begin score_comb = score + 1; end
    if(zombie_killed_1_re) begin score_comb = score + 1; end
    if(zombie_killed_2_re) begin score_comb = score + 1; end

  end



endmodule // Enemies
