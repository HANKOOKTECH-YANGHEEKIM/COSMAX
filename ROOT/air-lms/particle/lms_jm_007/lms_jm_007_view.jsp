<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	String mng_pati_uid         = request.getParameter("AIR_PARTICLE");
	String doc_mas_mode_code	= request.getParameter("doc_mas_mode_code");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String sol_mas_uid			= request.getParameter("sol_mas_uid");
	String new_doc_mas_uid		= request.getParameter("new_doc_mas_uid");
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	
	String lms_pati_jm_007_uid 	= jsonMap.getString("LMS_PATI_JM_007_UID");
	
	// 유형코드
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(resultMap.getResult("JM_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //자문유형
	
	//회사코드
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "");
	
	//언어선택
	String EONEO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("EONEO_LIST"), "CODE,LANG_CODE", "");
	//보안등급
	String LMS_BOANSTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMS_BOAN"), "CODE,LANG_CODE", "");
	
%>

<script type="text/javascript">
    var frm = document.form1;
</script>

<input type="hidden" name="lms_pati_jm_007_uid" value="<%=lms_pati_jm_007_uid%>">

<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.법률자문검토결과",siteLocale)%></caption>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
		<td class="td2" colspan="3" >
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_JAMUN_TIT")) %>
		</td>
	</tr>
	<tr>			
 		<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4">
			<%=jsonMap.getString("LMS_PATI_HOESA_NAM")%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_YUHYEONG01_NAM")) %> / 
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_YUHYEONG02_NAM")) %>
		</td>
	</tr>
	<tr>
		<th class="th4"><span><%=StringUtil.getLocaleWord("L.품목",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<%=StringUtil.convertForView(jsonMap.get("LMS_PATI_ITEM"))%>
		</td>
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
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td2" colspan="3">
			<table class="basic">
		    <%
			String[] REL_SOL = jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS");
			if(REL_SOL != null && REL_SOL.length > 0){
		 	%>
    	    <tr>
		        <th width="12%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
		        <th width="13%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
		        <th width="75%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
		    </tr>
   		   	<%
				for(int i=0; i< REL_SOL.length; i++){
					String funNm = ""+StringUtil.capitalize(jsonMap.getArrStr("LMS_PATI_REL_GUBUN")[i])+"";
			%>
			<tr onclick="airLms.goGwanRyeonPopup('<%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN")[i]%>','<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i] %>')" style="cursor:pointer;">
		        <td align="center"><%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN_NAME")[i]%></td>
		        <td align="center"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE_NO")[i]%></td>
		        <td align="left"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE")[i]%></td>
		    </tr>
			<%
				}
			}
			%>
            </table>
		</td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.검토결과",siteLocale)%></th>
		<td class="td2"  colspan="3"><%=jsonMap.getString("LMS_PATI_RVW_RSL")%></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %></th>
		<td class="td4"  colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/JM/GONGMUN" name="typeCode" />
			</jsp:include>
		</td>	
	</tr>
</table>
<p>
