<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
	//http://127.0.0.1:58080/ServletController?AIR_ACTION=LMS_GY_LIST_MAS&AIR_MODE=POPUP_REVIEW_GLIST&SYSTEM_ID=APPROVAL&LOGIN_ID=TEST
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	String stuId = requestMap.getString("STU_ID");
	String pum_en_dte = requestMap.getDefStr("PUM_EN_DTE", "1900-01-01");
	
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 	= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 		= responseMap.getString(CommonConstants.MODE_CODE);
	String sSYSTEM_ID	= request.getParameter("SYSTEM_ID"); //SYSTEM_ID : IRNPM = 투심위, EPS = 구매협업시스템, APPROVAL = 사용인감
	
	String jsonDataUrl = "/ServletController"
	        + "?AIR_ACTION=LMS_GY_LIST_MAS"  
	        + "&AIR_MODE=JSON_LIST"
   	        + "&SYSTEM_ID=" + sSYSTEM_ID;
	
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE","|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	//언어선택
	String EONEO_CODESTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("PCODEID_GY_EONEO_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
	//상태
	String STU_LISTSTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("STU_LIST"), "STU_ID,STU_BASE_NM", "|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));

	String sSingleSelect = "false"; //한개행만 선택가능한지 여부
	
	if("EPS".equals(sSYSTEM_ID)) { //구매협업시스템
		sSingleSelect = "true";
	}
%>
<!-- // Content // -->
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.계약검토현황",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
	<form name="form1">
	<input type="hidden" name="pum_en_dte__start" data-type="search" value="<%=pum_en_dte%>" />
	<input type="hidden" name="schgubun" data-type="search" value="AUTHS" />
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
							<col style="width:14%" />
							<col style="width:auto" />
							<col style="width:80px" />
						</colgroup>
						<tr>
							<th><%=StringUtil.getLang("L.의뢰일",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "YOCHEONG_DTE__START", "YOCHEONG_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "YOCHEONG_DTE__END", "YOCHEONG_DTE__END", "", "data-type=\"search\"")%>
							</td>
							<th><%=StringUtil.getLang("L.회사",siteLocale) %></th>
							<td>
								<input type="text" name="HOESA_NAM__LK" onkeydown="doSearch(document.form1, true);" data-type="search" class="text width_max" />
<%-- 								<%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", HOESA_CODESTR, "", "class=\"select width_max\" data-type=\"search\" style='width:100%;'")%> --%>
							</td>
							<th><%=StringUtil.getLang("L.의뢰부서",siteLocale) %></th>
							<td>
								<input type="text" name="YOCHEONG_DPT_NAM" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text" style='width:97.1%;' />
							</td>
							<td rowspan="6" class="verticalContainer">
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
							<th><%=StringUtil.getLang("L.담당자",siteLocale) %></th>
							<td>
								<input type="text" name="DAMDANG_NAM" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="30" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.진행상태",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "STU_ID", "STU_ID", STU_LISTSTR, stuId, "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %></td>		
						</tr>						
						<tr>							
							<th><%=StringUtil.getLang("L.의뢰자",siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="YOCHEONG_NAM" data-type="search" onkeydown="doSearch(document.form1, true);"/>
							</td>		
							<th><%=StringUtil.getLang("L.검토결과",siteLocale) %></th>
							<td>
								<input type="text" name="RVW_RSL" data-type="search" onkeyup="doSearch(document.form1, true);" maxlength="30" class="text width_max" />
							</td>		
							<th><%=StringUtil.getLang("L.체결계약서",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "CGGY_YN", "CGGY_YN", "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^Y|Y^N|N", "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %></td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.계약상대방",siteLocale) %></th>
							<td>
								<input type="text" name="GYEYAG_SANGDAEBANG_NAM" data-type="search" onkeydown="doSearch(document.form1, true);" maxlength="30" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.언어",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "eoneo_cod", "eoneo_cod", EONEO_CODESTR, "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %></td>
							<th><%=StringUtil.getLang("L.법무검토",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "GEOMTO_YN", "GEOMTO_YN", "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^Y|Y^N|N", requestMap.getString("GEOMTO_YN"), "class=\"select\" data-type=\"search\" style='width:100%;'") %></td>						
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.관리번호",siteLocale) %></th>
							<td>
								<input type="text" name="GWANRI_NO" data-type="search" onkeydown="doSearch(document.form1, true);" maxlength="20" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.법무검토수정여부",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "_not", "_not", "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^Y|Y^N|N", "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %></td>								
							<th><%=StringUtil.getLang("L.EPS계약포함",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "EPS_IF_YN", "EPS_IF_YN", "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^Y|Y^N|N", "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %></td>
						</tr>
						<tr>																
							<th><%=StringUtil.getLang("L.계약명",siteLocale) %></th>
							<td colspan="3">
								<input type="text" name="GYEYAG_TIT" onkeydown="doSearch(document.form1, true);" data-type="search" maxlength="50" class="text" style="width:99.3%;" />
							</td>
							<th><%=StringUtil.getLang("L.거래조건정책적용여부",siteLocale) %></th>
							<td><%=HtmlUtil.getSelect(request, true, "term_yn", "term_yn", "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^Y|Y^N|N", "", "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'") %></td>
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
		    </div>
		    <div class="rigth">
		    	<span class="ui_btn medium icon"><span class=confirm></span><a href="javascript:void(0)" id="listCK" ><%=StringUtil.getLocaleWord("B.선택",siteLocale)%></a></span>
		    </div>
		</div>	
	</form>
		
		<table id="listTable" style="height:auto;clear:both">
			<thead>
			<tr>
				<th data-options="field:'CK',width:10,halign:'center',align:'center',checkbox:true"></th>
				<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
				<th data-options="field:'STU_ID',width:0,hidden:true"></th>
				<th data-options="field:'GWANRI_NO',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.관리번호", siteLocale)%></th>
				<th data-options="field:'GYEYAG_TIT',width:220,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.계약명", siteLocale)%></th>
				<th data-options="field:'HOESA_NAME',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.회사", siteLocale)%></th>
				<th data-options="field:'GYEYAG_SANGDAEBANG_NAM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.계약상대방", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_DPT_NM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰부서", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_NM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰자", siteLocale)%></th>
				<th data-options="field:'YOCHEONG_DTE',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.의뢰일", siteLocale)%></th>
				<th data-options="field:'STU_NAM',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.진행상태", siteLocale)%></th>
				<th data-options="field:'DAMDANG_NM',width:80,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.법무담당자", siteLocale)%></th>
				<th data-options="field:'FILE_NAME',width:100,halign:'CENTER',align:'CENTER',editor:'text',sortable:true"><%=StringUtil.getLang("L.체결계약서", siteLocale)%></th>
			</tr>
			</thead>
		</table>
	</div>
</div>

<script type="text/javascript">

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

 $(function(){
		$('#listTabs-LIST').css('width','100%');
		$('#listTable').datagrid({
			singleSelect:true,
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
			onLoadError:function() { airCommon.hideBackDrop(); }
// 			onClickCell: function(index, field, value){
// 	       		if(field == "FILE_NAME" || field == "FILE_NAME2"){
// 	       			rowClickYn = "N";
// 	       		}else{
// 	       			rowClickYn = "Y";
// 	       		}
// 	       	},
// 	       	onClickRow:function(rowIndex,rowData) {
// 	       		if(rowClickYn == "Y"){
// 	 				goView(rowIndex,rowData);
// 	       		}
// 	       	}
		});
		$(window).bind('resize', airCommon.gridResize);
		
		$("#listCK").click(function(){
			var rows = $('#listTable').datagrid('getChecked');
			for ( i = 0 ; i < rows.length ; i++ ) { 
				alert(rows[i]["SOL_MAS_UID"] +"\n"+ rows[i]["GWANRI_NO"] +"\n"+ rows[i]["GYEYAG_TIT"])
			}
		});
	});

// $(document).ready(function () {

//  	$("#btnSel").click(function(){
//  		alert("");
//  		//var rows = $('#gyeyagList').datagrid('getChecked');            
//  	});
//     $("#gyeyagList").datagrid({
//         onCheck: function(index, row){
//         	opener.$('input[name=org_gy_no]').val(row.GWANRI_NO);
//         	opener.$('input[name=org_gy_uid]').val(row.SOL_MAS_UID);
//         	opener.$('input[name=org_gy_type]').val(row.GY_TYPE);
//         	self.close();
//         }
//     });
    
//});
</script>
