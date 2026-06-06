`timescale 1ns/1ns
module FSM_Baseball(
    input Pitch, RSTN, CLK, // 입력: Pitch(0:B, 1:S), RSTN, CLK
    output reg [1:0] Result // 출력: 0(결과 없음), 1(볼넷), 2(아웃)
);
    reg [1:0] state_ball, next_ball; // Ball 상태
    reg [1:0] state_strike, next_strike; // Strike 상태
    reg [1:0] next_Result;

    localparam B0 = 2'd0, B1 = 2'd1, B2 = 2'd2, B3 = 2'd3; // Ball 상태정의
    localparam S0 = 2'd0, S1 = 2'd1, S2 = 2'd2; // Strike 상태정의

    always @(posedge CLK or negedge RSTN) begin // 순차논리: 상태 업데이트
        if(!RSTN) begin // 비동기 리셋: 초기화
            state_ball <= B0;
            state_strike <= S0;
            Result <= 2'b00;
        end
        else begin // 클럭 에지: 상태 전이
            state_ball <= next_ball;
            state_strike <= next_strike;
            Result <= next_Result;
        end
    end

    always @(*) begin // 조합논리: 다음상태 계산
        // 초기설정
        next_ball = state_ball; next_strike = state_strike; next_Result = 2'b00;
        if(Pitch == 1'b0) begin // Ball 입력 시
            if(state_ball == B3) begin // 4-Ball 달성 시 볼넷 처리 및 전체리셋
                next_Result = 2'b01;
                next_ball = B0;
                next_strike = S0;
            end
            else begin // 볼 카운트 증가
                next_ball = state_ball + 1'b1;
            end
        end
        else begin // Strike 입력 시
            if(state_strike == S2) begin // 3-Strike 달성 시 아웃 처리 및 전체리셋
                next_Result = 2'b10;
                next_ball = B0;
                next_strike = S0;
            end
            else begin // 스트라이크 카운트 증가
                next_strike = state_strike + 1'b1;
            end
        end
    end
endmodule