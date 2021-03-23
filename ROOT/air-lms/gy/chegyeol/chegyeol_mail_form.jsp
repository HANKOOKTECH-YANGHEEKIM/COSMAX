<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.02.21
  - 
  - @(#)
  - Description : 법무시스템 공용 결재문서리스트
  --%>
<%@page import="java.lang.reflect.Field"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@page import="com.emfrontier.air.common.util.StringUtil"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants"%>
<%@page import="com.emfrontier.air.common.model.SysLoginModel"%>
<%@page import="com.emfrontier.air.common.util.DateUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

String shGyeYagSangDaeBang	= requestMap.getString("SHGYEYAGSANGDAEBANG");
String shYoCheongJa			= requestMap.getString("SHYOCHEONGJA");
String shDamDangJa			= requestMap.getString("SHDAMDANGJA");
String shGyeYagMyeong		= requestMap.getString("SHGYEYAGMYEONG");
String shGwanriNo			= requestMap.getString("SHGWANRINO");
String PYOJUN_GYEYAGSEO_YN	= requestMap.getString("PYOJUN_GYEYAGSEO_YN");
String shMailCnt			= requestMap.getString("SHMAILCNT");
String schQry				= requestMap.getString("SCHQRY");
String sol_mas_uids			=  requestMap.getString("SOL_MAS_UIDS");



if(StringUtil.isBlank(schQry)){
	schQry = "{}";
}

String shGeomtoDteTo      = StringUtil.convertNull(request.getParameter("shGeomtoDteTo"));
if(shGeomtoDteTo == null || "".equals(shGeomtoDteTo)) {
	shGeomtoDteTo = DateUtil.addDays(DateUtil.getCurrentDate(), -90);
}

//-- 결과값 셋팅
BeanResultMap resultMap     = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

//리스트 컬럼
String   finalListColumn 			= "GWANRI_NO|GYEYAG_TIT|GYEYAG_SANGDAEBANG_NAM|YOCHEONG_DTE|HOESA_NAM|YOCHEONG_NAM|YOCHEONG_ID|YOCHEONG_DPT_NAM|SANGTAE_NAM|SANGTAE_COD|DAMDANG_NAM|GEOMTO_DTE|EONEO_NAM|SOYOGIGAN|FILE_NAME|RE_GT_DATE";
String[] finalListColumnArray 		= StringUtil.split(finalListColumn, "|");


String actionCode           = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode             = resultMap.getString(CommonConstants.MODE_CODE);
String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));

SQLResults listResult		= resultMap.getResult("LIST");
%>
<!-- // Content // -->
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.이메일",siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
		<form id="form1" name="form1" method="post" onsubmit="return false;">
		<input type="hidden" name="sol_mas_uids" id="sol_mas_uids" value="<%=sol_mas_uids%>">
		<input type="hidden" name="shCSFile" value="N">
		<input type="hidden" name="schGuBun" value="NOREG">
		<input type="hidden" name="shGeomtoDteTo" id="shGeomtoDteTo" value="<%=shGeomtoDteTo%>"/>
		<input type="hidden" name="shGyeYagSangDaeBang" value="<%=shGyeYagSangDaeBang%>">
		<input type="hidden" name="shYoCheongJa" value="<%=shYoCheongJa%>">
		<input type="hidden" name="shDamDangJa" value="<%=shDamDangJa%>">
		<input type="hidden" name="shGyeYagMyeong" value="<%=shGyeYagMyeong%>">
		<input type="hidden" name="shGwanriNo" value="<%=shGwanriNo%>">
		<input type="hidden" name="PYOJUN_GYEYAGSEO_YN" value="<%=PYOJUN_GYEYAGSEO_YN%>">
		<input type="hidden" name="shMailCnt" value="<%=shMailCnt%>">
		<input type="hidden" name="page" value="-1">
		<br/>
		<table class="basic">
		<caption><%=StringUtil.getLocaleWord("B.WRITE",siteLocale) %></caption>
			<tr>
				<th class="th2"><%=StringUtil.getLocaleWord("L.수신자",siteLocale) %></th>
				<td class="td2">
					<input type="checkbox" name="yocheongja_yn" id="yocheongja_yn" value="Y" checked/><label for="yocheongja_yn"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale) %></label>
					<input type="checkbox" name="yocheong_leader_yn" id="yocheong_leader_yn" value="Y"/><label for="yocheong_leader_yn"><%=StringUtil.getLocaleWord("L.팀장" ,siteLocale) %></label>
<%-- 					<input type="checkbox" name="yocheong_chair_yn" id="yocheong_chair_yn" value="Y"/><label for="yocheong_chair_yn"><%=StringUtil.getLocaleWord("L.회사장" ,siteLocale) %></label> --%>
				</td>
			</tr>
			<tr>
				<th class="th2"><%=StringUtil.getLocaleWord("L.제목",siteLocale) %></th>
				<td class="td2"><input type="text" name="title" id="title" class="text width_max" /></td>
			</tr>
			<tr>
				<th class="th2"><%=StringUtil.getLocaleWord("L.내용",siteLocale) %></th>
				<td class="td2"><textarea name="content" id="content" class="text width_max" rows="22"></textarea></td>
			</tr>
		</table>
		</form>
	 	<div class="buttonlist">
			<div class="right">
				<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doSubmit();"><%=StringUtil.getLocaleWord("B.발송",siteLocale)%></a></span>
				<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="window.close()"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">

var doSubmit = function(){
	
	var schQry = <%=schQry%>;
	schQry["yocheongja_yn"] 		= $("#yocheongja_yn").is(":checked")?"Y":"N" ;
	schQry["yocheong_leader_yn"] 	= $("#yocheong_leader_yn").is(":checked")?"Y":"N";
	schQry["title"] 				= $("#title").val();
	schQry["content"] 				= $("#content").val();
	schQry["sol_mas_uids"] 			= $("#sol_mas_uids").val();
	console.log(JSON.stringify(schQry));
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, StringUtil.getLocaleWord("B.발송",siteLocale))%>")) {
		var frm = document.form1;
		airCommon.callAjax('LMS_GY_LIST_MAS','MAIL_WRITE_PROC',schQry, function(data){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			self.close();
		});
	}
}

var goBack = function() {
	history.back(-1);
}

$(function(){
	
});
</script>
