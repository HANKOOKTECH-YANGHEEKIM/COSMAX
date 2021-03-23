<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	String mng_pati_uid         = StringUtil.convertNull(request.getParameter("AIR_PARTICLE"));
	String doc_mas_uid			= StringUtil.convertNull(request.getParameter("doc_mas_uid"));
	String new_doc_mas_uid		= StringUtil.convertNull(request.getParameter("new_doc_mas_uid"));
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid"));

	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	/* Code Start	
	String sampleField      = "";	
	*/
	//String lms_pati_gy_003_uid = jsonMap.getString("lms_pati_gy_008_uid");
	String lms_pati_gy_003_uid 	= jsonMap.getString("LMS_PATI_GY_003_UID");
	
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
			
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0){
		lmsMap.putAll(LMS_MAS.getRowResult(0));
	}	
	
	
	String geom_doc_mas_uid = resultMap.getString("GEOM_DOC_MAS_UID");
%>
<!-- 파일첨부보여주기 -->
<!-- ips_cw_004_view.jsp 참조 -->
	
	
<!-- Code Start -->
<table class="basic">
	<caption>
		<span class="left">
			<%=StringUtil.getLocaleWord("L.계약체결품의",siteLocale)%>
		</span>
	</caption>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.법무팀_검토계약서_수정여부",siteLocale)%></th>
		<td class="td2">
			<%="Y".equals(jsonMap.getString("LMS_PATI_MODI_CONT_YN")) ? "Yes" : "No" %>
			<%-- <%if("Y".equals(jsonMap.getString("LMS_PATI_MODI_CONT_YN"))){ %>
				<span style="color:red;">(<%=StringUtil.getLocaleMessage("M.수정계약_알림2", siteLocale) %>)</span>
			<%} %> --%>
		</td>
	</tr>
<%
	if("Y".equals(jsonMap.getString("LMS_PATI_MODI_CONT_YN"))){
%>	
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.수정내용및사유",siteLocale)%></th>
		<td class="td2">
			<%=jsonMap.getStringView("LMS_PATI_MODI_REASON") %>
		</td>
	</tr>
<%
	}
%>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.품의내용",siteLocale)%></th>
		<td class="td2"><%=jsonMap.getString("LMS_PATI_APR_OPI") %></td>
	</tr>
<%if(StringUtil.isBlank(lmsMap.getString("PUM_EN_DTE"))){ //-- 검토완료 전 %>
	<%if("Y".equals(jsonMap.getString("LMS_PATI_MODI_CONT_YN"))){ %>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.수정계약서",siteLocale)%></th>
		<td class="td2">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_MODI" name="typeCode" />
			</jsp:include>
		</td>
	</tr>
	<%}else{ %>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.검토완료계약서",siteLocale) %><br/>(<%=StringUtil.getLocaleWord("L.클린본",siteLocale) %>)</th>
      	<td class="td4" colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=geom_doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_CLEAN" name="typeCode" />
			</jsp:include>
		</td>	
	</tr>
	<%} %>
<%}else{//-- 검토완료후 %>
	<%if("Y".equals(jsonMap.getString("LMS_PATI_MODI_CONT_YN"))){ %>
	<tr >
		<th class="th2">PDF 변환본</th>
		<td class="td2">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=sol_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_PDF" name="typeCode" />
			</jsp:include>
		</td>
	</tr>
	<%}else{ %>
	<tr >
		<th class="th2">PDF 변환본</th>
		<td class="td2">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=sol_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_PDF" name="typeCode" />
			</jsp:include>
		</td>
	</tr>
	<%} %>
<%} %>
	
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.관련자료",siteLocale)%></th>
		<td class="td2">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="CMM" name="systemTypeCode" />
				<jsp:param value="CMM/CMM" name="typeCode" />
			</jsp:include>
		</td>
	</tr>
</table>

<%if("GY_PUM".equals(lmsMap.getString("STU_ID")) && "A".equals(lmsMap.getString("DOC_STU"))){ %>
<span style="color:red;"><%=StringUtil.getLocaleMessage("M.사용인감신청알림",siteLocale)%>(계약체결품의 결재완료 상태일때만 표시됨)</span>
<%} %>
