module Barrier ( input [3:0] level_sel,
                 output logic [0:14][0:19][0:1] barrier // include [0:1] --> ...[0:19][0:1] barrier
  );

  always_comb begin

    // THIS IS A TEMPLATE FOR THE BARRIER SO THAT NONE OF THE SPRITES CAN SPAWN ON A BARRIER
    // FILL IN 0's and 1's  for all of the X's on the template
    // barrier <=
    //   '{
    //   '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //   '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
    //   '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,0,0,X,X,X,X,X,X,X,X,X,X,X,X,0,0,X,0},
    //   '{0,X,0,0,X,X,X,X,X,0,0,X,X,X,X,X,0,0,X,0},
    //   '{0,X,0,0,X,X,X,X,X,X,X,X,X,X,X,X,0,0,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
    //   '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    //   };

    case (level_sel)
      4'd1: // "ECE"
      barrier <=
        '{
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
          '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
          '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
          '{0,X,X,X,1,1,1,X,1,1,1,X,X,1,1,1,X,X,X,0},
          '{0,X,0,0,1,X,X,X,1,X,X,X,X,1,X,X,0,0,X,0},
          '{0,X,0,0,1,1,0,X,1,0,0,X,X,1,1,0,0,0,X,0},
          '{0,X,0,0,1,X,X,X,1,X,X,X,X,1,X,X,0,0,X,0},
          '{0,X,X,X,1,1,1,X,1,1,1,X,X,1,1,1,X,X,X,0},
          '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
          '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
          '{0,X,0,0,X,X,0,0,X,X,X,X,0,0,X,X,0,0,X,0},
          '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
          };
      4'd2: // "385"
      barrier <=
        '{
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0},
          '{0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0},
          '{0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0},
          '{0,0,0,0,0,1,0,0,1,1,1,1,0,0,0,1,0,0,0,0},
          '{0,0,0,1,1,1,0,0,1,0,0,1,0,1,1,1,0,0,0,0},
          '{0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
          };
      4'd3: // Generic
      barrier <=
        '{
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
          };
      4'd4: // :)
        barrier <=
          '{
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
          };
      default:
        barrier <=
          '{
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
          };
    endcase
  end
endmodule // barrier
