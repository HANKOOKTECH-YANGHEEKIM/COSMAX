<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale				= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);
	
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
	
	//String sHOESA_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sDPT_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("DPT_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sYUHYEONG_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	//String sBEOBWEON_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("BEOBWEON_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	//String sDEPOSIT_BEOBWEON_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("DEPOSIT_BEOBWEON_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));	
	String sSANGTAE01_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("SANGTAE01_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
%>
<!-- //--엑셀 다운로드 -->
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.공탁현황",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
	<form name="form1">
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
							<col style="width:12%" />
							<col style="width:20%" />
							<col style="width:12%" />
							<col style="width:auto" />
							<col style="width:80px" />
						</colgroup>
						<tr>
							<th><%=StringUtil.getLang("L.공탁일자",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_DTE__START", "DEPOSIT_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_DTE__END", "DEPOSIT_DTE__END", "", "data-type=\"search\"")%>
							</td>
							<th><%=StringUtil.getLang("L.공탁자",siteLocale) %></th>
							<td>
								<input type="text" name="DEPOSIT_MAN" data-type="search" maxLength="20" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.공탁번호",siteLocale) %></th>
							<td>
								<input type="text" name="DEPOSIT_NO" data-type="search" maxLength="20" class="text width_max" />
							</td>
							<td rowspan="3" class="verticalContainer">
								<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
								<span class="separ"></span>																								
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.종결일",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_GET_DTE__START", "DEPOSIT_GET_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_GET_DTE__END", "DEPOSIT_GET_DTE__END", "", "data-type=\"search\"")%>
							</td>
							<th><%=StringUtil.getLang("L.사건번호", siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SAGEON_NO" data-type="search" maxLength="20" />
							</td>
							<th><%=StringUtil.getLang("L.유형", siteLocale) %></th>
							<td>
								<%=HtmlUtil.getSelect(request, true, "YUHYEONG_COD", "YUHYEONG_COD", sYUHYEONG_LIST, "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %>
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.공탁금액", siteLocale) %></th>
							<td>
								<input type="text" name="DEPOSIT_COST__GT" data-type="search" maxLength="50" class="text width_max" style="width:92px;" />
								~
								<input type="text" name=DEPOSIT_COST__LT data-type="search" maxLength="50" class="text width_max" style="width:92px;" />
							</td>							
							<th><%=StringUtil.getLang("L.공탁원인사실", siteLocale) %></th>
							<td>
								<input type="text" name="DEPOSIT_WONIN" data-type="search" maxLength="50" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.처리상태", siteLocale) %></th>
							<td>
								<%=HtmlUtil.getSelect(request, true, "SANGTAE01_COD", "SANGTAE01_COD", sSANGTAE01_LIST, "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %>
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
	</form>
		<div class="buttonlist">
		    <div class="left">
		    </div>
		    <div class="rigth">
<% if (LmsUtil.isBeobmuTeamUser(loginUser)) { %>
				<script>
					var goNewWrite = function(){
						var url = "/ServletController";
						url += "?AIR_ACTION=LMS_DEPOSIT";
						url += "&AIR_MODE=WRITE_FORM";
						
						airCommon.openWindow(url, "1024", "650", "LMS_DEPOSIT_WRITE_FORM", "yes", "yes", "");	
					};
				</script>
		    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewWrite();"><%=StringUtil.getLocaleWord("B.공탁등록", siteLocale)%></a></span>
<% } %>		    	
					<script>
					/*
					 * 엑셀다운로드
					 */
					function doExcelDown(frm){
						var data = airCommon.getSearchQueryParams();
						airCommon.callAjax("<%=actionCode%>", "JSON_EXCEL",data, function(json){
							$('#listTable').datagrid('toExcel', {
							    filename: '<%=StringUtil.getLocaleWord("L.공탁현황",siteLocale)+"_"+DateUtil.getCurrentDate()%>.xls',
							    rows: json.rows,
							    worksheet: 'Worksheet'
							});
						});
					}
					</script>
					<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale) %></a></span>
		    </div>
		</div>	
		
		<table id="listTable" style="height:auto;clear:both">
			<thead>
			<tr>
				<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'DEPOSIT_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'GWANRI_NO',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.관리번호", siteLocale)%></th>
				<th data-options="field:'DEPOSIT_TIT',width:210,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.사건명", siteLocale)%></th>
				<th data-options="field:'YUHYEONG_NAM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.유형", siteLocale)%></th>
				<th data-options="field:'DEPOSIT_NO',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.공탁번호", siteLocale)%></th>
				<th data-options="field:'SAGEON_NO',width:110,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.사건번호", siteLocale)%></th>
				<th data-options="field:'DEPOSIT_MAN',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.공탁자", siteLocale)%></th>
				<th data-options="field:'DEPOSIT_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.공탁일자", siteLocale)%></th>
				<th data-options="field:'DEPOSIT_COST_MONEY',width:100,halign:'CENTER',align:'RIGHT',editor:'text',sortable:true"><%=StringUtil.getLang("L.공탁금액", siteLocale)%></th>
				<th data-options="field:'END_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.종결일", siteLocale)%></th>
				<th data-options="field:'DEPOSIT_GET_COST_MONEY',width:100,halign:'CENTER',align:'RIGHT',editor:'text',sortable:true"><%=StringUtil.getLang("L.회수합계", siteLocale)%></th>
				<th data-options="field:'SANGTAE_NAM',width:70,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.처리상태", siteLocale)%></th>
				<th data-options="field:'REG_NAM',width:70,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당자", siteLocale)%></th>
			</tr>
			</thead>
		</table>
	</div>
</div>
<script>
var doReset = function(frm){
	frm.reset();
};

function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {
		return;
	}
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}

var goView = function(index,data){
	var uid = data.UIROE_NO;
    var id = data.GWANRI_NO;        
    var title = data.GYEYAG_TIT;
    var title_no = "";
	
    if(id == ''){
     	title_no = uid;
    } else  {
    	title_no = id;
    }             
     
    if ($("#listTabsLayer").tabs("exists", title_no)) {
    	$("#listTabsLayer").tabs("close", title_no);
    } 
    
	var url = "/ServletController?AIR_ACTION=LMS_DEPOSIT&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ data.SOL_MAS_UID;// +"&stu_id="+ data.STU_ID +"&stu_gbn=GY";
	url+="&DEPOSIT_MAS_UID="+data.DEPOSIT_MAS_UID;

	airCommon.openWindow(url, "1024", "700", "TEP_"+ data.SOL_MAS_UID, "yes", "yes");
<%--	
    $("#listTabsLayer").tabs("add", {   
         id:'listTabs-'+title_no,
         title:title_no,
		href:url,
         closable:true,
         iconCls:'icon-document',
         style:{paddingTop:'5px'}
    });  
 --%>   
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