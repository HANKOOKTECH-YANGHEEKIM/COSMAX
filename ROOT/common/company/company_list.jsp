<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");


	//-- 결과값 셋팅
	BeanResultMap responseMap 		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults typeListResult 		= responseMap.getResult("TYPE_LIST");
	SQLResults classListResult 		= responseMap.getResult("CLASS_LIST");
	SQLResults natListResult 		= responseMap.getResult("NAT_LIST");
	SQLResults statusListResult 	= responseMap.getResult("STATUS_LIST");
	SQLResults listResult 			= responseMap.getResult("LIST");
	Integer listTotalCount			= responseMap.getInt("LIST_TOTALCOUNT");

	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);

	String schTypeCodestr		= StringUtil.getCodestrFromSQLResults(typeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String schClassCodestr		= StringUtil.getCodestrFromSQLResults(classListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String schNatCodestr		= StringUtil.getCodestrFromSQLResults(natListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String schStatusCodestr		= StringUtil.getCodestrFromSQLResults(statusListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));


	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
%>
<form name="form1" style="margin:0; padding:0;">
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
<input type="hidden" name="company_uid" />

<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.업체_관리",siteLocale) %>" style="padding-top:5px">
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
						<col style="width:10%;" />
						<col style="width:35%;" />
						<col style="width:auto;" />
					</colgroup>
					<tr>
						<th>로펌명<%-- <%=StringUtil.getLocaleWord("L.업체명", siteLocale)%> --%></th>
						<td><input type="text" name="NAME_KO" id="NAME_KO"  class="text width_max" data-type="search" onkeydown="doSearch(this.form, true)" /></td>
						<th><%=StringUtil.getLocaleWord("L.CONTACT변호사", siteLocale)%></th>
						<td><input type="text" name="CEO_NAME" id="CEO_NAME"  class="text width_max" data-type="search" onkeydown="doSearch(this.form, true)" /></td>
						<td rowspan="2" class="verticalContainer">
							<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
						</td>
					</tr>
<%--
					<tr>
						<th><%=StringUtil.getLocaleWord("L.상태", siteLocale)%></th>
						<td><%=HtmlUtil.getSelect(request,  true, "STATUS_CODE", "STATUS_CODE", schStatusCodestr, "", "data-type=\"search\"")%></td>
						<th><%=StringUtil.getLocaleWord("L.전담사무소여부", siteLocale)%></th>
						<td><%=HtmlUtil.getSelect(request,  true, "JEONDAM_YN", "JEONDAM_YN", "|"+StringUtil.getLocaleWord("L.CBO_ALL", siteLocale)+"^"+IpsUtils.getYnStr(), "", "data-type=\"search\"")%></td>
						 <th><%=StringUtil.getLocaleWord("L.업체분류", siteLocale)%></th>
						<td><%=HtmlUtil.getSelect(request,  true, "schClass", "schClass", schClassCodestr, schClass, "")%></td>
						<th><%=StringUtil.getLocaleWord("L.국가", siteLocale)%></th>
						<td><%=HtmlUtil.getSelect(request,  true, "schNat", "schNat", schNatCodestr, schNat, "")%></td>
					</tr>
--%>
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
		<div class="right">
			<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:goWrite(document.form1)"><%=StringUtil.getLocaleWord("B.WRITE",siteLocale)%></a></span>
		</div>
	</div>
	
	<table id="listTable" class="easyui-datagrid"
			data-options="singleSelect:true,
						  striped:true,
						  fitColumns:false,
						  rownumbers:true,
						  multiSort:true,
						  pagination:true,
						  pageList:[10,50,100,200],
						  pagePosition:'bottom',
						  selectOnCheck:false,
						  checkOnSelect:false,
						  url:'',
						  method:'post'"
			style="height:auto">
			<thead>
			<tr>
				<th data-options="field:'UUID',width:0,hidden:true"></th>
				<th data-options="field:'COMPANY_UID',width:0,hidden:true"></th>
				<th data-options="field:'CODE',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true">코드<%-- <%=StringUtil.getLang("L.업체코드", siteLocale)%> --%></th>
				<th data-options="field:'NAME_KO',width:280,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">로펌명<%-- <%=StringUtil.getLang("L.업체명", siteLocale)%> --%></th>
				<th data-options="field:'CEO_NAME',width:190,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.Contact 변호사", siteLocale)%></th>
				<th data-options="field:'USER_CNT',width:70,halign:'CENTER',align:'CENTER',editor:'text',sortable:true">변호사 수</th>
				<th data-options="field:'TELEPHONE_NO',width:150,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.전화번호", siteLocale)%></th>
				<th data-options="field:'EMAIL',width:380,halign:'CENTER',align:'CENTER',editor:'text',sortable:true">EMAIL</th>
			</tr>
			</thead>
		</table>
	</div>
</div>
</form>
<script type="text/javascript">
/**
 * 검색 수행
 */
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {
		return;
	}

	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}

/**
 * 검색항목 초기화
 */
function doReset(frm) {
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {

		$('#schName').val("");
		$('#schCeoName').val("");
		$('#schStatus').val("");
		$('#schType').val("");
		$('#schClass').val("");
		$('#schNat').val("");

// 		frm.reset();
	}
}

/**
 * 신규작성 페이지로 이동
 */
function goWrite(frm) {
	var url = "/ServletController?AIR_ACTION=SYS_COMPANY";
	url += "&AIR_MODE=WRITE_FORM";

	airCommon.openWindow(url, 1000, 720, 'popup_company_form', 'yes', 'yes');
<%--
 	frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_FORM"; 
// 	frm.action = "/ServletController";
// 	frm.target = "_self";
// 	frm.submit();
--%>
}

/**
 * 상세보기 페이지로 이동
 */
function goView(frm, json) {
	var url = "/ServletController?AIR_ACTION=SYS_COMPANY";
	url += "&AIR_MODE=VIEW";
	url += "&company_uid="+json.COMPANY_UID;
	url += "&group_code="+json.CODE;

	airCommon.openWindow(url, 1000, 720, 'popup_company_view', 'yes', 'yes');
<%-- 	
	frm.<%=CommonConstants.MODE_CODE%>.value = "VIEW"; 
// 	frm.company_uid.value = company_uid;
// 	frm.action = "/ServletController";
// 	frm.target = "_self";
// 	frm.submit();
--%>
}

/**
 * 페이지 이동
 */
function goPage(frm, pageNo, rowSize) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
	frm.<%=CommonConstants.PAGE_NO%>.value = pageNo;
	frm.<%=CommonConstants.PAGE_ROWSIZE%>.value = rowSize;
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
}
</script>
<script>
$(function(){
	$(window).bind('resize', function() {
		var w = $('.panel.datagrid').width();
		$('.panel.datagrid .panel-header').css('width',(w - 12) +'px');
		$(".panel.datagrid .panel-body").css('width', (w-2) + 'px');
		$('.panel.datagrid .datagrid-view').css('width', (w-2) + 'px');
			$('.datagrid-view2').css('width', (w-28)+'px');
			$('.datagrid-header').css('width',(w-28)+'px');
			$('.datagrid-body').css('width',(w-28)+'px');
			$('.datagrid-footer').css('width',(w-28)+'px');
	});
	
	$('#listTable').datagrid({
		url:'<%=jsonDataUrl%>',
		onBeforeLoad:function() { airCommon.showBackDrop(); },
		onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onLoadError:function() { airCommon.hideBackDrop(); },
		onClickCell:function(index,field,value){
            var jsonDataRows = $("#listTable").datagrid('getData');
            var jsonData  = jsonDataRows.rows[index];
            goView(document.form1,  jsonData );
        }
	});
	
	$('#listTabs-LIST').css('width','100%');
});
</script>