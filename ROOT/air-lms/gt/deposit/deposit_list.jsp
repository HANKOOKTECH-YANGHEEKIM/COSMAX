<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults" %>
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
	String	 sol_mas_uid =  requestMap.getString("SOL_MAS_UID");
	String	 sim_cha_no =  requestMap.getString("SIM_CHA_NO");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	SQLResults sqlrDepositPut = resultMap.getResult("DEPOSIT_PUT");
	SQLResults sqlrDepositGet = resultMap.getResult("DEPOSIT_GET");
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO, SIM_CHA_NM", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	
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
	
	if( loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	}
%>
<form name="depositForm" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
<span style="color:darkred; font-weight:bold;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
<table class="list">
	<caption>
		<span class="left">
			<%=HtmlUtil.getSelect(request, true, "SIM_CHA_NO", "SIM_CHA_NO", SIM_CODESTR, sim_cha_no, "onchange=\"JavaScript:getLmsGtCostMng"+sol_mas_uid+"(1);\" data-type='search' class=\"select\" style='width:100px;'")%>
		</span>
		<span class="right">
		<%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goDepositPutWrite();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
		<%} %>
		</span>
	</caption>
</table>
</form>

<%
	BeanResultMap brmDepositPut = new BeanResultMap();
	BeanResultMap brmDepositGet = new BeanResultMap();

	for(int iCount=0; sqlrDepositPut.getRowCount()>iCount; iCount++) {
		brmDepositPut.putAll(sqlrDepositPut.getRowResult(iCount));
%>
<table class="list" style="margin-bottom:5px;">
	<thead>
	<tr>
		<th style="width:50px">심급</th>
		<th style="width:110px">공탁번호</th>
		<th style="width:auto">공탁법원</th>
		<th style="width:100px">공탁일자</th>
		<th style="width:15%">공탁금</th>
		<th style="width:20%">공탁사유</th>
		<th style="width:70px"></th>
	</tr>
	</thead>
		<tr>
			<td onclick="goDepositPutView('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositPut.getString("SIM_NAME") %></td>
			<td onclick="goDepositPutView('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositPut.getString("GONGTAG_NO") %></td>
			<td onclick="goDepositPutView('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositPut.getString("BEOBWEON_NAM") %></td>
			<td onclick="goDepositPutView('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositPut.getString("GONGTAG_DTE") %></td>
			<td onclick="goDepositPutView('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositPut.getString("GONGTAG_COST_NAME") %> <%=StringUtil.getFormatCurrency(brmDepositPut.getString("GONGTAG_COST"), -1) %></td>
			<td onclick="goDepositPutView('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositPut.getString("SAYU_NAME") %></td>
			<td style="text-align:center;"><%if(isAuths){ %><span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDepositPutDel('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span><%}%></td>
		</tr>
		<tr class="not_hover">
			<td colspan="7" style="padding:10px;">
				<table class="list">
					<caption>
						<span class="left"></span>
						<span class="right">
						<%if(isAuths){ %>
					    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goDepositGetWrite('<%=brmDepositPut.getString("GT_DEPOSIT_UID") %>');"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
						<%} %>
						</span>
					</caption>
					<thead>
					<tr>
						<th style="width:70px">회수차수</th>
						<th style="width:100px">회수일자</th>
						<th style="width:15%">회수금액</th>
						<th style="width:15%">회수이자</th>
						<th style="width:auto">회수사유</th>
						<th style="width:65px"></th>
					</tr>
					</thead>
<%
	for(int iCount2=0; sqlrDepositGet.getRowCount()>iCount2; iCount2++) {
		brmDepositGet.putAll(sqlrDepositGet.getRowResult(iCount2));
		if( brmDepositPut.getString("GT_DEPOSIT_UID").equals(brmDepositGet.getString("GT_DEPOSIT_UID"))){
%>
					<tr>
						<td onclick="goDepositGetView('<%=brmDepositGet.getString("GT_DEPOSIT_GET_UID") %>');" style="text-align:center; cursor:pointer;"><%=iCount2+1 %></td>
						<td onclick="goDepositGetView('<%=brmDepositGet.getString("GT_DEPOSIT_GET_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositGet.getString("GET_DTE") %></td>
						<td onclick="goDepositGetView('<%=brmDepositGet.getString("GT_DEPOSIT_GET_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositGet.getString("GET_COST_NAME") %> <%=StringUtil.getFormatCurrency(brmDepositGet.getString("GET_COST"), -1) %></td>
						<td onclick="goDepositGetView('<%=brmDepositGet.getString("GT_DEPOSIT_GET_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositGet.getString("IJA_COST_NAME") %> <%=StringUtil.getFormatCurrency(brmDepositGet.getString("IJA_COST"), -1) %></td>
						<td onclick="goDepositGetView('<%=brmDepositGet.getString("GT_DEPOSIT_GET_UID") %>');" style="text-align:center; cursor:pointer;"><%=brmDepositGet.getString("SAYU") %></td>
						<td style="text-align:center;"><%if(isAuths){ %><span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDepositGetDel('<%=brmDepositGet.getString("GT_DEPOSIT_GET_UID") %>');"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span><%} %></td>
					</tr>
<%
		}
	}
%>
				</table>
			</td>
		</tr>
<% 
	}
%>
</table>
<script>
var doSearch = function(vSim_cha_no) {
	var vUrl = "/ServletController?AIR_ACTION=LMS_GT_DEPOSIT&AIR_MODE=LIST&gbn=SS&sol_mas_uid=<%=sol_mas_uid%>&sim_cha_no="+vSim_cha_no;
	
	$('#tepIndexOptTabs-deposit').panel('open').panel('refresh', vUrl);
}
<%if(isAuths){ %>
var goDepositPutWrite = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_DEPOSIT";
	url += "&AIR_MODE=POPUP_PUT_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";

	airCommon.openWindow(url, "1024", "350", "POPUP_PUT_WRITE_FORM", "yes", "yes", "");	
};
<%}%>

var goDepositPutView = function(vGT_DEPOSIT_UID){
	
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_PUT_VIEW"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='GT_DEPOSIT_UID'>").val(vGT_DEPOSIT_UID));
	airCommon.openWindow("", "1024", "350", "POP_VIEW_"+vGT_DEPOSIT_UID, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+vGT_DEPOSIT_UID);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
};

var goDepositPutDel = function(uuid){
	var data = {};
	data["gt_deposit_uid"] = uuid;

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "PUT_DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			$('#tepIndexOptTabs-deposit').panel('open').panel('refresh');
		});
	}
};

var goDepositGetWrite = function(vGT_DEPOSIT_UID){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_GET_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='GT_DEPOSIT_UID'>").val(vGT_DEPOSIT_UID));
	airCommon.openWindow("", "1024", "350", "POPUP_GET_WRITE_FORM"+vGT_DEPOSIT_UID, "yes", "yes", "");	
	imsiForm.attr("target", "POPUP_GET_WRITE_FORM"+vGT_DEPOSIT_UID);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
};

var goDepositGetView = function(vGT_DEPOSIT_GET_UID){
	
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_GET_VIEW"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='GT_DEPOSIT_GET_UID'>").val(vGT_DEPOSIT_GET_UID));
	airCommon.openWindow("", "1024", "350", "POP_VIEW_"+vGT_DEPOSIT_GET_UID, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+vGT_DEPOSIT_GET_UID);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
	
};

var goDepositGetDel = function(uuid){
	var data = {};
	data["gt_deposit_get_uid"] = uuid;
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "GET_DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			$('#tepIndexOptTabs-deposit').panel('open').panel('refresh');
		});
	}
};
</script>