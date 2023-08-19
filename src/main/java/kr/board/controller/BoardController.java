package kr.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

@Controller
public class BoardController {
	
	@Autowired
	BoardMapper boardMapper; 
	
	@RequestMapping("/boardMain.do")
	public String home() {
		return "board/main";
	}
	

	@RequestMapping("/boardList.do")
	public @ResponseBody List<Board> boardList(){
		
		List<Board> boardList=boardMapper.getLists(); 
		
		return boardList; 
		
	}
	
	@RequestMapping("/boardInsert.do")
	public @ResponseBody void boardInsert(Board vo) {
		
		boardMapper.boardInsert(vo);  // 글등록  
	}
	
	@RequestMapping("/boardDelete.do")
	public @ResponseBody void boardDelete(@RequestParam("idx") int idx) {
		
		boardMapper.deleteBoard(idx); 
	}
	
	@RequestMapping("/boardUpdate.do")
	public @ResponseBody void boardUpdate(Board vo) {
		
		boardMapper.boardUpdate(vo);
	}
	@RequestMapping("/boardContent.do")
	public @ResponseBody Board boardContent(int idx) {
		
		Board vo= boardMapper.boardContent(idx); 
		return vo; 
	}
	
	@RequestMapping("/boardCount.do")
	public @ResponseBody Board boardCount(int idx) {
		
		boardMapper.boardCount(idx);  // 조회수 증가 
		Board vo = boardMapper.boardContent(idx); 
		return vo;  
		
	}
	
	
	

	
	
}