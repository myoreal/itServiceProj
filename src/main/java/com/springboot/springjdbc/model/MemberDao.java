package com.springboot.springjdbc.model;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
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
}

class MemberRowMapper implements RowMapper<MemberDo> {
    @Override
    public MemberDo mapRow(ResultSet rs, int rowNum) throws SQLException {
        MemberDo member = new MemberDo();
        member.setM_no(rs.getInt("m_no"));
        member.setEmail(rs.getString("email"));
        member.setName(rs.getString("name"));
        member.setRole(rs.getString("role"));
        return member;
    }
}