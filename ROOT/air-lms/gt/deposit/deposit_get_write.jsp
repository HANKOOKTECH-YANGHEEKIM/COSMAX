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
	String	 gt_deposit_uid =	requestMap.getString("GT_DEPOSIT_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults rsDeposit = resultMap.getResult("DEPOSIT_GET");
	
	BeanResultMap depositMap = new BeanResultMap();
	if(rsDeposit != null && rsDeposit.getRowCount()> 0){
		depositMap.putAll(rsDeposit.getRowResult(0));
		gt_deposit_uid = depositMap.getString("GT_DEPOSIT_UID");
	}
	
	String gt_deposit_get_uid = depositMap.getString("GT_DEPOSIT_GET_UID");
	String temp_gt_deposit_get_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_COD,SIM_CHA_NM", "");
	String SAYU_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SAYU_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); 
	String BEOBWEON_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("BEOBWEON_LIST"), "CODE,LANG_CODE", "|");
	String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));// + "^SJ/HJ|심급/확정종결";

	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids = "";
	
	if(StringUtil.isBlank(gt_deposit_get_uid)){ //신규
		att_master_doc_id = temp_gt_deposit_get_uid;
		att_default_master_doc_Ids 	= "";
	}else{ //수정
		att_master_doc_id = gt_deposit_get_uid;
		att_default_master_doc_Ids = gt_deposit_get_uid;
	}
%>
<form name="depositGetForm" id="depositGetForm">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_deposit_uid" value="<%=gt_deposit_uid%>" />
	<input type="hidden" name="gt_deposit_get_uid" value="<%=gt_deposit_get_uid%>" />
	<input type="hidden" name="temp_gt_deposit_get_uid" value="<%=temp_gt_deposit_get_uid%>" />
	<table class="basic">
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.회수일자", siteLocale) %></th>
			<td class="td4"><%= HtmlUtil.getInputCalendar(request, true, "GET_DTE", "GET_DTE", depositMap.getString("GET_DTE"), "")%></td>	
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.회수담당자", siteLocale) %></span></th>
			<td class="td4"><input type="text" name="GET_DAMDANGJA_NAM" id="GET_DAMDANGJA_NAM" value="<%=StringUtil.convertForInput(depositMap.getString("GET_DAMDANGJA_NAM"))%>" onblur="airCommon.validateMaxLength(this, 50);airCommon.validateSpecialChars(this);" maxlength="50" class="text width_max" /></td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.회수금액", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "GET_COST_COD", "GET_COST_COD", strCurGubunList, depositMap.getString("GET_COST_COD"), "class=\"select\"")%>
				<input type="text" name="GET_COST" id="GET_COST" value="<%=StringUtil.convertForInput(depositMap.getString("GET_COST"))%>" onkeyup="airCommon.getFormatCurrency(this);" maxlength="15" class="cost" style="width:195px" />
			</td>		
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.회수이자", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "IJA_COST_COD", "IJA_COST_COD", strCurGubunList, depositMap.getString("IJA_COST_COD"), "class=\"select\"")%>
				<input type="text" name="IJA_COST" id="IJA_COST" value="<%=StringUtil.convertForInput(depositMap.getString("IJA_COST"))%>" size="30" onkeyup="airCommon.getFormatCurrency(this);" maxlength="15" class="cost" style="width:195px" />
			</td>	
		</tr>
		<tr>			
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.회수사유", siteLocale) %></span></th> 
			<td class="td4" colspan="3">
				<textarea name="SAYU" id="SAYU" onblur="airCommon.validateMaxLength(this, 4000)" class="memo width_max2" style="height:60px;"><%=depositMap.getStringEditor("SAYU") %></textarea>
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
	                   <jsp:param value="LMS/GT/DEPOSIT/GET" name="typeCode" />
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
	if ("" == $("#GET_DTE").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다", siteLocale, StringUtil.getLocaleWord("L.회수일자", siteLocale))%>");
		$("#GET_DTE").focus();
	    return false;	
	}
	
	if ("" == $("#GET_DAMDANGJA_NAM").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다", siteLocale, StringUtil.getLocaleWord("L.회수담당자", siteLocale))%>");
		$("#GET_DAMDANGJA_NAM").focus();
	    return false;	
	}

	if ("" == $("#GET_COST").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다", siteLocale, StringUtil.getLocaleWord("L.회수금액", siteLocale))%>");
		$("#GET_COST").focus();
	    return false;	
	}
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#depositGetForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "GET_WRITE_PROC", data, function(json){
			try {
				opener.$('#tepIndexOptTabs-deposit').panel('open').panel('refresh');
			} catch(exception) {
			}
<%if(StringUtil.isNotBlank(gt_deposit_get_uid)){ %>
			
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_GET_VIEW"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_deposit_get_uid'>").val("<%=gt_deposit_get_uid%>"));
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