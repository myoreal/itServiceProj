<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>IT Service KIM Dashboard</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; color: #333; }
        
        /* 네비게이션 바 */
        .navbar { background-color: rgba(255, 255, 255, 0.95); backdrop-filter: blur(10px); box-shadow: 0 2px 10px rgba(0,0,0,0.05); z-index: 1000; }
        .navbar-brand { font-weight: 700; color: #4e73df; }
        

        .carousel-item {
            height: 450px; /* 높이를 키워서 시원하게 */
            background-color: #333;
            color: white;
            position: relative;
        }
        /* 슬라이드 1: 블루-퍼플  */
        .bg-gradient-1 { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        /* 슬라이드 2: 다크-네이비  */
        .bg-gradient-2 { background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%); }
        /* 슬라이드 3: 오렌지-핑크  */
        .bg-gradient-3 { background: linear-gradient(135deg, #ff9966 0%, #ff5e62 100%); }

        .carousel-caption {
            top: 50%; transform: translateY(-50%); bottom: auto; /* 수직 중앙 정렬 */
            text-shadow: 0 2px 10px rgba(0,0,0,0.3);
        }
        .hero-title { font-size: 3rem; font-weight: 700; margin-bottom: 20px; letter-spacing: -1px; }
        .hero-desc { font-size: 1.2rem; font-weight: 300; opacity: 0.9; margin-bottom: 30px; }
        .btn-hero { padding: 12px 35px; border-radius: 50px; font-weight: bold; font-size: 1.1rem; transition: transform 0.2s; }
        .btn-hero:hover { transform: scale(1.05); }

        /* 카드 공통 스타일 */
        .card { border: none; border-radius: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: transform 0.3s ease, box-shadow 0.3s ease; overflow: hidden; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        
        /* Top 5 섹션 */
        .top-card { background: white; border-left: 5px solid #ff6b6b; }
        .rank-badge { position: absolute; top: 10px; right: 10px; width: 30px; height: 30px; background: #ff6b6b; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; box-shadow: 0 3px 6px rgba(255, 107, 107, 0.4); }

        /* 게시글 리스트 */
        .board-card-img { height: 180px; object-fit: cover; background-color: #eee; }
        .placeholder-img { height: 180px; background: linear-gradient(45deg, #e0e0e0, #f5f5f5); display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 3rem; }
        .status-badge { font-size: 0.75rem; padding: 5px 10px; border-radius: 20px; }
        .status-접수 { background-color: #e2e6ea; color: #495057; }
        .status-완료 { background-color: #d4edda; color: #155724; }
        .category-label { color: #6c757d; font-size: 0.85rem; font-weight: 500; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Floating Action Button */
        .btn-floating { position: fixed; bottom: 30px; right: 30px; width: 60px; height: 60px; border-radius: 50%; background: #4e73df; color: white; display: flex; align-items: center; justify-content: center; font-size: 24px; box-shadow: 0 4px 15px rgba(78, 115, 223, 0.4); transition: all 0.3s; z-index: 1000; text-decoration: none;}
        .btn-floating:hover { background: #375a7f; transform: scale(1.1); color: white; }
    </style>
</head>
<body>

    <!-- 1. 네비게이션 바 -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="getBoardList.do"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item"><a class="nav-link active" href="getBoardList.do">홈</a></li>

                    
                    <!-- 로그인 안 했을 때 -->
                    <c:if test="${empty sessionScope.member}">
                        <li class="nav-item ms-2">
                            <a class="btn btn-primary px-4 rounded-pill shadow-sm fw-bold" 
                               href="login.do" 
                               style="background-color: #0d6efd !important; color: white !important; border: none;">
                                로그인
                            </a>
                        </li>
                    </c:if>

                    <!-- 로그인 했을 때 -->
                    <c:if test="${not empty sessionScope.member}">
                        <li class="nav-item ms-3">
                            <a href="myPage.do" class="text-decoration-none fw-bold text-dark me-2">
                                <i class="fa-solid fa-user-circle me-1 text-primary"></i>${sessionScope.member.name}님
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="/logout" class="btn btn-sm btn-light border rounded-pill px-3 ms-2">로그아웃</a>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>


    <div id="heroCarousel" class="carousel slide mt-5" data-bs-ride="carousel">
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
        </div>
        <div class="carousel-inner">
            <!-- 슬라이드 1 -->
            <div class="carousel-item active bg-gradient-1">
                <div class="carousel-caption">
                    <h1 class="hero-title">고객의 목소리로 성장합니다</h1>
                    <p class="hero-desc">여러분의 소중한 의견이 더 나은 서비스를 만듭니다.<br>지금 바로 건의사항을 남겨주세요.</p>
                    <a href="insertBoard.do" class="btn btn-light btn-hero text-primary shadow"> 의견 남기기 <i class="fa-solid fa-paper-plane ms-1"></i></a>
                </div>
            </div>
            <!-- 슬라이드 2 -->
			<div class="carousel-item bg-gradient-2">
			    <div class="carousel-caption">
			        <h1 class="hero-title">실시간 인기 이슈 Top 5</h1>
			        <p class="hero-desc">사용자들이 가장 원하는 기능이 무엇인지 확인해보세요.<br>투표를 통해 개발 우선순위를 결정합니다.</p>
			        
			       
			        <a href="getRankBoardList.do" class="btn btn-outline-light btn-hero border-2"> 
			            랭킹 확인하기 <i class="fa-solid fa-arrow-right ms-1"></i>
			        </a>
			        
			    </div>
			</div>
            <!-- 슬라이드 3 -->
            <div class="carousel-item bg-gradient-3">
                <div class="carousel-caption">
                    <h1 class="hero-title">고객과 직접 소통하는 서비스</h1>
                    <p class="hero-desc">성장을 위한 인사이트를 발견합니다<br>IT Service KIM이 함께합니다.</p>
                </div>
            </div>
        </div>
        <!-- 좌우 화살표 -->
        <button class="carousel-control-prev" type="button" data-bs-target="#heroCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#heroCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>

    <!-- 메인 콘텐츠 영역 -->
    <div class="container my-5">
        
        <!-- 3. Top 5 인기 제안 -->
        <div id="top5-section" class="d-flex align-items-center mb-3">
            <h4 class="fw-bold mb-0"><i class="fa-solid fa-fire text-danger me-2"></i>인기 게시글 Top 5</h4>
            <span class="badge bg-danger ms-2">HOT</span>
        </div>
        
        <div class="row flex-nowrap overflow-auto pb-3 mb-4" style="scrollbar-width: thin;">
            <c:forEach var="top" items="${topList}" varStatus="status">
                <div class="col-10 col-md-4 col-lg-3">
                    <div class="card top-card h-100 p-3 position-relative" onclick="location.href='getOneBoard.do?seq=${top.seq}'" style="cursor: pointer;">
                        <div class="rank-badge">${status.count}</div>
                        <h6 class="fw-bold mt-2 text-truncate">${top.title}</h6>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <small class="text-muted"><i class="fa-regular fa-user me-1"></i>${top.writer}</small>
                            <span class="text-danger fw-bold"><i class="fa-solid fa-heart me-1"></i>${top.voteCount}</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <hr class="my-5">

        <!-- 4. 사용자 게시판 (검색 & 리스트) -->
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h3 class="fw-bold">사용자 게시판</h3>
                <p class="text-muted small">총 ${bList.size()}건의 의견이 등록되었습니다.</p>
            </div>
            <div class="col-md-6">
                <form action="searchBoardList.do" method="get" class="d-flex shadow-sm rounded-pill overflow-hidden bg-white">
                    <select name="searchCon" class="form-select border-0 rounded-0" style="width: 120px; background-color: #f8f9fa;">
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                        <option value="writer">작성자</option>
                    </select>
                    <input type="text" name="searchKey" class="form-control border-0" placeholder="검색어를 입력하세요..." required>
                    <button type="submit" class="btn btn-primary rounded-0 px-4"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
            </div>
        </div>

        <!-- 카드형 게시글 리스트 -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:forEach var="board" items="${bList}">
                <div class="col">
                    <div class="card h-100" onclick="location.href='getOneBoard.do?seq=${board.seq}'" style="cursor: pointer;">
                        
                        <c:choose>
                            <c:when test="${not empty board.filename}">
                                <img src="${pageContext.request.contextPath}/upload/${board.filename}" class="card-img-top board-card-img" alt="attachment">
                            </c:when>
                            <c:otherwise>
                                <div class="placeholder-img rounded-top">
                                    <i class="fa-regular fa-image"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <span class="category-label text-primary">#${board.category}</span>
                                <span class="status-badge status-${board.status}">${board.status}</span>
                            </div>
                            <h5 class="card-title fw-bold text-truncate">${board.title}</h5>
                            <p class="card-text text-muted small text-truncate">${board.content}</p>
                        </div>
                        <div class="card-footer bg-white border-0 pt-0 pb-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <small class="text-muted">
                                    <i class="fa-regular fa-user me-1"></i>${board.writer}
                                </small>
                                <div class="text-secondary small">
                                    <span class="me-2"><i class="fa-solid fa-heart text-danger me-1"></i>${board.voteCount}</span>
                                    <span><i class="fa-regular fa-calendar me-1"></i>${board.regDate.substring(0,10)}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 5. 플로팅 글쓰기 버튼 -->
    <a href="insertBoard.do" class="btn-floating" title="새 글 작성">
        <i class="fa-solid fa-pen"></i>
    </a>

    <!-- Footer -->
    <footer class="text-center py-4 text-muted border-top mt-5 bg-white">
        <small>&copy; 2025 IT Service KIM Project. All rights reserved.</small>
    </footer>

    <!-- Bootstrap JS (이게 있어야 움직입니다!) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>