<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
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
<form name="lawMemoForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
</form>
<table class="list" id="TB_LAWMEMO<%=sol_mas_uid%>">
	<caption>
		<span class="left" style="color:darkred;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
		<span class="right">
		<%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewLawMemoWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
		<%} %>
		</span>
	</caption>
	<thead>
	<tr>
		<th style="width:5%" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"GT_MEMO_UID;SOL_MAS_UID"}'>No.</th>
		<th style="width:*" data-opt='{"align":"left","col":"TITLE","onClick":"popupMemoDetail<%=sol_mas_uid%>(\"@{GT_MEMO_UID}\")"}'><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"REG_EMP_NM"}'><%=StringUtil.getLocaleWord("L.작성자", siteLocale) %></th>
		<th style="width:10%" data-opt='{"align":"center","col":"MOD_DATE"}'><%=StringUtil.getLocaleWord("L.작성일", siteLocale) %></th>
	<!-- 	
		<th style="width:5%"   data-opt='{"align":"center","inputHidden":"UUID;STU_GBN;STU_ID"
			,"html":{"type":"text"
					,"class":"text width_max"
					,"name":"ORD_SEQ"
					,"event":[{
						"type":"onfocus"
						,"href":"setImsiVal(this.value)"
					},
					{
						"type":"onKeyUp"
						,"href":"goModStr(true,\"@{UUID}\",this)"
					}]
			}
		}'>순번</th>
		<th style="width:8%" data-opt='{"align":"center","col":"STU_GBN_NM"}'>법무구분</th>
		<th style="width:10%" data-opt='{"align":"center","col":"AUTH_NM"}'>권한자</th>
		<th style="width:18%" data-opt='{"align":"left","col":"STU_NM"}'>현재상태</th>
		<th style="width:12%" data-opt='{"align":"center","col":"FORM_NO"}'>폼 NO</th> 
	-->
		<th style="width:70px" data-opt='{"align":"center","html":{"type":"BTN","class":"delete","callback":"goLawMemoDel<%=sol_mas_uid%>(\"@{GT_MEMO_UID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}}'></th>
	</tr>
	</thead>
	<tbody id="TB_LAWMEMO<%=sol_mas_uid%>Body"></tbody>

</table>
<%-- 페이지 목록 --%>
<div class="pagelist" id="TB_LAWMEMO<%=sol_mas_uid%>Page"></div> 


<script>
var popupMemoDetail<%=sol_mas_uid%> = function(gt_memo_uid){

	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_memo_uid'>").val(gt_memo_uid));
	imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
	airCommon.openWindow("", "1024", "650", "POP_VIEW_"+gt_memo_uid, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+gt_memo_uid);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
}
<%if(isAuths){ %>
var goNewLawMemoWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_LAW_MEMO";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
};
<%} %>

var goLawMemoDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	data["gt_memo_uid"] = uuid;
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getLmsGtLawMemo<%=sol_mas_uid%>(1);
		});
	}
};

var getLmsGtLawMemo<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.lawMemoForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		airCommon.createTableRow("TB_LAWMEMO<%=sol_mas_uid%>", json, pageNo, 10, "getLmsGtLawMemo<%=sol_mas_uid%>");
	});
};

$(function(){
	getLmsGtLawMemo<%=sol_mas_uid%>(1);
});
</script>