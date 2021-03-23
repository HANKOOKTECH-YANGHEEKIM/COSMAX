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
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);


	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String gbn	=	requestMap.getString("GBN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		costMng = resultMap.getResult("MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(costMng != null && costMng.getRowCount()> 0){
		masMap.putAll(costMng.getRowResult(0));
	}
	
	String gt_cost_mng_uid	= masMap.getString("GT_COST_MNG_UID");
	String temp_gt_cost_mng_uid = StringUtil.getRandomUUID();
	
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	//첨부관련 셋팅
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	if(StringUtil.isNotBlank(gt_cost_mng_uid)){ //수정
		att_master_doc_id = gt_cost_mng_uid;
		att_default_master_doc_Ids = gt_cost_mng_uid;
	}else{ //신규
		att_master_doc_id = temp_gt_cost_mng_uid;
		att_default_master_doc_Ids = "";
	}
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO,SIM_CHA_NM", "");
	String GUBUN_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN"), "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String JIGEUB_DAESANG_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("JIGEUB_DAESANG_CODESTR"), "SOSOG_COD,SOSOG_NAM", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale))+"^COM-000000_ZZ|"+StringUtil.getLocaleWord("L.기타",siteLocale);
%>
<form name="saveForm" id="saveForm">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gubun_cod" value="<%=gbn%>" />
	<input type="hidden" name="gt_cost_mng_uid" value="<%=gt_cost_mng_uid%>" />
	<input type="hidden" name="temp_gt_cost_mng_uid" value="<%=temp_gt_cost_mng_uid%>" />
	<table class="basic">
<%if("SS".equals(gbn)){ %>
	    <tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></span></th>
			<td class="td4" colspan="3">
				<%=HtmlUtil.getSelect(request, true, "sim_cha_no", "sim_cha_no", SIM_CODESTR, "", "class=\"select\"")%>
			</td>
		</tr> 
<%} %>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.지급구분", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "jigeub_gubun", "jigeub_gubun", GUBUN_STR, masMap.getString("JIGEUB_GUBUN"), "onchange=\"changeEtcTxt(this.value, 'jigeub_gubun_name', this.id)\" class=\"select width_max\"") %>
				<input type="text" name="jigeub_gubun_name" id="jigeub_gubun_name" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=masMap.getString("JIGEUB_GUBUN_NAME")%>" maxlength="50" class="text width_max" style="display:<%=masMap.getString("JIGEUB_GUBUN").endsWith("ZZ") ? "" : "none" %>;" />
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.지급대상", siteLocale) %></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "jigeub_daesang_cod", "jigeub_daesang_cod", JIGEUB_DAESANG_STR, masMap.getString("JIGEUB_DAESANG_COD"), "onchange=\"changeEtcTxt(this.value, 'jigeub_daesang_nam', this.id)\" class=\"select width_max\"") %>
 				<input type="text" name="jigeub_daesang_nam" id="jigeub_daesang_nam" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=masMap.getString("JIGEUB_DAESANG_NAM")%>" maxlength="50" class="text width_max" style="display:<%=masMap.getString("JIGEUB_DAESANG_COD").endsWith("ZZ") ? "" : "none" %>;" />
			</td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.지급품의연월", siteLocale) %></th> 
			<td class="td4">
				<input type="text" name="jigeub_yyyy" id="jigeub_yyyy" maxlength="4" placeholder="XXXX(4자리로 입력)" value="<%=masMap.getString("JIGEUB_YYYY")%>" /><%=StringUtil.getLocaleWord("L.년", siteLocale) %>
				<input type="text" name="jigeub_mm" id="jigeub_mm" maxlength="2" placeholder="XX(2자리로 입력)" value="<%=masMap.getString("JIGEUB_MM")%>" /><%=StringUtil.getLocaleWord("L.월", siteLocale) %>
			
<%-- 		<%= HtmlUtil.getInputCalendar(request, true, "jigeubil_dte", "jigeubil_dte", masMap.getString("JIGEUBIL_DTE"), "") %><br /> --%>
				<br /><span style="color:red;"><%=StringUtil.getLocaleWord("M.지급품의연월_알림",siteLocale) %></span>
			</td>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.지급금액", siteLocale) %></th>
			<td class="td4" style="text-align:left;">
				(KRW)
				<input type="text"  name="jigeub_biyong" id="jigeub_biyong" onkeyup="airCommon.getFormatCurrency(this);" value="<%=StringUtil.getFormatCurrency(masMap.getString("JIGEUB_BIYONG"),-1)%>" maxlength="15" style="width:80%" />
				<br />
				<span style="color:red"><%=StringUtil.getLocaleWord("M.부가세_별도",siteLocale) %></span>
			</td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td class="td4" colspan="3">
				<input type="text" name="win_where" id="win_where" value="<%=masMap.getString("WIN_WHERE")%>" maxlength="50" class="text width_max" />
				<%-- 
				<span style="color:red">※ 지급수수료 파일 항목에 그대로 기재되는 내용입니다.</span>
<% if("SS".equals(gbn)){ %>
				<span style="color:red">※ 법원, 사건번호를 반드시 기입하시기 바랍니다.</span>
<% } %> --%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/BIYONG" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
<%--
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.성공보수조건", siteLocale) %></th>
			<td class="td2" colspan="3">
				<input type="text" name="win_where" id="win_where" value="<%=masMap.getString("WIN_WHERE")%>" maxlength="100" class="text width_max" />
			</td>
		</tr>
--%>		
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    	<%if(StringUtil.isNotBlank(gt_cost_mng_uid)){ %>
	    	<span class="ui_btn medium icon"><span class="refresh"></span><a href="javascript:void(0)" onclick="history.back() ;"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
	   	<%}else{ %>
   	    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
	   	<%} %>
    </div>
</div>	
<script>
var frm = document.saveForm;

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
<%if("SS".equals(gbn)){ %>	
	if ("" == frm.sim_cha_no.value ) {
	    alert ("<%=StringUtil.getLocaleWord("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.심급", siteLocale))%>");
	    frm.sim_cha_no.focus();
	    return false;
	}
<%}%>
	var bool = true;
	if ("" == $("#jigeub_gubun").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"지급구분")%>");
		$("#jigeub_gubun").focus();
	    return false;	
	}else if($("#jigeub_gubun").val().endsWith("99")){
		if ("" == $("#jigeub_gubun_name").val() ) {
			alert ("지급구분 '기타' 선택 시 입력란은 필수 입력 사항입니다.");
			$("#jigeub_gubun_name").focus();
			bool =  false;	
		}
	}
	if(!bool){
		return false;
	}
	if ("" == $("#jigeub_yyyy").val() || "" == $("#jigeub_mm").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"지급품의연월")%>");
		$("#jigeub_yyyy").focus();
	    return false;	
	}
	if(4 != $("#jigeub_yyyy").val().length ){
		alert ("지급품의연은 4자로 입력해야 합니다.");
		$("#jigeub_yyyy").focus();
	    return false;	
	}
	if(2 != $("#jigeub_mm").val().length ){
		alert ("지급품의월은 2자로 입력해야 합니다.");
		$("#jigeub_mm").focus();
	    return false;	
	}

	if ("" == $("#jigeub_biyong").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"지급금액")%>");
		$("#jigeub_biyong").focus();
	    return false;	
	}
	if ("" == $("#win_where").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"검토쟁점")%>");
		$("#jigeub_dte").focus();
	    return false;	
	}
	
	frm.jigeub_biyong.value = frm.jigeub_biyong.value.replace(/,/g,"");
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			
		<%if(StringUtil.isNotBlank(gt_cost_mng_uid)){ %>
			try {
				opener.getLmsGtCostMng<%=sol_mas_uid%>(1);
			}catch(e) {
			}
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_cost_mng_uid'>").val("<%=gt_cost_mng_uid%>"));
			imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
		
	   	<%}else{ %>
		   	opener.getLmsGtCostMng<%=sol_mas_uid%>(1);
			window.close();
	   <%} %>
		});
	}
}
</script>