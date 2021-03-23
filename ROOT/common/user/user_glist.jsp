<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField		= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	String callbackFunction		= requestMap.getString("callbackFunction");

	String schUserAuth			= requestMap.getString("schUserAuth");
	String schAdminAuth			= requestMap.getString("schAdminAuth");
	String schStatus			= requestMap.getString("schStatus");
	String schCsf				= requestMap.getString("schCsf");
	String schValue				= requestMap.getString("schValue");
	String hoesaCod				= requestMap.getString("HOESA_COD");
	

	//-- 결과값 셋팅
	BeanResultMap responseMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	SQLResults userDutyListResult 		= responseMap.getResult("USER_DUTY_LIST");
	SQLResults userPosListResult 		= responseMap.getResult("USER_POS_LIST");
	SQLResults userGrdListResult 		= responseMap.getResult("USER_GRD_LIST");
	SQLResults userTypeListResult 		= responseMap.getResult("USER_TYPE_LIST");
	SQLResults userStatListResult 		= responseMap.getResult("USER_STAT_LIST");
	SQLResults adminAuthListResult 		= responseMap.getResult("ADMIN_AUTH_LIST");
	SQLResults userAuthListResult 		= responseMap.getResult("USER_AUTH_LIST");
	SQLResults userHoesaListResult		= responseMap.getResult("HOESA_LIST");

	//-- 파라메터 셋팅
	String actionCode 				= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 				= responseMap.getString(CommonConstants.MODE_CODE);

	String jsonDataUrl = "/ServletController"
	   + "?AIR_ACTION=SYS_USER"
	   + "&AIR_MODE=JSON_LIST";

	//-- 코드정보 문자열 셋팅
	String userDutyCodestr 	= StringUtil.getCodestrFromSQLResults(userDutyListResult, "CODE,TEXT_"+ siteLocale, "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userPosCodestr 	= StringUtil.getCodestrFromSQLResults(userPosListResult, "CODE,TEXT_"+ siteLocale, "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userGrdCodestr 	= StringUtil.getCodestrFromSQLResults(userGrdListResult, "CODE,TEXT_"+ siteLocale, "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userTypeCodestr 	= StringUtil.getCodestrFromSQLResults(userTypeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userStatCodestr 	= StringUtil.getCodestrFromSQLResults(userStatListResult, "CODE,LANG_CODE", "ALL|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String adminAuthCodestr = StringUtil.getCodestrFromSQLResults(adminAuthListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String userAuthCodestr  = StringUtil.getCodestrFromSQLResults(userAuthListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String hoesaCodestr 	= StringUtil.getCodestrFromSQLResults(userHoesaListResult, "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
%>
<script>
/**
 * 검색 수행
 */
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {
		return;
	}

	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());

	return;
}

/**
 * 검색항목 초기화
 */
function doReset(frm) {
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
		frm.reset();
	}
}

/**
 * 권한 수정 페이지로 이동
 */
function goEdit(frm) {
	var uuids = [];
	var names = [];

	var rows = $("#listTable").datagrid("getChecked");
	if(rows.length == 0){
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale,"L.사용자")%>");
		return;
	}

	for(var i=0; i<rows.length; i++) {
		uuids.push(rows[i].UUID);
		names.push(rows[i].NAME_<%=siteLocale%>);

		if (i == 0) {
// 			frm.uuid.value = rows[i].UUID;
		}
	}
	
	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=UPDATE_FORM";
	url += "&user_uid="+uuids.join(",");
	url += "&chk_user_name_all="+names.join(",");

	airCommon.openWindow(url , 1024, 420, 'popup_update_form', 'yes', 'yes');
	
// 	frm.chk_user.value = uuids.join(",");
// 	frm.chk_user_name_all.value = names.join(", ");

<%-- 	frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_FORM"; --%>
// 	frm.action = "/ServletController";
// 	frm.target = "_self";
// 	frm.submit();
}

/**
 * 상세보기 오픈
 */
function openDetail(uuid){
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_VIEW&uuid=' + uuid, 1024, 340, 'open_user_info', 'yes', 'yes');
}

/*
 * 사용자 수정
 */
function doEditUser( user_uid){
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=UPDATE_FORM&user_uid='+user_uid, 1024, 420, 'company_edit_user', 'yes', 'yes');
}

/*
 * 사용자 추가
 */
function doAddUser(){
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=INSERT_FORM&group_uid=&company_uid=', 1024, 420, 'company_add_user', 'yes', 'yes');
}
</script>

<form name="form1" method="post" onsubmit="return false">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
	<input type="hidden" name="uuid" />
	<input type="hidden" name="chk_user" />	
	<input type="hidden" name="chk_user_name_all" />
	
	<div class="table_cover">
	
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
						<col style="width:8%" />
						<col style="width:36%" />
						<col style="width:12%" />
						<col style="width:auto" />
						<col style="width:80px" />
					</colgroup>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.이름", siteLocale)%></th>
						<td>
							<input type="text" name="NAME_KO" value="<%=StringUtil.convertForInput(schValue) %>" data-type="search" onkeydown="doSearch(this.form, true)" maxlength="30" class="text width_max" />
		<%-- 					<input type="text" name="GROUP_NAME_KO" value="<%=StringUtil.convertForInput(schValue) %>" size="30" class="text" data-type="search" onkeydown="doSearch(this.form, true)" /> --%>
		<%-- 					<%=HtmlUtil.getSelect(request,  true, "schCsf", "schCsf", "name|이름^dept|부서명", schCsf, "") %> --%>
		<%-- 					<input type="text" name="schValue" value="<%=StringUtil.convertForInput(schValue) %>" size="30" class="text" data-type="search" onkeydown="doSearch(this.form, true)" /> --%>
						</td>
						<th><%=StringUtil.getLocaleWord("L.회사", siteLocale)%></th>
						<td>
							<%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", hoesaCodestr, hoesaCod, "class=\"select width_max\" data-type=\"search\" style='width:100%;'")%>
						</td>
						<td rowspan="2" class="verticalContainer">
							<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							<span class="separ"></span>
							<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
						</td>
					</tr>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.상태", siteLocale)%></th>
						<td><%=HtmlUtil.getSelect(request,  true, "STATUS_CODE", "STATUS_CODE", userStatCodestr, schStatus, "data-type=\"search\" style='width:99.8%;'")%></td>
						<th><%=StringUtil.getLocaleWord("L.사용자권한", siteLocale)%></th>
						<td><%=HtmlUtil.getSelect(request,  true, "AUTH_CODES", "AUTH_CODES", userAuthCodestr, schUserAuth, "data-type=\"search\" style='width:99.7%;'")%></td>
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
		
	</div>
</form>
	<div class="buttonlist">
		<div class="left">
		</div>
		<div class="right">
		 	<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:doAddUser()"><%=StringUtil.getLocaleWord("B.사용자생성",siteLocale)%></a></span>
			<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goEdit(document.form1);"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
		</div>	
	</div>

	<table id="listTable"
		data-options="singleSelect:true,
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
		<th data-options="field:'UUID',width:0,hidden:true"></th>
		<th data-options="field:'NAME',width:0,hidden:true"></th>
		<th data-options="field:'NAME_<%=siteLocale%>',width:130,halign:'center',align:'left',sortable:true" align="center" >이름</th>
		<th data-options="field:'HOESA_NAM',width:300,halign:'center',align:'left',sortable:true" align="center" >회사명</th>
		<th data-options="field:'TELEPHONE_NO',width:130,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.연락처", siteLocale)%></th>
		<th data-options="field:'AUTH_NAMES',width:460,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.사용자권한", siteLocale)%></th>
		<th data-options="field:'STATUS_NAME_<%=siteLocale%>',width:100,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.사용유무", siteLocale)%></th>
	</tr>
	</thead>
	</table>
	
	<%-- <span style="color:red;">
		<%//=StringUtil.getLocaleWord("M.소송매니저_권한_설명",siteLocale)%><br/>
		<%//=StringUtil.getLocaleWord("M.공통_시스템관리자_권한_설명",siteLocale)%><br/>
		<%//=StringUtil.getLocaleWord("M.법무_시스템관리자_권한_설명",siteLocale)%><br/>
		<%//=StringUtil.getLocaleWord("M.공통/게시판관리자_권한_설명",siteLocale)%><br/>
	</span> --%>
	
<script>
$(function(){
	$('#listTabs-LIST').css('width','100%');
	$('#listTable').datagrid({
		url:'<%=jsonDataUrl%>',
		method:"post",
		queryParams:airCommon.getSearchQueryParams(),
		onBeforeLoad:function() { airCommon.showBackDrop(); },
		onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onLoadError:function() { airCommon.hideBackDrop(); }
		/* ,onDblClickCell:function(index,field,value){
            var jsonDataRows = $("#listTable").datagrid('getData');
            var jsonData  = jsonDataRows.rows[index];
            doEditUser(jsonData.UUID )
        } */
	});
	$(window).bind('resize', airCommon.gridResize);
	$("#listTabsLayer").tabs({
		onSelect:function(title,index){
			if (0 == index) {
				doSearch(document.form1);
			}
		},
		onClose:function(title,index){
			doSearch(document.form1);
		}
	});
});
</script>