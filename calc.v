\m5_TLV_version 1d: tl-x.org
\m5
   
   // ============================================
   // Welcome, new visitors! Try the "Learn" menu.
   // ============================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   
\TLV
   m4+cal_viz(@4)
   
   |cal
      @0
         $reset = *reset;
      @1
         
         $val2[31:0] = $rand2[3:0];
         $val1[31:0] = >>2$out;
         $valid = $reset ? 1'b0 : >>1$valid + 1'b1;
         $reset_or_valid = $reset || $valid;
         
      ?$reset_or_valid
         @1
            $sum[31:0] = $val1 + $val2;
            $diff[31:0] = $val1 - $val2;
            $prod[31:0] = $val1 * $val2;
            $quot[31:0] = $val1 / $val2;


         @2
            $out[31:0] = $reset ? 32'b0:
                                     ($op[2:0] == 3'b000) ? $sum :
                                     ($op[2:0] == 3'b001) ? $diff :
                                     ($op[2:0] == 3'b010) ? $prod :
                                     ($op[2:0] == 3'b011) ? $quot:
                                     ($op[2:0] == 3'b100) ? >>2$mem : >>2$out;
            
            $mem[31:0] = $reset ? 32'b0 : ($op[2:0] ==3'b101) ? $val1 : >>2$mem;


         
   // Assert these to end simulation (before the cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
