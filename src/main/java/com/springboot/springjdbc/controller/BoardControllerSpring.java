package com.springboot.springjdbc.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.springjdbc.model.BoardDaoSpring;
import com.springboot.springjdbc.model.BoardDo;
import com.springboot.springjdbc.model.MemberDo;
import com.springboot.springjdbc.model.ReplyDo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class BoardControllerSpring {
    
    @Autowired
    BoardDaoSpring bdaoSpring;

    @RequestMapping(value="/login.do")
    public String login() { return "login"; }

    @RequestMapping(value="/getBoardList.do")
    public String getBoardList(Model model) {
        ArrayList<BoardDo> blist = bdaoSpring.getBoardList();
        ArrayList<BoardDo> topList = bdaoSpring.getTop5BoardList();
        model.addAttribute("bList", blist);
        model.addAttribute("topList", topList);
        return "getBoardListView";
    }

    // ★★★글쓰기 처리 부분 ★★★
    @RequestMapping(value="/insertBoardProc.do")
    public String insertBoardProc(BoardDo bdo, 
            @RequestParam(value="uploadFile", required=false) MultipartFile uploadFile, 
            HttpServletRequest request, HttpSession session) {
        
        // 1. 세션에서 로그인 정보 가져오기
        MemberDo member = (MemberDo) session.getAttribute("member");
        
        if (member != null) {
            bdo.setWriter(member.getName()); 
            // ★★★ 여기가 제일 중요합니다! 회원 번호(m_no)를 writerId에 넣어야 0이 안 됩니다 ★★★
            bdo.setWriterId(member.getM_no()); 
        } else {
            return "redirect:login.do";
        }
        
        // 파일 업로드 로직
        if (uploadFile != null && !uploadFile.isEmpty()) {
            String path = System.getProperty("user.dir") + "\\src\\main\\webapp\\upload\\";
            File folder = new File(path);
            if (!folder.exists()) folder.mkdirs();
            String uuid = UUID.randomUUID().toString();
            String savedFileName = uuid + "_" + uploadFile.getOriginalFilename();
            File file = new File(path + savedFileName);
            try {
                uploadFile.transferTo(file); 
                bdo.setFilename(savedFileName);
            } catch (IllegalStateException | IOException e) { e.printStackTrace(); }
        } else { bdo.setFilename(null); }
        
        // DB 저장
        bdaoSpring.insertBoard(bdo);
        return "redirect:getBoardList.do";
    }
    
    // ★★★ 좋아요 처리 (중복 방지 & 기록) ★★★
    @RequestMapping(value="/voteBoard.do")
    public String voteBoard(@RequestParam("seq") int seq, HttpSession session) {
        
        MemberDo member = (MemberDo) session.getAttribute("member");
        
        // 1. 로그인 안 했으면 로그인 페이지로
        if (member == null) {
            return "redirect:login.do";
        }
        
        // 2. 이미 좋아요 눌렀는지 확인
        boolean alreadyLiked = bdaoSpring.checkLike(seq, member.getM_no());
        
        if (!alreadyLiked) {
            // 3. 안 눌렀으면 -> 기록 남기고 + 카운트 증가
            bdaoSpring.insertLike(seq, member.getM_no());
            bdaoSpring.updateVoteCount(seq);
        } else {
            // 이미 눌렀으면 아무것도 안 함 (또는 취소 로직을 넣을 수도 있음)
            System.out.println("이미 좋아요를 누른 게시글입니다.");
        }
        
        return "redirect:getOneBoard.do?seq=" + seq;
    }

    // ★★★ 마이페이지 (좋아요 목록 추가) ★★★
    @RequestMapping(value="/myPage.do")
    public String myPage(HttpSession session, Model model) {
        MemberDo member = (MemberDo) session.getAttribute("member");
        if (member == null) { return "redirect:login.do"; }
        
        // 1. 내가 쓴 글
        ArrayList<BoardDo> myList = bdaoSpring.getMyBoardList(member.getM_no());
        
        // 2. 내가 좋아요 누른 글 (신규)
        ArrayList<BoardDo> likedList = bdaoSpring.getMyLikedBoardList(member.getM_no());
        
        model.addAttribute("myList", myList);
        model.addAttribute("likedList", likedList); // 화면으로 전달
        
        return "myPage"; 
    }

    // 수정 페이지 이동 (본인 확인)
    @RequestMapping(value="/modifyBoard.do")
    public String modifyBoard(BoardDo bdo, Model model, HttpSession session) {
        BoardDo board = bdaoSpring.getOneBoard(bdo.getSeq());
        MemberDo member = (MemberDo) session.getAttribute("member");
        
        // m_no와 writerId 비교
        if (member == null || member.getM_no() != board.getWriterId()) {
             return "redirect:getOneBoard.do?seq=" + bdo.getSeq(); 
        }
        model.addAttribute("board", board);        
        return "modifyBoardView";            
    }
    
    // 수정 처리 (본인 확인)
    @RequestMapping(value="/modifyBoardProc.do")
    public String modifyBoardProc(BoardDo bdo, HttpSession session) {
        BoardDo originBoard = bdaoSpring.getOneBoard(bdo.getSeq());
        MemberDo member = (MemberDo) session.getAttribute("member");
        
        if (member != null && member.getM_no() == originBoard.getWriterId()) {
            bdaoSpring.updateBoard(bdo);
        }
        return "redirect:getBoardList.do";
    }
    
    // 삭제 처리 (본인 확인)
    @RequestMapping(value="/deleteBoard.do")
    public String deleteBoard(BoardDo bdo, HttpSession session) {
        BoardDo originBoard = bdaoSpring.getOneBoard(bdo.getSeq());
        MemberDo member = (MemberDo) session.getAttribute("member");
        
        if (member != null && (member.getM_no() == originBoard.getWriterId() || "ADMIN".equals(member.getRole()))) {
            bdaoSpring.deleteBoard(bdo.getSeq());
        }
        return "redirect:getBoardList.do";
    }

    @RequestMapping(value="/getOneBoard.do")
    public String getOneBoard(@RequestParam("seq") int seq, Model model) {
        
        // 1. 조회수 먼저 증가시킴 
        bdaoSpring.updateViewCount(seq);
        
        // 2. 그 다음 데이터를 가져옴 
        BoardDo board = bdaoSpring.getOneBoard(seq);
        ArrayList<ReplyDo> rList = bdaoSpring.getReplyList(seq);
        
        model.addAttribute("board", board);
        model.addAttribute("rList", rList);
        return "getOneBoard";
    }


    @RequestMapping(value="/addReply.do")
    public String addReply(ReplyDo rdo, HttpSession session) {
        MemberDo member = (MemberDo) session.getAttribute("member");
        if(member != null) rdo.setR_writer(member.getName());
        bdaoSpring.insertReply(rdo);
        return "redirect:getOneBoard.do?seq=" + rdo.getB_no();
    }
    
    @RequestMapping(value="/insertBoard.do")
    public String insertBoard(HttpSession session) { 
        if(session.getAttribute("member") == null) return "redirect:login.do";
        return "insertBoardView"; 
    }
    
    @RequestMapping(value="/searchBoardList.do")
    public String searchBoardList(@RequestParam("searchCon") String searchCon, @RequestParam("searchKey") String searchKey, Model model) {
        ArrayList<BoardDo> bList = bdaoSpring.searchBoardList(searchCon, searchKey);        
        model.addAttribute("bList", bList);
        return "getBoardListView"; 
    }
    
 // 인기순 게시판 (랭킹 페이지) 이동
    @RequestMapping(value="/getRankBoardList.do")
    public String getRankBoardList(Model model) {
        // 1. 전체 랭킹 데이터 가져오기
        ArrayList<BoardDo> rankList = bdaoSpring.getRankedBoardList();
        // 2. 화면에 전달
        model.addAttribute("rankList", rankList);
        return "getRankBoardListView"; 
    }
}