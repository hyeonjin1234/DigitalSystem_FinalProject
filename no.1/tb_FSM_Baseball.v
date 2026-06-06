`timescale 1ns/1ns
module tb_FSM_Baseball;
    reg Pitch;
    reg RSTN;
    reg CLK;
    wire [1:0] Result;

    FSM_Baseball u0(
        .Pitch(Pitch),
        .RSTN(RSTN),
        .CLK(CLK),
        .Result(Result)
    );

    always #5 CLK = ~CLK; // 10ns 주기(주파수 100MHz) 클럭 생성

    initial begin
        $dumpfile("FSM_Baseball.vcd");
        $dumpvars(0, tb_FSM_Baseball);
    end
    
    initial begin
        CLK = 0; RSTN = 0; Pitch = 0; // 초기 상태 설정

        #10 RSTN = 1; // 10ns 후 비동기 리셋 해제

        // [시나리오 1] 볼넷 판정 (입력: 0 -> 1 -> 0 -> 0 -> 1 -> 0)
        #5  Pitch = 0; // 1구: Ball (1B-0S)
        #10 Pitch = 1; // 2구: Strike (1B-1S)
        #10 Pitch = 0; // 3구: Ball (2B-1S)
        #10 Pitch = 0; // 4구: Ball (3B-1S)
        #10 Pitch = 1; // 5구: Strike (3B-2S, 풀카운트)
        #10 Pitch = 0; // 6구: Ball -> Result=1(Walk) 출력 및 전체리셋
        
        // [시나리오 2] 삼진 아웃 판정 (입력: 1 -> 1 -> 0 -> 0 -> 0 -> 1)
        #10 Pitch = 1; // 1구: Strike (0B-1S)
        #10 Pitch = 1; // 2구: Strike (0B-2S)
        #10 Pitch = 0; // 3구: Ball (1B-2S)
        #10 Pitch = 0; // 4구: Ball (2B-2S)
        #10 Pitch = 0; // 5구: Ball (3B-2S, 풀카운트)
        #10 Pitch = 1; // 6구: Strike -> Result=2(Out) 출력 및 전체리셋
        
        // [시나리오 3] 삼진 아웃 판정 (입력: 0 -> 1 -> 0 -> 1 -> 0 -> 1)
        #10 Pitch = 0; // 1구: Ball (1B-0S)
        #10 Pitch = 1; // 2구: Strike (1B-1S)
        #10 Pitch = 0; // 3구: Ball (2B-1S)
        #10 Pitch = 1; // 4구: Strike (2B-2S)
        #10 Pitch = 0; // 5구: Ball (3B-2S, 풀카운트)
        #10 Pitch = 1; // 6구: Strike -> Result=2(Out) 출력 및 전체리셋
        
        #10 $finish; // 시뮬레이션 종료
    end
endmodule