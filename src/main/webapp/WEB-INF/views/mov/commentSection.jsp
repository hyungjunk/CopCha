<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<html>
<head>
<style>
table { table-layout: fixed; }
table th, table td { overflow: hidden; }
td {
	white-space:pre
} 
</style>
</head>
<body>
<div class="container">
<br>

<ul id="comments" class="list-group">
<script id="commentTemplate" type="text/x-handlebars-template">
	{{#each .}}
	  <li class="list-group-item d-flex justify-content-between align-items-center">
		  <div class="row w-100">
		  	<div class="col-2" name="uid">{{uid}}</div>
		  	<div class="col-8" name="ucomment">{{ucomment}}</div>
		  	<div class="col-2" name="regdate">{{prettifyDate regdate}}</div>
		  </div>
			<button type="button" class="btn" onclick="modifyComment()">Modify</button> 
			<button type="button" class="btn" onclick="deleteComment()">Delete</button> 
	    <span class="badge badge-primary badge-pill">14</span>
	  </li>
	{{/each }}
</script>
</ul>

<div class="input-group">
	<button id="openForm" class="btn btn-info" data-toggle="collapse" data-target="#openNew">Add</button>&nbsp;
	<button id="golist" type="button" class="btn btn-success">List</button>
</div>

<nav>
  <ul class="pagination justify-content-center">
    <li class="page-item ${pageMaker.startPage==1?'disabled':'' }"/>
      <a class="page-link">Previous</a>
    </li>
    <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="page">
		<li data-page="paging" class="page-item">
		<a class="page-link" onclick="getCommentPage(${page})"> ${page}</a>
		</li>
	</c:forEach>
    <li class="page-item ${pageMaker.endPage==pageMaker.startPage+4?'':'disabled'}">
      <a class="page-link">Next</a>
    </li>
  </ul>
</nav>

<div id="openNew" class="collapse bg-light">
	<!-- <form id="addForm" action="/mov/comment/post" method="POST"> -->
		<div class="form-group">
			<input id="cid" type="hidden">
	  		<label for="name">Name</label>
			<input id="uid" class="form-control" name="uid" type="text" style="width:50%">
		</div>
		<div class="form-group">
			<label for="reply">Your comment</label>
			<input id="ucomment" name="ucomment" class="form-control" type="text" style="width:50%">
		</div>
	<!-- </form> -->
	<button id="sendForm" type="submit" class="btn btn-info" onclick="addComment()">Send</button>
	<button id="cancel" type="button" class="btn btn-warning" data-toggle="collapse" data-target="#openNew">Cancel</button>
</div>
<div class="bottom"></div>
</div>
</body>

<script>
/* 코멘트 등록 폼 노출 */
$("#openForm").click(function() {
    $('html,body').animate({
    	scrollTop: $(".bottom").offset().top}, 
    	'slow');
});

var formObj = $("#addForm");
$("#sendForm").on("click", function(){
	formObj.submit();
});

/* 코멘트 등록 */
function addComment(){
	var cid = $("#cid").val();
	var uid = $("#uid").val();
	var ucomment = $("#ucomment").val();
	$.ajax({
		type: "post",
		url: "/mov/comment/post",
		headers : {"Content-Type" : "application/json"},
		data: JSON.stringify({
			cid: cid,
			uid: uid,
			ucomment: ucomment
		}),
		success: function(data){
			alert("성공했습니다");
			getCommentPage(1);
		},
		error: function(data){
			alert("실패했습니다");
		}
	})
}

/* 코멘트 수정 */
function modifyComment(cid){
	console.log(page);
	var cid = 1;
	var uid = "Jun";
	var ucomment = "hello~~";
	$.ajax({
		type: "post",
		url: "/mov/comment/"+cid,
		headers: {"Content-Type" : "application/json"},
		data: JSON.stringify({
			cid: cid,
			uid: uid,
			ucomment : ucomment
		}),
		success : function(data){
			if (data=="SUCCESS"){
				alert("수정 완료되었습니다");
				getCommentPage(page);
			} else{
				alert("수정에 실패했습니다.");
			}
		},
		error : function(data){
			alert("서버로부터 응답이 없습니다.");
		}
	})
};
/* 코멘트 삭제 */
function deleteComment(){
	console.log(page);
	var cid = 1;
	$.ajax({
		type: "delete",
		url: "/mov/comment/"+cid,
		success: function(data){
			if (data=="SUCCESS"){
				alert("삭제 완료");
				getCommentPage(page);
			} else{
				alert("삭제 실패");
			}			
		},
		error : function(data){
			alert("서버로부터 응답이 없습니다.");
		}
	})
}


/* 코멘트 Read, 페이징 관련 */
getCommentPage(1);
var commentTemplate = $("#commentTemplate").html();
function getCommentPage(page){
	window.page = page;
	var perPageNum = 5;
	$.get("/mov/comment/" + page, function(data){
		var template = Handlebars.compile(commentTemplate);
		$("#comments").html(template(data));
	})
};

$("li[data-page]").on("click", function(){
	$("li[data-page]").removeClass("active");
	$(this).addClass("active");
});

Handlebars.registerHelper("prettifyDate", function(timeValue){
	var dateObj = new Date(timeValue);
	var year = dateObj.getFullYear();
	var month = dateObj.getMonth() + 1;
	var date = dateObj.getDate();
	return year+"/"+month+"/"+date;
})


</script>
</html>
