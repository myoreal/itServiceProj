package com.springboot.springjdbc.model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository("boardDaoSpring")
public class BoardDaoSpring {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 1. 글 쓰기 (writer_id 추가됨)
    public void insertBoard(BoardDo bdo) {
        // ★ 이름(writer)과 회원번호(writer_id)를 둘 다 저장합니다.
        String sql = "insert into board (title, writer, content, category, vote_count, status, reg_date, filename, writer_id) values(?, ?, ?, ?, 0, '접수', now(), ?, ?)";
        jdbcTemplate.update(sql, bdo.getTitle(), bdo.getWriter(), bdo.getContent(), bdo.getCategory(), bdo.getFilename(), bdo.getWriterId());
    }    

    // 2. 마이페이지 (이름이 아니라 '회원 번호'로 조회)
    public ArrayList<BoardDo> getMyBoardList(int m_no) {
        System.out.println("(Spring JDBC) 내 글 조회 (회원번호): " + m_no);
        String sql = "select * from board where writer_id=? order by no desc";
        Object[] args = {m_no};
        return (ArrayList<BoardDo>)jdbcTemplate.query(sql, args, new BoardRowMapper());
    }

    // --- 나머지 메소드는 쿼리 변경 없음 (RowMapper만 변경됨) ---
    
    public ArrayList<BoardDo> getBoardList(){
        String sql = "select * from board order by no desc";                 
        return (ArrayList<BoardDo>)jdbcTemplate.query(sql, new BoardRowMapper());
    }
    public ArrayList<BoardDo> getTop5BoardList(){
        String sql = "select * from board order by vote_count desc limit 5";                
        return (ArrayList<BoardDo>)jdbcTemplate.query(sql, new BoardRowMapper());
    }
    public void updateBoard(BoardDo bdo) {
		System.out.println("(Spring JDBC) updateBoard() 처리 시작 !! ");
		String sql = "update board set title=?, content=?, category=?, update_date=now() where no=?";
		jdbcTemplate.update(sql, bdo.getTitle(), bdo.getContent(), bdo.getCategory(), bdo.getSeq());		
	}
    public void deleteBoard(int seq) {
        String sql = "delete from board where no=?";
        jdbcTemplate.update(sql, seq);
    }
    public BoardDo getOneBoard(int seq) {
        String sql = "select * from board where no=?";
        Object[] args = {seq};
        return jdbcTemplate.queryForObject(sql, args, new BoardRowMapper() );
    }
    
 // ★★★ [신규 1] 내가 좋아요 누른 글 목록 가져오기 (JOIN 쿼리) ★★★
    public ArrayList<BoardDo> getMyLikedBoardList(int m_no) {
        System.out.println("(Spring JDBC) 좋아요 누른 글 조회: " + m_no);
        // board 테이블과 board_like 테이블을 합쳐서(JOIN), 내가(m_no) 좋아요한 글만 가져옴
        String sql = "SELECT b.* FROM board b " +
                     "JOIN board_like bl ON b.no = bl.b_no " +
                     "WHERE bl.m_no = ? " +
                     "ORDER BY bl.bl_no DESC";
        Object[] args = {m_no};
        return (ArrayList<BoardDo>)jdbcTemplate.query(sql, args, new BoardRowMapper());
    }

    // ★★★ [신규 2] 이미 좋아요 눌렀는지 확인 (중복 방지) ★★★
    public boolean checkLike(int b_no, int m_no) {
        String sql = "SELECT count(*) FROM board_like WHERE b_no=? AND m_no=?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, b_no, m_no);
        return count != null && count > 0; // 0보다 크면 이미 누른 것
    }

    // ★★★ [신규 3] 좋아요 기록 저장 ★★★
    public void insertLike(int b_no, int m_no) {
        String sql = "INSERT INTO board_like (b_no, m_no) VALUES (?, ?)";
        jdbcTemplate.update(sql, b_no, m_no);
    }
    
    
    public ArrayList<BoardDo> searchBoardList(String searchCon, String searchKey){        
        String sql="";
        if(searchCon.equals("title")) sql = "select * from board where title like concat('%',?,'%') order by no desc";    
        else if(searchCon.equals("content")) sql = "select * from board where content like concat('%',?,'%') order by no desc";
        else if(searchCon.equals("writer")) sql = "select * from board where writer like concat('%',?,'%') order by no desc";
        else return null;        
        Object[] args = {searchKey};    
        return (ArrayList<BoardDo>)jdbcTemplate.query(sql, args, new BoardRowMapper());
    }
    public void updateVoteCount(int seq) {
        String sql = "update board set vote_count = vote_count + 1 where no=?";
        jdbcTemplate.update(sql, seq);
    }
    public void insertReply(ReplyDo rdo) {
        String sql = "insert into reply (b_no, r_writer, r_content, r_reg_date) values(?, ?, ?, now())";
        jdbcTemplate.update(sql, rdo.getB_no(), rdo.getR_writer(), rdo.getR_content());
    }
    public ArrayList<ReplyDo> getReplyList(int b_no) {
        String sql = "select * from reply where b_no=? order by r_no desc";
        Object[] args = {b_no};
        return (ArrayList<ReplyDo>)jdbcTemplate.query(sql, args, new ReplyRowMapper());
    }
    
    public void updateViewCount(int seq) {
        System.out.println("(Spring JDBC) 조회수 증가 !!");
        String sql = "update board set view_count = view_count + 1 where no=?";
        jdbcTemplate.update(sql, seq);
    }
}

class BoardRowMapper implements RowMapper<BoardDo>{
	@Override
	public BoardDo mapRow(ResultSet rs, int rowNum) throws SQLException {
		BoardDo bdo = new BoardDo();
		bdo.setSeq(rs.getInt("no"));
		bdo.setTitle(rs.getString("title"));
		bdo.setWriter(rs.getString("writer"));
		bdo.setContent(rs.getString("content"));
		bdo.setCategory(rs.getString("category"));
		bdo.setVoteCount(rs.getInt("vote_count"));
		bdo.setStatus(rs.getString("status"));
		bdo.setRegDate(rs.getString("reg_date"));
		bdo.setFilename(rs.getString("filename"));
		bdo.setWriterId(rs.getInt("writer_id"));
		bdo.setViewCount(rs.getInt("view_count")); 
		return bdo;
	}
}

class ReplyRowMapper implements RowMapper<ReplyDo>{
    @Override
    public ReplyDo mapRow(ResultSet rs, int rowNum) throws SQLException {
        ReplyDo rdo = new ReplyDo();
        rdo.setR_no(rs.getInt("r_no"));
        rdo.setB_no(rs.getInt("b_no"));
        rdo.setR_writer(rs.getString("r_writer"));
        rdo.setR_content(rs.getString("r_content"));
        rdo.setR_reg_date(rs.getString("r_reg_date"));
        return rdo;
    }
}