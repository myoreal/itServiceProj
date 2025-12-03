<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>새 건의사항 작성</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f8f9fa; }
        .write-container { max-width: 700px; margin: 100px auto; }
        .form-card { border: none; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); padding: 40px; background: white; }
    </style>
</head>
<body>

    <!-- 헤더 -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top bg-white border-bottom">
        <div class="container">
            <a class="navbar-brand fw-bold text-primary" href="getBoardList.do"><i class="fa-solid fa-rocket me-2"></i>IT Service KIM</a>
        </div>
    </nav>

    <div class="container write-container">
        <div class="form-card">
            <h3 class="fw-bold mb-4 text-center"> 새 글 등록</h3>
            
            <form action="insertBoardProc.do" method="post" enctype="multipart/form-data">
                
                <div class="row mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-bold small">분류</label>
                        <select name="category" class="form-select">
                            <option value="제안"> 기능 제안</option>
                            <option value="오류"> 버그/오류</option>
                            <option value="문의"> 기타 문의</option>
                        </select>
                    </div>
                    <div class="col-md-8">
                        <label class="form-label fw-bold small">작성자</label>
						<input type="text" name="writer" class="form-control" 
						                               value="${sessionScope.member.name}" readonly 
						                               style="background-color: #e9ecef; cursor: not-allowed;">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold small">제목</label>
                    <input type="text" name="title" class="form-control" placeholder="내용 입력" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold small">이미지 첨부 (선택)</label>
                    <input type="file" name="uploadFile" class="form-control" accept="image/*">
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold small">내용</label>
                    <textarea name="content" class="form-control" rows="8" placeholder="상세 내용을 자유롭게 작성해주세요." required></textarea>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <button type="button" class="btn btn-light px-4" onclick="history.back()">취소</button>
                    <button type="submit" class="btn btn-primary px-5 fw-bold">등록하기</button>
                </div>
            </form>
        </div>
    </div>

	<!-- Footer -->
	<footer class="text-center py-4 text-muted border-top mt-5 bg-white">
	    <small>&copy; 2025 IT Service KIM Project. All rights reserved.</small>
	</footer>
	
</body>
</html>