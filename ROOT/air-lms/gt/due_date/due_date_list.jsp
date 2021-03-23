<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
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
	String	 sim_cha_no =  requestMap.getString("SIM_CHA_NO");

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO, SIM_CHA_NM", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	
	String	 gbn = requestMap.getString("GBN");
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
<span style="color:darkred; font-weight:bold;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
<form name="dueDateForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
<table class="list" id="TB_DUE_DATE<%=sol_mas_uid%>">
	<caption>
		<span class="left">
			<%=HtmlUtil.getSelect(request, true, "SIM_CHA_NO", "SIM_CHA_NO", SIM_CODESTR, sim_cha_no, "onchange=\"JavaScript:getLmsGtDueDate"+sol_mas_uid+"(1);\" data-type='search' class=\"select\" style='width:100px;'")%>
		</span>
		<span class="right">
<%if(isAuths){ %>		
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goDueDateWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
<%} %>		
		</span>
	</caption>
	<thead>
	<tr>
		<th style="width:40px"><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
		<th style="width:80px"><%=StringUtil.getLocaleWord("L.일자", siteLocale) %></th>
		<th style="width:40px"><%=StringUtil.getLocaleWord("L.시간", siteLocale) %></th>
		<th style="width:8%"><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
		<th style="width:8%"><%=StringUtil.getLocaleWord("L.종류", siteLocale) %></th>
		<th style="width:10%"><%=StringUtil.getLocaleWord("L.장소", siteLocale) %></th>
		<th style="width:auto"><%=StringUtil.getLocaleWord("L.진행내용", siteLocale) %></th>
		<th style="width:18%"><%=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th>
		<th style="width:4%"><%=StringUtil.getLocaleWord("L.알람", siteLocale) %></th>
		<th style="width:65px"></th>
	</tr>
	</thead>
	<tbody id="LmsGtDueDate<%=sol_mas_uid%>Body"></tbody>
</table>
</form>
<%-- 페이지 목록 --%>
<%--
<div class="pagelist" id="TB_DUE_DATE<%=sol_mas_uid%>Page"></div>
 --%>
<script id="LmsGtDueDate<%=sol_mas_uid%>Template" type="text/html">
    <tr id="\${GT_DUE_DATE_UID}">
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${SIM_NM}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${GI_YYYYMMDD}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${GI_HH}:\${GI_MI}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${GUBUN_NAM}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${JONGRYU_NAM}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${JANGSO}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${GYEOLGWA}</td>
        <td style="text-align:left; cursor:pointer;">{{html fileDown(FILE_UID,FILE_NAME)}}</td>
        <td onclick="goDueDateView<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');" style="text-align:center; cursor:pointer;">\${TONGBO_YN_TEXT}</td>
		<td style="text-align:center;">
<%if(isAuths){ %>		
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDueDateDel<%=sol_mas_uid%>('\${GT_DUE_DATE_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
<%} %>		
		</td>
    </tr>
</script>
<script>
var fileDown = function(fileVal, fileNm){
	var rtnStr = "";
	var arrNm = fileNm.split("/");
	var arrVal = fileVal.split("/");
	if(fileNm != "" && arrNm.length > 0){
		rtnStr += "<ul class='attach_file_view'>"
		$(arrNm).each(function(k,a){
			rtnStr += "<li>"
			rtnStr += "<a href='javascript:airCommon.popupAttachFileDownload(\""+arrVal[k]+"\")'>"+arrNm[k]+"</a>";
			rtnStr += "</li>"
		});
		rtnStr += "</ul>"
	}
	
	return rtnStr;
};

var goDueDateWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_DUE_DATE";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
};

var goDueDateView<%=sol_mas_uid%> = function(vGt_due_date_uid){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")

	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_due_date_uid'>").val(vGt_due_date_uid));
	imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
	
	airCommon.openWindow("", "1024", "650", "POP_VIEW_"+vGt_due_date_uid, "yes", "yes", "");	
	
	imsiForm.attr("target","POP_VIEW_"+vGt_due_date_uid);
	imsiForm.appendTo("body");
	
	imsiForm.submit();
	
	imsiForm.remove();
};

var goDueDateDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	data["gt_due_date_uid"] = uuid;
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getLmsGtDueDate<%=sol_mas_uid%>(1);
		});
	}
};

var getLmsGtDueDate<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.dueDateForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json) {
	   //airCommon.createTableRow("TB_DUE_DATE<%=sol_mas_uid%>", json, pageNo, 10, "getLmsGtDueDate<%=sol_mas_uid%>");
		setLmsGtDueDate<%=sol_mas_uid%>(json);
	});
};

var setLmsGtDueDate<%=sol_mas_uid%> =  function(data){
	$("#LmsGtDueDate<%=sol_mas_uid%>Body tr").remove(); // 기존 데이터 삭제
	
	var arrData = data.rows;
   
   	var tgTbl = $("#LmsGtDueDate<%=sol_mas_uid%>Body"); //jquery-tmpl

	$("#LmsGtDueDate<%=sol_mas_uid%>Template").tmpl(arrData).appendTo(tgTbl);
};

$(function(){
	getLmsGtDueDate<%=sol_mas_uid%>(1);
});

var doSearch = function(vSim_cha_no) {
	getLmsGtDueDate<%=sol_mas_uid%>(1);
}
</script>