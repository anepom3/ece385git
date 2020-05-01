module Barrier ( input level_sel,
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
    //   '{0,X,0,X,X,X,0,X,X,X,X,X,X,0,X,X,X,0,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,0,X,X,X,X,X,X,0,0,X,X,X,X,X,X,0,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,X,0,X,X,X,0,X,X,X,X,X,X,0,X,X,X,0,X,0},
    //   '{0,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,0},
    //   '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    //   };

    case (level_sel)
      0:
      barrier <=
        '{
        '{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
        };
      1:
        barrier <=
          '{
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
          '{0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
          '{0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0},
          '{0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
          '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
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
          '{0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0},
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