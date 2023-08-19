package kr.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import kr.board.entity.Board;

@Mapper
public interface BoardMapper {
	
	public List<Board> getLists(); 
	
	// 글 등록된것 받아서 저장 
	public void boardInsert(Board vo); 
	
	public Board boardContent(int idx);
	
	// 각 게시판 글 보기 
	public Board getBoardDetail(int idx); 
	
	// 글 삭제 
	public void deleteBoard(int idx);
	
	// 글 상세 업데이트 
	public void boardUpdate(Board vo);
	
	// 조회수 카운트 
	@Update("UPDATE BOARD SET COUNT=COUNT+1 WHERE IDX=#{idx}")
	public void boardCount(int idx);
	
	
	
	
}
