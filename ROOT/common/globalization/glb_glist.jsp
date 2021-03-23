<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.lang.reflect.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField		= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String menuGbn						  	  = requestMap.getString("MENUGBN");
	String menuParamId						  = requestMap.getString("MENUPARAMID");
	String langCode					  = requestMap.getString("CODE");

	//-- 결과값 셋팅
	BeanResultMap responseMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode 					= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 					= responseMap.getString(CommonConstants.MODE_CODE);
	String contentName					= (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));

	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";

%>
<script>
var doSysAttch = function(){
	$.ajax({
		url: "/ServletController"
		, type: "POST"
		, dataType: "json"
		, data: {
				"AIR_ACTION":"<%=actionCode%>",
				"AIR_MODE":"SYS_APPEND",
			}
	})
	.done(function(data) {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT_DONE", siteLocale) %>");

    })
    .fail(function() {
    	// 도중 에러가 발생했습니다.
        alert("<%=StringUtil.getScriptMessage("M.처리중_오류발생",siteLocale, StringUtil.getLocaleWord("L.수정", siteLocale))%>");
    });
}

var doProc = function(isCheckEnter){
	if (isCheckEnter && event.keyCode != 13) {
		return;
	}

	var msg = "저장하시겠습니까?";
	if($("#ADD_CODE").val() != "" && confirm(msg)){
		$.ajax({
			url: "/ServletController"
			, type: "POST"
			, dataType: "json"
			, data: {
					"AIR_ACTION":"<%=actionCode%>",
					"AIR_MODE":"ADD_CODE",
					"TYPE":$("#ADD_TYPE").val(),
					"CODE":$("#ADD_CODE").val()
				}
		})
		.done(function(data) {
			if(Object.keys(data).length > 0){
				alert("처리되었습니다.");
				
// 				doInit(document.form1)
				$("#KO").val("");
				$("#EN").val("");
				$("#ZH").val("");
				$("#JA").val("");
				$("#CODE").val($("#ADD_CODE").val());
				$("#ADD_CODE").val("");
				$("input:radio[name='TYPE']").eq(0).prop("checked",true);
				doSearch(document.form1);
			}else{
				alert("<%=StringUtil.getScriptMessage("M.동일한코드가존재합니다확인해주세요", siteLocale)%>");
			}

	    })
	    .fail(function() {
	    	// 도중 에러가 발생했습니다.
            alert("<%=StringUtil.getScriptMessage("M.처리중_오류발생",siteLocale, StringUtil.getLocaleWord("L.수정", siteLocale))%>");
	    });
	}
}

function doInit(frm){
	frm.reset();
}

</script>
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-cellediting.js"></script>

<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="GLOBALIZATION" style="padding-top:5px;" data-options="selected:true">
		<form name="form1" method="post">
			<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
			<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />

			<input type="hidden" name="doc_flow_uid" />
			<input type="hidden" name="doc_mas_uid" />
			<input type="hidden" name="sol_mas_uid" />
			<input type="hidden" name="gwanri_mas_uid" />
			<input type="hidden" name="sys_gbn_code_id" />
			<input type="hidden" name="eobmu_gbn_code_id" />
			<input type="hidden" name="munseo_seosig_no" />
			<input type="hidden" name="include_json_params" />

			<input type="hidden" name="menuGbn" />
			<input type="hidden" name="menuParamId" />
			<input type="hidden" name="menuParamFromId" />
			<input type="hidden" name="MENU_NAME_KO" />
			<input type="hidden" name="menuParamWhereColumn" />
			<input type="hidden" name="menuParamListColumn" />
			<input type="hidden" name="menuParamFlowGbn" />

			<input type="hidden" name="menuParamMunseoBunryuGbnSysCodId1" />
			<input type="hidden" name="menuParamMunseoBunryuGbnSysCodId2" />
			<input type="hidden" name="menuParamMunseoBunryuGbnSysCodId3" />
			<input type="hidden" name="menuParamMunseoSeosigNo" />

			<input type="hidden" name="currentMenuParamId" value="<%=menuParamId%>">

			<script>
			/**
			 * 검색 수행
			 */
			function doSearch(frm, isCheckEnter) {
				if (isCheckEnter && event.keyCode != 13) {
					return;
				}

				$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
			}
			</script>

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
							<col style="width:10%" />
							<col style="width:32%" />
							<col style="width:15%" />
							<col style="width:32%" />
							<col style="width:*" />
						</colgroup>
						<tr>
							<th><%=StringUtil.getLang("L.코드",siteLocale) %></th>
							<td colspan="3"><input type="text" name="CODE" tabindex="1"  ID="CODE" onkeydown="doSearch(document.form1, true)" value="<%=langCode %>" data-type="search" class="text width_max" style="width:98.3%;" /></td>
							<td rowspan="4" class="verticalContainer">
									<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSearch(document.form1);" style="width:31px;"><%=StringUtil.getLocaleWord("L.검색",siteLocale)%></a></span>
									<span class="ui_btn medium icon"><span class="delete"></span><input type="button" name="btnCol"  value="Reset" onclick="doInit(document.form1)" /></span>
							</td>
						</tr>
						<tr>
							<th>KO</th>
							<td><input type="text" class="text width_max" name="KO" id="KO" tabindex="2" onkeydown="doSearch(document.form1, true)" data-type="search"/></td>
							<th>EN</th>
							<td><input type="text" class="text width_max" name="EN" id="EN" tabindex="3"  onkeydown="doSearch(document.form1, true)" data-type="search"/></td>
						</tr>
						<tr>
							<th>JP</th>
							<td><input type="text" class="text width_max" name="JA" id="JA" onkeydown="doSearch(document.form1, true)" data-type="search"/></td>
							<th>CN</th>
							<td><input type="text" class="text width_max" name="ZH" id="ZH" onkeydown="doSearch(document.form1, true)" data-type="search"/></td>
						</tr>
						<tr>
							<th>Type</th>
							<td colspan="3" style="padding-top:5px;">
								<input type="radio" name="TYPE" id="TYPE" value=""  data-type="search"  onClick="doSearch(document.form1)" checked/><%=StringUtil.getLocaleWord("L.전체", siteLocale) %>
								<input type="radio" name="TYPE" id="TYPE" value="L"  data-type="search" onClick="doSearch(document.form1)" />라벨(Label)
								<input type="radio" name="TYPE" id="TYPE" value="M" data-type="search"  onClick="doSearch(document.form1)" />메시지(Message)
								<input type="radio" name="TYPE" id="TYPE" value="B"  data-type="search" onClick="doSearch(document.form1)" />버튼(Button)
								<input type="radio" name="TYPE" id="TYPE" value="R"  data-type="search" onClick="doSearch(document.form1)" />라디오(Radio)
								<input type="radio" name="TYPE" id="TYPE" value="D"  data-type="search" onClick="doSearch(document.form1)" />문서(Document)
								<input type="radio" name="TYPE" id="TYPE" value="C"  data-type="search" onClick="doSearch(document.form1)" />코드(Code)
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
<%-- 
			<div class="table_cover">
				<table class="box">
					<tr>
						<td width="5%"><%=StringUtil.getLocaleWord("L.선택",siteLocale)%> :</td>
						<td id="selectPat" style="line-height: 20px;"></td>
					</tr>
				</table>
			</div> 
--%>
		<div class="buttonlist">
				<div class="left">
					<select name="ADD_TYPE" id="ADD_TYPE" style="border:1px solid #CCC9E1; padding:2px; width:120px;">
						<option value="l">라벨(Label)</option>
						<option value="M">메시지(Message)</option>
						<option value="B">버튼(Button)</option>
						<option value="R">라디오(Radio)</option>
						<option value="D">문서(Document)</option>
						<option value="C">코드(Code)</option>
					</select>
					<input type="text" class="text" id="ADD_CODE" style="margin-top:1px; padding:3px;" size="40" onkeydown="doProc(true)"/>
					<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:void(0);" onClick="doProc();"><%=StringUtil.getLocaleWord("B.ADD", siteLocale) %></a></span>
				</div>
				<div class="right">
					<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:void(0);" onClick="doSysAttch();">시스템적용</a></span>
				<%if(modeCode.indexOf("POPUP") < 0){ %>
					<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0);" onClick="airCommon.openWindow('/ServletController?AIR_ACTION=SYS_LANG&AIR_MODE=POPUP_GLIST',1024,600,'Lang List',true,true);">POPUP</a></span>
				<%}%>
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
					<th data-options="field:'CODE',width:300,halign:'CENTER',align:'LEFT',editor:'text',sortable:true"><%=StringUtil.getLang("L.코드", siteLocale)%></th>
					<th data-options="field:'KO',width:300,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">KO</th>
					<th data-options="field:'EN',width:300,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">EN</th>
					<th data-options="field:'JA',width:300,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">JA</th>
					<th data-options="field:'ZH',width:300,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">ZH</th>
				</tr>
			</table>
		</form>
	</div>
</div>
<script>
var beforeCost = {};
var modifyLang = function(row,index,changes){
		var UUID = row["UUID"];
		$.ajax({
			url: "/ServletController?AIR_ACTION=<%=actionCode%>&AIR_MODE=PROC_UPDATE&UUID="+UUID
			, type: "POST"
			, dataType: "json"
			, data: changes
		})
		.done(function(data) {

			if(Object.keys(data).length > 0){
				doSearch(document.form1);
			}else{
				alert("동일한코드명이존재합니다");
				reject();
			}
	    })
	    .fail(function() {
	    });
}
function reject(){
    $('#listTable').datagrid('rejectChanges');
}
$(function(){
	$('#listTabs-LIST').css('width','100%');
	$('#listTable').datagrid({
		url:'<%=jsonDataUrl%>',
		onBeforeLoad:function() { airCommon.showBackDrop(); },
		onLoadSuccess:function() {
			airCommon.hideBackDrop(), airCommon.gridResize();
		},
		onLoadError:function() { airCommon.hideBackDrop(); },
		 onAfterEdit:function(index,row, changes){
		    	if(Object.keys(changes).length > 0){//객체의 키의 갯수(IE:8은 동작안함) air-Common.js에 대응 코딩함..
		    		var message = "<%=StringUtil.getScriptMessage("M.값_변경_저장", siteLocale)%>";
		    		if(confirm(message)){
			    		modifyLang(row,index,changes );
		    		}else{
		    			reject()
		    		}
		    	}
		    }
	});
	$(window).bind('resize', airCommon.gridResize);
	$('#listTable').datagrid('enableCellEditing').datagrid('gotoCell', {
	    index: 0,
	    field: 'LANG_KO'

	});
});
</script>