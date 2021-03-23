<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	SQLResults LMS_GBN 	= resultMap.getResult("LMS_GBN");
	SQLResults AUTH_CODES = resultMap.getResult("AUTH_CODES");
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String schLmsGbnStr = StringUtil.getCodestrFromSQLResults(LMS_GBN, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String lmsGbnStr = StringUtil.getCodestrFromSQLResults(LMS_GBN, "CODE_ID,LANG_CODE", "");
	String schAuthStr = StringUtil.getCodestrFromSQLResults(AUTH_CODES, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userAuthStr = StringUtil.getCodestrFromSQLResults(AUTH_CODES, "CODE,LANG_CODE", "");
	
%>
<script type="text/javascript">
	 /**
	  * 검색 수행
	  */ 
	 function doSearch(isCheckEnter) {
		 getLmsDefDocStuOut(isCheckEnter);
	 }
	 
	//--- 상태 추가 처리 및 저장 처리 
	var goAddStu = function(isCheckEnter){
		
		if (isCheckEnter && event.keyCode != 13) {         
	         return;
	     }
		if ("" == $("#form_no").val() ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"폼 ID")%>");
			$("#form_no").focus();
		    return false;	
		}
		if ($("input:radio[name='auth_cd']:checked").length == 0 ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"권한자")%>");
			$("input:radio[name='auth_cd']").eq(0).focus();
		    return false;	
		}
		if ("" == $("#stu_id").val() ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"대상상태")%>");
			$("#stu_id").eq(0).focus();
		    return false;	
		}
		var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.ADD")%>";
		if(confirm(msg)){
			var data = $("#saveForm").serialize();
			airCommon.callAjax("<%=actionCode%>", "WRITE_OUT_PROC",data, function(json){
// 				document.saveForm.reset();
				getLmsDefDocStuOut();
			});
		}
	}
	
</script>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui.js"></script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>"value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="munseo_seosig_no" />
	<input type="hidden" name="munseo_seosig_nam" />
	<input type="hidden" name="parent_code_id" />
	<input type="hidden" name="status_gbn" />
	<table class="box">
	<tr>
		<td class="corner_lt"></td>
		<td class="border_mt"></td>
		<td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">
			<table>
				<colgroup>
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:auto" />
				</colgroup>
				<tr>				
					<th>법무구분</th>						
					<td >
						<%=HtmlUtil.getSelect(request, true, "STU_GBN", "STU_GBN", schLmsGbnStr, "", "class=\"select\" data-type=\"search\" style='width:100%;'") %>
					</td>
					<th>상태코드</th>					
					<td><input type="text" name="STU_ID" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<th>상태명</th>					
					<td><input type="text" name="STU_BASE_NM" value="" data-type="search" class="text" onkeydown="doSearch( true)" style="width:97%;" /></td>
					<td rowspan="3" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="getLmsDefDocStuOut();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>
					<th >지정메일여부</th>
					<td>
						<%=HtmlUtil.getSelect(request, true, "JIJUNG_YN", "JIJUNG_YN", "|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale)+"^Y|Yes^N|No", "", "class=\"select\" data-type=\"search\" style='width:100%;'") %>
					</td>
					<th>순번</th>					
					<td colspan="3">
						<input type="text" name="ORD_SEQ_GTEQ" value="" data-type="search" onkeydown="doSearch(true)" class="text" style="width:30%" />
						~ 
						<input type="text" name="ORD_SEQ_LTEQ" value="" data-type="search" onkeydown="doSearch(true)" class="text" style="width:30%" />
					</td>	
				</tr>
		</table>
	</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td>
		<td class="border_mb"></td>
		<td class="corner_rb"></td>
	</tr>							
	</table>
</form>	
	<br/>
	<br/>
	<br/>
	<!--
	{
		"type":"onBlur"
		,"href":"goModStr(false,\"@{UUID}\",this)"
	},
	  -->
<table class="list" id="LmsDefDocStuRelTable">
	<thead>
	<tr>
<!-- 		<th style="width:5%" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"STU_UID"}'>No.</th> -->
		<th style="width:10%" data-opt='{"align":"center","col":"STU_GBN_NM"}'>법무구분</th>
		<th style="width:10%" data-opt='{"align":"center","col":"PROC_GBN"}'>처리형식</th>
		<th style="width:25%" data-opt='{"align":"center","col":"STU_ID"}'>상태코드</th>
		<th style="width:auto" data-opt='{"align":"left","col":"STU_BASE_NM"}'>기본상태명</th>
		<th style="width:8%" data-opt='{"align":"center","col":"JIJUNG_YN"}'>지정메일여부</th>
		<th style="width:65px" data-opt='{"align":"center","html":{"type":"BTN","class":"write","callback":"setMail(\"@{STU_UID}\")","title":"<%=StringUtil.getLocaleWord("L.지정",siteLocale)%>"}}'></th>
	</tr>
	</thead>
	<tbody id="LmsDefDocStuRelTableBody"></tbody>
</table>
<%-- 페이지 목록 --%>
<!-- <div class="pagelist" id="LmsDefDocStuRelTablePage"></div>  -->
<script>

var setMail = function(stu_uid){

	var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=WRITE_FORM";
	url += "&stu_uid="+stu_uid;
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM"+stu_uid, "yes", "yes", "");	
	
}

var getLmsDefDocStuOut = function(isCheckEnter){
	
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	var data = airCommon.getSearchQueryParams();
	  
	airCommon.callAjax("LMS_DEF_STU", "JSON_LIST",data, function(json){
	  airCommon.createTableRow("LmsDefDocStuRelTable", json);
	});
};

$(function(){
	getLmsDefDocStuOut();
})
</script>