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

	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_COD,SIM_CHA_NM", "");
	String GUBUN_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	
	String att_master_doc_id = gt_document_uid;
%>
<br />
<form name="saveForm" id="saveForm">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_document_uid" value="<%=gt_document_uid%>" />
	<input type="hidden" name="temp_gt_document_uid" value="<%=temp_gt_document_uid%>" />
	<input type="hidden" name="sim_cha_no" />
	<table class="basic">
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<td class="td4"><%=documentMap.getStringView("REG_DATE") %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<td class="td4"><%=documentMap.getStringView("REG_EMP_NM") %></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
			<td class="td4">
				<%=documentMap.getStringView("SIM_NM") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
			<td class="td4">
				<%=documentMap.getStringView("GUBUN_NM") %>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td4" colspan="3">
				<%=documentMap.getStringView("DOCUMENT_TIT") %>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.자료개요", siteLocale) %></th>
			<td class="td4" colspan="3">
				<div style="min-height:300px;"><%=documentMap.getString("CONTENTS") %></div>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td class="td4" colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/DOCUMENT" name="typeCode" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goUpdate();"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<script>
var goUpdate = function(){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_document_uid'>").val("<%=gt_document_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
	
}
</script>