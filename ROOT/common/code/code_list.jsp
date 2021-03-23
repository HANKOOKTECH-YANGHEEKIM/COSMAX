<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	//String page_no 			= requestMap.getString(CommonConstants.PAGE_NO);
	//String page_rowsize 		= requestMap.getString(CommonConstants.PAGE_ROWSIZE);

	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String action_code 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code 			= resultMap.getString(CommonConstants.MODE_CODE);

	String sel_uuid_path		= requestMap.getString("SEL_UUID_PATH");
	String parent_uuid 			= request.getParameter("parent_uuid");

	//-- 기타값 셋팅
	String schFieldCodestr 		= "NAME_KO|"+StringUtil.getLocaleWord("L.이름", siteLocale)+"^CODE|코드"+"^CODE_ID|코드아이디";

%>
<script type="text/javascript">
	/**
	 * 코드 정보 뷰 변경
	 */
	function changeCodeView(json) {


		var data = JSON.parse(json);
		document.form1.uuid.value 		= data.uuid;
		document.form1.code_id.value 	= data.code_id;

		document.getElementById("txtNamePath").innerHTML 	= airCommon.convertForView(data.name_path_ko);
		document.getElementById("txtCodeId").innerHTML 		= airCommon.convertForView(data.code_id);
		document.getElementById("txtCode").innerHTML 		= airCommon.convertForView(data.code);
		document.getElementById("txtLangCode").innerHTML 	= airCommon.convertForView(data.lang_code);
		document.getElementById("txtNameKo").innerHTML 		= airCommon.convertForView(data.name_ko);
		document.getElementById("txtNameEn").innerHTML 		= airCommon.convertForView(data.name_en);
		document.getElementById("txtNameJa").innerHTML 		= airCommon.convertForView(data.name_ja);
		document.getElementById("txtNameZh").innerHTML 		= airCommon.convertForView(data.name_zh);
		document.getElementById("txtMemoKo").innerHTML 		= airCommon.convertForView(data.memo_ko);
		document.getElementById("txtMemoEn").innerHTML 		= airCommon.convertForView(data.memo_en);
		document.getElementById("txtMemoJa").innerHTML 		= airCommon.convertForView(data.memo_ja);
		document.getElementById("txtMemoZh").innerHTML 		= airCommon.convertForView(data.memo_zh);
		document.getElementById("txtCodeAttr1").innerHTML	= airCommon.convertForView(data.code_attr1);
		document.getElementById("txtCodeAttr2").innerHTML	= airCommon.convertForView(data.code_attr2);
		document.getElementById("txtCodeAttr3").innerHTML	= airCommon.convertForView(data.code_attr3);
		document.getElementById("txtCodeAttr4").innerHTML	= airCommon.convertForView(data.code_attr4);
		document.getElementById("txtCodeAttr1Desc").innerHTML	= airCommon.convertForView(data.code_attr1_desc);
		document.getElementById("txtCodeAttr2Desc").innerHTML	= airCommon.convertForView(data.code_attr2_desc);
		document.getElementById("txtCodeAttr3Desc").innerHTML	= airCommon.convertForView(data.code_attr3_desc);
		document.getElementById("txtCodeAttr4Desc").innerHTML	= airCommon.convertForView(data.code_attr4_desc);
		document.getElementById("txtCodeData").innerHTML	= airCommon.convertForView(data.code_data);
		document.getElementById("txtOrderNo").innerHTML	= airCommon.convertForView(data.order_no);
		document.getElementById("txtStatusName").innerHTML 	= airCommon.convertForView(data.status_name_ko);
		document.getElementById("sel_uuid_path").value 	= airCommon.convertForView(data.uuid_path);

		//-- 시스템 전용 코드일 경우 수정/삭제 버튼 디스플레이 처리
		var btnModifyObj = document.getElementById("btnModify");
		var btnModify_childObj = document.getElementById("btnModify_child");
		var btnDeleteObj = document.getElementById("btnDelete");

		if (data.status_code == "S") {
			btnModifyObj.style.display = "";
			btnModify_childObj.style.display = "";
			btnDeleteObj.style.display = "none";
		} else {
			btnModifyObj.style.display = "";
			btnModify_childObj.style.display = "";
			btnDeleteObj.style.display = "";
		}
	}

	/**
	 * 신규작성 페이지로 이동
	 */
	function goWrite(frm) {
		frm.action = "/ServletController";
		frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_FORM";
		frm.submit();
	}

	/**
	 * 수정 페이지로 이동
	 */
	function goModify(frm,update_mode) {
		if (frm.uuid.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.수정할코드정보", siteLocale))%>");
			return;
		}
		frm.update_mode.value = update_mode;
		frm.action = "/ServletController";
		frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_FORM";
		frm.submit();
	}

	/**
	 * 삭제 페이지로 이동
	 */
	function goDelete(frm) {
		if (frm.uuid.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.삭제할코드정보", siteLocale))%>");
			return;
		}

		if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT",siteLocale, StringUtil.getLocaleWord("L.선택하신코드및하위코드정보를완전히삭제", siteLocale))%>")) {
			airCommon.showBackDrop();
			frm.<%=CommonConstants.MODE_CODE%>.value = "DELETE";
			$.ajax({
	            url: "/ServletController"
            	, type: "POST"
				, dataType: "json"
	            , data: $("#form1").serialize()
			})
			.done(function(data) {
	            alert("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT_DONE",siteLocale)%>");
	            $("#treeArea").html("");
	            drawTree();
				airCommon.hideBackDrop();
			})
	        .fail(function() {
	        	alert("오류");
	            //승인처리 도중 에러가 발생했습니다.
				airCommon.hideBackDrop()
<%-- 		            alert("<%=StringUtil.getScriptMessage("M.처리중오류발생관리자문의하세요",siteLocale, StringUtil.getLocaleWord("L.승인처리", siteLocale))%>"); --%>
	        });
		}
	}

	var doSearch = function(isCheckEnter) {
		if (isCheckEnter && event.keyCode != 13) {
			return;
		}
		if($("#schValue").val() != ""){
			$("#treeArea").html("");
			treeDrawChild("treeArea","", airCommon.getSearchQueryParams(document.schForm));
		}else{
			$("#treeArea").html("");
			treeDrawChild("treeArea","null","");
		}
	}

	var selectNode = function(code_id){
		var codGrp = $("#"+code_id);
		var obj = codGrp.children("input:hidden");
		var jsonData = "";
		$(obj).each(function(i, d){
			if(i > 0){jsonData+=",";}
			jsonData+= $(this).attr("name")+":\""+$(this).val()+"\"";
		});
		eval("var data ={"+jsonData+"}");

		changeCodeView(JSON.stringify(data));

	};
	var drawTree = function(){
		var arrDEPTH = [];
		if($("#sel_uuid_path").val() != ""){
			arrDEPTH = $("#sel_uuid_path").val().split("≫");
		}
		//tree 불러오 air-action, air-mode 값 셋팅
		treeInitSet("SYS_CODE","JSON_TREE_DATA","CODE",JSON.stringify(arrDEPTH),'');

		//그려넣을 id, 루트id, 최종
	    treeDrawChild("treeArea","null");
	}
	$(function(){
		drawTree();
	});

</script>



	<table class="none">
	<colgroup>
		<col width="48%" />
		<col width="4%" />
		<col width="48%" />
	</colgroup>
	<tr>
		<td valign="top">
			<br>
				<form name="schForm" id="schForm" method="post" onSubmit="return false;">
				<div class="table_cover">
					<table class="box">
						<colgroup>
							<col width="15%" />
							<col width="65%" />
							<col width="20%" />
						</colgroup>
						<tr>
							<th width="15%"><%=HtmlUtil.getSelect(request,  true, "schField", "schField", schFieldCodestr, "", "class=\"select\" data-type=\"search\"")%></th>
							<td width="65%">
								<input type="text" name="schValue" id="schValue" value="" data-type="search"  class="text width_max" onkeydown="doSearch(true)" />
							</td>
							<td class="hbuttons">
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
					</table>
				</div>
				</form>
				<br>
<!-- // 코드 정보 트리 // -->
<%-- 			<iframe name="iframeCodeTreeList" frameborder="0" width="480" height="580" scrolling="no" src="<%=iframeCodeTreeListSrc.toString()%>"></iframe> --%>
			<div id="treeArea" class="treeCodeArea"></div>
		</td>
		<td></td>
		<td valign="top">
		<form name="form1" id="form1" method="post">
			<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
			<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
			<input type="hidden" name="uuid" />
			<input type="hidden" name="update_mode" />
			<input type="hidden" name="code_id" />
			<div class="table_cover">
			<table class="basic">
				<caption><span id="txtNamePath"></span></caption>
				<colgroup>
					<col width="25%" />
					<col width="75%" />
				</colgroup>
				<tr>
					<th>코드 아이디</th>
					<td><span id="txtCodeId"></span> <input type="hidden" name="sel_uuid_path" id="sel_uuid_path" value="<%=sel_uuid_path%>"/></td>
				</tr>
				<tr>
					<th>코드</th>
					<td><span id="txtCode"></span></td>
				</tr>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.다국어코드", siteLocale) %></th>
					<td><span id="txtLangCode"></span></td>
				</tr>
				<tr>
					<th>코드 이름<br />(한국어)</th>
					<td><span id="txtNameKo"></span></td>
				</tr>
				<tr>
					<th>코드 이름<br />(영어)</th>
					<td><span id="txtNameEn"></span></td>
				</tr>
				<tr>
					<th>코드 이름<br />(일어)</th>
					<td><span id="txtNameJa"></span></td>
				</tr>
				<tr>
					<th>코드 이름<br />(중어)</th>
					<td><span id="txtNameZh"></span></td>
				</tr>
				<tr>
					<th>코드 설명<br />(한국어)</th>
					<td><span id="txtMemoKo"></span></td>
				</tr>
				<tr>
					<th>코드 설명<br />(영어)</th>
					<td><span id="txtMemoEn"></span></td>
				</tr>
				<tr>
					<th>코드 설명<br />(일어)</th>
					<td><span id="txtMemoJa"></span></td>
				</tr>
				<tr>
					<th>코드 설명<br />(중어)</th>
					<td><span id="txtMemoZh"></span></td>
				</tr>
				<tr>
					<th>코드 속성값1</th>
					<td><span id="txtCodeAttr1"></span></td>
				</tr>
				<tr>
					<th>코드 속성값2</th>
					<td><span id="txtCodeAttr2"></span></td>
				</tr>
				<tr>
					<th>코드 속성값3</th>
					<td><span id="txtCodeAttr3"></span></td>
				</tr>
				<tr>
					<th>코드 속성값4</th>
					<td><span id="txtCodeAttr4"></span></td>
				</tr>
				<tr>
					<th>코드 속성값1</th>
					<td><span id="txtCodeAttr1Desc"></span></td>
				</tr>
				<tr>
					<th>코드 속성값2</th>
					<td><span id="txtCodeAttr2Desc"></span></td>
				</tr>
				<tr>
					<th>코드 속성값3</th>
					<td><span id="txtCodeAttr3Desc"></span></td>
				</tr>
				<tr>
					<th>코드 속성값4</th>
					<td><span id="txtCodeAttr4Desc"></span></td>
				</tr>
				<tr>
					<th>코드 Data</th>
					<td><span id="txtCodeData"></span></td>
				</tr>
				<tr>
					<th>정렬순서</th>
					<td><span id="txtOrderNo"></span></td>
				</tr>
				<tr>
					<th>코드 상태</th>
					<td><span id="txtStatusName"></span></td>
				</tr>
			</table>
			</div>

<%-- 버튼 목록 --%>
			<div class="buttonlist">
				<span class="ui_btn medium icon" id="btnWrite"><span class="write"></span><a href="javascript:void(0)" onclick="goWrite(document.form1);"><%=StringUtil.getLocaleWord("B.WRITE",siteLocale)%></a></span>
				<span class="ui_btn medium icon" id="btnModify" style="display:none;"><span class="modify"></span><a href="javascript:void(0)" onclick="goModify(document.form1,'');"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
				<span class="ui_btn medium icon" id="btnModify_child" style="display:none;"><span class="modify"></span><a href="javascript:void(0)" onclick="goModify(document.form1,'CHILD');">하위코드수정</a></span>
				<span class="ui_btn medium icon" id="btnDelete" style="display:none;"><span class="delete"></span><a href="javascript:void(0)" onclick="goDelete(document.form1);"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
			</div>
			</form>
		</td>
	</tr>
	</table>
