<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원가입 - IT Service KIM</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .signup-card { width: 100%; max-width: 400px; border: none; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); background: white; padding: 40px 30px; }
    </style>
</head>
<body>

    <div class="signup-card">
        <h4 class="fw-bold mb-4 text-center">회원가입</h4>
        
        <form action="signupProc.do" method="post">
            <div class="mb-3">
                <label class="form-label small fw-bold">이메일</label>
                <input type="email" name="email" class="form-control rounded-pill px-3" required>
            </div>
            <div class="mb-3">
                <label class="form-label small fw-bold">비밀번호</label>
                <input type="password" name="password" class="form-control rounded-pill px-3" required>
            </div>
            <div class="mb-4">
                <label class="form-label small fw-bold">이름 (닉네임)</label>
                <input type="text" name="name" class="form-control rounded-pill px-3" required>
            </div>
            <button type="submit" class="btn btn-primary w-100 rounded-pill fw-bold py-2 mb-3">가입하기</button>
        </form>
        
        <div class="text-center">
            <a href="login.do" class="text-decoration-none small">이미 계정이 있으신가요? 로그인</a>
        </div>
    </div>

</body>
</html>