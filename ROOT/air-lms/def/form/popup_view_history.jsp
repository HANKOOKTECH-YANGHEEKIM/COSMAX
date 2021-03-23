<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>

<%
	response.setContentType("text/html; charset=UTF-8");
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();


	//-- 요청값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	
	//-- 결과값 셋팅
	BeanResultMap responseMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	
	SQLResults DATA_LIST = responseMap.getResult("DATA_LIST");
	
	//-- 파라메터 셋팅
	String actionCode		= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode			= responseMap.getString(CommonConstants.MODE_CODE);
	
	
%>
<div id="tepIndexOptLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto" data-options="selected:true">
 <%if(DATA_LIST != null && DATA_LIST.getRowCount() > 0){ %>
	<%for(int i=0; i<DATA_LIST.getRowCount(); i++){
      String doc_mas_uid 		= DATA_LIST.getString(i,"doc_mas_uid") ;
      String munseo_seosig_no 	= DATA_LIST.getString(i,"munseo_seosig_no") ;
      String url = "/ServletController?AIR_ACTION=SYS_FORM";
      url += "&AIR_MODE=VIEW_FORM_ONE";
      url += "&doc_mas_uid="+doc_mas_uid;
      url += "&munseo_seosig_no="+munseo_seosig_no;
      
      String title = "Rev."+(DATA_LIST.getRowCount()-i);
      
	%>
	<div id="tepIndexOptTabs-workCont" title="<%=title%>" 
		data-options="href:'<%=url %>'" style="padding-top:5px;overflow-y:hidden;">
	</div>
	<%} %>
<%} %>
</div>
