package com.springboot.springjdbc.service;

import java.util.ArrayList;

import com.springboot.springjdbc.model.BoardDo;

public interface BoardService {
	
	//새로운 글 등록 메소드 
	void insertBoard(BoardDo bdo);	
	//전체 글 가져오는 메소드 
	ArrayList<BoardDo> getBoardList();	
	//글 조회 
	BoardDo getOneBoard(int seq);	
	//글 수정
	void updateBoard(BoardDo bdo);	
	//글 삭제 
	void deleteBoard(int seq);
}
