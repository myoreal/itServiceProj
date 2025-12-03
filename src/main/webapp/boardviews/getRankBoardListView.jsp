<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>인기 순위 - IT Service KIM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        .ranking-header { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); color: white; padding: 60px 0 40px; margin-bottom: 30px; }
        .table-hover tbody tr:hover { background-color: #f1f3f5; cursor: pointer; }
        
        /* 순위 아이콘 스타일 */
        .rank-icon { font-size: 1.2rem; margin-right: 5px; }
        .rank-1 { color: #FFD700; text-shadow: 0 1px 2px rgba(0,0,0,0.2); } /* 금메달 */
        .rank-2 { color: #C0C0C0; text-shadow: 0 1px 2px rgba(0,0,0,0.2); } /* 은메달 */
        .rank-3 { color: #CD7F32; text-shadow: 0 1px 2px rgba(0,0,0,0.2); } /* 동메달 */
        
        .table th { background-color: #f8f9fa; color: #495057; font-weight: 600; }
        .vote-badge { background-color: #ffeff0; color: #ff4757; font-weight: bold; padding: 5px 10px; border-radius: 20px; font-size: 0.9rem; }
    </style>
</head>
<body>

    <!-- 네비게이션 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="getBoardList.do"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>
            <div class="d-flex">
                <a href="getBoardList.do" class="btn btn-outline-secondary btn-sm rounded-pill">메인으로</a>
                <c:if test="${not empty sessionScope.member}">
                    <a href="/logout" class="btn btn-light btn-sm rounded-pill ms-2">로그아웃</a>
                </c:if>
            </div>
        </div>
    </nav>

    <!-- 헤더 영역 -->
    <div class="ranking-header mt-5">
        <div class="container text-center">
            <h1 class="fw-bold mb-2">인기 게시물 한 눈에 보기</h1>
            <p class="opacity-75">사용자들이 가장 많이 공감한 게시글 순위입니다.</p>
        </div>
    </div>

    <!-- 랭킹 리스트 (테이블) -->
    <div class="container mb-5">
        <div class="card shadow-sm border-0 rounded-4 overflow-hidden">
            <div class="card-body p-0">
                <table class="table table-hover mb-0 text-center align-middle">
                    <thead class="table-light">
                        <tr style="height: 50px;">
                            <th width="10%">순위</th>
                            <th width="10%">분류</th>
                            <th width="45%" class="text-start ps-4">제목</th>
                            <th width="15%">작성자</th>
                            <th width="10%">조회수</th>
                            <th width="10%">좋아요</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="board" items="${rankList}" varStatus="status">
                            <tr onclick="location.href='getOneBoard.do?seq=${board.seq}'">
                                <!-- 순위 표시 -->
                                <td class="fw-bold">
                                    <c:choose>
                                        <c:when test="${status.count == 1}"><i class="fa-solid fa-medal rank-icon rank-1"></i></c:when>
                                        <c:when test="${status.count == 2}"><i class="fa-solid fa-medal rank-icon rank-2"></i></c:when>
                                        <c:when test="${status.count == 3}"><i class="fa-solid fa-medal rank-icon rank-3"></i></c:when>
                                        <c:otherwise>${status.count}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge bg-light text-dark border">#${board.category}</span></td>
                                <td class="text-start ps-4 fw-bold text-dark">
                                    ${board.title}
                                    <c:if test="${not empty board.filename}">
                                        <i class="fa-regular fa-image text-muted ms-1 small"></i>
                                    </c:if>
                                </td>
                                <td>${board.writer}</td>
                                <td class="text-muted small">${board.viewCount}</td>
                                <td>
                                    <span class="vote-badge">
                                        <i class="fa-solid fa-heart me-1"></i>${board.voteCount}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${empty rankList}">
                    <div class="text-center py-5 text-muted">등록된 게시글이 없습니다.</div>
                </c:if>
            </div>
        </div>
    </div>

	<!-- Footer -->
	<footer class="text-center py-4 text-muted border-top mt-5 bg-white">
	    <small>&copy; 2025 IT Service KIM Project. All rights reserved.</small>
	</footer>
	
</body>
</html>