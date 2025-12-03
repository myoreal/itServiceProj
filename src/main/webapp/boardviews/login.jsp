<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인 - IT Service VOC</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            background: white;
            padding: 40px 30px;
        }
        .brand-logo {
            font-size: 24px;
            font-weight: 700;
            color: #4e73df;
            margin-bottom: 30px;
            text-decoration: none;
            display: block;
            text-align: center;
        }
        .btn-social {
            width: 100%;
            padding: 12px;
            border-radius: 50px;
            font-weight: 600;
            margin-bottom: 15px;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: transform 0.2s;
        }
        .btn-social:hover {
            transform: translateY(-2px);
            opacity: 0.95;
        }
        .btn-naver {
            background-color: #03C75A;
            color: white;
        }
        .btn-kakao {
            background-color: #FEE500;
            color: #3c1e1e;
        }
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 20px 0;
            color: #adb5bd;
            font-size: 14px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #dee2e6;
        }
        .divider::before { margin-right: .5em; }
        .divider::after { margin-left: .5em; }
    </style>
</head>
<body>

    <div class="login-card text-center">
        <!-- 로고 -->
        <a href="getBoardList.do" class="brand-logo">
            <i class="fa-solid fa-rocket me-2"></i>IT Service KIM
        </a>

        <h5 class="fw-bold mb-4">로그인</h5>
        <p class="text-muted small mb-4">서비스 이용을 위해 로그인해주세요.</p>

        <!-- 소셜 로그인 버튼들 -->
        <a href="/oauth2/authorization/naver" class="btn-social btn-naver">
            <i class="fa-solid fa-n me-2"></i> 네이버로 시작하기
        </a>

        <a href="/oauth2/authorization/kakao" class="btn-social btn-kakao">
            <i class="fa-solid fa-comment me-2"></i> 카카오로 시작하기
        </a>

        <div class="divider">또는</div>

        <a href="getBoardList.do" class="text-secondary small text-decoration-none">
            <i class="fa-solid fa-arrow-left me-1"></i> 메인으로 돌아가기
        </a>
    </div>

</body>
</html>