<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	String board_cd				= requestMap.getString("BOARD_CD");
	String baord_nm				= requestMap.getString(siteLocale);
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults LMS_BBS_TYPE 		    = responseMap.getResult("LMS_BBS_TYPE");
	
	//-- 파라메터 셋팅
	String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = responseMap.getString(CommonConstants.MODE_CODE);
	
	String bbsTypeStr = StringUtil.getCodestrFromSQLResults(LMS_BBS_TYPE, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
%>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=baord_nm %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
	<form name="form1" onsubmit="return false;">
		<input type="hidden" name="board_cd" id="board_cd" data-type="search" value="<%=board_cd%>"/>
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
						<col style="width:8%;" />
						<col style="width:35%;" />
						<col style="width:8%;" />
						<col style="width:35%;" />
						<col style="width:auto;" />
					</colgroup>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.유형", siteLocale) %></th>
						<td><%=HtmlUtil.getSelect(request, true, "TYPE_CD1", "TYPE_CD1", bbsTypeStr, "", "data-type=\"search\" class=\"select width_max_select\" style='width:100%;'") %></td>
						<th><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
						<td><input type="text" class="text width_max" name="TITLE_VAL" id="TITLE_VAL" data-type="search" onkeydown="doSearch(true)"></td>
						<td class="verticalContainer">
							<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
							<span class="separ"></span>																								
							<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
						</td>
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
		    <div class="left">
		    </div>
		    <div class="rigth">
<%if(LmsUtil.isBeobmuTeamUser(loginUser) || LmsUtil.isSysAdminUser(loginUser)){ %>
   			    	<script>
						/**
						 * 신규작성 페이지로 이동
						 */	 
						function goWrite(frm) {		
							var url = "/ServletController";
							url += "?AIR_ACTION=<%=actionCode%>";
							url += "&AIR_MODE=POPUP_WRITE_FORM";
							url += "&BOARD_CD=<%=board_cd%>";
							url += "&BAORD_NM=<%=baord_nm%>";
							
							airCommon.openWindow(url, "1024", "600", "POPUP_WRITE_FORM", "yes", "yes", "");		
						}
					</script>
					<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goWrite(document.form1);"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>		
<%} %>
		    </div>
		</div>	
	</form>
		
		<table id="listTable" style="height:auto;clear:both">
			<thead>
			<tr>
				<th data-options="field:'UUID',width:0,hidden:true"></th>
				<th data-options="field:'BOARD_CD',width:0,hidden:true"></th>
				<th data-options="field:'BOARD_TYPE',width:0,hidden:true"></th>
				<th data-options="field:'TYPE_NM',width:200,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.유형", siteLocale)%></th>
				<th data-options="field:'TITLE',width:665,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.제목", siteLocale)%></th>
				<th data-options="field:'REG_NAM',width:150,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.등록자", siteLocale)%></th>
				<th data-options="field:'REG_DTE',width:150,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.등록일", siteLocale)%></th>
			</tr>
			</thead>
		</table>
	</div>
</div>

<!-- //--엑셀 다운로드 -->
<!-- //	$("#listTable").datagrid('toExcel','test6.xls'); -->
<%-- <script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script> --%>
<script>
var doReset = function() {
	document.form1.reset();
}

/**
 * 검색 수행
 */ 
var doSearch = function(isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
};

var selectTabRefresh = function(){
	$("#listTabsLayer").tabs('getSelected').panel('refresh');
};

var goView = function(index,data){
	var uuid = data.UUID;        
    var board_cd = data.BOARD_CD;        
     
    var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=POPUP_VIEW";
	url += "&UUID="+uuid;
	url += "&BOARD_CD="+board_cd;
	url += "&BAORD_NM=<%=baord_nm%>";
	
	airCommon.openWindow(url, "1024", "600", "POPUP_VIEW", "yes", "yes", "");	
};

$(function(){
	$('#listTabs-LIST').css('width','100%');
	$('#listTable').datagrid({
		singleSelect:false,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pagePosition:'bottom',	
		nowrap:false,
 		url:'<%=jsonDataUrl%>',
 		method:"post",				            	             
      	queryParams:airCommon.getSearchQueryParams(),
      	onBeforeLoad:function() { airCommon.showBackDrop(); },
      	onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onLoadError:function() { airCommon.hideBackDrop(); },
		onClickCell: function(index, field, value){
       		if(field == "FILE_NAME" || field == "FILE_NAME2"){
       			rowClickYn = "N";
       		}else{
       			rowClickYn = "Y";
       		}
       	},
       	onClickRow:function(rowIndex,rowData) {
       		if(rowClickYn == "Y"){
 				goView(rowIndex,rowData);
       		}
       	}
	});
	$(window).bind('resize', airCommon.gridResize);
});
</script>