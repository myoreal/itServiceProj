package com.springboot.springjdbc.model;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 이메일로 회원 찾기
    public MemberDo findByEmail(String email) {
        String sql = "SELECT * FROM member WHERE email = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new Object[]{email}, new MemberRowMapper());
        } catch (Exception e) {
            return null; // 회원이 없으면 null
        }
    }

    // 회원 가입
    public void insertMember(String email, String name, String provider, String providerId) {
        String sql = "INSERT INTO member (email, name, provider, provider_id, role, reg_date) VALUES (?, ?, ?, ?, 'USER', NOW())";
        jdbcTemplate.update(sql, email, name, provider, providerId);
    }
    
    // 로컬 회원가입
    public void insertMemberLocal(MemberDo member) {
        // provider_id는 필수값이므로, 로컬 유저를 위한 고유 ID를 임의로 생성해서 넣습니다.
        String randomId = "local_" + UUID.randomUUID().toString().substring(0, 8);
        
        String sql = "INSERT INTO member (email, password, name, provider, provider_id, role, reg_date) VALUES (?, ?, ?, 'local', ?, 'USER', NOW())";
        
        // 순서: email, password, name, (provider_id자리), ...
        jdbcTemplate.update(sql, member.getEmail(), member.getPassword(), member.getName(), randomId);
    }

    // ★★★ 로컬 로그인 확인 (이메일 & 비번 일치 확인) ★★★
    public MemberDo loginCheck(String email, String password) {
        String sql = "SELECT * FROM member WHERE email = ? AND password = ? AND provider = 'local'";
        try {
            return jdbcTemplate.queryForObject(sql, new Object[]{email, password}, new MemberRowMapper());
        } catch (EmptyResultDataAccessException e) {
            return null; // 일치하는 회원 없음
        }
    }
}

class MemberRowMapper implements RowMapper<MemberDo> {
    @Override
    public MemberDo mapRow(ResultSet rs, int rowNum) throws SQLException {
        MemberDo member = new MemberDo();
        member.setM_no(rs.getInt("m_no"));
        member.setEmail(rs.getString("email"));
        member.setName(rs.getString("name"));
        member.setRole(rs.getString("role"));
        member.setProviderId(rs.getString("provider_id"));
        return member;
    }
}