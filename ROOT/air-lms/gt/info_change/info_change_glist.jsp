<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap responseMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= responseMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= responseMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField		= responseMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod	= responseMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);	
	String callbackFunction		= responseMap.getString("callbackFunction");
	
	String schGubun = responseMap.getString("SCHGUBUN");
	String schGwanriNo = responseMap.getString("SCHGWANRINO");
	String schYocheongNam = responseMap.getString("SCHYOCHEONGNAM");
	String schSubject = responseMap.getString("SCHSUBJECT");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	
	//-- 파라메터 셋팅
	String actionCode 				= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 				= resultMap.getString(CommonConstants.MODE_CODE);
	
	String jsonDataUrl = "/ServletController"
	   + "?AIR_ACTION="+actionCode  
	   + "&AIR_MODE=JSON_LIST";					   					   
	
	//-- 코드정보 문자열 셋팅
	
	String relStr = "|"+StringUtil.getLocaleWord("L.CBO_ALL", siteLocale)
					+"^GY|"+StringUtil.getLocaleWord("L.계약", siteLocale)
					+"^JM|"+StringUtil.getLocaleWord("L.자문", siteLocale)
					+"^IJ|"+StringUtil.getLocaleWord("L.인장", siteLocale)
//					+"^SS|"+StringUtil.getLocaleWord("L.소송", siteLocale)
//					+"^PJ|"+StringUtil.getLocaleWord("L.프로젝트", siteLocale)
//					+"^IS|"+StringUtil.getLocaleWord("L.이사회", siteLocale)
					;
	
	boolean isBoebmuUser = LmsUtil.isBeobmuTeamUser(loginUser);
%>  
<script>
/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}

<%--
	$("#listTable").datagrid("load", {
		schGubun:frm.schGubun.value,
		schGwanriNo:frm.schGwanriNo.value,
		schSubject:frm.schSubject.value
	});	
--%>
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
	
	return;
}

/**
 * 검색항목 초기화
 */
function doReset(frm) {
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
		frm.reset();
	}
}

/**
 * 의뢰자 변경 수정 페이지로 이동
 */
function goChangeRequestor(frm) {
	
	var rows = $("#listTable").datagrid("getChecked");
	if(rows.length == 0){
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>");
		return false;
// 	} else if(rows.length > 1){
<%-- 		alert("<%=StringUtil.getLocaleWord("M.하나만선택가능",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>"); --%>
// 		return false;
	}
	var bool = true;
	$(rows).each(function(i, d){
		if(d.GUBUN_COD == "IJ"){
			alert("인감은 요청자를 변경할 수 없습니다.");
			bool = false;
		}
	});
	if(!bool){
		return false;
	}
	var sol_mas_ids = [];
	if(!chkGbn(rows)){
		alert("<%=StringUtil.getScriptMessage("M.서로다른구분입니다",siteLocale)%>");
		return false;
	}
	
	//--소송 프로젝트는 의뢰자를 변경 할 수 없습니다.
	for(var i=0; i<rows.length; i++) {	
		sol_mas_ids.push(rows[i].SOL_MAS_UID);
		if("SS" == rows[i].GUBUN_COD || "PJ" == rows[i].GUBUN_COD  || "IS" == rows[i].GUBUN_COD){
			alert("<%=StringUtil.getScriptMessage("M.변경불가능한구분",siteLocale)%>");
			return false;
		}
	}	
	
	frm.sol_mas_ids.value = sol_mas_ids.join(",");		
	airCommon.openWindow("" , 1024, 300, 'REQUESTOR_CHANGE_FORM', 'yes', 'yes');
	
	frm.<%=CommonConstants.MODE_CODE%>.value = "REQUESTOR_CHANGE_FORM";
	frm.action = "/ServletController";
	frm.target = "REQUESTOR_CHANGE_FORM";
	frm.submit();
}

//--같은 구분을 구했는지 체크
var chkGbn = function(rows){
	var fstGbn = "";
	var bool = true;
	$(rows).each(function(i, e){
		if(i == 0){
			fstGbn = e.GUBUN_COD;
		}
		if(fstGbn != e.GUBUN_COD){
			bool = false;
			return false;
		}
	});
	
	return bool;
}

/**
 * 의뢰자 변경 수정 페이지로 이동
 */
function goChangeHoesinGihan(frm) {
	
	var rows = $("#listTable").datagrid("getChecked");
	if(rows.length == 0){
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>");
		return false;
// 	} else if(rows.length > 1){
<%-- 		alert("<%=StringUtil.getLocaleWord("M.하나만선택가능",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>"); --%>
// 		return false;
	}
	
	for(var i=0; i<rows.length; i++) {	
		if (i == 0) {
			frm.sol_mas_uid.value = rows[i].SOL_MAS_UID;		
		}
	}	
	
	frm.<%=CommonConstants.MODE_CODE%>.value = "HOESIN_GIHAN_CHANGE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
}

/**
 * 담당자 변경 수정 페이지로 이동
 */
function goChangeManager(frm) {
	
	var rows = $("#listTable").datagrid("getChecked");
	if(rows.length == 0){
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>");
		return false;
// 	} else if(rows.length > 1){
<%-- 		alert("<%=StringUtil.getLocaleWord("M.하나만선택가능",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>"); --%>
// 		return false;
	}
	var bool = true;
	$(rows).each(function(i, d){
		if(d.GUBUN_COD == "IJ"){
			alert("인감은 담당자를 변경할 수 없습니다.");
			bool = false;
		}
	});
	if(!bool){
		return false;
	}
	if(!chkGbn(rows)){
		alert("<%=StringUtil.getScriptMessage("M.서로다른구분입니다",siteLocale)%>");
		return false;
	}
	
	var sol_mas_ids = [];
	for(var i=0; i<rows.length; i++) {	
		sol_mas_ids.push(rows[i].SOL_MAS_UID);
	}	
	
	frm.sol_mas_ids.value = sol_mas_ids.join(",");		
	airCommon.openWindow("" , 1024, 300, 'MANAGER_CHANGE_FORM', 'yes', 'yes');
	frm.<%=CommonConstants.MODE_CODE%>.value = "MANAGER_CHANGE_FORM";
	frm.action = "/ServletController";
	frm.target = "MANAGER_CHANGE_FORM";
	frm.submit();
}

/**
 * 결재선 변경 수정 페이지로 이동
 */
function goApprovedLines(frm) {
	
	var rows = $("#listTable").datagrid("getChecked");
	if(rows.length == 0){
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>");
		return false;
	} else if(rows.length > 1){
		alert("<%=StringUtil.getScriptMessage("M.하나만선택가능",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>");
		return false;
	}
	
	for(var i=0; i<rows.length; i++) {

		if("SS" == rows[i].GUBUN_COD || "PJ" == rows[i].GUBUN_COD || "IS" == rows[i].GUBUN_COD ){
			alert("<%=StringUtil.getScriptMessage("M.변경불가능한구분",siteLocale)%>");
			return false;
		}
		
		if(!(rows[i].SANGTAE_COD == "LMS_GY_PROG_11"		//-- 법무부서 결재중
			|| rows[i].SANGTAE_COD == "LMS_GY_PROG_06"	//-- 계약	심의결재
			|| rows[i].SANGTAE_COD == "LMS_JM_PROG_07"	//-- 법무부서 결재중
			|| rows[i].SANGTAE_COD == "LMS_IJ_PROG_04"		//-- 인장날인 심의결재
			|| rows[i].SANGTAE_COD == "LMS_IJ_PROG_07"		//-- 인장날인 승인결재
			)
		) {
			
			alert("<%=StringUtil.getScriptMessage("M.결재선변경불가능",siteLocale, StringUtil.getLocaleWord("L.건", siteLocale))%>");
			return false;
		}
		if (i == 0) {
			frm.sol_mas_uid.value = rows[i].SOL_MAS_UID;		
		}
	}
	airCommon.openWindow("" , 1024, 600, 'APPROVAL_CHANGE_FORM', 'yes', 'yes');
	frm.<%=CommonConstants.MODE_CODE%>.value = "APPROVAL_CHANGE_FORM";
	frm.action = "/ServletController";
	frm.target = "APPROVAL_CHANGE_FORM";
	frm.submit();
}

function goDeleteDoc(frm,save_mode){
	
	var rows = $("#listTable").datagrid("getChecked");
	if(rows.length == 0){
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.건",siteLocale))%>");
		return false;
// 	} else if(rows.length > 1){
<%-- 		alert("<%=StringUtil.getLocaleWord("M.하나만선택가능",siteLocale, StringUtil.getLocaleWord("L.건",siteLocale))%>"); --%>
// 		return false;
	}
	
	confirm_message_label = "<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.삭제",siteLocale))%>";
	if (confirm(confirm_message_label)) {
	
		
		var sol_mas_ids = [];
		for(var i=0; i<rows.length; i++) {	
			sol_mas_ids.push(rows[i].SOL_MAS_UID);
		}	
		
		var data = {};
		data["sol_mas_ids"] = sol_mas_ids.join(",");
		
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE",siteLocale,StringUtil.getLocaleWord("L.처리",siteLocale))%>")
			doSearch();
		});
		
// 		frm.sol_mas_ids.value = sol_mas_ids.join(",");	
		
<%-- 		frm.<%=CommonConstants.MODE_CODE%>.value = "DELETE_PROC"; --%>
//  		frm.action = "/ServletController";
// 		frm.target = "_self";
// 		frm.submit();	 	
	}	
	
}
</script>
<form name="form1" method="post" onsubmit="return false">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />	
	<input type="hidden" name="sol_mas_uid" />
	<input type="hidden" name="sol_mas_ids" />
<!-- 	<input type="hidden" name="schGubun" value="My" data-type="search" /> -->
	
	<table class="box">
	<tr>
		<td class="corner_lt"></td>
		<td class="border_mt"></td>
		<td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">
			<table>
				<colgroup>
					<col style="width:7%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:auto" />
					<col style="width:8%" />
				</colgroup>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>		
					<td><%=HtmlUtil.getSelect(request, true, "gubun_cod", "gubun_cod", relStr, schGubun, "class=\"select\" data-type='search' style='width:100%;'")%></td>
					<th><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>		
					<td>
						<input type="text" name="TITLE_NO" value="<%=StringUtil.convertForInput(schGwanriNo) %>" maxLength="10" class="text" data-type='search' onkeydown="doSearch(this.form, true)" style="width:100%;" />
					</td>
					<th><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
					<td><input type="text" name="YOCHEONG_NAM_KO" value="<%=StringUtil.convertForInput(schYocheongNam) %>" maxLength="10" class="text" data-type='search' onkeydown="doSearch(this.form, true)" style="width:100%;" /></td>
					<td rowspan="2" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="separ"></span>																								
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1, false);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>		
					<td colspan="5"><input type="text" name="MAS_TIT" value="<%=StringUtil.convertForInput(schSubject) %>" maxLength="45" class="text" data-type='search' onkeydown="doSearch(this.form, true)" style="width:100%;" /></td>
				</tr>
		</table>
	</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td>
		<td class="border_mb"></td>
		<td class="corner_rb"></td>
	</tr>							
	</table>
	
	<div class="buttonlist">
		<div class="left"></div>
		<div class="right">
<%
if(isBoebmuUser){
%>
		<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDeleteDoc(document.form1,'REALSAGJE')"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span>&nbsp;
<%
}
%>
		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goChangeRequestor(document.form1);"><%=StringUtil.getLocaleWord("B.의뢰자_변경",siteLocale)%></a></span>&nbsp; 	
<%
if(isBoebmuUser){
%>
		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goChangeManager(document.form1);"><%=StringUtil.getLocaleWord("B.담당자_변경",siteLocale)%></a></span>
<%
}
%>
<%-- 		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goChangeHoesinGihan(document.form1);"><%=StringUtil.getLocaleWord("B.회신기한_변경",siteLocale)%></a></span>		 --%>
<%-- 		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goApprovedLines(document.form1);"><%=StringUtil.getLocaleWord("B.결재선_변경",siteLocale)%></a></span>		 --%>
		</div>
	</div>
	
	<table id="listTable" class="easyui-datagrid" 
		data-options="singleSelect:false,
					  striped:true,
					  fitColumns:false,
					  rownumbers:true,
					  multiSort:true,
					  pagination:true,
					  pagePosition:'bottom',
					  url:'',
					  method:'post'" 
		style="width:auto;height:auto">		
	<thead>
	<tr>	
		<th data-options="field:'chk',width:40,align:'center',checkbox:true"></th>
		<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
		<th data-options="field:'SANGTAE_COD',width:0,hidden:true"></th>
		<th data-options="field:'GUBUN_COD',width:0,hidden:true"></th>
        <th data-options="field:'GUBUN_NAM_<%=siteLocale %>',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>      
        <th data-options="field:'GWANRI_NO',width:120,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>      
        <th data-options="field:'MAS_TIT',width:540,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
        <th data-options="field:'YOCHEONG_NAM_<%=siteLocale %>',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
        <th data-options="field:'YOCHEONG_DTE',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.의뢰일",siteLocale)%></th>
        <th data-options="field:'DAMDANG_NAM_<%=siteLocale %>',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
        <th data-options="field:'SANGTAE_NAM',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.처리상태",siteLocale)%></th>
	</tr>
	</thead>
	</table>		
</form>
<script>
$(document).ready(function() {		
	$('#listTabs-LIST').css('width','100%');
	$("#listTable").datagrid({
		pagePosition:'bottom',	
		pageSize:<%=pageRowSize%>,
		nowrap:false,
		url:'<%=jsonDataUrl%>',
		method:"post",				            	             
     	queryParams:airCommon.getSearchQueryParams(),
     	onBeforeLoad:function() { airCommon.showBackDrop(); },
     	onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onSortColumn:function(sort, order) {
			onSort(sort, order);
		}
	});
	
});
</script>