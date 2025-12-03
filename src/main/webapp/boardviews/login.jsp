<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<!-- ★★★ [추가] 로그인 실패 시 팝업 띄우는 스크립트 ★★★ -->
   <script>
       window.onload = function() {
           // 주소창의 ?error=... 부분을 읽어옵니다.
           const urlParams = new URLSearchParams(window.location.search);
           const error = urlParams.get('error');

           if (error) {
               let msg = '로그인에 실패했습니다.'; // 기본 메시지
               
               // 에러 종류별 메시지 설정
               if (error === 'invalid') {
                   msg = '아이디 또는 비밀번호가 일치하지 않습니다.';
               } else if (error === 'extract_fail') {
                   msg = '소셜 로그인 정보를 가져오는데 실패했습니다.';
               } else if (error === 'db_fail') {
                   msg = '로그인 처리 중 시스템 오류가 발생했습니다.';
               }
               
               // 팝업창 띄우기
               alert(msg);
               
               // (선택사항) 팝업 닫은 후 주소창에서 ?error 파라미터 지우기 (새로고침 시 또 뜨는 것 방지)
               const newUrl = window.location.pathname;
               window.history.replaceState({}, document.title, newUrl);
           }
       };
   </script>	
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

	<div class="login-card">
	        <a href="getBoardList.do" class="brand-logo"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>

	        <h5 class="fw-bold mb-4 text-center">로그인</h5>

	        <!-- ★★★ 로컬 로그인 폼 ★★★ -->
	        <form action="loginProc.do" method="post">
	            <div class="mb-3">
	                <input type="email" name="email" class="form-control rounded-pill px-3" placeholder="이메일 주소" required>
	            </div>
	            <div class="mb-3">
	                <input type="password" name="password" class="form-control rounded-pill px-3" placeholder="비밀번호" required>
	            </div>
	            <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold mb-3 py-2">로그인</button>
	        </form>
	        
	        <div class="text-center mb-4">
	            <small class="text-muted">계정이 없으신가요? <a href="signup.do" class="text-decoration-none fw-bold">회원가입</a></small>
	        </div>

	        <div class="divider">또는 소셜 로그인</div>

	        <!-- 소셜 로그인 버튼 -->
	        <a href="/oauth2/authorization/naver" class="btn-social btn-naver">
	            <i class="fa-solid fa-n me-2"></i> 네이버로 시작하기
	        </a>
	        <a href="/oauth2/authorization/kakao" class="btn-social btn-kakao">
	            <i class="fa-solid fa-comment me-2"></i> 카카오로 시작하기
	        </a>

	        <div class="text-center mt-4">
	            <a href="getBoardList.do" class="text-secondary small text-decoration-none"><i class="fa-solid fa-arrow-left me-1"></i> 메인으로 돌아가기</a>
	        </div>
	    </div>
	


</body>
</html>