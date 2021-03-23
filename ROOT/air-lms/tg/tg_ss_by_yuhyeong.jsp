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

	String loginHoesaCod = loginUser.gethoesaCod();
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code = resultMap.getString(CommonConstants.MODE_CODE);
	String upper_board_code = resultMap.getString("UPPER_BOARD_CODE");
	String code_id = resultMap.getString("CODE_ID");

	//-- 권한 셋팅
	boolean isAdmin = LmsUtil.isBeobmuTeamUser(loginUser);

	//-- 코드정보 문자열 셋팅
	String schFieldCodestr = "";

	int titleLength = 1000;

	boolean isWritable = false;

	String yuhyeong01Codestr = StringUtil.getCodestrFromSQLResults(resultMap.getResult("YUHYEONG01_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String yuhyeong02Codestr = "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale);
	String gyeolgwaCodestr  = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_LIST"), "CODE,NAME_"+ siteLocale, "");
	String gyeolgwaBjCodestr  = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_BJ_LIST"), "CODE,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	gyeolgwaCodestr =gyeolgwaBjCodestr+"^"+gyeolgwaCodestr;
// 	String progCodestr = "|"+StringUtil.getLocaleWord("L.CBO_ALL",siteLocale)+"^"+LmsConstants.준비+"|"+StringUtil.getLocaleWord("L.준비중",siteLocale)+"^"+LmsConstants.진행+"|"+StringUtil.getLocaleWord("L.진행",siteLocale)+"^"+LmsConstants.심급종결+"|"+StringUtil.getLocaleWord("L.심급종결",siteLocale)+"^"+LmsConstants.확정+"|"+StringUtil.getLocaleWord("L.확정",siteLocale);
	String simCodestr = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "CODE,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));	
	String GUBUN_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE_ID,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	String STU_LISTSTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("STU_LIST"), "CODE_ID,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));

	String jsonDataUrl 
	= "/ServletController"
	+ "?AIR_ACTION=" + actionCode  
	+ "&AIR_MODE=SS_BY_YUHYEONG_JSON_LIST";
%>
<script type="text/javascript">
	
	/**
	 * 검색 수행
	 */	
	function doSearch(frm, isCheckEnter) {
		if (isCheckEnter && event.keyCode != 13) {
			return;
		}
		$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
	};
	
	function doReload(frm) {
	 	$("#listTable").datagrid("reload", airCommon.getSearchQueryParams());
	 };
	
	/**
	 * 신규작성 페이지로 팝업으로 이동
	 */	 
	function goWrite(frm) {			
		airCommon.openWindow("", "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");
		
		frm.action = "/ServletController";
		frm.<%=CommonConstants.MODE_CODE%>.value = "POPUP_WRITE_FORM";
		frm.target = "POPUP_WRITE_FORM";
		frm.submit();
	};
	
	/**
	 * 상세보기 페이지로 이동
	 */ 
	function goView(index,data) {
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
		
		var url = "/ServletController?AIR_ACTION=LMS_SS_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ data.SOL_MAS_UID;
		url+="&GB_DOC_MAS_UID="+data.GB_DOC_MAS_UID;
		
		airCommon.openWindow(url, "1024", "700", "TEP_"+ data.SOL_MAS_UID, "yes", "yes");
		
		/* 
		$("#listTabsLayer").tabs("add", {   
	         id:'listTabs-'+title_no,
	         title:title_no,
			href:url,
	         closable:true,
	         iconCls:'icon-document',
	         style:{paddingTop:'5px'}
	    }); 	 
		*/
	};
	
	 /**
	  * 검색항목 초기화
	  */
	 function doReset(frm) {
	 	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS", siteLocale)%>")) {
	 		frm.reset();
	 		$("#TYPE_CODE").val("");
	 	}
	 };
	
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
	};
	
	var resetType = function(){
// 		$("#type_code").val("");
	};
	
	/**
	*	유형클릭 시 
	*/
	var setBoardType = function(type_code){
		$("#TYPE_CODE").val(type_code);
	};
</script>
<!-- //--엑셀 다운로드 -->
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.소송현황",siteLocale) %>" style="padding-top:5px">

<form id="form1" name="form1" method="post" onsubmit="return false;" style="margin:0; padding:0;">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" /> 
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" /> 
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" /> 
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" /> 
	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
	<input type="hidden" name="TYPE_CODE" id="TYPE_CODE" value="" data-type="search" />
	<input type="hidden" name="filename" id="filename" value="" />

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
							<col style="width:8%" />
							<col style="width:20%" />
							<col style="width:12%" />
							<col style="width:20%" />
							<col style="width:12%" />
							<col style="width:auto" />
							<col style="width:80px" />
						</colgroup>
						
						<tr>
							<th>
								<%=StringUtil.getLocaleWord("L.회사", siteLocale)%>
							</th>
							<td> 
								<% if(loginUser.getAuthCodes().contains("CMM_SYS")){ %>
										<%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", HOESA_CODESTR, "", "data-type=\"search\" class=\"select width_half\"")%>
								<% }else{%>
										<%=HtmlUtil.getSelect(request, false, "HOESA_COD", "HOESA_COD", HOESA_CODESTR, loginHoesaCod, "data-type=\"search\" class=\"select width_half\"").replace("C.", "")%>
								<%} %>
							</td>
						</tr>	
						<tr>
							<th>
								<%=StringUtil.getLocaleWord("L.소제기일", siteLocale)%>
							</th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "SOJEGI_DTE__START", "SOJEGI_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "SOJEGI_DTE__END", "SOJEGI_DTE__END", "", "data-type=\"search\"")%>
							</td>
							<th><%=StringUtil.getLocaleWord("L.유형", siteLocale)%></th>
							<td colspan="3">
								<script>
								//구분 변경 이벤트 처리  
								function gubunYuhyeong_change(targetId, val) {
									
									var data = {};
									data["PARENT_CODE_ID"] = val;
									airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
										
										airCommon.initializeSelectJson(targetId, json, "|-- <%=StringUtil.getLang("L.선택",siteLocale) %> --", "CODE_ID", "<%=siteLocale%>");
									});
									
								}
								</script>
								<%=HtmlUtil.getSelect(request,true, "YUHYEONG01_COD", "YUHYEONG01_COD", yuhyeong01Codestr, "", "onchange=\"gubunYuhyeong_change('YUHYEONG02_COD', this.value)\" class=\"select width_half\" data-type=\"search\"")%>
								<%=HtmlUtil.getSelect(request,true, "YUHYEONG02_COD", "YUHYEONG02_COD", yuhyeong02Codestr, "", "data-type=\"search\" class=\"select width_half\"")%>
								
							</td>
						</tr>
						
						<tr>	
							<th><%=StringUtil.getLocaleWord("L.사건명", siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SAGEON_TIT" id="SAGEON_TIT" data-type="search" onkeydown="doSearch(document.form1, true)">
							</td>
							<th><%=StringUtil.getLocaleWord("L.사건번호", siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SAGEON_NO" id="SAGEON_NO" data-type="search" onkeydown="doSearch(document.form1, true)">
							</td>
							
							<td rowspan="7" class="verticalContainer">
								<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
								<span class="separ"></span>																								
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
						
						<tr>	
							<th><%=StringUtil.getLocaleWord("L.원고", siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="WEONGO" id="WEONGO" data-type="search" onkeydown="doSearch(document.form1, true)">
							</td>
							<th><%=StringUtil.getLocaleWord("L.피고", siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="PIGO" id="PIGO" data-type="search" onkeydown="doSearch(document.form1, true)">
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
			<div class="buttonlist">
			
				<div class="right">
					<script>
					/*
					 * 엑셀다운로드
					 */
					function doExcelDown(){
						
						var data = airCommon.getSearchQueryParams();
						
						airCommon.callAjax("<%=actionCode%>", "SS_BY_YUHYEONG_EXCEL",data, function(json){
							
							$('#listTable').datagrid('toExcel', {
							    filename: '<%=StringUtil.getLocaleWord("L.소송현황",siteLocale)+"_"+DateUtil.getCurrentDate()%>.xls',
							    rows: json.rows,
							    worksheet: 'Worksheet'
							});
						});
						
						
					}
					</script>
					<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:void(0)" onclick="doExcelDown()"><%=StringUtil.getLocaleWord("B.엑셀저장", siteLocale) %></a></span>		
				</div>
			</div>
			<table id="listTable" style="width: auto; height: auto">
				<thead>
					<tr>
						<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
						<th data-options="field:'GB_DOC_MAS_UID',width:0,hidden:true"></th>
						<th data-options="field:'GWANRI_NO',toExcel:true,width:130, halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.번호", siteLocale)%></th>
						<th data-options="field:'YUHYEONG_NAM',toExcel:true,width:150, halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.유형", siteLocale)%></th>
						<th data-options="field:'BEOBWEON_NAM',toExcel:true,width:150, halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.관할법원", siteLocale)%></th>
						<th data-options="field:'SAGEON_NO',toExcel:true,width:150, halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.사건번호", siteLocale)%></th>
						<th data-options="field:'SAGEON_TIT',toExcel:true,width:230,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.사건명", siteLocale)%></th>
						<th data-options="field:'HOESA_NM',toExcel:true,width:150,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.회사", siteLocale)%></th>
						<th data-options="field:'WEONGO_NM',toExcel:true,width:100,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.원고", siteLocale)%></th>
						<th data-options="field:'PIGO_NM',toExcel:true,width:100,halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.피고", siteLocale)%></th>
						<th data-options="field:'SEONGO_DTE',toExcel:true,width:110, halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.종국일자", siteLocale) %></th>
						<th data-options="field:'STU_ID_YN_NAM',toExcel:true,width:110, halign:'center',align:'center',sortable:true"><%=StringUtil.getLocaleWord("L.종결여부", siteLocale) %></th>
					</tr>
				</thead>
			</table>
		</form>
	</div>
</div>
<script>

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
		pageSize:<%=pageRowSize%>,
		nowrap:false,
		url:'<%=jsonDataUrl%>',
		method : "post",
		queryParams : airCommon.getSearchQueryParams(),
		onBeforeLoad : function() {
			airCommon.showBackDrop();
		},
		onLoadSuccess : function() {
// 			airCommon.hideBackDrop(), 
			airCommon.gridResize();
		},
		onClickRow:function(rowIndex,rowData) {
			//goView(rowIndex,rowData);
       	},
		rowStyler:function(index, row){
      		if(row.MAJOR_YN == 'Y'){
      			return 'color:#bb8c00';
      		}
      		/* 추가요청으로 삭제 2018-10-17*/
      		if(row.YUHYEONG01_COD == 'LMS_SS_YUHYEONG_GJ'){
      			return 'color:#666666';
      		}
      		 
      	}
	});

});
</script>