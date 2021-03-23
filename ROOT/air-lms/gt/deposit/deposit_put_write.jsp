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
	SQLResults rsDeposit = resultMap.getResult("DEPOSIT_PUT");
	
	BeanResultMap depositMap = new BeanResultMap();
	if(rsDeposit != null && rsDeposit.getRowCount()> 0){
		depositMap.putAll(rsDeposit.getRowResult(0));
	}
	
	String gt_deposit_uid = depositMap.getString("GT_DEPOSIT_UID");
	String temp_gt_deposit_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO, SIM_CHA_NM", "");
	String SAYU_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SAYU_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); 
	String BEOBWEON_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("BEOBWEON_LIST"), "CODE,LANG_CODE", "|");
	String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,LANG_CODE", "");

	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids = "";
	
	if(StringUtil.isBlank(gt_deposit_uid)){ //신규
		att_master_doc_id = temp_gt_deposit_uid;
		att_default_master_doc_Ids 	= "";
	}else{ //수정
		att_master_doc_id = gt_deposit_uid;
		att_default_master_doc_Ids = gt_deposit_uid;
	}
%>
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_deposit_uid" value="<%=gt_deposit_uid%>" />
	<input type="hidden" name="temp_gt_deposit_uid" value="<%=temp_gt_deposit_uid%>" />
	<table class="basic">
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></span></th>
			<td class="td4"  colspan="3"><%=HtmlUtil.getSelect(request, true, "SIM_CHA_NO", "SIM_CHA_NO", SIM_CODESTR, depositMap.getString("SIM_CHA_NO"), "class=\"select\" style='width:340px;'")%></td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.공탁번호", siteLocale) %></span></th> 
			<td class="td4">
				<input type="text" name="gongtag_no" id="gongtag_no" class="text width_max" value="<%=StringUtil.convertForInput(depositMap.getString("GONGTAG_NO"))%>" onblur="airCommon.validateMaxLength(this, 25);airCommon.validateSpecialChars(this);" />		
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.사건번호", siteLocale) %></th> 
			<td class="td4">
				<input type="text" name="sageon_no" id="sageon_no" class="text width_max"  value="<%=StringUtil.convertForInput(depositMap.getString("SAGEON_NO"))%>" onblur="airCommon.validateMaxLength(this, 25);airCommon.validateSpecialChars(this);" />		
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.공탁법원", siteLocale) %></th> 
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "beobweon", "beobweon", BEOBWEON_CODESTR, depositMap.getString("BEOBWEON_COD"), "class=\"easyui-combobox select\" style=\"width:285px\"")%>
				<input type="hidden" name="beobweon_cod" id="beobweon_cod" value="<%=StringUtil.convertForInput(depositMap.getString("BEOBWEON_COD"))%>" />
				<input type="hidden" name="beobweon_nam" id="beobweon_nam" value="<%=StringUtil.convertForInput(depositMap.getString("BEOBWEON_NAM"))%>" />
				<input type="hidden" name="beobweon_type" id="beobweon_type" value="" />
			</td>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.공탁일자", siteLocale) %></th>
			<td class="td4"><%= HtmlUtil.getInputCalendar(request, true, "gongtag_dte", "gongtag_dte", depositMap.getString("GONGTAG_DTE"), "")%></td>		
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.공탁금액", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "GONGTAG_COST_COD", "GONGTAG_COST_COD", strCurGubunList, depositMap.getString("GONGTAG_COST_COD"), "class=\"select\"")%>
				<input type="text" name="GONGTAG_COST" id="GONGTAG_COST" value="<%=StringUtil.convertForInput(depositMap.getString("GONGTAG_COST"))%>" onkeyup="airCommon.getFormatCurrency(this);" maxlength="15" class="cost" style="width:195px" />
			</td>		
			<th class="th4"><%=StringUtil.getLocaleWord("L.공탁사유", siteLocale) %></th> 
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "SAYU_COD", "SAYU_COD", SAYU_CODESTR, depositMap.getString("SAYU_COD"), "onchange=\"changeEtcTxt(this.value, 'SAYU_NAM', this.id)\" class=\"select width_max\"") %>
				<input type="text" name="SAYU_NAM" id="SAYU_NAM" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=depositMap.getString("SAYU_NAM")%>" maxlength="50" class="text width_max" style="display:<%=depositMap.getString("SAYU_COD").endsWith("ZZ") ? "" : "none" %>;" />
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
                    <jsp:param value="LMS/GT/DEPOSIT/PUT" name="typeCode" />
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
var changeEtcTxt = function(vThisVal, vId, vThisID){
	if(vThisVal.endsWith("99") || vThisVal.endsWith("ZZ")){
		$("#"+vId).val("");
		$("#"+vId).show();
	}else{
		$("#"+vId).val($("#"+vThisID+" option:selected").text());
		$("#"+vId).hide();
	}
};

function ckBeobweon(){ //같은 단어이지만 공백들어갔을시, 코드에 등록된 단어로 치환후 저장하도록 수정, beobweon, beobweon_nam
	var optionText; 
	var inputText  = $("#beobweon").combobox("getText").replace(/ /g, '').toUpperCase();
	var i=0;
	$('#beobweon > option').each(function() {
		++i;	
		optionText = $(this).text(); //SelectBox Text
		if(inputText == optionText.replace(/ /g, '')){
			$('#beobweon').combobox('setText',optionText);
			$("#beobweon_cod").val($("#beobweon").combobox("getValue").replace(/ /g, '').toUpperCase());
			$("#beobweon_nam").val($("#beobweon").combobox("getText").replace(/ /g, '').toUpperCase());
		}
	});
};

function ckBeobweonType(){ //법원 코드ID 데이터 타입 확인
	var beobweon_cod = $("#beobweon_cod").val();
	var result = isNaN(beobweon_cod);
	
	if(result){//숫자는 false, 문자는 true
		$("#beobweon_type").val("STRING");
	}else{
		$("#beobweon_type").val("INT");
	}
};

var goProc = function(){
	if ("" == $("#sim_cha_no").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"심급")%>");
		$("#sim_cha_no").focus();
	    return false;	
	}
	
	if ("" == $("#gongtag_no").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"공탁번호")%>");
		$("#gongtag_no").focus();
	    return false;	
	}

	if ("" == $("#gongtag_dte").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"공탁일자")%>");
		$("#gongtag_dte").focus();
	    return false;	
	}
	
	if ("" == $("#GONGTAG_COST").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"공탁금액")%>");
		$("#GONGTAG_COST").focus();
	    return false;	
	}
	if ("" == $("#GONGTAG_COST_COD").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"공탁금액 화폐단위")%>");
		$("#GONGTAG_COST_COD").focus();
	    return false;	
	}
	
	ckBeobweon();
	ckBeobweonType();
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "PUT_WRITE_PROC",data, function(json){
			try {
				opener.$('#tepIndexOptTabs-deposit').panel('open').panel('refresh');
			} catch(exception) {
			}
			
<%if(StringUtil.isNotBlank(gt_deposit_uid)){ %>
			
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_PUT_VIEW"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_deposit_uid'>").val("<%=gt_deposit_uid%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
<%}else{ %>
			window.close();
<%} %>
		});
	}
}

$(function () {
	$("#beobweon").combobox({
		selectOnNavigation:$(this).is(':checked')
	});
});

$("#beobweon").combobox().next().children(":text").blur(function(){
	ckBeobweon();
});
</script>