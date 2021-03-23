<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.util.DateUtil"%>
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

	String	 sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults rsDocument = resultMap.getResult("DOCUMENT");
	
	BeanResultMap documentMap = new BeanResultMap();
	if(rsDocument != null && rsDocument.getRowCount()> 0){
		documentMap.putAll(rsDocument.getRowResult(0));
	}
	
	String gt_document_uid	= documentMap.getString("GT_DOCUMENT_UID");
	String temp_gt_document_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO, SIM_CHA_NM", "");
	String GUBUN_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	
	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids = "";
	
	if(StringUtil.isBlank(gt_document_uid)){ //신규
		att_master_doc_id = temp_gt_document_uid;
		att_default_master_doc_Ids 	= "";
	}else{ //수정
		att_master_doc_id = gt_document_uid;
		att_default_master_doc_Ids = gt_document_uid;
	}
%>
<br />
<form name="saveForm" id="saveForm" method="post">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_document_uid" value="<%=gt_document_uid%>" />
	<input type="hidden" name="temp_gt_document_uid" value="<%=temp_gt_document_uid%>" />
	<input type="hidden" name="sim_cha_no" />
	<table class="basic">
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<td class="td4"><%=DateUtil.getCurrentDate()%></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<td class="td4"><%=loginUser.getName()%></td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "SIM_CHA_NO", "SIM_CHA_NO", SIM_CODESTR, documentMap.getString("SIM_CHA_NO"), "class=\"select width_max\" ")%>
			</td>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "GUBUN_COD", "GUBUN_COD", GUBUN_CODESTR, documentMap.getString("GUBUN_COD"), "class=\"select width_max\" ")%>
			</td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td4" colspan="3">
				<input type="text" name="document_tit" id="document_tit" value="<%=documentMap.getString("DOCUMENT_TIT") %>" class="text width_max2" maxlength="255" />
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.자료개요", siteLocale) %></th>
			<td class="td4" colspan="3">
				<textarea name="CONTENTS" id="CONTENTS" onblur="airCommon.validateMaxLength(this, 4000)" class="memo width_max2" style="height:265px;"><%=documentMap.getStringEditor("CONTENTS") %></textarea>
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
                    <jsp:param value="LMS/GT/DOCUMENT" name="typeCode" />
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
  	    <span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<script>
var goProc = function(){
	if ("" == $("#sim_cod").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"심급")%>");
		$("#sim_cod").focus();
	    return false;	
	}

	if ("" == $("#gubun_cod").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"구분")%>");
		$("#gubun_cod").focus();
	    return false;	
	}
	
	if ("" == $("#document_tit").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"제목")%>");
		$("#document_tit").focus();
	    return false;	
	}
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			try {
				opener.getGtDocument<%=sol_mas_uid%>(1);
			} catch(exception) {
			}
			
<%if(StringUtil.isNotBlank(gt_document_uid)){ %>
			
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_document_uid'>").val("<%=gt_document_uid%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
<%}else{ %>
			window.close();
<%} %>
		});
	}
}
</script>