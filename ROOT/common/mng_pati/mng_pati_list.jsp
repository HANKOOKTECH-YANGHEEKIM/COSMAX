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
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 					= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField		= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	String schPatiGwanriNo		= requestMap.getString("schPatiGwanriNo");
	String schPatiNam        	= requestMap.getString("schPatiNam");
	String schSysPatiGbn01		= requestMap.getString("schSysPatiGbn01");	
	String schSysPatiGbn02		= requestMap.getString("schSysPatiGbn02");

	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	SQLResults listResult 		= resultMap.getResult("LIST");	
	Integer listTotalCount		= resultMap.getInt("LIST_TOTALCOUNT");
	SQLResults sysPatiGbnList	= resultMap.getResult("SYS_PATI_GBN_LIST");
	
	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 코드정보 문자열 셋팅
	String sysPatiGbnStr 			= StringUtil.getCodestrFromSQLResults(sysPatiGbnList, "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
%>  
<script type="text/javascript">
/**
 * 검색 수행
 */	
function doSearch(isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	getList();
	
	
}

/**
 * 페이지 이동
 */	 
function goPaging( pageNo) {		

	getList(pageNo);
	
}

var getList =  function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams();
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
	  var page = $("#<%=CommonConstants.PAGE_NO%>").val();
	  var rowCnt = $("#<%=CommonConstants.PAGE_ROWSIZE%>").val();
	  
	  airCommon.createTableRow("SysMngPtiTable", json, page, rowCnt, "getList");
	  
	});
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
function goView(uuid) {	
	
	var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=POPUP_VIEW";
	url += "&mng_pati_uid="+uuid;
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");	
}

/**
 * 권한 수정 페이지로 이동
 */
function goEdit(frm) {
	
	var chk_user_name= "";
	
	if(!airCommon.isCheckedInput(frm.chk_user)){
		alert("<%=StringUtil.getLocaleWord("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.사용자", siteLocale))%>");
		return false;
	}
	
	for(var i = 1 ; i < frm.chk_user.length ; i++) {
		if (frm.chk_user[i].checked == true) {
			chk_user_name += frm.chk_user_name[i].value + ", ";
		}
	}
	
	frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
} 

/**
 * 상세보기 오픈
 */
function openDetail(uuid){
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_VIEW&uuid=' + uuid, 800, 520, 'open_user_info', 'yes', 'yes');
}

function getSysPatiGbnCode(targetId, val){		
	var data = {};
	data["PARENT_CODE_ID"] = val;
	airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
		
		airCommon.initializeSelectJson(targetId, json, "|-- 선택 --", "CODE_ID", "NAME_KO");
	});
}
$(function(){
	doSearch();
});
</script>

<form name="form1" method="post">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" id="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" />
	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" id="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=pageRowSize%>" />
    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" />
    <input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" />
    <input type="hidden" name="mng_pati_uid" />
	
	<table class="box">
	<tr>
		<td class="corner_lt"></td><td class="border_mt"></td><td class="corner_rt"></td>
	</tr>
	<tr>
		<td class="border_lm"></td>
		<td class="body">
			<table>
				<colgroup>
					<col style="width:8%" />
					<col style="width:15%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:10%" />
					<col style="width:28%" />
					<col style="width:auto" />
				</colgroup>
				<tr>
					<th>관리번호 :</th>	
					<td><input type="text" name="pati_gwanri_no" value="<%=StringUtil.convertForInput(schPatiGwanriNo) %>" style="width:90%" data-type="search" class="text" onkeydown="doSearch(true)" /></td>
					<th>파티클명칭 :</th>	
					<td><input type="text" name="pati_nam" value="<%=StringUtil.convertForInput(schPatiNam) %>" style="width:90%" data-type="search" class="text" onkeydown="doSearch(true)" /></td>
					<th>파티클 구분 :</th>						
					<td>
						<%=HtmlUtil.getSelect(request, true, "PATI_GBN_SYS_COD_ID1", "PATI_GBN_SYS_COD_ID1", sysPatiGbnStr, schSysPatiGbn01, "class=\"select\" data-type='search' onChange=\"getSysPatiGbnCode('PATI_GBN_SYS_COD_ID2', this.value);\"") %>
						<%=HtmlUtil.getSelect(request, true, "PATI_GBN_SYS_COD_ID2", "PATI_GBN_SYS_COD_ID2", "|--선택--", schSysPatiGbn02, "class=\"select\"  data-type='search'") %>
					</td>	
					<td style="text-align:center;">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
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
</form>
	<table class="list" id="SysMngPtiTable">		
		<thead >
		<tr data-opt='{"onClick":"goView(\"@{MNG_PATI_UID}\")"}'>
			<th style="width:5%" data-opt='{"align":"center","col":"ROWSEQ","inputHidden":"GT_MEMO_UID;SOL_MAS_UID"}'>No.</th>
			<th style="width:15%" data-opt='{"align":"center","col":"PATI_GWANRI_NO"}'>관리번호</th>
			<th style="width:15%" data-opt='{"align":"center","col":"PATI_GBN_NAM1"}'>파티클구분<br>(Depth 1)</th>
			<th style="width:15%" data-opt='{"align":"center","col":"PATI_GBN_NAM2"}'>파티클구분<br>(Depth 2)</th>
			<th style="width:*" data-opt='{"align":"center","col":"PATI_NAM"}'>파티클명</th>
			<th style="width:10%" data-opt='{"align":"center","col":"USE_DOC_CNT"}'>사용문서수</th>
		</thead>
		<tbody id="SysMngPtiTableBody">
		</tbody>
	</table>
	<%-- 페이지 목록 --%>
	<div class="pagelist" id="SysMngPtiTablePage"></div> 
	
	<div class="buttonlist">
		<div class="right">
<%--
			<input type="button" name="btnWrite" class="btn70" value="<%=StringUtil.getLocaleWord("B.파티클_추가",siteLocale)%>" onclick="goWrite(this.form);" />
 --%>		
		</div>		
	</div>
	
