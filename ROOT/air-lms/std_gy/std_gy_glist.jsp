<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();
	boolean isBeobmuTeamUser = LmsUtil.isBeobmuTeamUser(loginUser);

	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String pageNo = requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String schTitle = StringUtil.convertNull(request.getParameter("schTitle")); // 제목

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code = resultMap.getString(CommonConstants.MODE_CODE);
	String upper_board_code = resultMap.getString("UPPER_BOARD_CODE");
	String code_id = resultMap.getString("CODE_ID");

	

	//-- 코드정보 문자열 셋팅
	String schFieldCodestr = "";

	int titleLength = 1000;

	String jsonDataUrl = "/ServletController" + "?AIR_ACTION=" + actionCode + "&AIR_MODE=JSON_LIST";

	//-- 권한 셋팅
	
	boolean isWritable = false;

	isWritable = (LmsUtil.isBeobmuTeamUser(loginUser) || isWritable ? true : false);

	SQLResults GY_YUHYEONG_LIST = resultMap.getResult("GY_YUHYEONG_LIST");//게시글 카운트
	
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(GY_YUHYEONG_LIST, "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //계약유형
	String HOESA_LIST_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	
%>
<script type="text/javascript">
	
	/**
	 * 검색 수행
	 */	
	function doSearch(frm, isCheckEnter) {
		if (isCheckEnter && event.keyCode != 13) {
			return;
		}
		loadTypeResult();
		$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
		
	}
	
	function doReload(frm) {
	 	$("#listTable").datagrid("reload", airCommon.getSearchQueryParams());
	 }
	
	/**
	 * 상세보기 페이지로 이동
	 */ 
	function goView(index,data) {
		var uuid = data.UUID;
		var parent_uuid = data.PARENT_UUID
		
		var url	= "/ServletController";
		url	+= "?AIR_ACTION=<%=actionCode%>";
		url	+= "&AIR_MODE=POPUP_VIEW";
		url	+= "&uuid=" + data.UUID;
		
		airCommon.openWindow(url, "1024", "650", "VIEW", "yes", "yes", "");		
	}
	
	 /**
	  * 검색항목 초기화
	  */
	 function doReset(frm) {
	 	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS", siteLocale)%>")) {
	 		frm.reset();
	 		$("#TYPE_CODE").val("");
	 	}
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
	
	var loadTypeResult = function(){
		var data = airCommon.getSearchQueryParams();
		airCommon.callAjax("<%=actionCode%>", "JSON_TYPE_RESULT",data, function(json){
			$("#typeCntArea").html("");
	        $("#typeCntTmpl").tmpl(json).appendTo("#typeCntArea");
		});
		
	}

	var resetType = function(){
// 		$("#type_code").val("");
	}
	/**
	*	유형클릭 시 
	*/
	var setBoardType = function(type_code){
		$("#TYPE_CODE").val(type_code);
	}
</script>
<script id="typeCntTmpl" type="text/x-jquery-tmpl">
<a href="javascript:void(0);" onclick="setBoardType('\${CODE_ID}');doSearch(document.form1)" class="linkbutton" style="display:inline-block;width:280px; margin:5px 5px 5px 5px;">
	<span class="linktext" id="\${CODE_ID}" >\${NAME_<%=siteLocale%>}(\${CNT})</span>
</a>
</script>
<div id="listTabsTools-LIST">
	<a href="javascript:void(0)" onclick="doSearch(document.form1)" class="icon-mini-refresh"></a>
</div>
<div id="listTabsLayer" class="easyui-tabs"
	data-options="border:false,plain:true"
	style="width: auto; height: auto">
	<div id="listTabs-LIST"
		title="<%=StringUtil.getLocaleWord("L.표준계약서현황", siteLocale)%>"
		data-options="tools:'#listTabsTools-LIST'" style="padding-top: 5px">

<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" /> 
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" /> 
<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" /> 
<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" /> 
<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
<input type="hidden" name="TYPE_CODE" id="TYPE_CODE" value="" data-type="search" />
<input type="hidden" name="singyu_yn__eq" id="singyu_yn__eq" value="Y" data-type="search" />

			<!-- 검색창 시작 -->
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
							<%if(isWritable){ %>
								<col style="width: 10%;" />
								<col style="width: 10%;" />
							<%}else{ %>
								<col style="width: 1px;" />
							<%} %>
								<col style="width: 10%;" />
								<col style="width: auto;" />
								<col style="width: 14%;" />
							</colgroup>
							<tr>
							<%if(isWritable){ %>
								<th ><%=StringUtil.getLocaleWord("L.회사", siteLocale)%></th>
								<td ><%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", HOESA_LIST_STR, loginUser.gethoesaCod(), "data-type=\"search\" onChange=\"doSearch(document.form1);\"") %></td>
							<%}else{ %>
								<td ><input type="hidden" name="HOESA_COD" value="<%=loginUser.gethoesaCod()%>" data-type="search"/></td>
							<%} %>
								<th><%=StringUtil.getLocaleWord("L.계약서명", siteLocale)%></th>
								<td><input type="text" name="TITLE" id="TITLE" value="<%=StringUtil.convertFor(schTitle, "INPUT")%>" onkeydown="doSearch(document.form1, true)" data-type="search" maxlength="50" class="text" style="width:100%;" /></td>
								<td class="verticalContainer">
									<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT", siteLocale)%></a></span>
									<span class="separ"></span> <span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH", siteLocale)%></a></span>
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
			<!-- 검색창 끝 -->
			<table class="basic" style="margin-top:5px;">
				<colgroup>
					<col style="width:25%" />
					<col style="width:25%" />
					<col style="width:25%" />
					<col style="width:25%" />
				</colgroup>
				<tbody>
					<tr>
						<td id="typeCntArea" style="padding:10px;"></td>
					</tr>
				</tbody>
			</table>
			<div class="buttonlist">
				<div class="right">
<%
	if (isWritable) {
%>
					<script>
						/**
						 * 신규작성 페이지로 팝업으로 이동
						 */	 
						function goWrite(frm) {			
							airCommon.openWindow("", "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");
							
							frm.action = "/ServletController";
							frm.<%=CommonConstants.MODE_CODE%>.value = "POPUP_WRITE_FORM";
							frm.target = "POPUP_WRITE_FORM";
							frm.submit();
						}
					</script>
					<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:goWrite(document.form1);"><%=StringUtil.getLocaleWord("B.REG", siteLocale)%></a></span>
<%
	}
%>
				</div>
			</div>

			<table id="listTable" style="width: auto; height: auto">
				<thead>
					<tr>
						<th data-options="field:'PARENT_UUID',width:0,hidden:true"></th>
						<th data-options="field:'UUID',width:0,hidden:true,"></th>
						<th data-options="field:'HOESA_NAM',width:150,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.회사", siteLocale)%></th>
						<th data-options="field:'TYPE_NM',width:150,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.유형", siteLocale)%></th>
						<th data-options="field:'TITLE',width:685,halign:'center',align:'left',sortable:true"><%=StringUtil.getLocaleWord("L.계약서명", siteLocale)%></th>
						
<%--					
						<th data-options="field:'CONTENT',width:280,halign:'center',align:'left',formatter:checkLen"><%=StringUtil.getLocaleWord("L.해설", siteLocale)%></th>
						<th data-options="field:'FILE_NAME',width:300,halign:'center',align:'left',sortable:true"><%=StringUtil.getLocaleWord("L.계약서", siteLocale)%></th>
 --%>						
						<th data-options="field:'REG_NAME_KO',width:100,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.등록자", siteLocale)%></th>
						<th data-options="field:'REG_DATE',width:85,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.등록일", siteLocale)%></th>
					</tr>
				</thead>
			</table>
</form>
	</div>
</div>
<script>
function checkLen(val){
	val = val.replace(/<br\>/ig,"\n");
	val = val.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig,"");
	
	if(val.length > 24) val = val.substring(0,24)+"...";	  
		
    return val;
}

/**
 * onload event handler
 */
$(document).ready(function() {
	loadTypeResult();
	
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
				airCommon.hideBackDrop(), airCommon.gridResize();
			},
			onClickRow:function(rowIndex,rowData) {
				goView(rowIndex,rowData);
	       	}
		});

	});
</script>