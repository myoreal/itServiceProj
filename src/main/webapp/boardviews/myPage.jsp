<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - IT Service KIM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        .mypage-header { background: white; padding: 40px 0; border-bottom: 1px solid #eee; margin-bottom: 30px; }
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: transform 0.3s; overflow: hidden; }
        .card:hover { transform: translateY(-5px); }
        .board-card-img { height: 150px; object-fit: cover; }
        .placeholder-img { height: 150px; background: #e9ecef; display: flex; align-items: center; justify-content: center; color: #adb5bd; font-size: 2rem; }
        .nav-pills .nav-link.active { background-color: #4e73df; }
        .nav-pills .nav-link { color: #555; font-weight: bold; margin-right: 10px; border-radius: 50px; padding: 10px 20px;}
    </style>
</head>
<body>

    <!-- 네비게이션 -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom fixed-top">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="getBoardList.do"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>
            <div class="d-flex">
                <a href="getBoardList.do" class="btn btn-outline-secondary btn-sm rounded-pill">메인으로</a>
                <a href="/logout" class="btn btn-light btn-sm rounded-pill ms-2">로그아웃</a>
            </div>
        </div>
    </nav>

    <!-- 마이페이지 헤더 -->
    <div class="mypage-header mt-5">
        <div class="container text-center">
            <div class="mb-3">
                <i class="fa-solid fa-circle-user fa-4x text-primary"></i>
            </div>
            <h3 class="fw-bold">${sessionScope.member.name}님</h3>
            <p class="text-muted">${sessionScope.member.email}</p>
        </div>
    </div>

    <!-- 탭 메뉴 (내가 쓴 글 / 좋아요 한 글) -->
    <div class="container mb-5">
        <ul class="nav nav-pills mb-4 justify-content-center" id="pills-tab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="pills-my-tab" data-bs-toggle="pill" data-bs-target="#pills-my" type="button" role="tab">
                    <i class="fa-solid fa-pen-to-square me-2"></i>내가 쓴 글 (${myList.size()})
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pills-like-tab" data-bs-toggle="pill" data-bs-target="#pills-like" type="button" role="tab">
                    <i class="fa-solid fa-heart me-2"></i>좋아요 누른 글 (${likedList.size()})
                </button>
            </li>
        </ul>

        <div class="tab-content" id="pills-tabContent">
            
            <!-- 1. 내가 쓴 글 탭 -->
            <div class="tab-pane fade show active" id="pills-my" role="tabpanel">
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach var="board" items="${myList}">
                        <!-- 카드 컴포넌트 (반복) -->
                        <div class="col">
                            <div class="card h-100" onclick="location.href='getOneBoard.do?seq=${board.seq}'" style="cursor: pointer;">
                                <c:choose>
                                    <c:when test="${not empty board.filename}">
                                        <img src="${pageContext.request.contextPath}/upload/${board.filename}" class="card-img-top board-card-img" alt="img">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="placeholder-img"><i class="fa-regular fa-file-lines"></i></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="badge bg-light text-dark border">#${board.category}</span>
                                        <span class="badge bg-${board.status == '완료' ? 'success' : 'secondary'}">${board.status}</span>
                                    </div>
                                    <h5 class="card-title fw-bold text-truncate">${board.title}</h5>
                                    <p class="card-text text-muted small text-truncate">${board.content}</p>
                                </div>
                                <div class="card-footer bg-white border-0 pt-0">
                                    <small class="text-muted">${board.regDate.substring(0,10)} · 👍 ${board.voteCount}</small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty myList}">
                        <div class="col-12 text-center py-5 text-muted">아직 작성한 글이 없습니다.</div>
                    </c:if>
                </div>
            </div>

            <!-- 2. 좋아요 누른 글 탭 -->
            <div class="tab-pane fade" id="pills-like" role="tabpanel">
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach var="board" items="${likedList}">
                        <div class="col">
                            <div class="card h-100" onclick="location.href='getOneBoard.do?seq=${board.seq}'" style="cursor: pointer;">
                                <c:choose>
                                    <c:when test="${not empty board.filename}">
                                        <img src="${pageContext.request.contextPath}/upload/${board.filename}" class="card-img-top board-card-img" alt="img">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="placeholder-img"><i class="fa-solid fa-heart text-danger"></i></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span class="badge bg-light text-dark border">#${board.category}</span>
                                        <small class="text-primary fw-bold"><i class="fa-solid fa-user me-1"></i>${board.writer}</small>
                                    </div>
                                    <h5 class="card-title fw-bold text-truncate">${board.title}</h5>
                                    <p class="card-text text-muted small text-truncate">${board.content}</p>
                                </div>
                                <div class="card-footer bg-white border-0 pt-0">
                                    <small class="text-muted">${board.regDate.substring(0,10)} · <span class="text-danger fw-bold">👍 ${board.voteCount}</span></small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty likedList}">
                        <div class="col-12 text-center py-5 text-muted">아직 좋아요를 누른 글이 없습니다.</div>
                    </c:if>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>