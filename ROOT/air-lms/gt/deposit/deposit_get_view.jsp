<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
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
	String	 gt_deposit_uid =	requestMap.getString("GT_DEPOSIT_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults rsDeposit = resultMap.getResult("DEPOSIT_GET");
	
	BeanResultMap depositMap = new BeanResultMap();
	if(rsDeposit != null && rsDeposit.getRowCount()> 0){
		depositMap.putAll(rsDeposit.getRowResult(0));
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
	
	if(loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	
	}
%>
<form name="depositGetForm" id="depositGetForm">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_deposit_uid" value="<%=gt_deposit_uid%>" />
	<input type="hidden" name="gt_deposit_get_uid" value="<%=gt_deposit_get_uid%>" />
	<input type="hidden" name="temp_gt_deposit_get_uid" value="<%=temp_gt_deposit_get_uid%>" />
	<table class="basic">
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.회수일자", siteLocale) %></th>
			<td class="td4"><%=depositMap.getString("GET_DTE") %></td>	
			<th class="th4"><%=StringUtil.getLocaleWord("L.회수담당자", siteLocale) %></th>
			<td class="td4"><%=depositMap.getString("GET_DAMDANGJA_NAM") %></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.회수금액", siteLocale) %></th>
			<td class="td4"><%=depositMap.getString("GET_COST_NAME") %> <%=StringUtil.getFormatCurrency(depositMap.getString("GET_COST"),-1) %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.회수이자", siteLocale) %></th>
			<td class="td4"><%=depositMap.getString("IJA_COST_NAME") %> <%=StringUtil.getFormatCurrency(depositMap.getString("IJA_COST"),-1) %></td>
		</tr>
		<tr>			
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.회수사유", siteLocale) %></span></th> 
			<td class="td4" colspan="3"><%=depositMap.getString("SAYU") %></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td class="td4" colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/DEPOSIT/GET" name="typeCode" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    <%if(isAuths){ %>
    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goUpdate();"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
    <%} %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<%if(isAuths){ %>
<script>
var goUpdate = function(){

	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_GET_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_deposit_uid'>").val("<%=gt_deposit_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_deposit_get_uid'>").val("<%=gt_deposit_get_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
	
}
</script>
<%} %>