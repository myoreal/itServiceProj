package com.springboot.springjdbc.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.springboot.springjdbc.model.BoardDaoSpring;
import com.springboot.springjdbc.model.BoardDo;

@Service("boardService")
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDaoSpring bdao;

	@Override
	public void insertBoard(BoardDo bdo) {
		
		bdao.insertBoard(bdo);
	}

	@Override
	public ArrayList<BoardDo> getBoardList() {
		// TODO Auto-generated method stub
		return bdao.getBoardList(); //BoardDao 메소드 이용
	}

	@Override
	public BoardDo getOneBoard(int seq) {
		// TODO Auto-generated method stub
		return bdao.getOneBoard(seq);
	}

	@Override
	public void updateBoard(BoardDo bdo) {
		bdao.updateBoard(bdo);		
	}

	@Override
	public void deleteBoard(int seq) {
		bdao.deleteBoard(seq); 
		
	}

}
