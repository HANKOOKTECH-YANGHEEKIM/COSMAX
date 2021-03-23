<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
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

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults rsMas = resultMap.getResult("DECIDE_COST");
	
	BeanResultMap decideCostMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		decideCostMap.putAll(rsMas.getRowResult(0));
	}
	
	String gt_decide_cost_uid = decideCostMap.getString("GT_DECIDE_COST_UID");
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
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
<table class="basic" id="LmsGtDecideCostTable">
	<caption style="background:none;">
		<span class="left" style="color:darkred;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
		<span class="right">
		<%if(isAuths){ %>
<%
	if(null==gt_decide_cost_uid || "".equals(gt_decide_cost_uid)) {
%>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goDecideCostWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
<%
	} else {
%>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goDecideCostWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.수정",siteLocale)%></a></span>
	    	<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDecideCostDel<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
<%
	}
%>
		<%}%>
		</span>
	</caption>
<%
	if(null==gt_decide_cost_uid || "".equals(gt_decide_cost_uid)) {
	} else {
%>	
	<tr>
		<th class="th4">진행상태</th>
		<td class="td4"><%=StringUtil.convertForView(decideCostMap.getString("SANGTAE_NM")) %><span id="SANGTAE_NM"></span></td>
		<th class="th4">종결구분</th>
		<td class="td4"><%=StringUtil.convertForView(decideCostMap.getString("END_NM")) %><span id="END_NM"></span></td>
	</tr>
	<tr>
		<th class="th4">소송비용 확정금액</th>
		<td class="td4" style="text-align:left;">
			<%if(StringUtil.isNotBlank(decideCostMap.getString("DECIDE_COST"))){ %>
				(KRW)
			<%=StringUtil.getFormatCurrency(decideCostMap.getString("DECIDE_COST"),-1)%>
			<%} %>
		</td>
		<th class="th4">실제 입금 금액</th>
		<td class="td4" style="text-align:left;">
			<%if(StringUtil.isNotBlank(decideCostMap.getString("REAL_COST"))){ %>
				(KRW)
			<%=StringUtil.getFormatCurrency(decideCostMap.getString("REAL_COST"),-1)%>
			<%} %>
		</td>
	</tr>
	<tr>
		<th class="th4">신청 대리인</th>
		<td class="td4"><%=StringUtil.convertForView(decideCostMap.getString("DERIIN_NAM")) %><span id="DERIIN_NAM"></span></td>
		<th class="th4">소송비용청구 종결일</th>
		<td class="td4"><%=StringUtil.convertForView(decideCostMap.getString("DEMAND_END_DTE")) %><span id="DEMAND_END_DTE"></span></td>
	</tr>
	<tr>
		<th class="th4">확정신청 사건번호</th>
		<td class="td4" colspan="3"><%=StringUtil.convertForView(decideCostMap.getString("SAGEON_NO")) %><span id="SAGEON_NO"></span></td>
	</tr>
	<tr>
		<th class="th4">회수불가사유</th>
		<td class="td4" colspan="3"><%=StringUtil.convertForView(decideCostMap.getString("REASON")) %><span id="REASON"></span></td>
	</tr>
	<tr>
		<th class="th4">진행경과(일자별)</th>
		<td class="td4" colspan="3">
		
			<table class="list" id="LmsGtDecideCostProgressTable">
			<caption>
				<span class="left" style="color:darkred;"></span>
				<span class="right">
				<%if(isAuths){ %>
			    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProgressWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
				<%} %>
				</span>
			</caption>
			<thead>
			<tr>
				<th style="width:9%" data-opt='{"align":"center","col":"PROGRESS_DTE"}'><%=StringUtil.getLocaleWord("L.날짜", siteLocale) %></th>
				<th style="width:20%" data-opt='{"align":"center","col":"GUBUN_NM"}'><%=StringUtil.getLocaleWord("L.구분", siteLocale) %></th>
				<th style="width:auto" data-opt='{"align":"left","col":"DETAIL"}'><%=StringUtil.getLocaleWord("L.진행내용", siteLocale) %></th>
				<th style="width:20%" data-opt='{"align":"center","col":"IMSI"}'><%=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th>
				<th style="width:70px" data-opt='{"align":"center"<%if(isAuths){ %>,"html":{"type":"BTN","class":"delete","callback":"goDecideCostProgressDel<%=sol_mas_uid%>(\"@{GT_DECIDE_COST_PROGRESS_UID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}<%} %>}'></th>
			</tr>
			</thead>
			<tbody id="LmsGtDecideCostProgress<%=sol_mas_uid%>Body"></tbody>
			</table>
		</td>
	</tr>
<%
	}
%>
</table>
<form name="decideCostForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_decide_cost_uid" data-type="search" value="<%=gt_decide_cost_uid%>" />
</form>
<script id="LmsGtDecideCostProgress<%=sol_mas_uid%>Template" type="text/html">
    <tr id="\${GT_DECIDE_COST_PROGRESS_UID}">
        <td onclick="goProgressWrite<%=sol_mas_uid%>('\${GT_DECIDE_COST_PROGRESS_UID}');" style="text-align:center; cursor:pointer;">\${PROGRESS_DTE}</td>
        <td onclick="goProgressWrite<%=sol_mas_uid%>('\${GT_DECIDE_COST_PROGRESS_UID}');" style="text-align:center; cursor:pointer;">\${GUBUN_NAM}</td>
        <td onclick="goProgressWrite<%=sol_mas_uid%>('\${GT_DECIDE_COST_PROGRESS_UID}');" style="text-align:center; cursor:pointer;">\${DETAIL}</td>
        <td style="text-align:left; cursor:pointer;">{{html fileDown(FILE_UID,FILE_NAME)}}</td>
		<td style="text-align:center;">
			<%if(isAuths){ %>
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDecideCostProgressDel<%=sol_mas_uid%>('\${GT_DECIDE_COST_PROGRESS_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
			<%} %>
		</td>
    </tr>
</script>
<script>
var goDecideCostWrite<%=sol_mas_uid%> = function(){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")

	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_decide_cost_uid'>").val("<%=gt_decide_cost_uid%>"));
	
	airCommon.openWindow("", "1024", "300", "LMS_GT_DECIDE_COST_POPUP_WRITE_FORM_<%=gt_decide_cost_uid%>", "yes", "yes", "");	

	imsiForm.attr("target", "LMS_GT_DECIDE_COST_POPUP_WRITE_FORM_<%=gt_decide_cost_uid%>");
	
	imsiForm.appendTo("body");
	
	imsiForm.submit();
	
	imsiForm.remove();
};

var goProgressWrite<%=sol_mas_uid%> = function(vGt_decide_cost_progress_uid){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")

	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("PROGRESS_POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_decide_cost_uid'>").val("<%=gt_decide_cost_uid%>"));
	if(""==vGt_decide_cost_progress_uid) {
	} else {
		imsiForm.append($("<input type='hidden' name='gt_decide_cost_progress_uid'>").val(vGt_decide_cost_progress_uid));
	}
	
	airCommon.openWindow("", "1024", "550", "LMS_GT_DECIDE_COST_PROGRESS_POPUP_WRITE_FORM_"+vGt_decide_cost_progress_uid, "yes", "yes", "");	
	
	imsiForm.attr("target", "LMS_GT_DECIDE_COST_PROGRESS_POPUP_WRITE_FORM_"+vGt_decide_cost_progress_uid);
	
	imsiForm.appendTo("body");
	
	imsiForm.submit();
	
	imsiForm.remove();
};

var goDecideCostDel<%=sol_mas_uid%> = function(){
	var data = {};
	
	data["gt_decide_cost_uid"] = "<%=gt_decide_cost_uid%>";
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			$('#tepIndexOptTabs-decideCost').panel('open').panel('refresh');
		});
	}
};

var goDecideCostProgressDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	
	data["gt_decide_cost_uid"] = "<%=gt_decide_cost_uid%>";
	data["gt_decide_cost_progress_uid"] = uuid;
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "PROGRESS_DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getLmsDecideCostProgress<%=sol_mas_uid%>(1);
		});
	}
};

var getLmsDecideCostProgress<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.decideCostForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";

	airCommon.callAjax("<%=actionCode%>", "PROGRESS_JSON_LIST",data, function(json){
		setLmsDecideCostProgress<%=sol_mas_uid%>(json);
	});
};

var setLmsDecideCostProgress<%=sol_mas_uid%> =  function(data){
	// 기존 데이터 삭제
	$("#LmsGtDecideCostProgress<%=sol_mas_uid%>Body tr").remove();
	
	var arrData = data.rows;

   	//jquery-tmpl
   	var tgTbl = $("#LmsGtDecideCostProgress<%=sol_mas_uid%>Body");

	$("#LmsGtDecideCostProgress<%=sol_mas_uid%>Template").tmpl(arrData).appendTo(tgTbl);
};

var fileDown = function(fileVal, fileNm){
	var rtnStr = "";
	var arrNm = fileNm.split("/");
	var arrVal = fileVal.split("/");
	if(fileNm != "" && arrNm.length > 0){
		rtnStr += "<ul class='attach_file_view'>"
		$(arrNm).each(function(k,a){
			rtnStr += "<li>"
			rtnStr += "<a href='javascript:airCommon.popupAttachFileDownload(\""+arrVal[k]+"\")'>"+arrNm[k]+"</a>";
			rtnStr += "</li>"
		});
		rtnStr += "</ul>"
	}
	
	return rtnStr;
};

$(function(){
	getLmsDecideCostProgress<%=sol_mas_uid%>(1);
});
</script>