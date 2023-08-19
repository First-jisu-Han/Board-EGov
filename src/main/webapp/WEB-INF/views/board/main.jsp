<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Board Toy</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  
  <script type="text/javascript">

   $(document).ready(function(){
        loadList(); 
});
  
  function loadList(){ 

    $.ajax({
        url : "boardList.do",
        type : "post", 
        dataType :"json",
        success : makeView, 
        error : function(){ alert("error");   }
     }); 
    
};
   function makeView(data){
	   var listElement="<table class='table table-bordered'>"; 
	   listElement+="<tr>";
	   listElement+="<td>번호</td>";
	   listElement+="<td>제목</td>";
	   listElement+="<td>작성자</td>";
	   listElement+="<td>작성일</td>";
	   listElement+="<td>조회수</td>";
	   listElement+="<tr>";

	   $.each(data,function(index,obj){
		   listElement+="<tr>";
		   listElement+="<td>"+obj.idx+"</td>";
		   listElement+="<td id='title"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</td>";
		   listElement+="<td>"+obj.writer+"</td>";
		   listElement+="<td>"+obj.indate+"</td>";
		   listElement+="<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
		   listElement+="</tr>";
		   
		   listElement+="<tr id='seq"+obj.idx+"' style='display:none'>"; // 리스트에서 안보이게  
		   listElement+="<td>내용</td>";
		   listElement+="<td colspan='4'>"; 
		   listElement+="<textarea id='frmTA"+obj.idx+"' rows='7' class='form-control' readonly='true'>"+obj.content+"</textarea>";   
		   listElement+="<br/>";
		   listElement+="<span id='updt"+obj.idx+"'><button class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정 화면</button></span>&nbsp;";
		   listElement+="<button class='btn btn-warning btn-sm' onclick='dltContent("+obj.idx+")'>삭제</button>";
		   listElement+="</td>"; 
		   listElement+="</tr>"; 
	   });
	   
	   listElement+="<tr>"; 
	   listElement+="<td colspan='5'>";
	   listElement+="<button class='btn btn-primary btn-sm' onclick='makeForm()'>글쓰기</button>";
	   listElement+="</td>";
	   listElement+="</tr>";
	   listElement+="</table>"
	  
	  
	   // html에 data 넣어서 html 그리기 
	   $("#listElements").html(listElement); 
	   
	   $("#listElements").css("display","blcok"); 
	   $("#makeContent").css("display","none");
   }
   
   function makeForm(){
	   $("#listElements").css("display","none"); // 글쓰기 버튼 누르면 id=makeContent 바디의 html을 나타내도록 리스트 가리기 
	   $("#makeContent").css("display","block"); // 글쓰기 버튼 누르면 폼으로 교체됨. 
   }
   
   // makeForm 로직을 반대로 
   function goBackList(){
	   $("#listElements").css("display","block");
	   $("#makeContent").css("display","none");

   }
   function goInsert(){
	   
	   var fData=$("#frm").serialize(); // 글정보 데이터 한꺼번에 직렬화
	   
	   // 성공시, loadList() 
	   $.ajax({
		   url: "boardInsert.do",
		   type: "post",
		   data: fData,
		   success: loadList,
		   error: function() {alert("error");}
	   });
	   
	   
	   $("#fclear").trigger("click");
	   location.reload();
   };
   
   // 리스트에서 표출  
   function goContent(idx){
	   // 클릭시 보였다가 안보였다가 하도록 
	   if($("#seq"+idx).css("display")=="none"){
		   
		   $.ajax({
			   url : "boardContent.do",
			   type : "get", 
			   data : {"idx": idx } ,
			   dataType : "json",
			   success : function(data){
				   $("#frmTA"+idx).val(data.content); 
			   },
			   error : function(){alert("error");}
		   });  // 내용 가져오기  
		   
		   
		   $("#seq"+idx).css("display","table-row");
		   $("#frmTA"+idx).attr("readonly",true); 
	   } else {
		   
		   $("#seq"+idx).css("display","none"); // 보이지 않게 클릭 
		   
		   $.ajax({
			   url : "boardCount.do",
			   type : "get", 
			   data : {"idx" : idx } ,
			   dataType : "json",
			   success : function(data){
				   $("#cnt"+idx).html(data.count);
			   }, 
			   error : function(){alert("error");}
		   });  // 내용 가져오기  
		   
	   }
   }
   
   // 글 삭제 
   function dltContent(idx){
	   $.ajax({
		  url : "boardDelete.do" , 
		  type : "get", 
		  data : {"idx" : idx}, 
		  success : loadList , 
		  error : function(){ alert("error") }
	   });
   } 

   // 글 수정 허용  
   function goUpdateForm(idx){
	   $("#frmTA"+idx).attr("readonly",false);  // 내용 수정 
	   var title= $("#title"+idx).text();  // 원래 제목 

	   var updateElements = "<input type='text' id='mtitle"+idx+"' class='form control' value='"+title+"'/>"; // 수정할 제목 
	   $("#title"+idx).html(updateElements);
	   
	   // 수정화면 -> 수정으로 변경 
	   var newButton="<button class = 'bnt btn-info btn-sm' onclick='updateContent("+idx+")'>수정</button>"; 
	   $("#updt"+idx).html(newButton); 
   };
   
   // 내용 , 제목 수정 
   function updateContent(idx){
	   var utitle = $("#mtitle"+idx).val(); 
	   var ucontent = $("#frmTA"+idx).val();
	   
	   $.ajax({
		   url : "boardUpdate.do" , 
		   type : "post" ,
		   contentType : 'application/json;charset=utf-8',  // 넘기는 json 데이터 인코
		   data : JSON.stringify( { "idx" : idx, "title" : utitle ,"content" : ucontent } ) ,  // json 으로 넘기기
		   success : loadList, 
		   error : function(){ alert ("error");}
	   });
   }
   
  </script>

</head>
<body>
<jsp:include page="../common/header.jsp"/>
<div class="container">
  <h2>Board Toy</h2>
  <div class="panel panel-default">
    <div class="panel-heading">게시판</div>
   
   
  <div class="panel-body" id="listElements">Content</div>
    

  <div class="panel-body " id="makeContent" style="display:none" > 
   <form id="frm">
     <table class="table">
    <tr>
      <td>제목</td>
      <td><input type="text" id="title" name="title" class="form-control"/></td>
    <tr>  
      <td>내용</td>
      <td><textarea rows="7" class="form-control" id="content" name="content"></textarea></td>
    </tr>
    <tr>  
      <td>작성자</td>
      <td><input type="text" id="writer" name="writer" class="form-control"/></td>
    </tr>

    <tr>
    <td colspan="2" align="center">
        <button type="submit" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
        <button type="reset" class="btn btn-warning btn-sm" id="fclear">취소</button>
        <button type="button" class="btn btn-info btn-sm" onclick="goBackList()">리스트로 가기</button>
    </td>
    </tr>
    </table>
   </form>    
    </div>   
    <div class="panel-footer">게시판_토이프로젝트</div>
 </div>
</div>

</body>
</html>