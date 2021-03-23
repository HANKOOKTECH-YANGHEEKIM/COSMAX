<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@page import="com.emfrontier.air.common.util.DateUtil"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

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
	
	//유형코드
// 	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(responseMap.getResult("JM_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	//상태
	String STU_LISTSTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("STU_LIST"), "STU_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
		
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE","|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	String PAPER_YH_CODE_LIST = StringUtil.getCodestrFromSQLResults(responseMap.getResult("PAPER_YH_CODE_LIST"), "CODE_ID,LANG_CODE","|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
%>
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.법인인감",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
<form name="form1" style="margin:0; padding:0;">
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
						<col style="width:24%" />
						<col style="width:8%" />
						<col style="width:20%" />
						<col style="width:10%" />
						<col style="width:20%" />
						<col style="width:*" />
					</colgroup>
					<tr>
						<th><%=StringUtil.getLang("L.의뢰일",siteLocale) %></th>
						<td>
							<%=HtmlUtil.getInputCalendar(request, true, "YOCHEONG_DTE__START", "YOCHEONG_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "YOCHEONG_DTE__END", "YOCHEONG_DTE__END", "", "data-type=\"search\"")%>
						</td>
						<th><%=StringUtil.getLang("L.서류유형",siteLocale) %></th>
						<td><%=HtmlUtil.getSelect(request, true, "SEORYU_TYPE_COD", "SEORYU_TYPE_COD", PAPER_YH_CODE_LIST, "", "class=\"select width_max_select\" data-type=\"search\" style='width:98%;'") %></td>
						<th><%=StringUtil.getLang("L.회사",siteLocale) %></th>
						<td>
							<input type="text" name="HOESA_NAM__LK" onkeydown="doSearch(document.form1, true);" data-type="search" class="text width_max" />
<%-- 								<%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", HOESA_CODESTR, "", "class=\"select width_max\" data-type=\"search\" style='width:100%;'")%> --%>
						</td>
						<td rowspan="4" class="verticalContainer">
							<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
							<span class="separ"></span>																								
							<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
						</td>
					</tr>
					<tr>
						<th><%=StringUtil.getLang("L.의뢰부서",siteLocale) %></th>
						<td>
							<input type="text" name="YOCHEONG_DPT_NM" data-type="search"  onkeyup="doSearch(document.form1, true);" maxlength="30" class="text width_max" />
						</td>
						<th><%=StringUtil.getLang("L.의뢰자",siteLocale) %></th>
						<td>
							<input type="text" name="YOCHEONG_NM" data-type="search" onkeyup="doSearch(document.form1, true);" maxlength="30" class="text width_max" />
						</td>
						<th><%=StringUtil.getLang("L.상태",siteLocale) %></th>
						<td><%=HtmlUtil.getSelect(request, true, "STU_ID", "STU_ID", STU_LISTSTR, "", "class=\"select width_max_select\" data-type=\"search\" style='width:98%;'") %></td>
					</tr>
					<tr>
						<th><%=StringUtil.getLang("L.서류제목",siteLocale) %></th>
						<td colspan="3">
							<input type="text" name="INJANG_TIT" data-type="search"  onkeyup="doSearch(document.form1, true);" maxlength="30" class="text" style="width:98.5%;" />
						</td>
						<th><%=StringUtil.getLang("L.관리번호",siteLocale) %></th>
						<td>
							<input type="text" name="GWANRI_NO" data-type="search"  onkeyup="doSearch(document.form1, true);" maxlength="20" class="text width_max" />
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
		    	 <%if(loginUser.isUserAuth("LMS_BJD")){ %>
			    	<%=HtmlUtil.getInputRadio(request, true, "schGuBun", "All|" + StringUtil.getLocaleWord("R.전체",siteLocale) + "^My|" + StringUtil.getLocaleWord("L.나의업무",siteLocale) , "My", "onclick=\"doSearch(document.form1);\" data-type=\"search\"", "")%>	
			    <%}else if(loginUser.isUserAuth("LMS_OFI")){ %>
			    	<input type="hidden" name="schGubun" id="schGubun" value="All" data-type="search" />
			    <%}else{ %>
			    	<%=HtmlUtil.getInputRadio(request, true, "schGuBun", "All|" + StringUtil.getLocaleWord("L.부서",siteLocale) + "^My|" + StringUtil.getLocaleWord("L.나의업무",siteLocale), "My", "onclick=\"doSearch(document.form1);\" data-type=\"search\"", "")%>
			    <%} %>
		    </div>
		    <div class="rigth">
		    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewWrite();"><%=StringUtil.getLocaleWord("B.인감날인요청",siteLocale)%></a></span>
		    	 <%
			if(LmsUtil.isBeobmuTeamUser(loginUser)){
			%>
					    	<script>
							/*
							 * 엑셀다운로드
							 */
							function doExcelDown(){
								
								var data = airCommon.getSearchQueryParams();
								
								airCommon.callAjax("<%=actionCode%>", "JSON_EXCEL",data, function(json){
									
									$('#listTable').datagrid('toExcel', {
									    filename: '<%=StringUtil.getLocaleWord("L.법인인감",siteLocale)+"_"+DateUtil.getCurrentDate()%>.xls',
									    rows: json.rows,
									    worksheet: 'Worksheet'
									});
								});
							}
							</script>
							<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown()"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>
			<%
				}
			%>
		    </div>
		</div>	
</form>
		
		<table id="listTable" style="height:auto;clear:both">
			<thead>
			<tr>
				<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'STU_ID',width:0,hidden:true"></th>
				<th data-options="field:'GWANRI_NO',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.관리번호", siteLocale)%></th>
				<th data-options="field:'INJANG_TIT',width:280,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.서류제목", siteLocale)%></th>
				<th data-options="field:'SEORYU_TYPE_NM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.서류유형", siteLocale)%></th>
				<th data-options="field:'HOESA_NAM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회사", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_DPT_NM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰부서", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_NM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰자", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰일", siteLocale)%></th>
				<th data-options="field:'GEOMTO_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.날인완료일", siteLocale)%></th>
				<th data-options="field:'DAMDANG_DPT_NM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당부서", siteLocale)%></th>				
				<th data-options="field:'DAMDANG_NM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당자", siteLocale)%></th>
				<th data-options="field:'STU_NAM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.상태", siteLocale)%></th>
			</tr>
			</thead>
		</table>
	</div>
</div>

<script>
var doReset = function(frm){
	frm.reset();
};
/**
 * 검색 수행
 */ 
var doSearch = function(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	
	var stday = $("#YOCHEONG_DTE__START").val(); // frm.schYocheongDteStart.value;  // 의뢰일 시작일자
	var edday = $("#YOCHEONG_DTE__END").val(); // frm.schYocheongDteEnd.value;  // 의뢰일 종료일자
	
	if ("" !=stday && "" != edday ){
		if(stday > edday) {
		    alert("<%=StringUtil.getScriptMessage("M.ALERT_REINPUT", siteLocale, StringUtil.getLocaleWord("L.종료일이시작일보다작습니다_종료일", siteLocale))%>");
		    frm.lms_pati_gyeyag_ed_dte.focus();
	        return false;	
		 }
	} 
	
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}
var selectTabRefresh = function(){
	$("#listTabsLayer").tabs('getSelected').panel('refresh');
}
var goNewWrite = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=SYS_FORM";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&munseo_seosig_no=DDD-LMS-IJ-001";
	url += "&stu_id=IJ_REQ";
	url += "&next_stu_id=IJ_REQ";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
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
    
	var url = "/ServletController?AIR_ACTION=LMS_IJ_LIST_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ data.SOL_MAS_UID;

	airCommon.openWindow(url, "1024", "700", "TEP_"+ data.SOL_MAS_UID, "yes", "yes");
	
    /* 
    	같은 문서의 작성창이 열릴 경우 오브젝트 id중복으로 인한 오류 해결을 위해 팝업
    $("#listTabsLayer").tabs("add", {   
         id:'listTabs-'+title_no,
         title:title_no,
		href:url,
         closable:true,
         iconCls:'icon-document',
         style:{paddingTop:'5px'}
    });  */
}
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
		nowrap:true,
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