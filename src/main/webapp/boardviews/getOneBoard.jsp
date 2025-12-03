<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${board.title} - 상세보기</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        .detail-container { max-width: 800px; margin: 100px auto 50px; }
        .card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .btn-vote { transition: all 0.2s; border-radius: 50px; padding: 10px 30px; font-weight: bold; }
        .btn-vote:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3); }
        .reply-item { background-color: #f1f3f5; border-radius: 15px; padding: 15px; margin-bottom: 15px; position: relative; }
        .reply-icon { width: 40px; height: 40px; background: #dee2e6; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px; }
    </style>
</head>
<body>

    <!-- 헤더 -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top bg-white border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="getBoardList.do"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>
            <div class="d-flex">
                <a href="getBoardList.do" class="btn btn-outline-secondary btn-sm rounded-pill"><i class="fa-solid fa-arrow-left me-1"></i>목록으로</a>
                <!-- 로그인 상태면 로그아웃 버튼 표시 -->
                <c:if test="${not empty sessionScope.member}">
                    <a href="/logout" class="btn btn-light btn-sm rounded-pill ms-2">로그아웃</a>
                </c:if>
            </div>
        </div>
    </nav>

    <div class="container detail-container">
        <!-- 게시글 본문 카드 -->
        <div class="card p-4 mb-4">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="badge bg-primary rounded-pill px-3 py-2">#${board.category}</span>
                    <span class="text-muted small"><i class="fa-regular fa-clock me-1"></i>${board.regDate}</span>
					<span class="text-muted small me-3"><i class="fa-regular fa-eye me-1"></i>${board.viewCount}</span>
                </div>
                
                <h2 class="fw-bold mb-3">${board.title}</h2>
                
                <div class="d-flex align-items-center mb-4 border-bottom pb-3">
                    <div class="avatar bg-light rounded-circle d-flex align-items-center justify-content-center text-secondary me-2" style="width: 40px; height: 40px;">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <div>
                        <p class="mb-0 fw-bold">${board.writer}</p>
                        <small class="text-muted">작성자</small>
                    </div>
                    <div class="ms-auto">
                        <span class="badge bg-secondary">${board.status}</span>
                    </div>
                </div>

                <div class="content-body mb-5" style="min-height: 200px; line-height: 1.8;">
                    <!-- 이미지 표시 -->
                    <c:if test="${not empty board.filename}">
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/upload/${board.filename}" class="img-fluid rounded shadow-sm" style="max-height: 500px;" alt="Attached Image">
                        </div>
                    </c:if>
                    
                    <!-- 본문 내용 (줄바꿈 처리) -->
                    ${board.content}
                </div>

                <!-- 좋아요 버튼 -->
                <div class="text-center mb-4">
                    <a href="voteBoard.do?seq=${board.seq}" class="btn btn-outline-danger btn-vote btn-lg">
                        <i class="fa-solid fa-thumbs-up me-2"></i>좋아요 <span class="ms-1 fw-bold">${board.voteCount}</span>
                    </a>
                </div>

				<!-- 수정/삭제 버튼 (본인 글일 때만 보임) -->
                <div class="d-flex justify-content-end gap-2">
                    <!-- ★★★ 로그인한 사람의 번호(m_no)와 글 작성자 번호(writerId)가 같을 때만 버튼 노출 ★★★ -->
                    <c:if test="${sessionScope.member.m_no == board.writerId}">
                        <a href="modifyBoard.do?seq=${board.seq}" class="btn btn-light btn-sm text-secondary">수정</a>
                        <a href="deleteBoard.do?seq=${board.seq}" class="btn btn-light btn-sm text-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 댓글 섹션 -->
        <div class="card p-4">
            <h5 class="fw-bold mb-4"><i class="fa-regular fa-comments me-2"></i>댓글 (${rList.size()})</h5>
            
            <!-- 댓글 리스트 -->
            <div class="reply-list mb-4">
                <c:forEach var="reply" items="${rList}">
                    <div class="reply-item d-flex">
                        <div class="reply-icon flex-shrink-0">
                            <i class="fa-solid fa-user text-muted"></i>
                        </div>
                        <div class="w-100">
                            <div class="d-flex justify-content-between">
                                <strong class="text-dark">${reply.r_writer}</strong>
                                <small class="text-muted">${reply.r_reg_date.substring(0,16)}</small>
                            </div>
                            <p class="mb-0 mt-1 text-secondary">${reply.r_content}</p>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty rList}">
                    <div class="text-center text-muted py-4">
                        <i class="fa-regular fa-paper-plane fa-2x mb-3 text-light-gray"></i>
                        <p>첫 번째 댓글을 남겨보세요!</p>
                    </div>
                </c:if>
            </div>

            <!-- 댓글 작성 폼 -->
            <!-- 로그인 상태일 때만 입력 가능 -->
            <c:choose>
                <c:when test="${not empty sessionScope.member}">
                    <form action="addReply.do" method="post" class="bg-light p-3 rounded-3">
                        <input type="hidden" name="b_no" value="${board.seq}">
                        <div class="row g-2">
                            <div class="col-md-3">
                                <!-- 작성자 자동 입력 및 수정 불가 -->
                                <input type="text" name="r_writer" class="form-control border-0 shadow-sm" 
                                       value="${sessionScope.member.name}" readonly 
                                       style="background-color: #e9ecef;">
                            </div>
                            <div class="col-md-7">
                                <input type="text" name="r_content" class="form-control border-0 shadow-sm" placeholder="댓글을 입력하세요..." required>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100 shadow-sm fw-bold">등록</button>
                            </div>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-3 bg-light rounded-3">
                        <span class="text-muted small">댓글을 작성하려면 <a href="login.do" class="text-decoration-none fw-bold">로그인</a>이 필요합니다.</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</body>
</html>