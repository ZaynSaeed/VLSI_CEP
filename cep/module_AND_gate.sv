module AND_gate(
    input  logic branch,
    input  logic less,
    input  logic zero,
    input  logic jump,
    output logic out
);

logic n1;

always_comb begin
    n1  = branch & less;
    out = n1 | jump;
end
endmodule