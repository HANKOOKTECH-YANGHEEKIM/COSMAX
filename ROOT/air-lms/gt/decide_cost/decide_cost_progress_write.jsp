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
	String gt_decide_cost_uid	= requestMap.getString("GT_DECIDE_COST_UID");
	String gt_decide_cost_progress_uid	= requestMap.getString("GT_DECIDE_PROGRESS_COST_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults rsDecideCost = resultMap.getResult("DECIDE_COST_PROGRESS");
	
	BeanResultMap decideCostMap = new BeanResultMap();
	if(rsDecideCost != null && rsDecideCost.getRowCount()> 0){
		decideCostMap.putAll(rsDecideCost.getRowResult(0));
	}
	
	String temp_gt_decide_cost_progress_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String GUBUN_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); 	
	
	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids = "";
	
	if(StringUtil.isBlank(gt_decide_cost_progress_uid)){
		att_master_doc_id = temp_gt_decide_cost_progress_uid;
		att_default_master_doc_Ids 	= "";
	}else{
		att_master_doc_id = gt_decide_cost_progress_uid;
		att_default_master_doc_Ids = gt_decide_cost_progress_uid;
	}
%>
<br />
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_decide_cost_uid" value="<%=gt_decide_cost_uid%>" />
	<input type="hidden" name="gt_decide_cost_progress_uid" value="<%=gt_decide_cost_progress_uid%>" />
	<input type="hidden" name="temp_gt_decide_cost_progress_uid" value="<%=temp_gt_decide_cost_progress_uid%>" />
	<table class="basic">
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.날짜", siteLocale) %></th>
			<td class="td4">
				<%= HtmlUtil.getInputCalendar(request, true, "PROGRESS_DTE", "PROGRESS_DTE", decideCostMap.getString("PROGRESS_DTE"), "") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "GUBUN_COD", "GUBUN_COD", GUBUN_CODESTR, decideCostMap.getString("GUBUN_COD"), "onchange=\"changeEtcTxt(this.value, 'GUBUN_NAM', this.id)\" class=\"select width_max\"") %>
				<input type="text" name="GUBUN_NAM" id="GUBUN_NAM" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=decideCostMap.getString("GUBUN_NAM")%>" maxlength="50" class="text width_max" style="display:<%=decideCostMap.getString("GUBUN_COD").endsWith("ZZ") ? "" : "none" %>;" />
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.진행내용", siteLocale) %></th>
			<td class="td4" colspan="3">
				<textarea name="DETAIL" id="DETAIL" onblur="airCommon.validateMaxLength(this, 4000)" class="memo width_max2" style="height:265px;"><%=decideCostMap.getStringEditor("DETAIL") %></textarea>
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
                    <jsp:param value="LMS/GT/DECIDE_COST_PROGRESS" name="typeCode" />
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

var goProc = function(){
	if ("" == $("#SANGTAE_COD").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"진행상태")%>");
		$("#SANGTAE_COD").focus();
	    return false;	
	}

	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "PROGRESS_WRITE_PROC",data, function(json){
			opener.getLmsDecideCostProgress<%=sol_mas_uid%>(1);
			//opener.$('#tepIndexOptTabs-decideCost').panel('open').panel('refresh');
			window.close();
		});
	}
}
</script>