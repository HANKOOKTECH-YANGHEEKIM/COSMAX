<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap searchMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= searchMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String sol_mas_uid 					= resultMap.getString("sol_mas_uid");
	String sol_mas_ids 					= resultMap.getString("sol_mas_ids");
	SQLResults viewResult 				= resultMap.getResult("VIEW");
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 상세보기 값 셋팅
	/* String gubun_cod			= "";
	String gubun_nam			= "";
	String mas_tit				= "";
	String damdang_id			= "";
	String damdang_nam			= "";
	
	if(viewResult != null && viewResult.getRowCount() > 0){
		gubun_cod				= viewResult.getString(0, "gubun_cod");
		gubun_nam				= viewResult.getString(0, "gubun_nam_" + siteLocale);
		mas_tit					= viewResult.getString(0, "mas_tit");
		damdang_id				= viewResult.getString(0, "damdang_id");
		damdang_nam				= viewResult.getString(0, "damdang_nam_" + siteLocale);
	}
	 */
%>

<script type="text/javascript">
/**
 * 목록 페이지로 이동
 */	

var nodeCnt = 0;


function goList(frm) {		
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_GOLIST",siteLocale)%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();	
	}	
}

/**
 * 저장
 */	
function doSubmit(frm) {	

	// 결재예정 결재라인 수 체크 - 결재에정인 건이 없으면 저장할 수 없도록 함. 이유는 결재완료로 처리할 수 없기 때문. 2015.05.11, 추가
	var flowCheoriYnCnt = 0;
	var cnt = document.getElementsByName("_approvalSignCheck").length;
	
	for(var i = 0; i < cnt; i++) {
		if(document.getElementsByName("_approvalSignCheck")[i].value == "W" 
				|| document.getElementsByName("_approvalSignCheck")[i].value == "N") { 
			flowCheoriYnCnt++;
		}
	}

	if(flowCheoriYnCnt == 0) {
		alert("<%=StringUtil.getLocaleWord("M.최소_한_명_이상_결재예정자를_선택해야합니다",siteLocale)%>");
		return false;
	}
	
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_SUBMIT",siteLocale, StringUtil.getLocaleWord("L.저장", siteLocale))%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "APPROVAL_CHANGE_PROC";
		
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}
}

function doPopupPageOpen(frm){
	
	var actionCode = "";
	var airMode = "";
	var doc_mas_uid = "<%=viewResult.getString(0, "doc_mas_uid")%>";
	var def_doc_main_uid = "<%=viewResult.getString(0, "def_doc_main_uid")%>";
	
	actionCode = 'SYS_DOC_MAS';
	airMode = 'VIEW_FORWARD';
	
	var url
	= "/ServletController"
	+ "?AIR_ACTION="+actionCode
	+ "&AIR_MODE="+airMode
	+ "&def_doc_main_uid="+def_doc_main_uid
	+ "&doc_mas_uid="+doc_mas_uid;
	
	airCommon.openWindow(url, "1024", "800", "POPUP_VIEW", "yes", "yes", "");
}


/**
 * 결재선 지정 버튼 클릭
 */
function _approvalSignAddButton_Click( signType, uidx ) {
	
	var aprv = $("[data-meaning='aprvUser']", "#tbody_aprv_line");
	var defaultUser="";
	aprv.each(function(i,e){
		if(i>0)defaultUser+=",";
		defaultUser+=$(this).find("[name='_approvalSignUserId']").val();
	});
	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_APRV_USER_SIGN_SELECT";
	url += "&callbackFunction=_getDefault";
	url += "&defaultUser="+defaultUser;
	url += "&signTypeCode="+ signType;
	url += "&groupTypeCodes=IG"
	url += "&defaultAppLineDisable=N"
	url += "&defaultSet=Y"
	url += "&userType=aprv"
        	
	airCommon.openWindow(url , 1024, 600, 'open_aprv_user', 'yes', 'yes');
}


function _getDefault(json){
	
	$.ajax({
		url: "/ServletController"
		, type: "POST"
		, async: true
		, cache: false
		, data: {
			"AIR_ACTION":"SYS_DOC_FLOW"
			,"AIR_MODE":"CHK_SUB_APRV_LINE"
			,"jsonStr":json
		}
		, dataType: "json"
	}).done(function(data){
		_approvalSignList_AddNode(JSON.stringify(data));
		
	}).fail(function(){
		alert("<%=StringUtil.getLocaleWord("M.에러처리", siteLocale)%>");
	});

	
}
function _approvalSignList_AddNode(json) {
	var data = JSON.parse(json);
	if(data.length > 0){
		$("#tbody_aprv_line").html(""); 
		$("#addAprvHtmlTmpl").tmpl(data).appendTo("#tbody_aprv_line");
	}
}
function initApprovalLine(){
	<%if(viewResult != null && viewResult.getRowCount() >0){
		String signUserUuid = "";
		String signUserId = "";
		String signUserName = "";
		String signUserPosCode = "";
		String signUserPosName = "";
		String signGrpUuid = "";
		String signGrpName = "";
		String signFlowCheoriYn = "";
		
		for(int i = 0; i < viewResult.getRowCount(); i++){
			signUserUuid = viewResult.getString(i, "REAL_CHEORIJA_UID");
			signUserId = viewResult.getString(i, "REAL_CHEORIJA_ID");
			signUserName = viewResult.getString(i, "REAL_CHEORIJA_NAM");
			signUserPosCode = viewResult.getString(i, "POSITION_CODE");
			signUserPosName = viewResult.getString(i, "POSITION_NAME");
			signGrpUuid = viewResult.getString(i, "REAL_CHEORIJA_GROUP_UID");
			signGrpName = viewResult.getString(i, "REAL_CHEORIJA_GROUP_NAM");
			signFlowCheoriYn = viewResult.getString(i, "FLOW_CHEORI_YN");
	%>
		_approvalSignList_AddNode(1, <%=i%>, "<%=signUserUuid%>", "<%=signUserId%>", "<%=signUserName%>", "<%=signUserPosCode%>", "<%=signUserPosName%>", "<%=signGrpUuid%>", "<%=signGrpName%>", "<%=signFlowCheoriYn%>");
	<%	}%>
	<%}%>
	
}

window.onload = function(){
	initApprovalLine();
}

</script>
<script id="addAprvHtmlTmpl" type="text/x-jquery-tmpl">
<tr>
	<th class="th6"><%=StringUtil.getLocaleWord("L.성명",siteLocale) %></th>
	<td class="td6" data-meaning="aprvUser">
{{if SUB_APRV.length > 0 }}
		<select name="_approvalSignUserId">
			<option value="\${LOGIN_ID}">\${NAME_<%=siteLocale%>} \${POSITION_NAME_<%=siteLocale%>}</option>
	{{each(i, item) SUB_APRV}}
			<option value="\${LOGIN_ID}">\${NAME_<%=siteLocale%>} \${POSITION_NAME_<%=siteLocale%>}</option>
	{{/each}}
		</select><%=StringUtil.getLocaleWord("L.위임자확인", siteLocale)%>
{{else}}
			\${NAME_<%=siteLocale%>} \${POSITION_NAME_<%=siteLocale%>}
			<input type="hidden" name="_approvalSignUserId" value="\${LOGIN_ID}"/>
{{/if}}
			<input type="hidden" name="_approvalSignUserUuid" value="\${UUID}"/>
			<input type="hidden" name="_approvalSignUserName" value="\${NAME_<%=siteLocale%>}"/>
			<input type="hidden" name="_approvalSignUserPosCode" value="\${POSITION_CODE}"/>
			<input type="hidden" name="_approvalSignUserPosName" value="\${POSITION_NAME_<%=siteLocale%>}"/>
			<input type="hidden" name="_approvalSignGrpUuid" value="\${GROUP_UUID}"/>
			<input type="hidden" name="_approvalSignGrpName" value="\${GROUP_NAME_<%=siteLocale%>}"/>
			<input type="hidden" name="_approvalSignCheck" value='N' />
	</td>
	<th class="th6"><%=StringUtil.getLocaleWord("L.소속",siteLocale) %></th>
	<td class="td6">\${GROUP_NAME_<%=siteLocale%>}</td>
	<th class="th6"><%=StringUtil.getLocaleWord("L.결재상태",siteLocale) %></th>
	<td class="td6"><%=StringUtil.getLocaleWord("L.결재예정",siteLocale) %></td>
</tr>
</script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="sol_mas_ids" value="<%=sol_mas_ids%>" />
	<input type="hidden" name="doc_mas_uid" value="<%=viewResult.getString(0, "doc_mas_uid")%>" />
	<input type="hidden" name="def_doc_main_uid" value="<%=viewResult.getString(0, "def_doc_main_uid")%>" />
	<div id="div_aprv_line">
		<table class="basic" id="tb_aprv_line">
			<caption>
				<span style="float:left;">
					<%-- <a href="javascript:void(0)" onclick="doPopupPageOpen(document.form1);"><%=viewResult.getString(0, "MUNSEO_SEOSIG_NAM_KO")%></a> : <%=StringUtil.getLocaleWord("L.결재선지정",siteLocale) %> --%> 
					<%=viewResult.getString(0, "MUNSEO_SEOSIG_NAM_KO")%>
				</span>
				<span id="div_aprv_line_select_button" style="float:right;">
					<input type="button" title="<%=StringUtil.getLocaleWord("B.SEARCH_CHR",siteLocale)%>" class="btn_search" onclick="_approvalSignAddButton_Click('APRVCH','1')" /> <%=StringUtil.getLocaleWord("L.결재자추가",siteLocale) %> 
				</span>
			</caption>
	<%if(viewResult != null && viewResult.getRowCount() >0){
		String signUserUuid = "";
		String signUserId = "";
		String signUserName = "";
		String signUserPosCode = "";
		String signUserPosName = "";
		String signGrpUuid = "";
		String signGrpName = "";
		String signFlowCheoriYn = "";
		
		for(int i = 0; i < viewResult.getRowCount(); i++){
			signUserUuid = viewResult.getString(i, "REAL_CHEORIJA_UID");
			signUserId = viewResult.getString(i, "REAL_CHEORIJA_ID");
			signUserName = viewResult.getString(i, "REAL_CHEORIJA_NAM");
			signUserPosCode = viewResult.getString(i, "POSITION_CODE");
			signUserPosName = viewResult.getString(i, "POSITION_NAME");
			signGrpUuid = viewResult.getString(i, "REAL_CHEORIJA_GROUP_UID");
			signGrpName = viewResult.getString(i, "REAL_CHEORIJA_GROUP_NAM");
			signFlowCheoriYn = viewResult.getString(i, "FLOW_CHEORI_YN");
			if("W".equals(signFlowCheoriYn)||"I".equals(signFlowCheoriYn)){
				out.print("<tbody id=\"tbody_aprv_line\">");
			}
	%>
		<tr>
			<th class="th6"><%=StringUtil.getLocaleWord("L.성명",siteLocale) %></th>
			<td class="td6" data-meaning="aprvUser">
					<%=signUserName %> <%=signUserPosName %>
					<input type="hidden" name="_approvalSignUserId" value="<%=signUserId%>"/>
					<input type="hidden" name="_approvalSignUserUuid" value="<%=signUserUuid%>"/>
					<input type="hidden" name="_approvalSignUserName" value="<%=signUserName%>"/>
					<input type="hidden" name="_approvalSignUserPosCode" value="<%=signUserPosCode%>"/>
					<input type="hidden" name="_approvalSignUserPosName" value="<%=signUserPosName%>"/>
					<input type="hidden" name="_approvalSignGrpUuid" value="<%=signGrpUuid%>"/>
					<input type="hidden" name="_approvalSignGrpName" value="<%=signGrpName%>"/>
					<input type="hidden" name="_approvalSignCheck" value="<%=signFlowCheoriYn %>" />
			</td>
			<th class="th6"><%=StringUtil.getLocaleWord("L.소속",siteLocale) %></th>
			<td class="td6"><%=signGrpName %></td>
			<th class="th6"><%=StringUtil.getLocaleWord("L.결재상태",siteLocale) %></th>
			<td class="td6"><%=("Y".equals(signFlowCheoriYn)?StringUtil.getLocaleWord("L.결재완료",siteLocale):StringUtil.getLocaleWord("L.결재예정",siteLocale)) %></td>
		</tr>
		
		
		
	<%	}%>
	<%}else{
		out.print("<tbody id=\"tbody_aprv_line\">");
	}
	%>
			</tbody>
		</table>
	</div>
	<div class="buttonlist">	
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doSubmit(document.form1);"><%=StringUtil.getLocaleWord("B.CONFIRM",siteLocale)%></a></span>	
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0)" onclick="goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
	</div>  
</form>

