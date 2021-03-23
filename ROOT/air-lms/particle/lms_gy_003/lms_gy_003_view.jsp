<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
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

	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	/* Code Start	
	String sampleField      = "";	
	*/
	//String lms_pati_gy_003_uid = jsonMap.getString("lms_pati_gy_008_uid");
	String lms_pati_gy_003_uid 	= jsonMap.getString("LMS_PATI_GY_003_UID");
%>
<!-- 파일첨부보여주기 -->
<!-- ips_cw_004_view.jsp 참조 -->
	
	
<!-- Code Start -->
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.담당자지정",siteLocale)%></caption>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.검토담당자",siteLocale)%></th>
		<%-- <td class="td2"><b><span style="font-size:11pt;"><%=jsonMap.getString("LMS_PATI_DAMDANG_NAM_"+siteLocale)%></span></b></td> --%>
		<td class="td2" colspan="3"><b><%=jsonMap.getDefStr("LMS_PATI_DAMDANG_VIEW", jsonMap.getString("LMS_PATI_DAMDANG_NAME_KO"))%></b></td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.참조부서_열람가능",siteLocale)%></th>
		<td class="td4">
			<table style="width:100%;">
			<%
				String[] arrCjbu = StringUtil.split(jsonMap.getString("LMS_PATI_CHAMJOBUSEO_NAM_"+siteLocale),'\n');
			if(arrCjbu != null && arrCjbu.length > 0){
				int curRows = 0;
				for(int i=0; i< arrCjbu.length; i++){
					if(curRows == 0)out.print("<tr>");
			%>
				<td><%=arrCjbu[i]%></td>
			<%
					curRows++;
					if(curRows == 3){out.print("</tr>");curRows = 0;}
				}
			}
			%>
			</table>
 		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.참조자_열람가능",siteLocale)%></th>
		<td class="td4">
			<table style="width:100%;">
			<%
				String[] arrCjja = StringUtil.split(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM"),'\n');
			if(arrCjja != null && arrCjja.length > 0){
				int curRows = 0;
				for(int i=0; i< arrCjja.length; i++){
					if(curRows == 0)out.print("<tr>");
			%>
				<td><%=arrCjja[i]%></td>
			<%
					curRows++;
					if(curRows == 3){out.print("</tr>");curRows = 0;}
				}
			}
			%>
			</table>
		</td>
	</tr>
	
	<%if(LmsUtil.isBeobmuOfiUser(loginUser)){ %>
	 <tr>
           <th class="th2">
               <%=StringUtil.getLocaleWord("L.담당자_지정_의견",siteLocale)%>
           </th>
           <td class="td2" colspan="3">
           	<%=jsonMap.getStringView("LMS_PATI_MEMO") %>
           </td>
       </tr>
	<%} %>
</table>
      
<p>
