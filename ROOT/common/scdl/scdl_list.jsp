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
	//BeanResultMap requestMap = (BeanResultMap)request.getAttribute("requestMap");
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD); 
	
	String schType				= requestMap.getString("SCHTYPE");
	String schField				= requestMap.getString("SCHFIELD");
	String schValue				= requestMap.getString("SCHVALUE");
	String schFromDate			= requestMap.getString("SCHFROMDATE");
	String schToDate			= requestMap.getString("SCHTODATE");
	String rangeDay             = requestMap.getString("RANGEDAY");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	
	SQLResults listResult 			= resultMap.getResult("LIST");
	//Integer listTotalCount			= resultMap.getInt("LIST_TOTALCOUNT");
	SQLResults schTypeListResult 	= resultMap.getResult("SCH_TYPE_LIST");
	
	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
	
	String 제목 = StringUtil.getLocaleWord("L.제목",siteLocale);
	String 장소 = StringUtil.getLocaleWord("L.장소",siteLocale);
	String 메모 = StringUtil.getLocaleWord("L.메모",siteLocale);
	String 유형 = StringUtil.getLocaleWord("L.유형",siteLocale);
	String 검색어 = StringUtil.getLocaleWord("L.검색어",siteLocale);
	String 기간 = StringUtil.getLocaleWord("L.기간",siteLocale);
	String 번호 = StringUtil.getLocaleWord("L.번호",siteLocale);
	String 일시 = StringUtil.getLocaleWord("L.일시",siteLocale);
	String 등록자 = StringUtil.getLocaleWord("L.등록자",siteLocale);
	String 전체 = StringUtil.getLocaleWord("L.전체",siteLocale);
	String 건 = StringUtil.getLocaleWord("L.건",siteLocale);  
	
	//-- 코드정보 문자열 셋팅
	String schFieldCodestr 	= "SCDL_TIT;SCDL_PLCE;SCDL_MEMO|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale) +"^SCDL_TIT|"+제목+"^SCDL_PLCE|"+장소+"^SCDL_MEMO|"+메모;
	String schTypeCodestr 	= StringUtil.getCodestrFromSQLResults(schTypeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	
	//-- 권한 설정
//	boolean isAdmin		= resultMap.getBoolean("IS_ADMIN");			//관리자 권한
//	boolean isWriteUser	= resultMap.getBoolean("IS_WRITE_USER");	//작성자 권한
	
	boolean isAdmin		= true;			//관리자 권한
	boolean isWriteUser	= true;	//작성자 권한

    String jsonDataUrl = "/ServletController"
            + "?AIR_ACTION=CMM_SCDL" 
            + "&AIR_MODE=JSON_LIST" ;
%>
<script type="text/javascript">
var frm2 = document.form1;

/**
 * 검색 수행
 */ 
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	
	var stday = frm.SCDL_BGN_DATE__START.value;  // 의뢰일 시작일자
	var edday = frm.SCDL_END_DATE__END.value;  // 의뢰일 종료일자
	
	if ("" !=stday && "" != edday ){
		if(stday > edday) { 
		    alert("<%=StringUtil.getLocaleWord("M.ALERT_REINPUT", siteLocale, StringUtil.getLocaleWord("L.종료일이시작일보다작습니다_종료일", siteLocale))%>");
		    frm.schToDate.focus();
	        return false;	
		 }
	} 
 
	
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}


/**
 * 검색 수행
 */	
<%--
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	frm.<%=CommonConstants.PAGE_NO%>.value = "1";
	frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();		
} 
--%>

/**
 * 검색항목 초기화
 */
function doReset(frm) {
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
		frm.reset();
	}
}

/**
 * 신규작성 페이지로 이동
 */	 
function goWrite(frm) {		
	frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();		
}

/**
 * 상세보기 페이지로 이동
 */
function goView(scdlUid) {	
	document.form1.<%=CommonConstants.MODE_CODE%>.value = "VIEW";
	document.form1.scdl_uid.value = scdlUid;
	document.form1.action = "/ServletController";
	document.form1.target = "_self";
	document.form1.submit(); 
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

/**
 * 정렬 이벤트 핸들러
 */
function onSort(sort, order) {
	$("input[name=<%=CommonConstants.PAGE_ORDERBY_FIELD%>]").val(sort);
	$("input[name=<%=CommonConstants.PAGE_ORDERBY_METHOD%>]").val(order);
}

/**
 * onload event handler
 */
$(document).ready(function() {		
	$("#listTable").datagrid({
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
		onClickRow:function(rowIndex,rowData) {
			goView(rowData.SCDL_UID)
// 			if(""==rowData.SCDL_REF_DOC_ID) {
// 				goView(rowData.SCDL_UID)
// 			} else {
// 				goDueDateView(rowData.SCDL_UID, rowData.SCDL_REF_DOC_ID)
// 			}
      	},
		onBeforeLoad:function() { airCommon.showBackDrop(); },
     	onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onSortColumn:function(sort, order) {
			onSort(sort, order);
		}
	});
	
	// 리사이징 처리
	$(window).resize(function(){
		airCommon.gridResize();
	});
});	

var goDueDateView = function(vGt_due_date_uid, vSol_mas_uid){
	var url = "/ServletController";
	url += "?gt_due_date_uid=" + vGt_due_date_uid;
	url += "&AIR_ACTION=LMS_GT_DUE_DATE";
	url += "&AIR_MODE=POPUP_VIEW_FORM";
	url += "&sol_mas_uid=" + vSol_mas_uid;
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
};
</script>
<form id="form1" name="form1" method="post" onsubmit="return false;">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
	<input type="hidden" name="scdl_uid" />
	<input type="hidden" name="rangeDay" value="<%=rangeDay%>"  data-type="search" />
	
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
				<col style="width:5%" />
				<col style="width:11%" />
				<col style="width:9%" />
				<col style="width:80px" />
				<col style="width:auto" />
				<col style="width:8%" />
				<col style="width:230px" />
				<col style="width:150px" />
			</colgroup>
				<tr>
					<th><%=유형 %></th>
					<td><%=HtmlUtil.getSelect(request, true, "SCDL_TYPE_CODE", "SCDL_TYPE_CODE", schTypeCodestr, schType, "class=\"select width_max\" data-type=\"search\"")%></td>
					<th><%=검색어 %></th>
					<td>
						<%=HtmlUtil.getSelect(request, true, "TEXT_COL", "TEXT_COL", schFieldCodestr, schField, "class=\"select width_max\" data-type=\"search\"")%>
					</td>
					<td>
						<input type="text" name="TEXT_VAL" value="<%=StringUtil.convertForInput(schValue)%>" onkeydown="doSearch(this.form, true)" maxlength="15"  data-type="search" class="text width_max" />
					</td>
					<th><%=기간 %></th>
					<td><%=HtmlUtil.getInputCalendar(request, true, "SCDL_BGN_DATE__START", "SCDL_BGN_DATE__START", schFromDate, "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "SCDL_END_DATE__END", "SCDL_END_DATE__END", schToDate, "data-type=\"search\"")%></td>
					<td class="hbuttons">						
						<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="separ"></span>																								
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>			
					</td> 					
				</tr>
			</table>
		</td>
		<td class="border_rm"></td>
	</tr>
	<tr>
		<td class="corner_lb"></td><td class="border_mb"></td><td class="corner_rb"></td>
	</tr>							
	</table>

	<table class="list_top">
		<tr>
			<td align="left">
				<%-- <span class="totalcount"><%=전체 %> : <span class="info"><%=listTotalCount%></span> <%=건 %></span> --%>
			</td>
			<td align="right">
<%if(isAdmin || isWriteUser){ %>
				<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goWrite(document.form1);"><%=StringUtil.getLocaleWord("B.WRITE",siteLocale)%></a></span>
<%} %>
			</td>
		</tr>
	</table>
	
 	<table id="listTable" style="width:auto;height:auto">		
		<thead>
		<tr>	
			<th data-options="field:'SCDL_UID',width:0,hidden:true"></th>
			<th data-options="field:'SCDL_REF_DOC_ID',width:0,hidden:true"></th>
			<th data-options="field:'SCDL_STAT_CODE',width:0,hidden:true"></th> 				
			<th data-options="field:'SCDL_TYPE_CODE',width:0,hidden:true"></th>
			<th data-options="field:'UIROE_NO',width:0,hidden:true"></th>  
			<th data-options="field:'SCDL_TYPE_NAME',width:110,align:'CENTER',sortable:true"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th>
			<th data-options="field:'SCDL_TIT',width:340,align:'CENTER',sortable:true"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>		
			<th data-options="field:'SCDL_PLCE',width:180,align:'CENTER',sortable:true"><%=StringUtil.getLocaleWord("L.장소",siteLocale)%></th>
			<th data-options="field:'SCDL_DTE',width:240,align:'CENTER',sortable:true"><%=StringUtil.getLocaleWord("L.일시",siteLocale)%></th>
			<th data-options="field:'SCDL_INS_USER_NAME',width:100,align:'CENTER',sortable:true"><%=StringUtil.getLocaleWord("L.등록자",siteLocale)%></th>  
		</tr>
		</thead>
	</table>
 
	
	<%-- <table class="list">		
		<thead>
		<tr>
			<th width="5%"><%=번호 %></th>
			<th width="10%"><%=유형 %></th>
			<th width="*"><%=제목 %></th>
			<th width="15%"><%=장소 %></th>			
			<th width="30%"><%=일시 %></th>
			<th width="10%"><%=등록자 %></th>									
		</thead>
		<tbody>
<%
	if (listResult != null && listResult.getRowCount() > 0) {
		for (int i = 0; i < listResult.getRowCount(); i++) {
			int row_no					= listResult.getInt(i, "pagingRowNo");
			String scdl_uid 			= listResult.getString(i, "scdl_uid");
			String scdl_stat_code		= listResult.getString(i, "scdl_stat_code");
			String scdl_type_code		= listResult.getString(i, "scdl_type_code");
			String scdl_type_name 		= listResult.getString(i, "scdl_type_name");
			String scdl_tit				= listResult.getString(i, "scdl_tit");
			String scdl_plce 			= listResult.getString(i, "scdl_plce");
			String scdl_bgn_date		= listResult.getString(i, "scdl_bgn_date");
			String scdl_bgn_time		= listResult.getString(i, "scdl_bgn_time");
			String scdl_end_date		= listResult.getString(i, "scdl_end_date");
			String scdl_end_time		= listResult.getString(i, "scdl_end_time");
			String scdl_ins_user_name	= listResult.getString(i, "scdl_ins_user_name");
%>
			<tr <%if("R".equals(scdl_stat_code)){ %>class="task"<%} %>>				
				<td align="center"><%=listTotalCount - row_no + 1%></td>
				<td align="center"><%=scdl_type_name%></td>
				<td align="left"><a href="javascript:void(0)" onclick="goView(document.form1, '<%=scdl_uid%>');" title="<%=StringUtil.convertForInput(scdl_tit)%>"><%=StringUtil.convertForView(StringUtil.getTrunc(scdl_tit, 30))%></a></td>
				<td align="center"><%=StringUtil.convertForView(scdl_plce)%></td>
				<td align="center"><%=scdl_bgn_date +"&nbsp;"+ scdl_bgn_time%>&nbsp;~&nbsp;<%=scdl_end_date +"&nbsp;"+ scdl_end_time%></td>
				<td align="center"><%=scdl_ins_user_name%></td>
			</tr>
<%
		}
	} else {
		%>
		<tr>
			<td align="center" colspan="6"><%=StringUtil.getLocaleWord("M.INFO_NORECORDS",siteLocale)%></td>
		</tr>
		<%
	}
%>
		</tbody>
	</table> --%>
	
	<%-- 페이지 목록 --%>
	<%-- <%=HtmlUtil.getPageList(listTotalCount, Integer.parseInt(pageNo), Integer.parseInt(pageRowSize), "goPage(document.form1, [PAGE_NO], [ROW_SIZE])")%> --%>			
</form>  