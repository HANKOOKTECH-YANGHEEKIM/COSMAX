<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo               = requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize          = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    String pageOrderByField     = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
    String pageOrderByMethod    = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	    
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);
	
	String munseoBunryuGbnSTR = StringUtil.getCodestrFromSQLResults(responseMap.getResult("SYS_MUNSEO_BUNRYU_GBN_LIST"), "CODE_ID,LANG_CODE","|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale));
%>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.문서정의",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
	<form name="form1">
		 <input type="hidden" data-type="search" name="<%=CommonConstants.PAGE_NO%>" id="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
         <input type="hidden" data-type="search" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
         <input type="hidden" data-type="search" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
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
							<col style="width:36%" />
							<col style="width:12%" />
							<col style="width:auto" />
							<col style="width:80px" />
						</colgroup>
						<tr>
							<th><%=StringUtil.getLang("L.문서서식번호",siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="MUNSEO_SEOSIG_NO" data-type="search"  onkeyup="doSearch( true);"/>
							</td>
							<th><%=StringUtil.getLang("L.문서서식명",siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SEOSIG_NAM" data-type="search"  onkeyup="doSearch(true);"/>
							</td>
							<td rowspan="4" class="verticalContainer">
								<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
								<span class="separ"></span>																								
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
						<tr>
							<th>문서분류구분</th>
							<td colspan="3">
								솔루션 <%=HtmlUtil.getSelect(request,  true, "MUNSEO_BUNRYU_GBN_SYS_COD_ID1", "MUNSEO_BUNRYU_GBN_SYS_COD_ID1", munseoBunryuGbnSTR, "", "onChange=\"getMunseoBunryuGbnCode('MUNSEO_BUNRYU_GBN_SYS_COD_ID2', this.value);\" data-type=\"search\"") %>
								업무유형 <%=HtmlUtil.getSelect(request, true, "MUNSEO_BUNRYU_GBN_SYS_COD_ID2", "MUNSEO_BUNRYU_GBN_SYS_COD_ID2", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale), "", "onChange=\"getMunseoBunryuGbnCode('MUNSEO_BUNRYU_GBN_SYS_COD_ID3', this.value);\" data-type=\"search\"") %>
								단계 <%=HtmlUtil.getSelect(request, true, "MUNSEO_BUNRYU_GBN_SYS_COD_ID3", "MUNSEO_BUNRYU_GBN_SYS_COD_ID3", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale), "", " data-type=\"search\"") %>
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
		    	페이지 갯수:<%=HtmlUtil.getSelect(request, true, CommonConstants.PAGE_ROWSIZE, CommonConstants.PAGE_ROWSIZE, "10|10^20|20^30|30^50|50^100|100", pageRowSize, "data-type=\"search\"  onChange=\"doSearch();\"") %><%--  <input type="hidden" data-type="search" name="<%=CommonConstants.PAGE_ROWSIZE%>" id="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" /> --%>
		    </div>
		    <div class="rigth">
		     <%if(LmsUtil.isSysAdminUser(loginUser) && "112.220.221.117".equals(request.getRemoteAddr())){ %>
		    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goMigStart();">MIG시작</a></span>
		    <%} %>
		    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewWrite();">문서추가</a></span>
		    </div>
		</div>	
	</form>
		
		<table class="list" id="SysDefDocMainTable">
			<thead>
			<tr>
				<th data-opt='{"col":"MUNSEO_SEOSIG_NO","width":"12%","align":"CENTER","inputHidden":"DEF_DOC_MAIN_UID;MUNSEO_SEOSIG_NO","trKey":"DEF_DOC_MAIN_UID","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서서식번호</th>
				<th data-opt='{"col":"MUNSEO_ORD_SEQ","width":"5%","align":"LEFT","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>순차<br />번호</th>
				<th data-opt='{"col":"MUNSEO_SEOSIG_GBN_NAM","width":"8%","align":"CENTER","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서서식구분</th>
				<th data-opt='{"col":"MUNSEO_BUNRYU_GBN_NAM1","width":"12%","align":"CENTER","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서분류구분<br>(솔루션)</th>
				<th data-opt='{"col":"MUNSEO_BUNRYU_GBN_NAM2","width":"10%","align":"CENTER","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서분류구분<br>(업무유형)</th>
				<th data-opt='{"col":"MUNSEO_BUNRYU_GBN_NAM3","width":"12%","align":"CENTER","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서분류구분<br>(단계)</th>
				<th data-opt='{"col":"SEOSIG_NAM","width":"20%","align":"left","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서서식명</th>
				<th data-opt='{"col":"KO","width":"*","align":"left","onClick":"goView(\"@{DEF_DOC_MAIN_UID}\");"}'>문서서식명(한글)</th>
			</tr>
			</thead>
			<tbody id="SysDefDocMainTableBody"></tbody>
		</table>
		<%-- 페이지 목록 --%>
		<div class="pagelist" id="SysDefDocMainTablePage"></div> 
	</div>
</div>
<script>
/**
 * 검색항목 초기화
 */
function doReset(frm) {
	frm.reset();
}
function goMigStart(){
	var data = {};
	airCommon.callAjax("SYS_MIG", "MIG_PROG",data, function(json){
		
	});
	
}
//--  리스트
var doSearch = function(isCheckEnter){
	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
	
	var data = airCommon.getSearchQueryParams();
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
	  var page = $("#<%=CommonConstants.PAGE_NO%>").val();
	  var rowCnt = $("#<%=CommonConstants.PAGE_ROWSIZE%>").val();
	  
	  airCommon.createTableRow("SysDefDocMainTable", json, page, rowCnt, "goPaging");
	  
	});
	
};
//-- 페이지 이동
var goPaging = function(pageNo){
	$("#<%=CommonConstants.PAGE_NO%>").val(pageNo);
	
	doSearch();
}

function getMunseoBunryuGbnCode(targetId, val){
	var data = {};
	data["PARENT_CODE_ID"] = val;
	airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
		
		airCommon.initializeSelectJson(targetId, json, "|-- 선택 --", "CODE_ID", "NAME_KO");
	});
	
}

var goNewWrite = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=WRITE_FORM";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
}

var goView = function(def_uid){
// 	var $munseoNo = $("input:hidden[name='MUNSEO_SEOSIG_NO']", "#"+def_uid);
	
//     var title_no = $munseoNo.val();
	
//     if ($("#listTabsLayer").tabs("exists", title_no)) {
//     	$("#listTabsLayer").tabs("close", title_no);
//     } 
    
	var url = "/ServletController?AIR_ACTION=SYS_DEF_DOC_MAIN&AIR_MODE=WRITE_FORM&def_doc_main_uid="+ def_uid;// +"&stu_id="+ data.STU_ID +"&stu_gbn=GY";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
	
//     $("#listTabsLayer").tabs("add", {   
//          id:'listTabs-'+title_no,
//          title:title_no,
// 		href:url,
//          closable:true,
//          iconCls:'icon-document',
//          style:{paddingTop:'5px'}
//     });  
}
$(function(){
	doSearch();
});
</script>