<%--
  - Author : Yang, Ki Hwa
  - Date : 2015.01.22
  - 
  - @(#)
  - Description : 법무시스템 계약 구데이터 리스트
  --%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.lang.reflect.*"%>  
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@page import="com.emfrontier.air.common.util.StringUtil" %>
<%
    SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
    String siteLocale = CommonProperties.getSystemDefaultLocale();
    
    if (loginUser != null) {
    	siteLocale = loginUser.getSiteLocale();
    }
    
    String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
    String CONTENT_PATH = (String)request.getAttribute(CommonConstants.CONTENT_PATH);
    String popupContentName  = StringUtil.unescape(StringUtil.convertNull(request.getParameter("popupContentName")));
    
    //-- 검색값 셋팅
    BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
    
    
    //-- 결과값 셋팅
    BeanResultMap resultMap             = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);  
    
    // 회사코드
    SQLResults hoesaCdList = resultMap.getResult("COMPANY_LIST");
    String hoesaCdStr = StringUtil.getCodestrFromSQLResults(hoesaCdList, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));   
    
    String actionCode           = resultMap.getString(CommonConstants.ACTION_CODE);
    String modeCode             = resultMap.getString(CommonConstants.MODE_CODE);
    String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));
    
    String jsonDataUrl = "/ServletController"
            + "?AIR_ACTION="+ actionCode  
            + "&AIR_MODE=JSON_LIST";
    
    // 법무팀 여부
    boolean legalTeamFlag = LmsUtil.isBeobmuTeamUser(loginUser);
    
    String sMenu_id = requestMap.getString("MENU_ID");
    String TAD1_ATTRIBUTE26 = "";
    
    if("LMS_GY_OLD".equals(sMenu_id)) {
    	TAD1_ATTRIBUTE26 = "R1"; // R1=계약, R2=자문,  R3=약관,  R4=신청서, 
    } 
    
    String APP_FORM_ID = "A10AAB0108"; //요청서=A10AAB0108, 답변서=A10ACO0289 ; 요청서만으로 목록을 가져옴
%>
<div id="listTabsTools-LIST">
	<a href="javascript:void(0)" onclick="doSearch(document.form1)" class="icon-mini-refresh"></a>
</div>

<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=("LMS_GY_OLD".equals(sMenu_id)) ? StringUtil.getLocaleWord("L.구계약현황",siteLocale) : StringUtil.getLocaleWord("L.구자문현황",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
<form id="form1" name="form1" method="post" onsubmit="return false;">	
  <input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
  <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
  <input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
  <input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
  <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
  <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
  <input type="hidden" name="gy_old_uid" />
  <input type="hidden" name="doc_flow_uid" />
  <input type="hidden" name="doc_mas_uid" />
  <input type="hidden" name="sol_mas_uid" />
  <input type="hidden" name="gwanri_mas_uid" />
  <input type="hidden" name="sys_gbn_code_id" />
  <input type="hidden" name="eobmu_gbn_code_id" />
  <input type="hidden" name="xls_jeoe_columns" />	
  <input type="hidden" name="TAD1_ATTRIBUTE26" value="<%=TAD1_ATTRIBUTE26 %>" data-type="search" />	
  <input type="hidden" name="APP_FORM_ID" value="<%=APP_FORM_ID %>" data-type="search" />		    
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
					<col width="8%" />
					<col width="22%" />
					<col width="8%" />
					<col width="20%" />
					<col width="10%" />
					<col width="*" />
					<col width="8%" />
				</colgroup>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.요청일",siteLocale)%></th>
					<td>
						<%=HtmlUtil.getInputCalendar(request, true, "LAST_UPDATE_DATE_START", "LAST_UPDATE_DATE_START", "", "data-type=\"search\"")%> ~ 
						<%=HtmlUtil.getInputCalendar(request, true, "LAST_UPDATE_DATE_END", "LAST_UPDATE_DATE_END", "", "data-type=\"search\"")%>
					</td>
					<th><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
					<td>
						<%--=HtmlUtil.getSelect(request, true, "TAD1_ATTRIBUTE28", "TAD1_ATTRIBUTE28", hoesaCdStr, "", "class='select width_max_select' data-type=\"search\" style='width:99%;'")--%>
						<input type="text" name="TAD1_ATTRIBUTE28" id="TAD1_ATTRIBUTE28" value="" data-type="search" onkeydown="doSearch(document.form1, true)" class="text width_max" maxlength="20" />
					</td>
					<th><%=StringUtil.getLocaleWord("L.요청자",siteLocale)%></th>
					<td>
						<input type="text" name="TAD1_ATTRIBUTE10" id="TAD1_ATTRIBUTE10" value="" data-type="search" onkeydown="doSearch(document.form1, true)" class="text width_max" maxlength="20" />
					</td>
					<td rowspan="2" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						<span class="separ"></span>																								
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>
					<th><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
					<td colspan="3">
						<input type="text" class="text width_max" name="TAD1_ATTRIBUTE6" id="TAD1_ATTRIBUTE6" value="" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="50" style="width:99%;" />
					</td>
					<th><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
					<td>
						<input type="text" name="TAD2_ATTRIBUTE10" id="TAD2_ATTRIBUTE10" value="" data-type="search" onkeydown="doSearch(document.form1, true)" class="text width_max" maxlength="20" />
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
		</div>
		<table id="listTable" style="width:auto;height:auto">		
		<thead>
		<tr>	
			<th data-options="field:'REQ_DOC_SEQ',width:0,hidden:true"></th> 
			<th data-options="field:'ANSWER_DOC_SEQ',width:0,hidden:true"></th> 
			<th data-options="field:'TITLE_NO',width:0,hidden:true"></th>  
			<th data-options="field:'SEQ',width:65,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.관리번호", siteLocale)%></th>
			<th data-options="field:'TAD1_ATTRIBUTE6',width:430,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.제목", siteLocale)%></th>
			<th data-options="field:'TAD1_ATTRIBUTE28',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회사", siteLocale)%></th>
<%-- 			<th data-options="field:'TAD1_ATTRIBUTE13',width:220,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.요청부서", siteLocale)%></th> --%>
			<th data-options="field:'TAD1_ATTRIBUTE10',width:230,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.요청자", siteLocale)%></th>
			<th data-options="field:'TAD1_LAST_UPDATE_DATE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.요청일", siteLocale)%></th>
			<th data-options="field:'TAD2_LAST_UPDATE_DATE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회신일", siteLocale)%></th>
			<th data-options="field:'TAD2_ATTRIBUTE10',width:170,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당자", siteLocale)%></th>
		</tr>
		</thead>
		</table>
</form>
	</div>
</div>
<script type="text/javascript">
 /**
  * 상세보기 페이지로 이동
  */
 function goView(index,data) {
	
	var url
		= "/ServletController"
		+ "?AIR_ACTION=<%=actionCode%>"
		+ "&AIR_MODE=POPUP_INDEX"
		+ "&seq=" + data.SEQ;
	
	airCommon.openWindow(url, "1024", "600", "POPUP_VIEW", "yes", "yes", "");     
 }
 
 /**
  * 검색 수행
  */ 
 function doSearch(frm, isCheckEnter) {
 	if (isCheckEnter && event.keyCode != 13) {         
         return;
     }
 	
 	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
 };
 
 /**
  * 검색항목 초기화
  */
 function doReset(frm) {
 	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
 		frm.reset();
 	}
 }
 
 /**
  * 정렬 이벤트 핸들러
  */
 function onSort(sort, order) {
 	$("input[name=<%=CommonConstants.PAGE_ORDERBY_FIELD%>]").val(sort);
 	$("input[name=<%=CommonConstants.PAGE_ORDERBY_METHOD%>]").val(order);
 }
 
 /**
  * 탭 코드 값으로 해당 탭을 선택된 상태로 셋팅
  */
 function listTabs_setSelected(tabCode) {
     var title = $("#listTabs-"+ tabCode).panel("options").title;
     $("#listTabsLayer").tabs("select", title);
 }

 /**
  * 탭 코드 값으로 탭을 변경하고, 컨텐츠 경로 값이 있으면 경로도 함께 변경
  */
 function listTabs_change(tabCode, src) {
     if (tabCode == "LIST") {
         doSearch(document.form1);
     } else {
         if (src) {
             $("#listTabsFrame-"+ tabCode).attr("src", src);
         }
     }
     
     tepTabs_setSelected(tabCode);
 }

 /**
  * 탭 코드 값으로 해당 탭 닫기
  */
 function listTabs_close(tabCode) {
     $("#listTabsLayer").tabs("close", title);
 }
 
 /**
  * onload event handler
  */
 $(document).ready(function() {		
 	$("#listTable").datagrid({
 		singleSelect:true,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pagePosition:'bottom',	
		pageSize:<%=pageRowSize%>,
		nowrap:false,
 		url:'<%=jsonDataUrl%>',
 		method:"post",				            	             
      	queryParams:airCommon.getSearchQueryParams(),
      	onClickRow:function(rowIndex,rowData) {
 			goView(rowIndex,rowData);
       	},
		onSortColumn:function(sort, order) {
			onSort(sort, order);
		}
 	});
 	
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