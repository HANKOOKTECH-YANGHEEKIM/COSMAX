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
	SQLResults rsDecideCost = resultMap.getResult("DECIDE_COST");
	
	BeanResultMap decideCostMap = new BeanResultMap();
	if(rsDecideCost != null && rsDecideCost.getRowCount()> 0){
		decideCostMap.putAll(rsDecideCost.getRowResult(0));
	}
	
	String gt_decide_cost_uid	= decideCostMap.getString("GT_DECIDE_COST_UID");
	String temp_gt_decide_cost_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String SANGTAE_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SANGTAE_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); 
	String END_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("END_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); 	
	
	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids = "";
	
	if(StringUtil.isBlank(gt_decide_cost_uid)){
		att_master_doc_id = temp_gt_decide_cost_uid;
		att_default_master_doc_Ids 	= "";
	}else{
		att_master_doc_id = gt_decide_cost_uid;
		att_default_master_doc_Ids = gt_decide_cost_uid;
	}
%>
<br />
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_decide_cost_uid" value="<%=gt_decide_cost_uid%>" />
	<input type="hidden" name="temp_gt_decide_cost_uid" value="<%=temp_gt_decide_cost_uid%>" />
	<table class="basic">
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.진행상태", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "SANGTAE_COD", "SANGTAE_COD", SANGTAE_CODESTR, decideCostMap.getString("SANGTAE_COD"), "onchange=\"changeEtcTxt(this.value, 'SANGTAE_NAM', this.id)\" class=\"select width_max\"")%>
				<input type="hidden" name="SANGTAE_NAM" id="SANGTAE_NAM" value="<%=decideCostMap.getString("SANGTAE_NAM") %>" />
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.종결구분", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "END_COD", "END_COD", END_CODESTR, decideCostMap.getString("END_COD"), "class=\"select width_max\"")%>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.소송비용확정금액", siteLocale) %></th>
			<td class="td4" style="text-align:right">
				KRW <input type="text" name="DECIDE_COST" id="DECIDE_COST" onkeyup="airCommon.getFormatCurrency(this);" value="<%=StringUtil.getFormatCurrency(decideCostMap.getString("DECIDE_COST"),-1) %>" maxlength="15" class="cost" style="width:85%" />
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.실제입금금액", siteLocale) %></th>
			<td class="td4" style="text-align:right">
				KRW <input type="text" name="REAL_COST" id="REAL_COST" onkeyup="airCommon.getFormatCurrency(this);" value="<%=StringUtil.getFormatCurrency(decideCostMap.getString("REAL_COST"),-1) %>" maxlength="15" class="cost" style="width:85%" />
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.신청대리인", siteLocale) %></th>
			<td class="td4">
				<input type="text" name="DERIIN_NAM" id="DERIIN_NAM" value="<%=decideCostMap.getString("DERIIN_NAM") %>" maxlength="15" class="text width_max" maxlength="255" />
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.소송비용청구종결일", siteLocale) %></th>
			<td class="td4">
				<%= HtmlUtil.getInputCalendar(request, true, "DEMAND_END_DTE", "DEMAND_END_DTE", decideCostMap.getString("DEMAND_END_DTE"), "") %>
			</td>
		</tr>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.확정신청사건번호", siteLocale) %></th>
			<td class="td2" colspan="3">
				<input type="text" name="SAGEON_NO" id="SAGEON_NO" value="<%=decideCostMap.getString("DEMAND_END_DTE") %>" maxlength="20" class="text width_max2" maxlength="255" />
			</td>
		</tr>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.회수불가사유", siteLocale) %></th>
			<td class="td2" colspan="3">
				<input type="text" name="REASON" id="REASON" value="<%=decideCostMap.getString("REASON") %>" class="text width_max2" maxlength="50" />
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
var changeEtcTxt = function(vThisValue, vId, vThisID){
	if(vThisValue.endsWith("_99") || vThisValue.endsWith("_ZZ")){
		$("#"+vId).val("기타");
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
		
		$("#DECIDE_COST").val($("#DECIDE_COST").val().replace(/,/g,""));
		$("#REAL_COST").val($("#REAL_COST").val().replace(/,/g,""));
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			try {
				opener.$('#tepIndexOptTabs-decideCost').panel('open').panel('refresh');
			} catch(exception) {
			}

			window.close();
		});
	}
};
</script>