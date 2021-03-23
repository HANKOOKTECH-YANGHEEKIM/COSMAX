<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
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
	sGI_HH_CODESTR = "00|^"+sGI_HH_CODESTR;
	
	String sGI_MI_CODESTR = "";
	for (int i=0; i<60; i=i+5) {
		String val = StringUtil.leftPad(Integer.toString(i, 10), 2, '0');
		sGI_MI_CODESTR += (i!=0 ? "^" : "");
		sGI_MI_CODESTR += val+"|"+val;
	}
	sGI_MI_CODESTR = "00|^"+sGI_MI_CODESTR;
	
	//String sim_cha_no = StringUtil.convertNull(request.getParameter("sim_cha_no"));
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO, SIM_CHA_NM", "|" + StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
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
%>
<br />
<form name="saveForm" id="saveForm" method="post">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_due_date_uid" value="<%=gt_due_date_uid%>" />
	<input type="hidden" name="temp_gt_due_date_uid" value="<%=temp_gt_due_date_uid%>" />
	<table class="basic">
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
			<td class="td4" colspan="3">
				<%=HtmlUtil.getSelect(request, true, "SIM_CHA_NO", "SIM_CHA_NO", SIM_CODESTR, dueDateMap.getString("SIM_CHA_NO"), "class=\"select\" style='width:335px;'")%>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "gubun_cod", "gubun_cod", GUBUN_CODESTR, dueDateMap.getString("GUBUN_COD"), "onchange=\"changeEtcTxt(this.value, 'gubun_nam', this.id)\" class=\"select width_max\"")%>
				<input type="text" name="gubun_nam" id="gubun_nam" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=dueDateMap.getString("GUBUN_NAM") %>" maxlength="50" class="text width_max" style="display:<%if(!dueDateMap.getString("GUBUN_COD").endsWith("ZZ"))out.print("none;"); %>" />

			</td>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.종류", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "jongryu_cod", "jongryu_cod", JONGRYU_CODESTR, dueDateMap.getString("JONGRYU_COD"), "onchange=\"changeEtcTxt(this.value, 'jongryu_nam', this.id)\" class=\"select width_max\"")%>
				<input type="text" name="jongryu_nam" id="jongryu_nam" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=dueDateMap.getString("JONGRYU_NAM") %>" maxlength="50" class="text width_max" style="display:<%if(!dueDateMap.getString("JONGRYU_COD").endsWith("ZZ"))out.print("none;"); %>" />
			</td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.일자", siteLocale) %></span></th>
			<td class="td4"><%=HtmlUtil.getInputCalendar(request, true, "gi_yyyymmdd", "gi_yyyymmdd", dueDateMap.getString("GI_YYYYMMDD"), "") %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.시간", siteLocale) %></th>
			<td class="td4"><%=HtmlUtil.getSelect(request, true, "gi_hh", "gi_hh", sGI_HH_CODESTR, dueDateMap.getString("GI_HH"), "class=\"select\"")%> : <%=HtmlUtil.getSelect(request, true, "gi_mi", "gi_mi", sGI_MI_CODESTR, dueDateMap.getString("GI_MI"), "class=\"select\"")%></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.장소", siteLocale) %></th>
			<td class="td4" colspan="3"><input type="text" name="JANGSO" id="JANGSO" value="<%=dueDateMap.getString("JANGSO") %>" maxlength="50" class="text width_max" /></td>
		</tr>
		<tr>			
			<th class="th4"><%=StringUtil.getLocaleWord("L.알람여부", siteLocale) %></th>
			<td class="td4"><%=HtmlUtil.getSelect(request, true, "TONGBO_YN", "TONGBO_YN", "|--선택--^Y|Yes(7일 전 알람메일 발송)^N|No", dueDateMap.getString("TONGBO_YN"), "class=\"select width_max\" data-type=\"search\" ") %></td>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.일정 반영여부", siteLocale) %></th>
			<td class="td4"><%=HtmlUtil.getSelect(request, true, "CALENDAR_YN", "CALENDAR_YN", "|--선택--^Y|Yes^N|No", dueDateMap.getString("CALENDAR_YN"), "class=\"select width_max\" data-type=\"search\" ") %></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.진행내용", siteLocale) %></th>
			<td class="td4" colspan="3">
				<textarea class="memo width_max" name="GYEOLGWA" id="GYEOLGWA" onblur="airCommon.validateMaxLength(this, 4000)" style="height:250px;"><%=dueDateMap.getStringEditor("GYEOLGWA") %></textarea>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td class="td4" colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/DUE_DATE" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
   	<%if(StringUtil.isNotBlank(gt_due_date_uid)){ %>
    	<span class="ui_btn medium icon"><span class="refresh"></span><a href="javascript:void(0)" onclick="goDueDateView<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
   	<%}else{ %>
    	<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
   	<%} %>
    </div>
</div>	
<script>
var goProc = function(){
	if ("" == $("#sim_cha_no").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.심급", siteLocale))%>");
		$("#sim_cha_no").focus();
	    return false;	
	}
	
	if ("" == $("#jongryu_cod").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.종류", siteLocale))%>");
		$("#jongryu_cod").focus();
	    return false;	
	}	
	
	if(""== $("#CALENDAR_YN").val()) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.일정 반영여부", siteLocale))%>");
		$("#CALENDAR_YN").focus();
	    return false;	
	} else if ("Y" == $("#CALENDAR_YN").val() ) { //일정반영여부가 Yes
		if(""== $("#gi_hh").val()) {
			alert("일정 반영시 시간은 필수 입력사항입니다.");
			$("#gi_hh").focus();
		    return false;	
		}
		if(""== $("#gi_mi").val()) {
			alert("일정 반영시 시간은 필수 입력사항입니다.");
			$("#gi_mi").focus();
		    return false;
		}
	}
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			try {
				opener.getLmsGtDueDate<%=sol_mas_uid%>(1);
			} catch(exception) {
			}
			
<%if(StringUtil.isNotBlank(gt_due_date_uid)){ %>

			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_due_date_uid'>").val("<%=gt_due_date_uid%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
			
<%}else{ %>
			window.close();
<%} %>
		});
	}
}

var changeEtcTxt = function(vThisVal, vId, vThisID){
	if(vThisVal.endsWith("_99") || vThisVal.endsWith("_ZZ")){
		$("#"+vId).val("");
		$("#"+vId).show();
	}else{
		$("#"+vId).val($("#"+vThisID+" option:selected").text());
		$("#"+vId).hide();
	}
};

$(function() {
	//changeEtcTxt(this.value, 'gubun_nam', this.id);
	//changeEtcTxt(this.value, 'jongryu_nam', this.id);
});

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
</script>