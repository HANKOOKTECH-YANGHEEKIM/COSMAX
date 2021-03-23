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
	String siteLocale = loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               	= requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField    	= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);	
	String menuNm					= requestMap.getString(siteLocale);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=SS_COST_BY_DECIDE_JSON_LIST";
	
	//-- 코드정보 문자열 셋팅
	String sSelectBox_BEOBWEON_COD = StringUtil.getCodestrFromSQLResults(resultMap.getResult("BEOBWEON_COD"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	String sSelectBox_SANGTAE_COD = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SANGTAE_COD"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	String sSelectBox_END_COD = StringUtil.getCodestrFromSQLResults(resultMap.getResult("END_COD"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	String sSelectBox_DANGSAJA_JIWI_COD = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DANGSAJA_JIWI_COD"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
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
						<col style="width:11%" />
						<col style="width:20%" />
						<col style="width:12%" />
						<col style="width:20%" />
						<col style="width:12%" />
						<col style="width:auto" />
						<col style="width:80px" />
					</colgroup>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.사건명",siteLocale) %></th>
						<td><input type="text" name="SAGEON_TIT" onkeydown="doSearch(document.form1, true)" data-type="search" maxlength="30" class="text width_max" style="" /></td>
						<th><%=StringUtil.getLocaleWord("L.관할법원",siteLocale) %></th>  
						<td><%=HtmlUtil.getSelect(request, true, "BEOBWEON_COD", "BEOBWEON_COD", sSelectBox_BEOBWEON_COD, requestMap.getString("BEOBWEON_COD"), "style=\"width:100%;\" class=\"select\" data-type=\"search\"")%></td>
						<th><%=StringUtil.getLocaleWord("L.진행상태",siteLocale) %></th>
						<td><%=HtmlUtil.getSelect(request, true, "SANGTAE_COD", "SANGTAE_COD", sSelectBox_SANGTAE_COD, requestMap.getString("SANGTAE_COD"), "style=\"width:100%;\" class=\"select\" data-type=\"search\"")%></td>  
						<td style="text-align:center;" rowspan="3">
						    <span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
							<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>						
						</td>
					</tr>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.확정신청사건번호",siteLocale) %></th>
						<td><input type="text" name="SAGEON_NO" onkeydown="doSearch(document.form1, true)" data-type="search" maxlength="30" class="text width_max" /></td>  
						<th><%=StringUtil.getLocaleWord("L.담당자",siteLocale) %></th>  
						<td><input type="text" name="DAMDANGJA_NAM" onkeydown="doSearch(document.form1, true)" data-type="search" maxlength="30" class="text width_max" /></td>
						<th><%=StringUtil.getLocaleWord("L.종결구분",siteLocale) %></th>
						<td><%=HtmlUtil.getSelect(request, true, "END_COD", "END_COD", sSelectBox_END_COD, requestMap.getString("END_COD"), "style=\"width:100%;\" class=\"select\" data-type=\"search\"")%></td>  
					</tr>
					<tr>
						<th><%=StringUtil.getLocaleWord("L.소송비용청구종결일",siteLocale) %></th>
						<td>
							<%=HtmlUtil.getInputCalendar(request, true, "DEMAND_END_DTE_FROM", "DEMAND_END_DTE_FROM", requestMap.getString("DEMAND_END_DTE_FROM"), "data-type=\"search\"")%>
							~
							<%=HtmlUtil.getInputCalendar(request, true, "DEMAND_END_DTE_TO", "DEMAND_END_DTE_TO", requestMap.getString("DEMAND_END_DTE_TO"), "data-type=\"search\"")%>
						</td>
						<th><%=StringUtil.getLocaleWord("L.상대방",siteLocale) %></th>  
						<td><input type="text" name="SANGDAEBANG" onkeydown="doSearch(document.form1, true)" data-type="search" maxlength="30" class="text width_max" /></td>
						<th><%=StringUtil.getLocaleWord("L.당사지위",siteLocale) %></th>
						<td><%=HtmlUtil.getSelect(request, true, "DANGSAJA_JIWI_COD", "DANGSAJA_JIWI_COD", sSelectBox_DANGSAJA_JIWI_COD, requestMap.getString("DANGSAJA_JIWI_COD"), "style=\"width:100%;\" class=\"select\" data-type=\"search\"")%></td>  
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
				<span style="color:red">※ 소송이 확정된 건 중 소송비용을 회수하기로 결정한 건을 대상으로 합니다.</span>
			</div>
			<div class="right">
		    	<script>
				/*
				 * 엑셀다운로드
				 */
				function doExcelDown(){
					var data = airCommon.getSearchQueryParams();
					airCommon.callAjax("<%=actionCode%>", "SS_COST_BY_DECIDE_JSON_EXCEL",data, function(json){
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
		<table id="listTable" style="height:auto;clear:both">
			<thead>
			<tr>
				<th data-options="field:'COLOR',width:0,hidden:true"></th>
				<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'STU_ID',width:0,hidden:true"></th>
				<th data-options="field:'GWANRI_NO',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.관리번호", siteLocale)%></th>
				<th data-options="field:'SANGDAEBANG',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.상대방", siteLocale)%></th>
				<th data-options="field:'SOSONGGA_COST',width:100,halign:'CENTER',align:'RIGHT',editor:'text',sortable:true, formatter:formatCurrency"><%=StringUtil.getLang("L.소송가액", siteLocale)%></th>
				<th data-options="field:'DAMDANGJA_NAM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당자", siteLocale)%></th>
				<th data-options="field:'SAGEON_TIT',width:200,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.사건명", siteLocale)%></th>
				<th data-options="field:'SANGTAE_NAM',width:125,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.진행상태", siteLocale)%></th>
				<th data-options="field:'DERIIN_NAM',width:90,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.신청대리인", siteLocale)%></th>		
				<th data-options="field:'DECIDE_COST',width:120,halign:'CENTER',align:'RIGHT',editor:'text',sortable:true, formatter:formatCurrency"><%=StringUtil.getLang("L.소송비용확정금액", siteLocale)%></th>	
				<th data-options="field:'REAL_COST',width:100,halign:'CENTER',align:'RIGHT',editor:'text',sortable:true, formatter:formatCurrency"><%=StringUtil.getLang("L.실제입금금액", siteLocale)%></th>
				<th data-options="field:'DEMAND_END_DTE',width:130,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.소송비용청구종결일", siteLocale)%></th>
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
		$('#schDateFrom').getDiffDate(1,'year');
		$("#schDateTo").getDiffDate(0,'day');	
		$("#schYuHyeong").val("");
		$("#schHoesaCd").val("");
		$("#schHoesaNm").val("");
	}
}

// 오늘,1주일,1달 등등
$(function(){
  $.fn.extend({
    getDiffDate:function(diff,type){
      var to_date = new Date();

      switch(type){
        case 'day':
          to_date.setDate(to_date.getDate()-diff);
          break;

        case 'month':
          to_date.setMonth(to_date.getMonth()-diff);
          break;

        case 'year':
          to_date.setFullYear(to_date.getFullYear()-diff);
          break;
        default:
          return false;
          break;
      }     

      $(this).val(to_date.getFullYear()+'-'+$.fn.setAddZero(to_date.getMonth()+1)+'-'+$.fn.setAddZero(to_date.getDate()));
    },
    setAddZero:function(val){
      var tmp = val.toString();

      if(tmp.length == 1){
        tmp = '0'+tmp;
      }
      return tmp;
    }
  });
});

/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter){
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	var stday = frm.DEMAND_END_DTE_FROM.value;  
	var edday = frm.DEMAND_END_DTE_TO.value;  
	 
	if ("" !=stday && "" != edday ){
	    if(stday > edday) {
		    alert ("<%=StringUtil.getLocaleWord("M.ALERT_WRONG",siteLocale,StringUtil.getLocaleWord("L.기간", siteLocale))%>");
		    frm.schDateTo.focus();  
		   return;
		}
	} 
	
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