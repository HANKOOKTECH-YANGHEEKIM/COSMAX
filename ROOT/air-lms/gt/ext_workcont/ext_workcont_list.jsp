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
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
	
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
<form name="extWorkContForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>"/>
</form>
<table class="list" id="TB_EXT_WORKCONT<%=sol_mas_uid%>">
	<caption>
		<span class="left" style="color:darkred;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
		<span class="right">
			<%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewExtWorkContWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
			<%} %>
		</span>
	</caption>
	<thead>
	<tr>
		<th style="width:5%" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"GT_EXT_WORKCONT_UID;SOL_MAS_UID"}'>No.</th>
		<th style="width:auto" data-opt='{"align":"left","col":"YOCHEONG_TIT","onClick":"popupExtWorkCont<%=sol_mas_uid%>(\"@{GT_EXT_WORKCONT_UID}\")"}'><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"BALSINJA_NAM"}'><%=StringUtil.getLocaleWord("L.발신자", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"BALSIN_DTE"}'><%=StringUtil.getLocaleWord("L.발신일", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"SUSINJA_NAM"}'><%=StringUtil.getLocaleWord("L.수신자", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"SUSIN_DTE"}'><%=StringUtil.getLocaleWord("L.회신일", siteLocale) %></th>
	</tr>
	</thead>
	<tbody id="TB_EXT_WORKCONT<%=sol_mas_uid%>Body"></tbody>

</table>
<%-- 페이지 목록 --%>
<div class="pagelist" id="TB_EXT_WORKCONT<%=sol_mas_uid%>Page"></div> 

<script>
<%if(isAuths){ %>
var goNewExtWorkContWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_EXT_WORKCONT";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	url += "&gbn=<%=gbn%>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
};
<%} %>

var popupExtWorkCont<%=sol_mas_uid%> = function(gt_ext_workcont_uid){
	
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_ext_workcont_uid'>").val(gt_ext_workcont_uid));
	imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
	airCommon.openWindow("", "1024", "550", "POP_VIEW_"+gt_ext_workcont_uid, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+gt_ext_workcont_uid);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
	
}
var getLmsGtExtWorkCont<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.extWorkContForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		airCommon.createTableRow("TB_EXT_WORKCONT<%=sol_mas_uid%>", json, pageNo, 10, "getLmsGtExtWorkCont<%=sol_mas_uid%>");
	});
};

$(function(){
	getLmsGtExtWorkCont<%=sol_mas_uid%>(1);
});
</script>