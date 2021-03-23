<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.08
  - 
  - @(#)
  - Description : 법무시스템 공탁TEP
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

SQLResults rsDepositMas = responseMap.getResult("DEPOSIT_MAS");
//-- 뷰 권한 체크
if(rsDepositMas == null || rsDepositMas.getRowCount() == 0){
	out.print("<script>");
	out.print("alert('"+StringUtil.getScriptMessage("M.접근권한이_없습니다", siteLocale)+"');");
	out.print("if(opener){");
	out.print("self.close();");
	out.print("}");
	out.print("</script>");
}

BeanResultMap masMap = new BeanResultMap();  

if(rsDepositMas != null && rsDepositMas.getRowCount() > 0) masMap.putAll(rsDepositMas.getRowResult(0));


boolean isAuths = false;

if(
		loginUser.getLoginId().equals(masMap.getString("DAMDANGJA_ID")) ||
		loginUser.isUserAuth("LMS_SSM") ||
		LmsUtil.isSysAdminUser(loginUser)
){
	isAuths = true;
}

String deposit_mas_uid = requestMap.getString("DEPOSIT_MAS_UID");
String gb_doc_mas_uid	= masMap.getString("GB_DOC_MAS_UID");
if(StringUtil.isNotBlank(sol_mas_uid)){
	String href = "/ServletController?AIR_ACTION=LMS_DEPOSIT";
	href +="&AIR_MODE=VIEW_FORM";
	href +="&sol_mas_uid="+sol_mas_uid;
	href +="&gb_doc_mas_uid="+gb_doc_mas_uid;
%>
<div id="VIEW<%=sol_mas_uid %>" title="<%=StringUtil.getLocaleWord("L.공탁내역", siteLocale) %>" class="easyui-panel" style="padding:5px" data-options="href:'<%=href %>',collapsible:true,collapsed:false"></div>
<%
}
%>

<br />

<script id="depositGetListRowTemplate" type="text/html">
    <tr id="\${DEPOSIT_GET_UID}">
        <td onclick="goNewGetWrite<%=sol_mas_uid%>('\${DEPOSIT_GET_UID}');" style="cursor:pointer; text-align:center;">{{html rownum()}}</td>
        <td onclick="goNewGetWrite<%=sol_mas_uid%>('\${DEPOSIT_GET_UID}');" style="cursor:pointer; text-align:center;">\${DEPOSIT_GET_DTE}</td>
        <td onclick="goNewGetWrite<%=sol_mas_uid%>('\${DEPOSIT_GET_UID}');" style="cursor:pointer; text-align:right;">\${airCommon.getFormatCurrency( DEPOSIT_GET_COST,0)}</td>
        <td onclick="goNewGetWrite<%=sol_mas_uid%>('\${DEPOSIT_GET_UID}');" style="cursor:pointer; text-align:right;">\${airCommon.getFormatCurrency( DEPOSIT_GET_INTEREST,0)}</td>
        <td onclick="goNewGetWrite<%=sol_mas_uid%>('\${DEPOSIT_GET_UID}');" style="cursor:pointer; text-align:center;">\${DEPOSIT_GET_REASON}</td>
        <td style="text-align:left;">{{html fileDown(FILE_UID,FILE_NAME)}}</td>
    </tr>
</script>
<table class="list" id="depositGetList<%=sol_mas_uid%>">
	<caption class="title">
			<%=StringUtil.getLocaleWord("L.회수내역", siteLocale) %>
		<span class="right">
<% if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goNewGetWrite<%=sol_mas_uid%>('');"><%=StringUtil.getLocaleWord("B.회수정보등록",siteLocale)%></a></span>
<% } %>
		</span>
	</caption>
	<colgroup>
		<col style="width:80px;" />
		<col style="width:100px;" />
		<col style="width:12%;" />
		<col style="width:12%;" />
		<col style="width:auto;" />
		<col style="width:15%;" />
	</colgroup>
	<thead>
 	<tr>
		<th><%=StringUtil.getLocaleWord("L.회수차수", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.회수일자", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.회수금액", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.회수이자", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.회수사유", siteLocale) %></th>
		<th><%=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th>
	</tr>
	</thead>
	<tbody id="depositGetList<%=sol_mas_uid%>Body"></tbody>
</table>
<br />
<%
String workCont = "/ServletController?AIR_ACTION=LMS_GT_WORKCONT_NO_RE&AIR_MODE=LIST&gbn=DP&sol_mas_uid="+sol_mas_uid; //-- 업무연락
%>
<div id="tepIndexOptLayer<%=sol_mas_uid %>" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto" data-options="selected:true">
    
	<div id="tepIndexOptTabs-workCont" title="<%=StringUtil.getLocaleWord("L.업무연락" ,siteLocale)%>" 
		data-options="href:'<%=workCont %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab<%=sol_mas_uid %>('<%=StringUtil.getLocaleWord("L.업무연락" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
</div>
<script>
//-- 회수정보 목록
var getDepositGetList<%=sol_mas_uid%> = function(){
	var data = {};
	data["sol_mas_uid"]="<%=sol_mas_uid%>";
	
	airCommon.callAjax("<%=actionCode%>", "GET_JSON_LIST",data, function(json){
		setDepositGetList<%=sol_mas_uid%>(json);
	});
};

var setDepositGetList<%=sol_mas_uid%> =  function(data){
	$("#depositGetList<%=sol_mas_uid%>Body tr").remove(); // 기존 데이터 삭제
	
	var arrData = data.rows;

   	//jquery-tmpl
   	var tgTbl = $("#depositGetList<%=sol_mas_uid%>Body");

   	vRownum = 0;

   	$("#depositGetListRowTemplate").tmpl(arrData).appendTo(tgTbl);
};

var vRownum = 0;

var rownum = function(){
	vRownum ++;
	return vRownum;
};

var fileDown = function(fileVal, fileNm){
	var rtnStr = "";
	var arrNm = fileNm.split("/");
	var arrVal = fileVal.split("/");
	if(fileNm != "" && arrNm.length > 0){
		rtnStr += "<ul class='attach_file_view'>"
		$(arrNm).each(function(k,a){
			rtnStr += "<li>"
			rtnStr += "<a href='javascript:airCommon.popupAttachFileDownload(\""+arrVal[k]+"\")'>"+arrNm[k]+"</a>";
			rtnStr += "</li>"
		});
		rtnStr += "</ul>"
	}
	
	return rtnStr;
};

var goNewGetWrite<%=sol_mas_uid%> = function(vDeposit_get_uid){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_DEPOSIT";
	url += "&AIR_MODE=GET_WRITE_FORM";	
	url += "&SOL_MAS_UID=<%=sol_mas_uid %>";
	url += "&DEPOSIT_MAS_UID=<%=deposit_mas_uid %>";	
	url += "&DEPOSIT_GET_UID="+vDeposit_get_uid;	
	
	airCommon.openWindow(url, "1024", "380", "POPUP_WRITE_FORM", "yes", "yes", "");		
};

var refreshTab<%=sol_mas_uid %> = function(title){
	$('#tepIndexOptLayer<%=sol_mas_uid %>').tabs('getTab',title).panel('refresh');
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
	getDepositGetList<%=sol_mas_uid%>();
});
</script>