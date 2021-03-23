<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@page import="com.emfrontier.air.common.util.DateUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String menuNm				= requestMap.getString(siteLocale);
	String stuId				= requestMap.getString("STU_ID");
	
	String loginHoesaCod = loginUser.gethoesaCod();
	
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);
	
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
	
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE","|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	//유형코드
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(responseMap.getResult("JM_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	//상태
	String STU_LISTSTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("STU_LIST"), "STU_ID,LANG_CODE", "");
	//언어선택
	String EONEO_CODESTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("EONEO_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	
	String yuhyeong01Codestr = StringUtil.getCodestrFromSQLResults(responseMap.getResult("JM_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //자문유형
	String yuhyeong02Codestr = "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale);
	
	
	SQLResults STU_LIST = responseMap.getResult("STU_LIST");
	if(STU_LIST!= null && STU_LIST.getRowCount() > 0){
		STU_LISTSTR = "[";
		for(int i=0; i< STU_LIST.getRowCount(); i++){
			if(i > 0)STU_LISTSTR +=",";
			STU_LISTSTR += "{'STU_ID':'"+STU_LIST.getString(i, "STU_ID")+"', 'STU_BASE_NM':'"+StringUtil.getLang(STU_LIST.getString(i, "LANG_CODE"),siteLocale)+"'}";
		}
		STU_LISTSTR += "]";
	}
%>
<!-- //--엑셀 다운로드 -->
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=menuNm %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
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
							<th><%=StringUtil.getLang("L.의뢰일",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "YOCHEONG_DTE__START", "YOCHEONG_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "YOCHEONG_DTE__END", "YOCHEONG_DTE__END", "", "data-type=\"search\"")%>
							</td>
							<%-- <th><%//=StringUtil.getLang("L.의뢰부서",siteLocale) %></th>
							<td>
								<input type="text" name="YOCHEONG_DPT_NAM" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text" style='width:97.1%;' />
							</td> --%>
							<%//if(loginUser.isUserAuth("LMS_BCD")){ %>
							<th><%=StringUtil.getLang("L.회사",siteLocale) %></th>
							<td>
<!-- 							<input type="text" name="HOESA_NAM__LK" onkeydown="doSearch(document.form1, true);" data-type="search" class="text width_max" /> -->
								<% if(loginUser.getAuthCodes().contains("CMM_SYS")){ %>
										<%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", HOESA_CODESTR, "", "class=\"select width_max\" data-type=\"search\" style='width:100%;'")%>
								<% }else{%>
										<%=HtmlUtil.getSelect(request, false, "HOESA_COD", "HOESA_COD", HOESA_CODESTR, loginHoesaCod, "data-type=\"search\" class=\"select width_half\"").replace("C.", "")%>
								<%} %>
							</td>
							<%//}else{ %>
							<%-- <th><%//=StringUtil.getLang("L.의뢰부서",siteLocale) %></th> --%>
							<!-- <td>
								<input type="text" name="YOCHEONG_DPT_NAM" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text" style='width:97.1%;' />
							</td> -->
							<%//} %>
							
							<th><%//=StringUtil.getLang("L.의뢰부서",siteLocale) %></th>
							<td>&nbsp;</td>
							<td rowspan="4" class="verticalContainer">
								<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
								<span class="separ"></span>																								
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.회신일",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "GEOMTO_DTE__START", "GEOMTO_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "GEOMTO_DTE__END", "GEOMTO_DTE__END", "", "data-type=\"search\"")%>
							</td>						
							<th><%=StringUtil.getLang("L.의뢰자",siteLocale) %></th>
							<td>
								<input type="text" name="YOCHEONG_NAM__LK" data-type="search" onkeyup="doSearch(document.form1, true);" maxlength="30" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.담당자",siteLocale) %></th>
							<td>
								<input type="text" name="DAMDANG_NAM__LK" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text width_max" />
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.진행상태",siteLocale) %></th>
							<td>
								<input class="easyui-combobox" data-type="search" name="STU_ID_COMBO" id="STU_ID_COMBO" style="width:100%;" data-options="
				                    valueField:'STU_ID',
				                    textField:'STU_BASE_NM',
				                    value:'<%=stuId %>',
				                    data:<%=STU_LISTSTR %>,
				                    multiple:true,
				                    panelHeight:'auto'
				                    ">
<%-- 								<%=HtmlUtil.getSelect(request, true, "STU_ID_COMBO", "STU_ID_COMBO", STU_LISTSTR, stuId, "class=\"easyui-combobox\" multiple=\"true\" multiline=\"true\" class=\"select width_max_select\" style='width:100%;'") %> --%>
								<input type="hidden" name="stu_id" id="stu_id" value="<%=stuId %>" data-type="search"/>
							</td>
							<th><%=StringUtil.getLang("L.검토결과",siteLocale) %></th>
							<td>
								<input type="text" name="RVW_RSL__LK" data-type="search" onkeyup="doSearch(document.form1, true);" maxlength="30" class="text width_max" />
							</td>							
							<th><%=StringUtil.getLang("L.관리번호",siteLocale) %></th>
							<td>
								<input type="text" name="GWANRI_NO__LK" data-type="search" onkeyup="doSearch(document.form1, true);" maxlength="20" class="text width_max" />
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.제목",siteLocale) %></th>
							<td>
								<input type="text" name="JAMUN_TIT" data-type="search" onkeyup="doSearch(document.form1, true);"r maxlength="50" class="text width_max" style="width:99.2%;" />
							</td>
							<th><%=StringUtil.getLocaleWord("L.유형", siteLocale)%></th>
							<td colspan="4">
								<script>
								//구분 변경 이벤트 처리  
								function gubunYuhyeong_change(targetId, val) {
									
									var data = {};
									data["PARENT_CODE_ID"] = val;
									airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
										
										airCommon.initializeSelectJson(targetId, json, "|--<%=StringUtil.getLang("L.선택",siteLocale) %>--", "CODE_ID", "<%=siteLocale%>");
									});
									
								}
								</script>
								<%=HtmlUtil.getSelect(request,true, "YUHYEONG01_COD", "YUHYEONG01_COD", yuhyeong01Codestr, "", "onchange=\"gubunYuhyeong_change('YUHYEONG02_COD', this.value)\" class=\"select width_half\" data-type=\"search\"")%>
								<%=HtmlUtil.getSelect(request,true, "YUHYEONG02_COD", "YUHYEONG02_COD", yuhyeong02Codestr, "", "data-type=\"search\" class=\"select width_half\"")%>
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
		    	 <%if (loginUser.isUserAuth("LMS_BCD")) { %>
			    	<%=HtmlUtil.getInputRadio(request, true, "schGuBun", "All|" + StringUtil.getLocaleWord("R.전체",siteLocale) + "^My|" + StringUtil.getLocaleWord("L.나의업무",siteLocale)+ "^Rec|" + StringUtil.getLocaleWord("L.접수대기",siteLocale), "My", "onclick=\"doSearch(document.form1);\" data-type=\"search\"", "") %>
			    <%}else if(loginUser.isUserAuth("LMS_BJD")){ %>
			    	<%=HtmlUtil.getInputRadio(request, true, "schGuBun", "All|" + StringUtil.getLocaleWord("R.전체",siteLocale) + "^My|" + StringUtil.getLocaleWord("L.나의업무",siteLocale) , "My", "onclick=\"doSearch(document.form1);\" data-type=\"search\"", "")%>	
			    <%}else if(loginUser.isUserAuth("LMS_OFI")){ %>
			    	<input type="hidden" name="schGubun" id="schGubun" value="All" data-type="search" />
			    <%}else{ %>
			    	<%=HtmlUtil.getInputRadio(request, true, "schGuBun", "All|" + StringUtil.getLocaleWord("R.전체",siteLocale) + "^My|" + StringUtil.getLocaleWord("L.나의업무",siteLocale), "My", "onclick=\"doSearch(document.form1);\" data-type=\"search\"", "")%>
			    <%} %>
		    </div>
		    <div class="rigth">
		    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewWrite();"><%=StringUtil.getLocaleWord("B.JM_REQUEST_EXAM",siteLocale)%></a></span>
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
									    filename: '<%=menuNm+"_"+DateUtil.getCurrentDate()%>.xls',
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
				<th data-options="field:'COLOR',width:0,hidden:true"></th>
				<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'STU_ID',width:0,hidden:true"></th>
				<th data-options="field:'GWANRI_NO',width:120,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.관리번호", siteLocale)%></th>
				<th data-options="field:'JAMUN_TIT',width:440,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.제목", siteLocale)%></th>
				<th data-options="field:'HOESA_NAM',width:150,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회사", siteLocale)%></th>
				<th data-options="field:'JAMUN_YH_COD_NAM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.유형", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_NAM',width:130,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰자", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰일", siteLocale)%></th>
				<th data-options="field:'GEOMTO_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회신일", siteLocale)%></th>
				<th data-options="field:'STU_NAM',width:120,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.진행상태", siteLocale)%></th>
				<th data-options="field:'DAMDANG_NAM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.담당자", siteLocale)%></th>
			</tr>
			</thead>
		</table>
	</div>
</div>

<!-- //--엑셀 다운로드 -->
<!-- //	$("#listTable").datagrid('toExcel','test6.xls'); -->
<%-- <script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-export.js"></script> --%>

<script>
var doReset = function(frm){
	frm.reset();
	$('#STU_ID_COMBO').combobox('clear');
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
	
	$("#stu_id").val("");
	$("input:hidden[name='STU_ID_COMBO']").each(function(i, d){
		if(i > 0)$("#stu_id").val($("#stu_id").val()+",");
		$("#stu_id").val($("#stu_id").val()+$(d).val());
	});
	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
}
var selectTabRefresh = function(){
	$("#listTabsLayer").tabs('getSelected').panel('refresh');
}
var goNewWrite = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=SYS_FORM";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&munseo_seosig_no=DDD-LMS-JM-001";
	url += "&stu_id=JM_REQ";
	url += "&next_stu_id=JM_REQ";
	
	
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
    
	var url = "/ServletController?AIR_ACTION=LMS_JM_LIST_MAS&AIR_MODE=POPUP_INDEX&sol_mas_uid="+ data.SOL_MAS_UID;
	
	airCommon.openWindow(url, "1024", "700", "TEP_"+ data.SOL_MAS_UID, "yes", "yes");
	
    /* 같은 문서의 작성창이 열릴 경우 오브젝트 id중복으로 인한 오류 해결을 위해 팝업
    $("#listTabsLayer").tabs("add", {   
         id:'listTabs-'+title_no,
         title:title_no,
		href:url,
         closable:true,
         iconCls:'icon-document',
         style:{paddingTop:'5px'}
    });  
    */
}
$(function(){
	$("#stu_id").val("");
	$("input:hidden[name='STU_ID_COMBO']").each(function(i, d){
		if(i > 0)$("#stu_id").val($("#stu_id").val()+",");
		$("#stu_id").val($("#stu_id").val()+$(d).val());
	});
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
		<%if(LmsUtil.isBeobmuTeamUser(loginUser)){%>
      	rowStyler:function(index, row){
      		if(row.COLOR != ''){
      			return 'color:'+row.COLOR;
      		}
      	},
      	<%}%>
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