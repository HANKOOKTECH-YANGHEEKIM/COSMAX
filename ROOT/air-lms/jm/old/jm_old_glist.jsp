<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
    //-- 검색값 셋팅
    BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String   finalListColumn 			= resultMap.getString("FINAL_LIST_COLUMN");
	String[] finalListColumnArray 		= StringUtil.split(finalListColumn, "|");
		
	//-- 파라메터 셋팅
	String actionCode 					= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 					= resultMap.getString(CommonConstants.MODE_CODE);
	String contentName					= (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));
	
	String jsonDataUrl 
		= "/ServletController"
		+ "?AIR_ACTION=" + actionCode  
		+ "&AIR_MODE=JSON_OLD_LIST";
	
    String MUNSEO_SEOSIG_NO = "DDD-LMS-JM-016";
	
	//권한 셋팅
	boolean isWritable = LmsUtil.isBeobmuTeamUser(loginUser);

    // 회사코드
    SQLResults hoesaCdList = resultMap.getResult("COMPANY_LIST");
    String hoesaCdStr = StringUtil.getCodestrFromSQLResults(hoesaCdList, "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));   
%>
<script>
/**
 * 상세보기 페이지로 이동
 */
function goView(index,data) {
	
	var callback_function = "opener.parent.location.reload();self.close();";
	var sol_mas_uid = data.SOL_MAS_UID;
	var gwanri_mas_uid = data.GWANRI_MAS_UID;
	var doc_mas_uid = data.DOC_MAS_UID;
	var def_doc_main_uid = data.DEF_DOC_MAIN_UID;	
	
	var url	= "/ServletController";
	url	+= "?AIR_ACTION=<%=actionCode%>";
	url	+= "&AIR_MODE=POPUP_VIEW";
	url	+= "&sol_mas_uid=" + sol_mas_uid;
	url	+= "&gwanri_mas_uid=" + gwanri_mas_uid;
	url	+= "&doc_mas_uid=" + doc_mas_uid;
	url	+= "&def_doc_main_uid=" + def_doc_main_uid;
	url	+= "&callbackFunction="+ escape(callback_function);
	
	airCommon.openWindow(url, "1024", "600", "POPUP_VIEW", "yes", "yes", "");  
}

/**
 * 검색 수행
 */	
function doSearch(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	var txt = $(".combo").find("input:text");
	$("#schhoesaNm").val(txt.val());  
	$(".combo").find("input:hidden").attr("data-type","search");
	
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}

function doReload(frm) {
 	$("#listTable").datagrid("reload", airCommon.getSearchQueryParams());
}

function listTabs_reload(tabCode, src) {
    if (tabCode == "LIST") {
        doReload(document.form1);
    } else {
        if (src) {
            $("#listTabsFrame-"+ tabCode).attr("src", src);
        }
    }
    
    //tepTabs_setSelected(tabCode);
}


/**
 * 검색 쿼리 파라메터 반환 
 */
function getSearchQueryParams() {
	var frm = document.form1;
	
	return {
		schTitle:$("#schTitle").val(),
		schHoesa:$("#schHoesa").val(),
		schGomtoDteFrom:$("#schGomtoDteFrom").val(),
		schGomtoDteTo:$("#schGomtoDteTo").val(),
		schUiloeja:$("#schUiloeja").val()
	};
}

/**
 * 검색항목 초기화
 */
function doReset(frm) {
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
		frm.reset();
		
		$("#schHoesaCod").combobox("select","");
	}
}

/**
 * 정렬 이벤트 핸들러
 */
function onSort(sort, order) {
	$("input[name=<%=CommonConstants.PAGE_ORDERBY_FIELD%>]").val(sort);
	$("input[name=<%=CommonConstants.PAGE_ORDERBY_METHOD%>]").val(order);
}

<%--
/**
 * 소송유형(1차) 변경 이벤트 처리
 */  
function changeYuhyeong01(yuhyeong01, yuhyeong02) {
	yuhyeong02 = (yuhyeong02 == undefined ? "" : yuhyeong02);
	
	var codestr = airLms.getSsMasYuhyeong02ComboCodestr(yuhyeong01, "<%="|" + StringUtil.getLocaleWord(Label.CBO_ALL,siteLocale)%>", "<%=siteLocale%>");
	airCommon.initializeSelect("schYuhyeong02Cod", codestr, yuhyeong02);
}
--%>

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
		singleSelect:false,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pagePosition:"bottom",
		pageSize:<%=pageRowSize%>,
		nowrap:false,
		url:'<%=jsonDataUrl%>',
		method:"post",				            	             
     	queryParams:airCommon.getSearchQueryParams(),
     	onBeforeLoad:function() { airCommon.showBackDrop(); },
      	onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onLoadError:function(){
			airCommon.hideBackDrop();
		},
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
	
	var cc = $('#schHoesaCod');  // the combobox object
	 cc.combobox('textbox').bind('keydown', function(e){
		if(event.keyCode == 13){
			doSearch(document.form1); 
       }
	 
	 });
});
</script>

<div id="listTabsTools-LIST">
	<a href="javascript:void(0)" onclick="doSearch(document.form1)" class="icon-mini-refresh"></a>
</div>

<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.구자문현황", siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
		<form name="form1" method="post" onsubmit="return false;">	
			<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
			<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
			<input type="hidden" name="munseo_seosig_no" value="<%=MUNSEO_SEOSIG_NO%>" />
            <input type="hidden" name="doc_flow_uid" />
            <input type="hidden" name="doc_mas_uid" />
            <input type="hidden" name="sol_mas_uid" />
            <input type="hidden" name="gwanri_mas_uid" />
            <input type="hidden" name="sys_gbn_code_id" />
            <input type="hidden" name="eobmu_gbn_code_id" />
            <input type="hidden" name="xls_jeoe_columns" />	
            	
			<table class="box">
			<tr>
				<td class="corner_lt"></td><td class="border_mt"></td><td class="corner_rt"></td>
			</tr>
			<tr>
				<td class="border_lm"></td>
				<td class="body">
					<table>
						<colgroup>
							<col width="8%" />
							<col width="25%" />
							<col width="8%" />
							<col width="20%" />
							<col width="8%" />
							<col width="*" />
							<col width="8%" />
						</colgroup>
						<tr>
							<th><%=StringUtil.getLocaleWord("L.검토일", siteLocale) %></th>
							<td><%=HtmlUtil.getInputCalendar(request, true, "schGomtoDteFrom", "schGomtoDteFrom", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "schGomtoDteTo", "schGomtoDteTo", "", "data-type=\"search\"")%></td>
							<th><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
							<td><%=HtmlUtil.getSelect(request, true, "shHoesaCod", "shHoesaCod", hoesaCdStr, "", "class='select width_max_select' data-type=\"search\"")%></td>
							<td>
								<input type="text" name="DAMDANG_DPT_NM" id="DAMDANG_DPT_NM" value="" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text width_max" />
							</td>
							<td rowspan="2" class="verticalContainer">
								<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
								<span class="separ"></span>																								
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
							<td colspan="5">
								<input type="text" name="schTitle" id="schTitle" data-type="search" value="" onkeydown="doSearch(document.form1, true)" maxlength="50" class="text" style="width:100%;" />
							</td>
							<%-- <td><%=HtmlUtil.getSelect(request, true, "schHoesaCod", "schHoesaCod", hoesaCdStr, schHoesaCod, "class=\"select width_max_select\" data-type=\"search\"")%></td> --%>
						</tr>
					</table>
			</td>
				<td class="border_rm"></td>
			</tr>
			<tr>
				<td class="corner_lb"></td><td class="border_mb"></td><td class="corner_rb"></td>
			</tr>							
			</table>
			<div class="buttonlist">
				<div class="right">
<%
	if (isWritable) {
%>			 

					<script>
					/**
					 * 신규작성 페이지로 이동
					 */	 
					function goWrite(frm,musneo_seosig_no) {
						var uuid = airCommon.getRandomUUID();
						var url = "/ServletController";
						url += "?AIR_ACTION=SYS_DOC_MAS";
						url += "&AIR_MODE=POPUP_WRITE_FORM";
						url += "&munseo_seosig_no="+musneo_seosig_no;
						url += "&sol_mas_uid="+uuid;				
						
						airCommon.openWindow(url, "1024", "700", "POPUP_WRITE_FORM", "yes", "yes", "");		
					}
					</script>								
					<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:goWrite(document.form1,'DDD-LMS-JM-016');"><%=StringUtil.getLocaleWord("B.WRITE",siteLocale)%></a></span>
					<script>
					/*
					 * 엑셀다운로드
					 */
					function doExcelDown(frm){
						frm.action = "/ServletController";
						frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
						frm.<%=CommonConstants.MODE_CODE%>.value = "JSON_EXCEL";
						frm.target = "airBackgroundProcessFrame";
						frm.submit();
					}
					</script>
					<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown(document.form1)"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale)%></a></span>

<%
}
%>				
				</div>								
			</div>
		</form>	

		<table id="listTable" style="width:auto;height:auto">		
			<thead>
			<tr>								
				<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'GWANRI_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'DEF_DOC_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'DOC_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'SYS_GBN_CODE_ID',width:0,hidden:true"></th>
				<th data-options="field:'EOBMU_GBN_CODE_ID',width:0,hidden:true"></th>		
<%								  
Class label = Class.forName("com.emfrontier.air.lms.resource.list.LmsJmOldListLabel");
Field[] fields = label.getFields();
 
for (int i=0; i<finalListColumnArray.length; i++) {
	Field fld = label.getField(finalListColumnArray[i].toUpperCase());
	String options = StringUtil.getLocaleWord(fld.get(label).toString(),"OPTIONS");
	options = (!"".equals(options) ? ","+options : "");
%>
				<th data-options="field:'<%=finalListColumnArray[i].toUpperCase()%>',width:<%=StringUtil.getLocaleWord(fld.get(label).toString(),"WIDTH") %>,halign:'<%=StringUtil.getLocaleWord(fld.get(label).toString(),"HALIGN") %>',align:'<%=StringUtil.getLocaleWord(fld.get(label).toString(),"ALIGN") %>'<%=options%>"><%=StringUtil.convertForView(StringUtil.getLocaleWord(fld.get(label).toString(),siteLocale))%></th>									
<%
}
%>				
			</tr>	
			</thead>	
		</table>		
	</div>
</div>		