<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
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
	String	 gbn = requestMap.getString("GBN");
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
	
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
<form name="workContForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
<%-- 	<input type="hidden" data-type="search" name="<%=CommonConstants.PAGE_ROWSIZE%>" id="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" /> --%>
</form>
<table class="list" id="TB_WORKCONT<%=sol_mas_uid%>">
	<caption>
		<span class="left" style="color:darkred;"><%="SS".equals(requestMap.getString("GBN")) ? "※ 본 탭은 법무팀만 볼 수 있습니다." : ""  %></span>
		<span class="right">
		<%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goWorkContWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
		<%} %>
		</span>
	</caption>
	<thead>
<!-- 	<tr data-opt='{"onClick":"goWorkContView(\"@{WORK_CONT_UID}\",\"@{SOL_MAS_UID}\")"}'> -->
	<tr>
		<th style="width:15%" data-opt='{"align":"center","col":"WORK_NO"}'><%=StringUtil.getLocaleWord("L.업무연락번호", siteLocale) %></th>
		<th style="width:15%" data-opt='{"align":"center","col":"GWANRI_NO"}'><%=StringUtil.getLocaleWord("L.관리번호", siteLocale) %></th>
		<th style="width:auto" data-opt='{"align":"left","col":"DEPTH_WORK_TITLE","onClick":"goWorkContView<%=sol_mas_uid%>(\"@{WORK_CONT_UID}\",\"@{SOL_MAS_UID}\",\"@{WORK_NO}\")"}'><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"WORK_WRITE_NM"}'><%=StringUtil.getLocaleWord("L.작성자", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"WORK_WRITE_GROUP_NM"}'><%=StringUtil.getLocaleWord("L.소속", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"WORK_WRITE_DTE"}'><%=StringUtil.getLocaleWord("L.작성일", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"SUSINJA_NAM"}'><%=StringUtil.getLocaleWord("L.수신자", siteLocale) %></th>
		
	</tr>
	</thead>
	<tbody id="TB_WORKCONT<%=sol_mas_uid%>Body"></tbody>
</table>
<%-- 		<th style="width:8%" data-opt='{"align":"center","html":{"type":"BTN","class":"delete","callback":"goRowDelete(\"@{UUID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}}'></th> --%>
<%--
	보기 갯수:<%=HtmlUtil.getSelect(request, true, CommonConstants.PAGE_ROWSIZE, CommonConstants.PAGE_ROWSIZE, "10|10^20|20^30|30^50|50^100|100", "10", "data-type=\"search\"  onChange=\"getLmsGtWorkCont();\"") %>
 --%>
<%-- 페이지 목록 --%>
<div class="pagelist" id="TB_WORKCONT<%=sol_mas_uid%>Page"></div> 
<script>
var goWorkContView<%=sol_mas_uid%> = function(work_cont_uid,sol_mas_uid,work_no){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_WORKCONT";
	url += "&AIR_MODE=POPUP_VIEW_FORM";
	url += "&work_cont_uid="+work_cont_uid;
	url += "&sol_mas_uid="+sol_mas_uid;
	url += "&gbn=<%=gbn%>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_VIEW_"+work_no, "yes", "yes", "");	
};

var goWorkContWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_WORKCONT";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM<%=sol_mas_uid%>", "yes", "yes", "");	
};

var getLmsGtWorkCont<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.workContForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
<%-- 	var rowCnt = $("#<%=CommonConstants.PAGE_ROWSIZE%>").val(); --%>
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "<%=pageRowSize%>";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		airCommon.createTableRow("TB_WORKCONT<%=sol_mas_uid%>", json, pageNo, "<%=pageRowSize%>", "getLmsGtWorkCont<%=sol_mas_uid%>");
	});
};

$(function(){
	getLmsGtWorkCont<%=sol_mas_uid%>(1);
});
</script>