<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
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
	String	 gbn = requestMap.getString("GBN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO, SIM_CHA_NM", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0)lmsMap.putAll(LMS_MAS.getRowResult(0));
	boolean isAuths = false;
	if(
			loginUser.getLoginId().equals(lmsMap.getString("DAMDANG_ID")) ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
	
	if("SS".equals(gbn) && loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	
	}else if(loginUser.isUserAuth("LMS_BCD")){
		isAuths = true;
		
	}
%>
<form name="costMngForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
<table class="list" id="TB_COST_MNG<%=sol_mas_uid%>">
	<caption>
		<span class="left">
		<%if("SS".equals(gbn)){ %>
			<%=HtmlUtil.getSelect(request, true, "SIM_CHA_NO", "SIM_CHA_NO", SIM_CODESTR, sim_cha_no, "onchange=\"JavaScript:getLmsGtCostMng"+sol_mas_uid+"(1);\" data-type='search' class=\"select\" style='width:100px;'")%>
		<%} %>
			<span style="color:darkred; font-weight:bold;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
		</span>
		<span class="right">
		<%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewCostMngWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
		<%} %>
		</span>
	</caption>
	<thead>
	<tr>
<%-- 	<th style="width:5%" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"GT_COST_MNG_UID;SOL_MAS_UID"}'>No.</th> --%>
<% if("SS".equals(requestMap.getString("GBN"))) { %>
		<th style="width:40px" data-opt='{"align":"center","col":"SIM_CHA_NM","onClick":"popupCostMng<%=sol_mas_uid%>(\"@{GT_COST_MNG_UID}\")"}'><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
<% } %>	
		<th style="width:20%" data-opt='{"align":"right","dataTp":"currency","isShowSum":true,"col":"JIGEUB_BIYONG_COST","onClick":"popupCostMng<%=sol_mas_uid%>(\"@{GT_COST_MNG_UID}\")"}'><%=StringUtil.getLocaleWord("L.지급금액", siteLocale) %></th>
		<th style="width:20%" data-opt='{"align":"center","col":"JIGEUB_GUBUN_NAME","onClick":"popupCostMng<%=sol_mas_uid%>(\"@{GT_COST_MNG_UID}\")"}'><%=StringUtil.getLocaleWord("L.지급구분", siteLocale) %></th>
		<th style="width:auto" data-opt='{"align":"center","col":"JIGEUB_DAESANG_NAM","onClick":"popupCostMng<%=sol_mas_uid%>(\"@{GT_COST_MNG_UID}\")"}'><%=StringUtil.getLocaleWord("L.지급대상", siteLocale) %></th>
		<th style="width:100px" data-opt='{"align":"center","col":"JIGEUB_YYYY_MM","onClick":"popupCostMng<%=sol_mas_uid%>(\"@{GT_COST_MNG_UID}\")"}'><%=StringUtil.getLocaleWord("L.지급품의연월", siteLocale) %></th>
		<th style="width:25%" data-opt='{"align":"left"
			,"html":{"type":"fileDown"
					,"name":"FILE_NAME"
					,"value":"FILE_UID"
					}
			}'><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
		<%if(isAuths){ %>
		<th style="width:70px" data-opt='{"align":"center","html":{"type":"BTN","class":"delete","callback":"goCostMngDel<%=sol_mas_uid%>(\"@{GT_COST_MNG_UID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}}'></th>
		<%} %>
	</tr>
	</thead>
	<tbody id="TB_COST_MNG<%=sol_mas_uid%>Body"></tbody>
<%-- 	<tfoot id="TB_COST_MNG<%=sol_mas_uid%>Foot"> --%>
<!-- 	<tr> -->
<%-- 		<td colspan="2" style="text-align:center;"><%=StringUtil.getLocaleWord("L.합계", siteLocale) %></td> --%>
<%-- 		<td data-meaning="COST_SUM<%=sol_mas_uid%>" style="text-align:right"></td> --%>
<!-- 		<td colspan="3"></td> -->
<!-- 	</tr> -->
<!-- 	</tfoot> -->
</table>
</form>
<%-- 페이지 목록 --%>
<%-- <div class="pagelist" id="TB_COST_MNG<%=sol_mas_uid%>Page"></div>  --%>
<br/>
<table class="basic">
<caption><%=StringUtil.getLocaleWord("L.비용합계", siteLocale) %></caption>
<tr>
	<th style="text-align:center; width:50%"><%=StringUtil.getLocaleWord("L.합계", siteLocale) %></th>
	<td data-meaning="COST_SUM<%=sol_mas_uid%>" style="text-align:right"></td>
</tr>
</table>

<script>
var goNewCostMngWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_GT_COST_MNG";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&sol_mas_uid=<%=sol_mas_uid%>";
	url += "&gbn=<%=gbn%>";
	
	airCommon.openWindow(url, "1024", "370", "POPUP_WRITE_FORM<%=sol_mas_uid%>", "yes", "yes", "");	
};

var popupCostMng<%=sol_mas_uid%> = function(gt_cost_mng_uid){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_cost_mng_uid'>").val(gt_cost_mng_uid));
	imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
	airCommon.openWindow("", "1024", "370", "POP_VIEW_"+gt_cost_mng_uid, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+gt_cost_mng_uid);
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
};
<%if(isAuths){ %>
var goCostMngDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	data["gt_cost_mng_uid"] = uuid;
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getLmsGtCostMng<%=sol_mas_uid%>(1);
		});
	}
};
<%} %>

var getLmsGtCostMng<%=sol_mas_uid%> = function(){
	var data = airCommon.getSearchQueryParams(document.costMngForm<%=sol_mas_uid%>);
<%-- 	data["<%=CommonConstants.PAGE_NO%>"] = pageNo; --%>
<%-- 	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10"; --%>
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		airCommon.createTableRow("TB_COST_MNG<%=sol_mas_uid%>", json);
		
		$("td[data-meaning='COST_SUM<%=sol_mas_uid%>']").text(0);
		
		if(json.rows != undefined ){
			if(json.rows[0].JIGEUB_BIYONG_COST_SUM){
<%-- 				$("#TB_COST_MNG<%=sol_mas_uid%>Foot").show(); --%>
// 				alert(json.rows[0].JIGEUB_BIYONG_COST_SUM);
				$("td[data-meaning='COST_SUM<%=sol_mas_uid%>']").text(json.rows[0].JIGEUB_BIYONG_COST_SUM);
			}
		}else{
<%-- 			$("#TB_COST_MNG<%=sol_mas_uid%>Foot").hide(); --%>
		}
	});
	
};

$(function(){
	getLmsGtCostMng<%=sol_mas_uid%>(1);
});
</script>