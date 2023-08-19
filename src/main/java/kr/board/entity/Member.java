package kr.board.entity;

import lombok.Data;

@Data
public class Member{
	
	private int memIdx;  // 회원번호  
	private String memID; // 회원 ID 
	private String memPassword;  // 회원 비밀번호  
	private String memName; // 회원이름  
	private int memAge;   // 회원나이 
	private String memGender;       // 회원 성별  
	private String memEmail;   // 회원 E-mail 
	private String memInfo;     // 멤버 프로필 
	
	
}
