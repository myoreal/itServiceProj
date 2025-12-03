<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${board.title} - IT Service KIM</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        .detail-container { max-width: 800px; margin: 100px auto 50px; }
        
        /* 게시글 카드 스타일 */
        .card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        
        /* 좋아요 버튼 */
        .btn-vote { transition: all 0.2s; border-radius: 50px; padding: 10px 30px; font-weight: bold; }
        .btn-vote:hover { transform: scale(1.05); box-shadow: 0 5px 15px rgba(220, 53, 69, 0.3); }
        
        /* 댓글 스타일 */
        .reply-item { background-color: #f8f9fa; border-radius: 15px; padding: 20px; margin-bottom: 15px; position: relative; border: 1px solid #eee; }
        .reply-icon { width: 40px; height: 40px; background: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 15px; color: #6c757d; }
        
        /* 관리자 댓글 강조 */
        .admin-reply { background-color: #e3f2fd; border: 1px solid #bbdefb; }
        .admin-reply .reply-icon { background-color: #bbdefb; color: #0d6efd; }
    </style>
</head>
<body>

    <!-- 헤더 (네비게이션) -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top bg-white border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="getBoardList.do"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>
            <div class="d-flex">
                <a href="getBoardList.do" class="btn btn-outline-secondary btn-sm rounded-pill px-3"><i class="fa-solid fa-list me-1"></i>목록으로</a>
                <!-- 로그인 상태면 로그아웃 버튼 표시 -->
                <c:if test="${not empty sessionScope.member}">
                    <a href="/logout" class="btn btn-light btn-sm rounded-pill ms-2 px-3">로그아웃</a>
                </c:if>
            </div>
        </div>
    </nav>

    <div class="container detail-container">
        
        <!-- 1. 게시글 본문 카드 -->
        <div class="card p-4 mb-4">
            <div class="card-body">
                
                <!-- 상단 정보 (카테고리, 조회수, 날짜) -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="badge bg-primary rounded-pill px-3 py-2">#${board.category}</span>
                    <div class="text-muted small">
                        <span class="me-3"><i class="fa-regular fa-eye me-1"></i>${board.viewCount}</span>
                        <span><i class="fa-regular fa-clock me-1"></i>${board.regDate}</span>
                    </div>
                </div>
                
                <!-- 제목 -->
                <h2 class="fw-bold mb-4">${board.title}</h2>
                
                <!-- 작성자 및 상태 정보 -->
                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                    <div class="avatar bg-light rounded-circle d-flex align-items-center justify-content-center text-secondary me-3" style="width: 45px; height: 45px; font-size: 1.2rem;">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <div>
                        <p class="mb-0 fw-bold text-dark">${board.writer}</p>
                        <small class="text-muted">작성자</small>
                    </div>
                    
                    <div class="ms-auto d-flex align-items-center">
                        <!-- 현재 상태 배지 -->
                        <span class="badge bg-${board.status == '완료' ? 'success' : (board.status == '처리중' ? 'info' : 'secondary')} me-2 px-3 py-2">
                            ${board.status}
                        </span>

                        <!-- ★ [관리자 전용] 상태 변경 기능 ★ -->
                        <c:if test="${sessionScope.member.role == 'ADMIN'}">
                            <form action="updateStatus.do" method="post" class="d-flex">
                                <input type="hidden" name="seq" value="${board.seq}">
                                <select name="status" class="form-select form-select-sm me-1 border-secondary" style="width: auto;">
                                    <option value="접수" <c:if test="${board.status == '접수'}">selected</c:if>>접수</option>
                                    <option value="처리중" <c:if test="${board.status == '처리중'}">selected</c:if>>처리중</option>
                                    <option value="완료" <c:if test="${board.status == '완료'}">selected</c:if>>완료</option>
                                </select>
                                <button type="submit" class="btn btn-dark btn-sm">변경</button>
                            </form>
                        </c:if>
                    </div>
                </div>

                <!-- 본문 내용 -->
                <div class="content-body mb-5" style="min-height: 200px; line-height: 1.8;">
                    <!-- 이미지 표시 -->
                    <c:if test="${not empty board.filename}">
                        <div class="text-center mb-4">
                            <img src="${pageContext.request.contextPath}/upload/${board.filename}" class="img-fluid rounded shadow-sm border" style="max-height: 600px;" alt="Attached Image">
                        </div>
                    </c:if>
                    
                    <!-- 텍스트 내용 (엔터 처리 등은 필요 시 jstl replace 활용) -->
                    ${board.content}
                </div>

                <!-- 좋아요 버튼 -->
                <div class="text-center mb-5">
                    <a href="voteBoard.do?seq=${board.seq}" class="btn btn-outline-danger btn-vote btn-lg">
                        <i class="fa-solid fa-thumbs-up me-2"></i>좋아요 <span class="ms-1 fw-bold">${board.voteCount}</span>
                    </a>
                </div>

                <!-- 게시글 수정/삭제 버튼 -->
                <div class="d-flex justify-content-end gap-2">
                    <!-- ★ 조건: 본인 글(m_no == writerId) 이거나 관리자(ADMIN)일 때 ★ -->
                    <c:if test="${sessionScope.member.m_no == board.writerId || sessionScope.member.role == 'ADMIN'}">
                        
                        <!-- 수정은 본인만 가능 -->
                        <c:if test="${sessionScope.member.m_no == board.writerId}">
                            <a href="modifyBoard.do?seq=${board.seq}" class="btn btn-light btn-sm text-secondary border px-3">수정</a>
                        </c:if>

                        <!-- 삭제는 본인 또는 관리자 가능 -->
                        <a href="deleteBoard.do?seq=${board.seq}" class="btn btn-light btn-sm text-danger border px-3" onclick="return confirm('정말 게시글을 삭제하시겠습니까?');">삭제</a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 2. 댓글 섹션 -->
        <div class="card p-4">
            <h5 class="fw-bold mb-4"><i class="fa-regular fa-comments me-2"></i>댓글 <span class="text-primary">${rList.size()}</span></h5>
            
            <!-- 댓글 리스트 -->
            <div class="reply-list mb-4">
                <c:forEach var="reply" items="${rList}">
                    
                    <!-- 관리자 댓글이면 클래스 추가 (선택사항) -->
                    <div class="reply-item mb-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div class="d-flex align-items-center">
                                <div class="reply-icon flex-shrink-0">
                                    <i class="fa-solid fa-user"></i>
                                </div>
                                <div>
                                    <strong class="text-dark d-block">${reply.r_writer}</strong>
                                    <small class="text-muted" style="font-size: 0.8rem;">${reply.r_reg_date.substring(0,16)}</small>
                                </div>
                            </div>
                            
                            <!-- ★ 댓글 수정/삭제 버튼 (본인 또는 관리자) ★ -->
                            <c:if test="${sessionScope.member.m_no == reply.rWriterId || sessionScope.member.role == 'ADMIN'}">
                                <div class="dropdown">
                                    <button class="btn btn-link btn-sm text-secondary p-0" type="button" data-bs-toggle="dropdown">
                                        <i class="fa-solid fa-ellipsis-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                        <!-- 수정: 본인만 -->
                                        <c:if test="${sessionScope.member.m_no == reply.rWriterId}">
                                            <li><a class="dropdown-item small" href="javascript:void(0);" onclick="toggleEditForm('${reply.r_no}')">수정</a></li>
                                        </c:if>
                                        <!-- 삭제: 본인 또는 관리자 -->
                                        <li><a class="dropdown-item small text-danger" href="deleteReply.do?r_no=${reply.r_no}&b_no=${board.seq}" onclick="return confirm('댓글을 삭제하시겠습니까?')">삭제</a></li>
                                    </ul>
                                </div>
                            </c:if>
                        </div>

                        <!-- 1. 평소에 보이는 댓글 내용 -->
                        <div id="reply-content-${reply.r_no}" class="text-dark ms-5" style="white-space: pre-wrap;">${reply.r_content}</div>

                        <!-- 2. 수정 버튼 누르면 나타나는 수정 폼 (평소엔 숨김) -->
                        <div id="reply-edit-${reply.r_no}" class="ms-5" style="display: none;">
                            <form action="updateReply.do" method="post">
                                <input type="hidden" name="r_no" value="${reply.r_no}">
                                <input type="hidden" name="b_no" value="${board.seq}">
                                <div class="input-group">
                                    <input type="text" name="r_content" class="form-control" value="${reply.r_content}" required>
                                    <button type="submit" class="btn btn-primary btn-sm">저장</button>
                                    <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEditForm('${reply.r_no}')">취소</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                </c:forEach>
                
                <c:if test="${empty rList}">
                    <div class="text-center text-muted py-5 bg-light rounded-3 mb-3">
                        <i class="fa-regular fa-comment-dots fa-2x mb-2"></i><br>
                        첫 번째 댓글의 주인공이 되어보세요!
                    </div>
                </c:if>
            </div>

            <!-- 3. 댓글 작성 폼 -->
            <c:choose>
                <c:when test="${not empty sessionScope.member}">
                    <form action="addReply.do" method="post" class="bg-white p-3 rounded-3 border shadow-sm">
                        <input type="hidden" name="b_no" value="${board.seq}">
                        <div class="mb-2 d-flex align-items-center">
                            <span class="badge bg-light text-dark border me-2">${sessionScope.member.name}</span>
                            <small class="text-muted">님으로 댓글 작성</small>
                        </div>
                        <div class="input-group">
                            <!-- 작성자 이름은 컨트롤러에서 세션으로 처리하므로 여기선 내용만 받으면 됨 -->
                            <input type="text" name="r_content" class="form-control border-end-0" placeholder="따뜻한 댓글을 남겨주세요..." required style="height: 50px;">
                            <button type="submit" class="btn btn-primary px-4 fw-bold">등록</button>
                        </div>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-4 bg-light rounded-3 border">
                        <span class="text-muted">댓글을 작성하려면 <a href="login.do" class="text-decoration-none fw-bold text-primary">로그인</a>이 필요합니다.</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- 댓글 수정 토글 스크립트 -->
    <script>
        function toggleEditForm(replyId) {
            var contentDiv = document.getElementById('reply-content-' + replyId);
            var editDiv = document.getElementById('reply-edit-' + replyId);

            if (editDiv.style.display === 'none') {
                contentDiv.style.display = 'none';
                editDiv.style.display = 'block';
            } else {
                contentDiv.style.display = 'block';
                editDiv.style.display = 'none';
            }
        }
    </script>

</body>
</html>