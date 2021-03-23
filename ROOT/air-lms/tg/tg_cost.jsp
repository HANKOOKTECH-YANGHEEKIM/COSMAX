<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale	= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               	= requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField    	= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);	
	String menuNm					= requestMap.getString(siteLocale);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	SQLResults COST_LIST = resultMap.getResult("COST_LIST");
			
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=COST_JSON_LIST";
	
	//-- 코드정보 문자열 셋팅
	String schYuHyeongStr = "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^GY|"+StringUtil.getLocaleWord("L.계약",siteLocale)+"^JM|"+StringUtil.getLocaleWord("L.자문",siteLocale)+"^SS|"+StringUtil.getLocaleWord("L.소송",siteLocale);
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
%>
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=menuNm %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
	
<form name="form1" method="post">
	<input type="hidden" name="<%=siteLocale %>" value="<%=requestMap.getString("MENU_NAME_KO")%>" />
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
		
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
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:auto" />
					<col style="width:160px" />
				</colgroup>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.지급품의연월",siteLocale) %></th>
					<td>
						<select name="schYear" data-type="search" style="width:70px;">
							<%=HtmlUtil.getSelectboxCalendar("YEAR", 2018, -1, requestMap.getString("SCHYEAR")) %>
						</select>
						<select name="schMonth" data-type="search" style="width:50px;">
							<%=HtmlUtil.getSelectboxCalendar("MONTH", 1, 12, requestMap.getString("SCHMONTH")) %>
						</select>
					</td>
					<th><%=StringUtil.getLocaleWord("L.구분",siteLocale) %></th>
					<td><%=HtmlUtil.getSelect(request, true, "GUBUN_COD", "GUBUN_COD", schYuHyeongStr, requestMap.getString("GUBUN_COD"), "data-type=\"search\" style=\"width:100%;\" class=\"select\"")%></td>  
					
					<script>
						//소송 삭제
						$("#GUBUN_COD option:eq(3)").remove();
					</script>
					
					<th><%=StringUtil.getLocaleWord("L.지급대상",siteLocale) %></th>
					<td><input type="text" name="JIGEUB_DAESANG_NAM" data-type="search" maxlength="30" class="text width_max" /></td>
					<td style="text-align:center;">
					    <span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>						
					</td>
				</tr>
				<tr>
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
			<span style="color:red"><%=StringUtil.getLocaleWord("M.지급품의연월기준",siteLocale) %></span>
		</div>
		<div class="right">
	    	<script>
			/*
			 * 엑셀다운로드
			 */
			function doExcelDown(){
				var data = airCommon.getSearchQueryParams();
				airCommon.callAjax("<%=actionCode%>", "COST_JSON_EXCEL",data, function(json){
					$('#listTable').datagrid('toExcel', {
					    filename: '<%=menuNm+"_"+DateUtil.getCurrentDate()%>.xls',
					    rows: json.rows,
					    worksheet: 'Worksheet'
					});
				});
			}
			</script>
			<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown()"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>		
		</div>
	</div>
</form>
		<table id="listTable" style="width:auto; height:auto">
			<thead>
			<tr>
				<th data-options="field:'GUBUN_NAME',width:50,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.구분", siteLocale)%></th>
				<th data-options="field:'REG_EMP_NAME',width:70,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당자", siteLocale)%></th>
				<th data-options="field:'WIN_WHERE',width:530,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.내용", siteLocale)%></th>
				<%-- <th data-options="field:'YOCHEONG_DPT_NAME',width:130,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%//=StringUtil.getLang("L.현업부서", siteLocale)%></th>
				<th data-options="field:'CHIEF_USER_NAME',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%//=StringUtil.getLang("L.현업팀장", siteLocale)%></th> --%>
				<th data-options="field:'HOESA_NAM',width:110,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회사", siteLocale)%></th>
				<th data-options="field:'JIGEUB_DAESANG_NAM',width:150,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.지급대상", siteLocale)%></th>
				<th data-options="field:'JIGEUB_GUBUN_NAME',width:160,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.지급구분", siteLocale)%></th>
				<th data-options="field:'JIGEUB_BIYONG',width:100,halign:'CENTER',align:'RIGHT',editor:'text',sortable:true,formatter:formatCurrency"><%=StringUtil.getLang("L.금액", siteLocale)%></th>
			</tr>
			</thead>
		</table>
	</div>
</div>
<script>
function formatCurrency(value){
    if (value){

        var s = airCommon.getFormatCurrency(value);
        return s;

    } else {
        return '';
    }
}
function doReset(frm) {
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale) %>")) {
		frm.reset();
	    $("#schYear").val("<%=Calendar.getInstance().get(Calendar.YEAR) %>");
	    $("#schMonth").val("<%=Calendar.getInstance().get(Calendar.MONTH)+1 %>");
		$("#GUBUN_COD").val("");
		$("#JIGEUB_DAESANG_NAM").val("");
	}
}

/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter){
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}

var selectTabRefresh = function(){
	$("#listTabsLayer").tabs('getSelected').panel('refresh');
}

$(document).ready(function() {
	$("#listTable").datagrid({
		singleSelect:false,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pagePosition:'bottom',	
		pageSize:<%=pageRowSize%>,
		nowrap:false,
		url:'<%=jsonDataUrl%>',
		method : "post",
		queryParams : airCommon.getSearchQueryParams(),
		onBeforeLoad : function() {
			airCommon.showBackDrop();
		},
		onLoadSuccess : function() {
			airCommon.gridResize();
		},
		onClickRow:function(rowIndex,rowData) {
       	},
		rowStyler:function(index, row){
      		if(row.MAJOR_YN == 'Y'){
      			return 'color:#bb8c00';
      		}
      		if(row.YUHYEONG01_COD == 'LMS_SS_YUHYEONG_GJ'){
      			return 'color:darkgray';
      		}
      	}
	});
});
</script>