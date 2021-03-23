<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="java.util.Map"%>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale 			= loginUser.getSiteLocale();
	//-- 결과값 셋팅
	BeanResultMap responseMap 	= (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	SQLResults DATA_LIST 		= responseMap.getResult("DATA_LIST");
	
	String mng_pati_uid         = StringUtil.convertNull(request.getParameter("AIR_PARTICLE"));
	String doc_mas_mode_code 	= StringUtil.convertNull(request.getParameter("doc_mas_mode_code"));
	String doc_mas_uid			= StringUtil.convertNull(request.getParameter("doc_mas_uid"));
	String new_doc_mas_uid 		= StringUtil.convertNull(request.getParameter("new_doc_mas_uid"));
	String def_doc_main_uid 	= StringUtil.convertNull(request.getParameter("def_doc_main_uid"));
	String munseo_seosig_no 	= StringUtil.convertNull(request.getParameter("munseo_seosig_no"));
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	BeanResultMap jsonMap 		= (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap 	= new BeanResultMap();
	
	String lms_pati_gy_004_uid 	= jsonMap.getString("LMS_PATI_GY_004_UID");  
	
	String caption 				= StringUtil.getLocaleWord("L.계약재검토요청", siteLocale);
	String title 				= StringUtil.getLocaleWord("L.내용", siteLocale);
	
	BeanResultMap dataMas = new BeanResultMap();
	
	if("DDD-LMS-GY-012".equals(munseo_seosig_no) || "DDD-LMS-GY-019".equals(munseo_seosig_no)){
		caption 	= StringUtil.getLocaleWord("L.계약체결중단", siteLocale);
		title 		= StringUtil.getLocaleWord("L.체결중단사유", siteLocale);
		
		if(DATA_LIST != null && DATA_LIST.getRowCount()> 0){
			dataMas.putAll(DATA_LIST.getRowResult(0));
		}
		
	}else if("DDD-LMS-JM-017".equals(munseo_seosig_no)){
		caption 	= StringUtil.getLocaleWord("L.추가검토_요청", siteLocale);
	}
%>

<input type="hidden" name="lms_pati_gy_004_uid" value="<%=lms_pati_gy_004_uid%>">

<table class="basic">
	<caption><%=caption%></caption>
	<tr>
		<th class="th4"><%=title%></th>
		<td class="td4" colspan ="3">
			<%=jsonMap.getString("LMS_PATI_CONTENT")%>			
		</td>
	</tr>
	<%if("DDD-LMS-GY-012".equals(munseo_seosig_no)){ %>	 
	<tr>
		<th class="th4">계약체결중단일</th>
		<td class="td4">
			<%=dataMas.getStringView("WRT_DTE") %>
	</tr>
	<%} %> 
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부",siteLocale) %> </th>
		<td class="td4" colspan ="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="CMM" name="systemTypeCode" />
				<jsp:param value="CMM/CMM" name="typeCode" />
			</jsp:include>
		</td>
	</tr>	
	<tr>
        <th class="th4"><%=StringUtil.getLocaleWord("L.참조자_열람가능",siteLocale)%></th>
        <td class="td4" colspan ="3"><%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM"))%></td>
    </tr>
</table>
<p>
