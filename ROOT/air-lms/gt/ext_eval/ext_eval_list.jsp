<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String pageNo = requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	String	 sol_mas_uid =  requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String	 gbn		 =  requestMap.getString("GBN");
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0)lmsMap.putAll(LMS_MAS.getRowResult(0));
	boolean isAuths = false;
	if(loginUser.getLoginId().equals(lmsMap.getString("YOCHEONG_ID")) ||
			loginUser.getLoginId().equals(lmsMap.getString("DAMDANG_ID")) ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
	
	if("SS".equals(gbn) && loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	
	}else if(loginUser.isUserAuth("LMS_BCD")){
		isAuths = true;
		
	}
%>
<form name="extEvalForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
</form>
<table class="list" id="TB_EXT_EVAL<%=sol_mas_uid%>">
	<caption>
		<span class="left" style="color:darkred;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
		<span class="right">
<%-- 	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewExtEvalWrite();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span> --%>
		</span>
	</caption>
	<thead>
	<tr data-opt='{"onClick":"goDetailExtEval<%=sol_mas_uid%>(\"@{GT_EXT_EVAL_UID}\",\"@{BYEONHOSA_ID}\",\"@{BYEONHOSA_NAM}\",\"@{EXT_EVAL}\")"}'>
<!-- 		<th style="width:5%" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"GT_EXT_UID;SOL_MAS_UID"}'>No.</th> -->
		<th style="width:15%" data-opt='{"align":"center","col":"SOSOG_NAM"}'><%=StringUtil.getLocaleWord("L.소속", siteLocale) %></th>
<%-- <th style="width:12%" data-opt='{"align":"center","col":"BYEONHOSA_NAM"}'><%=StringUtil.getLocaleWord("L.변호사명", siteLocale) %></th> --%>
		<th style="width:12%" data-opt='{"align":"center","col":"BYEONHOSA_NAM"}'><%=StringUtil.getLocaleWord("L.변호사명", siteLocale) %></th>
		<th style="width:8%" data-opt='{"align":"center","col":"EXT_EVAL"}'><%=StringUtil.getLocaleWord("L.평가결과", siteLocale) %></th>
		<th style="width:*" data-opt='{"align":"left","col":"EXT_EVAL_MEMO"}'><%=StringUtil.getLocaleWord("L.평가의견", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"EXT_EVAL_NAM"}'><%=StringUtil.getLocaleWord("L.평가자", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"EXT_EVAL_DTE"}'><%=StringUtil.getLocaleWord("L.평가일", siteLocale) %></th>
	</tr>
	</thead>
	<tbody id="TB_EXT_EVAL<%=sol_mas_uid%>Body"></tbody>
</table>
<%-- 페이지 목록 --%>
<%-- <div class="pagelist" id="TB_EXT_EVAL<%=sol_mas_uid%>Page"></div>  --%>
<script>
var goDetailExtEval<%=sol_mas_uid%> = function(GT_EXT_EVAL_UID, BYEONHOSA_ID, BYEONHOSA_NAM, EXT_EVAL){
<%if(isAuths){ %>
	if(EXT_EVAL == ""){
		goNewExtEvalWrite<%=sol_mas_uid%>(GT_EXT_EVAL_UID, BYEONHOSA_ID, BYEONHOSA_NAM);
	}else{
// 		goVeiw();
		goNewExtEvalWrite<%=sol_mas_uid%>(GT_EXT_EVAL_UID, BYEONHOSA_ID, BYEONHOSA_NAM);
	}
<%} %>
}
var goNewExtEvalWrite<%=sol_mas_uid%> = function(GT_EXT_EVAL_UID, BYEONHOSA_ID, BYEONHOSA_NAM){
<%--
	var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	url += "&GT_EXT_EVAL_UID="+GT_EXT_EVAL_UID;	
	url += "&id="+BYEONHOSA_ID;
	url += "&nam="+encodeURIComponent(BYEONHOSA_NAM); 
	
	airCommon.openWindow(url, "1024", "350", "POPUP_WRITE_FORM", "yes", "yes", "");
--%>
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")

	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='GT_EXT_EVAL_UID'>").val(GT_EXT_EVAL_UID));
	imsiForm.append($("<input type='hidden' name='id'>").val(BYEONHOSA_ID));
	imsiForm.append($("<input type='hidden' name='nam'>").val(BYEONHOSA_NAM));
	
	airCommon.openWindow("", "1024", "250", "POPUP_WRITE_FORM_"+GT_EXT_EVAL_UID, "yes", "yes", "");	
	
	imsiForm.attr("target","POPUP_WRITE_FORM_"+GT_EXT_EVAL_UID);
	imsiForm.appendTo("body");
	
	imsiForm.submit();
	
	imsiForm.remove();
};

var goExtEvalDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	data["gt_memo_uid"] = uuid;
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getLmsGtExtEval<%=sol_mas_uid%>(1);
		});
	}
};

var getLmsGtExtEval<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.extEvalForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		airCommon.createTableRow("TB_EXT_EVAL<%=sol_mas_uid%>", json);
	});
};

$(function(){
	getLmsGtExtEval<%=sol_mas_uid%>(1);
});
</script>