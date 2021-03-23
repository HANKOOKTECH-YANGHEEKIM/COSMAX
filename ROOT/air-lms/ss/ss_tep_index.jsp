<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.08
  - 
  - @(#)
  - Description : 법무시스템 소송TEP
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}
//-- 검색값 셋팅
BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String sol_mas_uid = requestMap.getString("SOL_MAS_UID");

//-- 결과값 셋팅
BeanResultMap responseMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

//-- 파라메터 셋팅
String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
String modeCode = responseMap.getString(CommonConstants.MODE_CODE);


SQLResults rsSs			= responseMap.getResult("SS_MAS");
BeanResultMap masMap = new BeanResultMap();  
//-- 뷰 권한 체크
if(rsSs == null || rsSs.getRowCount() == 0){
	out.print("<script>");
	out.print("alert('"+StringUtil.getScriptMessage("M.접근권한이_없습니다", siteLocale)+"');");
	out.print("if(opener){");
	out.print("self.close();");
	out.print("}");
	out.print("</script>");
}


if(rsSs != null && rsSs.getRowCount() > 0)masMap.putAll(rsSs.getRowResult(0));

boolean isAuths = false;
if(loginUser.getLoginId().equals(masMap.getString("DAMDANGJA_ID")) ||
		loginUser.isUserAuth("LMS_SSM") ||
		LmsUtil.isSysAdminUser(loginUser)
){
	isAuths = true;
}

String base_doc_mas_uid = masMap.getString("GB_DOC_MAS_UID");
// String base_doc_mas_uid = requestMap.getString("GB_DOC_MAS_UID");

if(StringUtil.isNotBlank(base_doc_mas_uid)){
	String href = "/ServletController?AIR_ACTION="+actionCode;
	href +="&AIR_MODE=MAS_VIEW";
	href +="&sol_mas_uid="+sol_mas_uid;
	href +="&doc_mas_uid="+base_doc_mas_uid;
%>
<div id="SS_BASE<%=sol_mas_uid %>" title="<%=StringUtil.getLocaleWord("L.기본정보", siteLocale) %>" class="easyui-panel" style="padding:5px" data-options="href:'<%=href %>',collapsible:true,collapsed:false"> </div>
<%
}
%>
<br />
<script id="ssSimListRowTemplate" type="text/html">
    <tr id="\${SOL_MAS_UID}" onclick="goSimView<%=sol_mas_uid%>('\${SS_SIM_UID}');" style="cursor:pointer;">
        <td style="text-align:center;">
            \${SIM_CHA_NM}
			<input type="hidden" name="lms_pati_rel_title" id="lms_pati_rel_title" value="\${TITLE}" />
        </td>
        <td style="text-align:center;">\${SAGEON_NO}</td>
		<td style="text-align:center;">\${SAGEON_TIT}</td>
		<td style="text-align:center;">\${BEOBWEON_NAM}</td>
        <td style="text-align:center;">\${SOJEGI_DTE}</td>
        <td style="text-align:center;">\${SEONGO_DTE}</td>
		<td style="text-align:center;">\${GYEOLGWA_VAL}</td>
    </tr>
</script>

<table class="list" id="ssSimList<%=sol_mas_uid%>">
	<caption class="title">
		<%=StringUtil.getLocaleWord("L.심급목록", siteLocale) %>
		<span class="right">
<%
	if( ("LMS_SS_PROG_01".equals(masMap.getString("STU_ID")) 
		|| "LMS_SS_PROG_02".equals(masMap.getString("STU_ID")) 
		|| "LMS_SS_PROG_03".equals(masMap.getString("STU_ID")))
		&&((loginUser.getUserNo().equals(masMap.getString("DAMDANGJA_ID"))) || loginUser.getAuthCodes().contains("CMM_SYS"))
	){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewSimWrite<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.심급기본정보등록",siteLocale)%></a></span>
<%} %>
		</span>
	</caption>
	<colgroup>
		<col style="width:10%;" />
		<col style="width:10%;" />
		<col style="width:auto;" />
		<col style="width:12%;" />
		<col style="width:8%;" />
		<col style="width:8%;" />
		<col style="width:20%;" />
	</colgroup>
	<thead>
 	<tr>
		<th><%=StringUtil.getLocaleWord("L.심급", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.사건번호", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.사건명", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.관할법원", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.접수일자", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.종국일자", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.종국결과", siteLocale) %></th>
	</tr>
	</thead>
	<tbody id="ssSimList<%=sol_mas_uid%>Body"></tbody>
</table>

<br />

<div id="divSimView<%=sol_mas_uid%>">
	<%if(!"0".equals(masMap.getString("SIM_CHA_NO"))){ %>
	<div id="accordion-SimView<%=sol_mas_uid%>" title="<%=StringUtil.getLocaleWord("L.심급상세정보", siteLocale) %>" class="easyui-panel" data-options="collapsible:true,collapsed:true" style="padding:5px"></div>
	<br />
	<%} %>
</div>

<script>
var goNewSimWrite<%=sol_mas_uid%> = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_SS_MAS";
	url += "&AIR_MODE=SIM_START_WRITE_FORM";
	url += "&UPDATE_YN=N";	
	url += "&SOL_MAS_UID=<%=sol_mas_uid %>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_WRITE_FORM", "yes", "yes", "");		
};

var goSimView<%=sol_mas_uid%> = function(vSS_SIM_UID) {
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_SS_MAS";
	url += "&AIR_MODE=SIM_VIEW";	
	url += "&SOL_MAS_UID=<%=sol_mas_uid %>";
	url += "&SS_SIM_UID="+vSS_SIM_UID;
	url += "&STU_ID_YN="+vSS_SIM_UID;
	
	if($("#accordion-SimView<%=sol_mas_uid%>").length == 0){
		var div = $("<div class=\"easyui-panel\">").attr("id","#accordion-SimView<%=sol_mas_uid%>").css("padding","5px");
		$('#divSimView<%=sol_mas_uid%>').append(div);
	}
	
	var title = "<%=StringUtil.getLocaleWord("L.심급상세정보", siteLocale) %>";
	$("#accordion-SimView<%=sol_mas_uid%>").panel({
		href:url,
		title:title,
		collapsible:true,
		collapsed:false
	});
};

//-- 심급 목록
var getSimList<%=sol_mas_uid%> = function(){
	var data = {};
	data["sol_mas_uid"]="<%=sol_mas_uid%>";
	data["sim_cha_no__gt"] = "0";
	
	airCommon.callAjax("<%=actionCode%>", "SIM_JSON_LIST",data, function(json){
		setSimList<%=sol_mas_uid%>(json);
	});
};

var setSimList<%=sol_mas_uid%> =  function(data){
	$("#ssSimList<%=sol_mas_uid%>Body tr").remove(); // 기존 데이터 삭제
	
	if(data.RESULT === "NO_RESULT"){
		return false;
	}
	var arrData = data.rows;

   	//jquery-tmpl
   	var tgTbl = $("#ssSimList<%=sol_mas_uid%>Body");

	$("#ssSimListRowTemplate").tmpl(arrData).appendTo(tgTbl);
};


var refreshTab = function(title){
	$('#tepIndexOptLayer').tabs('getTab',title).panel('refresh');
}

var refreshWindow = function(){
	
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("LMS_SS_MAS"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_INDEX"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
	
}

//리사이징 처리
$(window).resize(function(){
// 	 $(".easyui-accordion").each(function(){
// 		 $(this).accordion('resize');
// 	 });
});
<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}

$(function(){
	getSimList<%=sol_mas_uid%>();
	
	$(window).resize(function() {
		$('.easyui-panel').panel('resize');
		$(".easyui-tabs").tabs('resize');
	});
});
</script>