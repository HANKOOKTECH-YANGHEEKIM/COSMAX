<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
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

	String	 sol_mas_uid =	requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults reDueDate = resultMap.getResult("DUE_DATE");
	
	BeanResultMap dueDateMap = new BeanResultMap();
	
	if(reDueDate != null && reDueDate.getRowCount()> 0){
		dueDateMap.putAll(reDueDate.getRowResult(0));
	}
	
	String gt_due_date_uid	= dueDateMap.getString("GT_DUE_DATE_UID");
	String temp_gt_due_date_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String sGI_HH_CODESTR = "";
	for (int i=0; i<24; i++) {
		String val = StringUtil.leftPad(Integer.toString(i, 10), 2, '0');
		sGI_HH_CODESTR += (i!=0 ? "^" : "");
		sGI_HH_CODESTR += val+"|"+val;  
	}
	
	String sGI_MI_CODESTR = "";
	for (int i=0; i<60; i=i+5) {
		String val = StringUtil.leftPad(Integer.toString(i, 10), 2, '0');
		sGI_MI_CODESTR += (i!=0 ? "^" : "");
		sGI_MI_CODESTR += val+"|"+val;
	}
	
	//String sim_cha_no = StringUtil.convertNull(request.getParameter("sim_cha_no"));
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_COD,SIM_CHA_NM", "");
	String JONGRYU_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("JONGRYU_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String GUBUN_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	
	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids = "";
	
	if(StringUtil.isBlank(gt_due_date_uid)){ //신규
		att_master_doc_id = temp_gt_due_date_uid;
		att_default_master_doc_Ids 	= "";
	}else{ //수정
		att_master_doc_id = gt_due_date_uid;
		att_default_master_doc_Ids = gt_due_date_uid;
	}

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
<br />
	<table class="basic">
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
			<td class="td4" colspan="3">
				<%=dueDateMap.getString("SIM_NM") %>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
			<td class="td4">
				<%=dueDateMap.getString("GUBUN_COD").endsWith("ZZ") ? "기타<br />("+dueDateMap.getString("GUBUN_NAM")+")" : dueDateMap.getString("GUBUN_NAM") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.종류", siteLocale) %></th>
			<td class="td4">
				<%=dueDateMap.getString("JONGRYU_COD").endsWith("ZZ") ? "기타<br />("+dueDateMap.getString("JONGRYU_NAM")+")" : dueDateMap.getString("JONGRYU_NAM") %>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.일자", siteLocale) %></th>
			<td class="td4"><%=dueDateMap.getString("GI_YYYYMMDD") %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.시간", siteLocale) %></th>
			<td class="td4"><%=dueDateMap.getString("GI_HH") %>:<%=dueDateMap.getString("GI_MI") %></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.장소", siteLocale) %></th>
			<td class="td4" colspan="3"><%=dueDateMap.getString("JANGSO") %></td>
		</tr>
		<tr>			
			<th class="th4"><%=StringUtil.getLocaleWord("L.알람여부", siteLocale) %></th>
			<td class="td4"><%="Y".equals(dueDateMap.getString("TONGBO_YN")) ? "Yes" : "No" %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.일정 반영여부", siteLocale) %></th>
			<td class="td4"><%="Y".equals(dueDateMap.getString("CALENDAR_YN")) ? "Yes" : "No" %></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.진행내용", siteLocale) %></th>
			<td class="td4" colspan="3" style="height:250px; vertical-align:top;">
				<%=dueDateMap.getStringView("GYEOLGWA")%>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td class="td4" colspan="3">
			<%if(isAuths){ %>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_DIVISION" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/DUE_DATE" name="typeCode" />
                </jsp:include>
                <span style="color:red">※ PDF파일만 분할 가능합니다.</span>
			<%}else{ %>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/DUE_DATE" name="typeCode" />
                </jsp:include>
			<%} %>
			</td>
		</tr>
	</table>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    <%if(isAuths){ %>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goDueDateWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.수정",siteLocale)%></a></span>
    <%} %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<script>
<%if(isAuths){ %>
var goDueDateWrite<%=sol_mas_uid%> = function(){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_due_date_uid'>").val("<%=gt_due_date_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
	
};
<%} %>

var doDivisionStart = function(vFileUUID, vFileName, vFileSaveName) {
	var data = airCommon.getSearchQueryParams(document.fileDivisionForm);
	
	data["UUID"] = vFileUUID;
	data["FileName"] = vFileName;
	data["FileSaveName"] = vFileSaveName;
	data["typeCode"] = "LMS/GT/DUE_DATE";
	data["att_master_doc_id"] = "<%=att_master_doc_id%>";
	data["systemTypeCode"] = "LMS";
	
	if(checkVal(vFileUUID)) {
		airCommon.callAjax("SYS_MULTI_PART", "PDF_DIVISIONT",data, function(json) {
			
			if(json[0].RESULT == "ERROR"){
        		alert(json[0].ALARM_MESSAGE);
        	}
			else{
				alert ("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT_DONE",siteLocale)%>");
				// location.href = location.href;
				goDueDateView<%=sol_mas_uid%>();
			}
			
			//airCommon.createTableRow("TB_DUE_DATE<%=sol_mas_uid%>", json, pageNo, 10, "getLmsGtDueDate<%=sol_mas_uid%>");
		});	
	} 
}

var goDueDateView<%=sol_mas_uid%> = function(){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_due_date_uid'>").val("<%=gt_due_date_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
};

$("body").css("overflow","scroll");
</script>