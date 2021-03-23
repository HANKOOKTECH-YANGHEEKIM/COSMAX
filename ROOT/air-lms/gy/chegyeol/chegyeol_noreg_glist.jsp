<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.02.21
  - 
  - @(#)
  - Description : 법무시스템 공용 결재문서리스트
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.util.StringUtil"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel"%>
<%@ page import="com.emfrontier.air.common.util.DateUtil" %>
<%
//-- 로그인 사용자 정보 셋팅
SysLoginModel loginUser     = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale           = loginUser.getSiteLocale();

//-- 검색값 셋팅
BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

//-- 결과값 셋팅
BeanResultMap resultMap     = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

//리스트 컬럼
String   finalListColumn 			= "MAIL_CNT|GWANRI_NO|GYEYAG_TIT|GYEYAG_SANGDAEBANG_NAM|YOCHEONG_DTE|PYOJUN_GYEYAGSEO_YN|HOESA_NAM|YOCHEONG_NAM|YOCHEONG_ID|YOCHEONG_DPT_NAM|SANGTAE_NAM|SANGTAE_COD|DAMDANG_NAM|GEOMTO_DTE|EONEO_NAM";
String[] finalListColumnArray 		= StringUtil.split(finalListColumn, "|");

String actionCode           = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode             = resultMap.getString(CommonConstants.MODE_CODE);
String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));

String jsonDataUrl = "";

jsonDataUrl = "/ServletController"
        + "?AIR_ACTION=LMS_GY_LIST_MAS"
        + "&AIR_MODE=JSON_LIST";

String PYOJUN_GYEYAGSEO_YNStr =  "|"+StringUtil.getLocaleWord("L.CBO_ALL",siteLocale)+"^Y|Yes^N|No";
%>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("B.체결계약서미등록메일발송",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
		<!-- // Content // -->
		<form id="form1" name="form1" method="post" onsubmit="return false;">   
		    <input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
		    <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
		    <input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
		    <input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
		    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
		    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
			<input type="hidden" name="sol_mas_uids" id="sol_mas_uids" value=""/>
			<input type="hidden" name="shCSFile" id="shCSFile" data-type="search" value="N"/>
			<input type="hidden" name="schGuBun" id="schGuBun" data-type="search" value="NOREG"/>
			<input type="hidden" name="schQry" id="schQry" value=""/>
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
							<col width="10%" />
							<col width="22%" />
							<col width="9%" />
							<col width="22%" />
							<col width="9%" />
							<col width="22%" />
							<col width="*" />
						</colgroup>
		                <tr>
		                    <th><%=StringUtil.getLocaleWord("L.메일차수",siteLocale)%></th>
							<td><input type="text" name="MAIL_CNT__START" id="MAIL_CNT__START" data-type="search" value="" onkeydown="doSearch(document.form1, true)" class="text" style="width:60px;" maxlength="2" />
								~ <input type="text" name="MAIL_CNT__END" id="MAIL_CNT__END" data-type="search" value="" onkeydown="doSearch(document.form1, true)" class="text" style="width:60px;" maxlength="2" />
							</td>
		                    <th><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
							<td><input type="text" class="text width_max" name="gwanri_no" id="gwanri_no" data-type="search" value="" onkeydown="doSearch(document.form1, true)" /></td>
		                    <th><%=StringUtil.getLocaleWord("L.표준계약서여부",siteLocale)%></th>
		                    <td><%=HtmlUtil.getSelect(request, true, "PYOJUN_GYEYAGSEO_YN", "PYOJUN_GYEYAGSEO_YN", PYOJUN_GYEYAGSEO_YNStr, "", "style='width:100%;' data-type=\"search\"")%></td>
		                    <td rowspan="4" class="verticalContainer">
		                        <span class="ui_btn medium icon"><span class="search"></span><input type="button" onclick="doSearch(document.form1);" value="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>"></span>
		                    </td>
						</tr>
		                <tr>
							<th><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale)%></th>
							<td><input type="text" class="text width_max" name="gyeyag_sangdaebang_nam" id="gyeyag_sangdaebang_nam" data-type="search" value="" onkeydown="doSearch(document.form1, true)" /></td>
							<th><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
							<td><input type="text" class="text width_max" name="YOCHEONG_NAM" id="YOCHEONG_NAM" data-type="search" value="" onkeydown="doSearch(document.form1, true)" /></td>
							<th><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
							<td><input type="text" class="text width_max" name="DAMDANG_NAM" id="DAMDANG_NAM" data-type="search" value="" onkeydown="doSearch(document.form1, true)" /></td>
		                </tr>
		                <tr>
		                    <th><%=StringUtil.getLocaleWord("L.계약명",siteLocale)%></th>
		                    <td colspan="3"><input type="text" class="text width_max" name="GYEYAG_TIT" id="GYEYAG_TIT" data-type="search" value="" onkeydown="doSearch(document.form1, true)" style="width:99.3%;" /></td>
		                	<th>품의완료일</th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "PUM_EN_DTE__START", "PUM_EN_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "PUM_EN_DTE__END", "PUM_EN_DTE__END", "", "data-type=\"search\"")%>
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
		        
		    <div id="listToolbar" style="height:auto">
		        <table style="border:0;width:100%;">
		        <colgroup>          
		            <col width="90%" />
		            <col width="10%" />
		        </colgroup>
		        <tr>
		            <th style="text-align:left"></th>
		            <td style="text-align:right">
		            </td>
		        </tr>
		        </table>    
		    </div>  
		    <div class="buttonlist">
				<div class="left" style="color:red;">
					※ 계약검토 요청 건 중 계약품의 후에도 체결계약서를 등록하지 않거나 계약체결중단 통보를 하지 않거나, 재검토 요청을 하지 않은 건만 표시됩니다
				</div>
				<div class="right">
					<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doWriteMail();"><%=StringUtil.getLocaleWord("B.선택발송",siteLocale)%></a></span>
					<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doWriteAllMail();"><%=StringUtil.getLocaleWord("B.일괄발송",siteLocale)%></a></span>
				</div>
			</div>
		              
		    <table id="listTable" style="width:auto;height:auto">		
				<thead>
				<tr>
					<th data-options="field:'chk',width:40,align:'center',checkbox:true"></th>
					<th data-options="field:'SOL_MAS_UID',width:0,hidden:true"></th>
					<th data-options="field:'GWANRI_MAS_UID',width:0,hidden:true"></th>
					<th data-options="field:'SYS_GBN_CODE_ID',width:0,hidden:true"></th>
					<th data-options="field:'EOBMU_GBN_CODE_ID',width:0,hidden:true"></th>					
					<th data-options="field:'TITLE_NO',width:0,hidden:true"></th>
					<th data-options="field:'UIROE_NO',width:0,hidden:true"></th>   		  
					<th data-options="field:'DAMDANG_ID',width:0,hidden:true"></th>
					<th data-options="field:'SANGTAE_COD',width:0,hidden:true"></th>   		
					<th data-options="field:'MAIL_CNT',width:60,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.메일차수",siteLocale))%></th>
					<th data-options="field:'GWANRI_NO',width:100,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.관리번호",siteLocale))%></th>
					<th data-options="field:'GYEYAG_TIT',width:320,halign:'center',align:'LEFT'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.계약명",siteLocale))%></th>
					<th data-options="field:'GYEYAG_SANGDAEBANG_NAM',width:120,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.계약상대방",siteLocale))%></th>
					<th data-options="field:'HOESA_NAM',width:120,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.회사",siteLocale))%></th>
					<th data-options="field:'YOCHEONG_DPT_NAM',width:80,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.의뢰일",siteLocale))%></th>
					<th data-options="field:'YOCHEONG_NAM',width:80,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.요청자",siteLocale))%></th>
					<th data-options="field:'DAMDANG_NAM',width:80,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.담당자",siteLocale))%></th>
					<th data-options="field:'PUM_EN_DTE',width:80,halign:'center',align:'CENTER'">품의완료일</th>
					<th data-options="field:'STU_NAM',width:90,halign:'center',align:'CENTER'"><%=StringUtil.convertForView(StringUtil.getLocaleWord("L.진행상태",siteLocale))%></th>
				</tr>
				</thead>
			</table>
		    <div class="buttonlist">
				<div class="right" style="color:red;">
					 ※ "일괄발송" 선택시 모든 대상건에 대하여 발송이 됩니다
				</div>
			</div>
</form>
	</div>
</div>
<script type="text/javascript">

//-- 공통 Ajax 호출
var callAjax = function(airAction, airMode, data, callback){
	
	var url = "/ServletController?AIR_ACTION="+airAction;
	url += "&AIR_MODE="+airMode;

	$.ajax({
      url : url,
      async : false,
      type : "POST",
      data : data
  })
  .done(function( json ) {
		callback(json);
  })
  .fail(function() {
      //승인처리 도중 에러가 발생했습니다.
      alert("<%=StringUtil.getScriptMessage("M.오류발생", siteLocale)%>");
		airCommon.hideBackDrop();
  });
}


/**
 * 오늘 하루 창 닫기
 */
function closeWin(seq) {
	airCommon.setCookie(seq,"GyealOk",1);
	self.close();
}


//-- 일괄발송
function doWriteAllMail(){
	var frm = document.form1;
	frm.sol_mas_uids.value="ALL";
	frm.schQry.value = JSON.stringify(airCommon.getSearchQueryParams());
	frm.<%=CommonConstants.ACTION_CODE%>.value="LMS_GY_LIST_MAS";
	frm.<%=CommonConstants.MODE_CODE%>.value="POPUP_CHEGYEOL_MAIL_WRITE_FORM";
	
	airCommon.openWindow('', "1024", "600", 'MAIL_SEND_FORM', 'yes', 'no');
	frm.action = "/ServletController";
	frm.target = "MAIL_SEND_FORM";
	frm.submit();
}

//-- 선택발송
function doWriteMail() {
	var rows = $("#listTable").datagrid("getChecked");

	if("" == rows ){
		alert("<%=StringUtil.getLocaleWord("M.RADIO_SELECT", siteLocale)%>");
		return;
	}
	
	var data = [];
	$(rows).each(function(i, e){
		data.push(e.SOL_MAS_UID);
	});
	
	var frm = document.form1;
	
	frm.sol_mas_uids.value=data.join(",");
	frm.<%=CommonConstants.ACTION_CODE%>.value="LMS_GY_LIST_MAS";
	frm.<%=CommonConstants.MODE_CODE%>.value="POPUP_CHEGYEOL_MAIL_WRITE_FORM";
	
	airCommon.openWindow('', "1024", "600", 'MAIL_SEND_FORM', 'yes', 'no');
	frm.action = "/ServletController";
	frm.target = "MAIL_SEND_FORM";
	frm.submit();
}

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
 * Reload Grid
 */ 
function doReload() {
    $("#listTable").datagrid("reload", airCommon.getSearchQueryParams());    
}
$(document).ready(function() {
    $("#listTable").datagrid({
        onClickRow:function(rowIndex,rowData) {
        },      
        singleSelect:false,
		striped:true,
		fitColumns:false,
		rownumbers:true,
		multiSort:true,
		pagination:true,
		pageSize:100,
		pageList:[10,100],
 		url:'<%=jsonDataUrl%>',
 		method:"post",				            	             
      	queryParams:airCommon.getSearchQueryParams(),
      	toolbar:"#listToolbar"
    });
});
</script>