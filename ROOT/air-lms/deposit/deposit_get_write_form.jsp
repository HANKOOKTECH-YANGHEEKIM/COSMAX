<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
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
	String	 sol_mas_uid =	requestMap.getString("SOL_MAS_UID");
	String	 deposit_mas_uid =	requestMap.getString("DEPOSIT_MAS_UID");
	String deposit_get_uid = requestMap.getString("DEPOSIT_GET_UID");
	String temp_deposit_get_uid = StringUtil.getRandomUUID(); //새로 생성한 아이디
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults sqlrDEPOSIT_GET = resultMap.getResult("DEPOSIT_GET");
	SQLResults sqlrDEPOSIT_MAS = resultMap.getResult("DEPOSIT_MAS");
	
	BeanResultMap depositGetMap = new BeanResultMap();
	if(sqlrDEPOSIT_GET != null && sqlrDEPOSIT_GET.getRowCount()> 0){
		depositGetMap.putAll(sqlrDEPOSIT_GET.getRowResult(0));
	}
	
	BeanResultMap masMap = new BeanResultMap();
	if(sqlrDEPOSIT_MAS != null && sqlrDEPOSIT_MAS.getRowCount()> 0){
		masMap.putAll(sqlrDEPOSIT_MAS.getRowResult(0));
	}
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMSSS002_SIM_LIST"), "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String BEOBWEON_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMSSS002_BEOBWEON_LIST"), "CODE,LANG_CODE", "|");
	
	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids 	= "";
	
	if(StringUtil.isBlank(deposit_get_uid)){ //신규
		att_master_doc_id = temp_deposit_get_uid;
		att_default_master_doc_Ids = ""; //다른데 있는 첨부파일을 끌어올때 사용
	}else{ //수정
		att_master_doc_id = deposit_get_uid;
		att_default_master_doc_Ids = deposit_get_uid;
	}
	
	boolean isAuths = false;
	
	if(
			loginUser.getLoginId().equals(masMap.getString("DAMDANGJA_ID")) ||
			loginUser.isUserAuth("LMS_SSM") ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
%>
<form name="saveForm" id="saveForm">
	<input type="hidden" name="SOL_MAS_UID" value="<%=sol_mas_uid%>" data-type="search" />
	<input type="hidden" name="DEPOSIT_MAS_UID" value="<%=deposit_mas_uid%>" data-type="search" />
	<input type="hidden" name="DEPOSIT_GET_UID" value="<%=deposit_get_uid%>" data-type="search" />
	<input type="hidden" name="TEMP_DEPOSIT_GET_UID" value="<%=temp_deposit_get_uid%>" />
	<input type="hidden" name="IS_NEW" value="<%=StringUtil.isBlank(deposit_get_uid) ? true : false %>" />
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.공탁회수",siteLocale) %> ( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale) %>)</caption>
	<tr>
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.회수일자",siteLocale) %></th>
		<td class="td4">
			<%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_GET_DTE", "DEPOSIT_GET_DTE", depositGetMap.getString("DEPOSIT_GET_DTE"), "") %>
		</td>
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.회수담당자",siteLocale) %></th>
		<td class="td4">
			<input type="text" name="DEPOSIT_GET_DAMDANGJA" id="DEPOSIT_GET_DAMDANGJA" value="<%=StringUtil.convertForInput(depositGetMap.getString("DEPOSIT_GET_DAMDANGJA")) %>" maxlength="50" class="text width_max" />
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.회수금액",siteLocale) %></th>
		<td class="td4">
			<span style="padding:0 0 0 8px;">KRW</span>
			<input type="text" name="DEPOSIT_GET_COST" id="DEPOSIT_GET_COST" onkeyup="airCommon.getFormatCurrency(this);" value="<%=StringUtil.getFormatCurrency(depositGetMap.getString("DEPOSIT_GET_COST"),-1) %>" maxlength="15" class="cost" style="float:right; width:85%;" />
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회수이자",siteLocale) %></th>
		<td class="td4" style="text-align:right">
			<span style="padding:0 0 0 8px;">KRW</span>
			<input type="text" name=DEPOSIT_GET_INTEREST id="DEPOSIT_GET_INTEREST" onkeyup="airCommon.getFormatCurrency(this);" value="<%=StringUtil.getFormatCurrency(depositGetMap.getString("DEPOSIT_GET_INTEREST"),-1) %>" maxlength="15" class="cost" style="width:85%" />
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회수사유",siteLocale) %></th>
		<td class="td4" colspan="3">
			<textarea name="DEPOSIT_GET_REASON" id="DEPOSIT_GET_REASON" onblur="airCommon.validateSpecialChars(this);airCommon.validateMaxLength(this, 2000);" class="memo width_max2"><%=StringUtil.convertForInput(depositGetMap.getString("DEPOSIT_GET_REASON")) %></textarea>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부",siteLocale) %></th>			
		<td class="td4" colspan="3">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/DEPOSIT/GET" name="typeCode" />
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
<% 
	if(isAuths){
		if(!"".equals(deposit_get_uid)) { //수정
%>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="javascript:getWriteProc<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.수정",siteLocale)%></a></span>
 		<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="javascript:getDelete<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span>
<%
		} else { //등록
%>
			<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="javascript:getWriteProc<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
<%
		}
	} 
%>
    </div>
</div>	
<% if(isAuths){ %>
<script>
var getWriteProc<%=sol_mas_uid%> = function(){
	if ("" == $("#SIM_COD").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.심급",siteLocale))%>");
		$("#SIM_COD").focus();
	    return false;
	}

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.저장")%>")){
		var data = $("#saveForm").serialize();
		
		airCommon.callAjax("<%=actionCode%>", "GET_WRITE_PROC",data, function(json){
			try {
				opener.parent.getDepositGetList<%=sol_mas_uid%>();
				opener.doSearch();
			}catch(Exception) {
			}
			
			window.close();
		});
	}
};

var getDelete<%=sol_mas_uid%> = function(){
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		var data = $("#saveForm").serialize();
		
		airCommon.callAjax("<%=actionCode%>", "DELETE_GET_PROC",data, function(json){
			try {
				opener.parent.getDepositGetList<%=sol_mas_uid%>();
				opener.doSearch();
			}catch(Exception) {
			}
			
			window.close();
		});
	}
};
</script>
<% } %>