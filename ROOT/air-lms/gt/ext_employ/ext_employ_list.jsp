<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
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
<form name="extEmployForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
<table class="list" id="TB_EXT_EMP<%=sol_mas_uid%>">
	<caption>
		<span class="left" style="color:darkred;">
			<select name="SUNIM_STAT" onchange="JavaScript:getLmsGtExtEmploy<%=sol_mas_uid%>('');" data-type="search" style="width:100px;">
				<option value="" selected>전체</option>
				<option value="ONLY_SUNIM">위임 중</option>
				<option value="HEIM">위임 종료</option>
			</select>
		※ 본 탭은 법무팀만 볼 수 있습니다.
		</span>
		<span class="right">
		<%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewExtEmployWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
		<%} %>
		</span>
	</caption>
	<thead>
	<tr>
<!-- 		<th style="width:40px" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"GT_EXT_UID;SOL_MAS_UID"}'>No.</th> -->
		<th style="width:15%;" data-opt='{"align":"center","col":"SOSOG_NAM","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.소속", siteLocale) %></th>
		<th style="width:12%" data-opt='{"align":"center","col":"BYEONHOSA_NAM","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.변호사명", siteLocale) %></th>
		<th style="width:85px" data-opt='{"align":"center","col":"PLUS_DATE","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.위임일", siteLocale) %></th>
		<th style="width:85px" data-opt='{"align":"center","col":"MINUS_DATE","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.위임종료일", siteLocale) %></th>
		<th style="width:75px" data-opt='{"align":"center","col":"PGL_YN_TEXT","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.주요검토자", siteLocale) %></th>
		<th style="width:auto" data-opt='{"align":"center","col":"MEMO","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.위임계약조건", siteLocale) %></th>
		<th style="width:150px" data-opt='{"align":"left"
			,"html":{"type":"fileDown"
					,"name":"FILE_NAME"
					,"value":"FILE_UID"
					}
			}'><%=StringUtil.getLocaleWord("L.위임계약서날인본", siteLocale) %></th>	
		<th style="width:70px" data-opt='{"align":"center","col":"REG_EMP_NAME","onClick":"popupExtEmploy<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")"}'><%=StringUtil.getLocaleWord("L.작성자", siteLocale) %></th>
		<th style="width:65px" data-opt='{"align":"center"<%if(isAuths){ %>,"html":{"type":"BTN","class":"delete","callback":"goExtEmployDel<%=sol_mas_uid%>(\"@{GT_EXT_UID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}<%} %>}'></th>
	</tr>
	</thead>
	<tbody id="TB_EXT_EMP<%=sol_mas_uid%>Body"></tbody>
</table>
</form>
<%-- 페이지 목록 --%>
<%--  
<div class="pagelist" id="TB_EXT_EMP<%=sol_mas_uid%>Page"></div> 
--%>
<script>
var goExtEmployHistory<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_EXT_EMPLOY";
	url += "&AIR_MODE=HISTORY";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	
	airCommon.openWindow(url, "1024", "500", "POPUP_WRITE_FORM", "yes", "yes", "");	
};
<%if(isAuths){ %>
var goNewExtEmployWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_EXT_EMPLOY";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	
	airCommon.openWindow(url, "1024", "500", "POPUP_WRITE_FORM", "yes", "yes", "");	
};
<%} %>

var popupExtEmploy<%=sol_mas_uid%> = function(gt_ext_uid){
	
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_ext_uid'>").val(gt_ext_uid));
	imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
	airCommon.openWindow("", "1024", "550", "POP_VIEW_"+gt_ext_uid, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+gt_ext_uid);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
	
};

var goExtEmployDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	data["gt_ext_uid"] = uuid;
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getLmsGtExtEmploy<%=sol_mas_uid%>(1);
		});		
	}
};

//--  리스트
var getLmsGtExtEmploy<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.extEmployForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		airCommon.createTableRow("TB_EXT_EMP<%=sol_mas_uid%>", json);
	});
};

$(function(){
	getLmsGtExtEmploy<%=sol_mas_uid%>(1);
});
</script>