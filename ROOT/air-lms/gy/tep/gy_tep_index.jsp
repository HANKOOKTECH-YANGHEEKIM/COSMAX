<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.08
  - 
  - @(#)
  - Description : 법무시스템 계약TEP
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
BeanResultMap responseMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
//-- 본 건 권한 체크 로직
SQLResults LMS_MAS		= responseMap.getResult("LMS_MAS");
BeanResultMap masMap = new BeanResultMap();
if(LMS_MAS == null || LMS_MAS.getRowCount() == 0){
	out.print("<script>");
	out.print("alert('"+StringUtil.getScriptMessage("M.접근권한이_없습니다", siteLocale)+"');");
	out.print("if(opener){");
	out.print("self.close();");
	out.print("}");
	out.print("</script>");
}else{
	masMap.putAll(LMS_MAS.getRowResult(0));
}

%>
<%-- 
//-- 계약만의 개인화 폼뷰가 필요할 경우 사용하면 됨.
<jsp:include page="/ServletController">
	<jsp:param value="LMS_GY_TEP" name="AIR_ACTION" />
	<jsp:param value="ILBAN_INCLUDE" name="AIR_MODE" />
	<jsp:param value="<%=sol_mas_uid%>" name="sol_mas_uid" />
</jsp:include>
--%>
<!-- 공통 폼모듈  -->
<jsp:include page="/ServletController">
	<jsp:param value="SYS_FORM" name="AIR_ACTION" />
	<jsp:param value="FORM_TOTAL_INCLUDE" name="AIR_MODE" />
	<jsp:param value="<%=sol_mas_uid%>" name="sol_mas_uid" />
</jsp:include>
<%

if(!"GY_REQ".equals(masMap.getString("STU_ID")) && !"GY_PUM2".equals(masMap.getString("STU_ID"))){//-- 요청 단계에서는 하다탬 표출안함
	
String workCont = "/ServletController?AIR_ACTION=LMS_GT_WORKCONT&AIR_MODE=LIST&gbn=GY&sol_mas_uid="+sol_mas_uid;		//-- 업무연락
String lawMemo = "/ServletController?AIR_ACTION=LMS_GT_LAW_MEMO&AIR_MODE=LIST&gbn=GY&sol_mas_uid="+sol_mas_uid;			//-- 법무팀메모
String extLawEmploy = "/ServletController?AIR_ACTION=LMS_GT_EXT_EMPLOY&AIR_MODE=LIST&gbn=GY&sol_mas_uid="+sol_mas_uid;		//-- 외부변호사위임
String extWorkCont = "/ServletController?AIR_ACTION=LMS_GT_EXT_WORKCONT&AIR_MODE=LIST&gbn=GY&sol_mas_uid="+sol_mas_uid;//-- 외부변호사 업무연락
String extEval = "/ServletController?AIR_ACTION=LMS_GT_EXT_EVAL&AIR_MODE=LIST&gbn=GY&sol_mas_uid="+sol_mas_uid;		//-- 외부변호사 평가
String costMng = "/ServletController?AIR_ACTION=LMS_GT_COST_MNG&AIR_MODE=LIST&gbn=GY&sol_mas_uid="+sol_mas_uid;		//-- 비용관리
%>
<div id="tepIndexOptLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto;margin-top:5px;">
    
	<div id="tepIndexOptTabs-workCont" title="<%=StringUtil.getLocaleWord("L.업무연락" ,siteLocale)%>" 
		data-options="href:'<%=workCont %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab('<%=StringUtil.getLocaleWord("L.업무연락" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
<%if(LmsUtil.isBeobmuOfiUser(loginUser)){ %>
	<div id="tepIndexOptTabs-lawMemo" title="<%=StringUtil.getLocaleWord("L.법무팀메모" ,siteLocale)%>" 
		data-options="href:'<%=lawMemo %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab('<%=StringUtil.getLocaleWord("L.법무팀메모" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
	<div id="tepIndexOptTabs-extLawEmploy" title="<%=StringUtil.getLocaleWord("L.외부변호사위임" ,siteLocale)%>" 
		data-options="href:'<%=extLawEmploy %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab('<%=StringUtil.getLocaleWord("L.외부변호사위임" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
	<div id="tepIndexOptTabs-extWorkCont" title="<%=StringUtil.getLocaleWord("L.외부변호사업무연락" ,siteLocale)%>" 
		data-options="href:'<%=extWorkCont %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab('<%=StringUtil.getLocaleWord("L.외부변호사업무연락" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
	<div id="tepIndexOptTabs-extEval" title="<%=StringUtil.getLocaleWord("L.외부변호사평가" ,siteLocale)%>" 
		data-options="href:'<%=extEval %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab('<%=StringUtil.getLocaleWord("L.외부변호사평가" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
	<div id="tepIndexOptTabs-costMng" title="<%=StringUtil.getLocaleWord("L.비용관리" ,siteLocale)%>" 
		data-options="href:'<%=costMng %>',tools:[{
      		iconCls:'icon-mini-refresh',
      			handler:function(){
      				refreshTab('<%=StringUtil.getLocaleWord("L.비용관리" ,siteLocale)%>');
      			}
  		}]" style="padding-top:5px;overflow-y:hidden;">
	</div>
<%} %>
<%if(StringUtil.isNotBlank(masMap.getString("EPS_IF_DTE"))){ %>
	<div id="tepIndexOptTabs-costMng" title="EPS"  style="padding-top:5px;overflow-y:hidden;">
  		<table class="basic">
  			<tr>
  				<th class="th2">EPS 계약체결여부 </th>
  				<td class="td2"><%="Y".equals(masMap.getStringView("EPS_GY_CHEGYL_YN"))?"Yes":"No" %></td>
  			</tr>
  			<tr>
  				<th>법무 검토 완료 계약서 수정여부 </th>
  				<td><%="Y".equals(masMap.getStringView("EPS_GY_MODIFY_YN"))?"Yes":"No" %></td>
  			</tr>
  			<tr>
  				<th>법무 검토 완료 계약서 수정사유</th>
  				<td><%=masMap.getStringView("EPS_GY_MODIFY_RESON") %></td>
  			</tr>
  		</table>
	</div>
<%} %>
</div>
<%} %>
<script>
var refreshTab = function(title){
	$('#tepIndexOptLayer').tabs('getTab',title).panel('refresh');
}

var refreshNowTab = function(){
	var tab = $('#tepIndexOptLayer').tabs('getSelected');
	tab.panel('refresh');
}

<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}

$(function(){
	//리사이징 처리
	$(window).resize(function() {
	});
	
});
</script>