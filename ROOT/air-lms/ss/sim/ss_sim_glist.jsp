<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants" %>
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

//-- 결과값 셋팅
BeanResultMap resultMap		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
String contentName			= (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));

//-- 파라메터 셋팅
String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");
String schField				= requestMap.getString("TEXT_COL");
String schWord				= requestMap.getString("TEXT_VAL");

String jsonDataUrl 
	= "/ServletController"
	+ "?AIR_ACTION=" + actionCode  
	+ "&AIR_MODE=SIM_JSON_LIST";

String schFieldStr			= "SAGEON_NO|"+StringUtil.getLocaleWord("L.사건번호", siteLocale)+"^SAGEON_TIT|"+StringUtil.getLocaleWord("L.사건명", siteLocale) +"^DAMDANGJA_NAM|"+StringUtil.getLocaleWord("L.담당자", siteLocale) ;
%>
<!-- // Content // -->
<script>
/**
 * 선택작업 수행
 */
function doSelect(index, data) {
	var callback = $("#callbackFunction").val();
	if (callback != "") {
		callback = unescape(callback).replace(/\[JSON_DATA\]/g, "data");
		eval(callback);
	}
}

/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	$("#listTable").datagrid("load", {
		text_col:frm.text_col.value,
		text_val:frm.text_val.value
	});		
}

$(document).ready(function() {
	$("#listTable").datagrid({		
		onClickRow:function(rowIndex, rowData) {
			doSelect(rowIndex, rowData);
		},		
		singleSelect:true,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		nowrap:false,
		pagination:true,
		pagePosition:'bottom',
		url:"<%=jsonDataUrl%>",				  					  					  							  
		method:"post",
		toolbar:"#listToolbar"		
	});
});
</script>	
<div id="listToolbar" style="padding:5px">
	<form name="form1" method="post">	
		<input type="hidden" name="callbackFunction" id="callbackFunction" value="<%=StringUtil.convertForInput(callbackFunction)%>" />
		<%=HtmlUtil.getSelect(request, true, "text_col", "text_col", schFieldStr, schField, "")%>
		<input type="text" name="text_val" id="text_val" value="<%=StringUtil.convertForInput(schWord)%>" onkeydown="doSearch(document.form1, true)" class="text" style="width:200px" />
		<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="javascript:doSearch(document.form1)"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>	
	</form>										
</div>	
				
<table id="listTable" style="width:auto;height:auto">		
	<thead>
	<tr>
		<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
		<th data-options="field:'SIM_CHA_NO',width:0,hidden:true"></th>
		<th data-options="field:'SAGEON_NO',width:120,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.사건번호", siteLocale) %></th>
		<th data-options="field:'SAGEON_TIT',width:400,halign:'center',align:'left'"><%=StringUtil.getLocaleWord("L.사건명", siteLocale) %></th>
		<th data-options="field:'SANGDAEBANG_MAS',width:100,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.상대방", siteLocale) %></th>	
		<th data-options="field:'SOJEGI_DTE',width:80,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.소제기일", siteLocale) %></th>	
		<th data-options="field:'SIM_TIT',width:70,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></th>
		<th data-options="field:'DAMDANGJA_NAM',width:80,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.담당자", siteLocale) %></th>
		<th data-options="field:'PROG_NAM',width:110,halign:'center',align:'center'"><%=StringUtil.getLocaleWord("L.진행상태", siteLocale) %></th>			
	</tr>
	</thead>
</table>