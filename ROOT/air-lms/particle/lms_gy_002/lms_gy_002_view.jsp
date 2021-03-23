<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="java.util.Map"%>
<%
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();
	
	String mng_pati_uid         = StringUtil.convertNull(request.getParameter("AIR_PARTICLE"));
	String doc_mas_mode_code = StringUtil.convertNull(request.getParameter("doc_mas_mode_code"));
	String doc_mas_uid			= StringUtil.convertNull(request.getParameter("doc_mas_uid"));
	String new_doc_mas_uid = StringUtil.convertNull(request.getParameter("new_doc_mas_uid"));
	String def_doc_main_uid = StringUtil.convertNull(request.getParameter("def_doc_main_uid"));
	String sol_mas_uid	 = StringUtil.convertNull(request.getParameter("sol_mas_uid"));
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults sQlResult = resultMap.getResult("MAS_DATA");

	String yocheong_id = "";
	String damdang_id = "";
	String baedang_id = "";
	
	if(sQlResult != null && sQlResult.getRowCount() > 0){ 
		yocheong_id = sQlResult.getString(0,"YOCHEONG_ID");
		damdang_id = sQlResult.getString(0,"DAMDANG_ID");
		baedang_id = sQlResult.getString(0,"BAEDANG_ID");
	}
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	String lms_pati_gy_002_uid = jsonMap.getString("LMS_PATI_GY_002_UID");  
	
    /*
     * 작성/수정 권한
     * 체결계약서는 의뢰자가 작성/수정할 수 있다.
     */
    boolean writeableFlag = false;
    //if( loginUser.isUserAuth(LmsConstants.USER_AUTH_ISJ) && (loginUser.getLoginId().equals(yocheong_id) || loginUser.getLoginId().equals(teamjang_id)) ){
    if(loginUser.getLoginId().equals(yocheong_id) 
    		|| loginUser.getLoginId().equals(damdang_id)
    		|| loginUser.getLoginId().equals(baedang_id)
    		){	
    	writeableFlag = true;
    }
    //-- 의뢰자에게 강제 수정 기능은 제거한다. COSMAX
    writeableFlag = false;
%>
<input type="hidden" name="lms_pati_gy_002_uid" value="<%=lms_pati_gy_002_uid%>">

<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.체결계약서",siteLocale)%></caption>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.체결일자",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_CHEGYEOL_DTE"))%>			
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약기간",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_GYEYAG_ST_DTE"))%> ~ 
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_GYEYAG_ED_DTE"))%>	
        </td>
	</tr> 
	<tr>
    	<th class="th4"><%=StringUtil.getLocaleWord("L.계약_갱신일",siteLocale)%></th>
        <td class="td4">
            <%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_GYEYAG_GS_DTE"))%><%--  <%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_ALARM_TERM"))%> <%=StringUtil.getLocaleWord("L.일전알람",siteLocale)%> --%>
        </td>    
        <th class="th4"><%=StringUtil.getLocaleWord("L.알람",siteLocale)%></th>
        <td class="td4"><%= HtmlUtil.getInputCalendar(request, false, "lms_pati_allam_dte", "lms_pati_allam_dte", jsonMap.getString("LMS_PATI_ALLAM_DTE"), "") %></td>
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
		<th class="th2"><%=StringUtil.getLocaleWord("L.내용",siteLocale)%></th>
		<td class="td2" colspan="3">
			<div class="reset-this">
				<%=jsonMap.getString("LMS_PATI_CHEGYEOL_NAEYONG")%>
			</div>
		</td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.체결계약서",siteLocale) %> </th>
		<td class="td2" colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_SIGN" name="typeCode" />
			</jsp:include>
		</td>
	</tr>	
	<%-- 	<tr>
        <th class="th4"><%=StringUtil.getLocaleWord("L.수신부서",siteLocale)%></th>
        <td class="td4">
            <%=StringUtil.convertForView(lms_pati_susinbuseo_nam)%>
        </td>
        <th class="th4"><%=StringUtil.getLocaleWord("L.수신자",siteLocale)%></th>
        <td class="td4">
            <%=StringUtil.convertForView(lms_pati_susinja_nam)%>
        </td>
    </tr> --%>
</table>
<p>
<script>
//문서가 로딩 되면 잠시후에 리사이즈 함수 타도록 하기(아코디언일 경우 대비)SSJ
$(document).ready(function () {
setTimeout(
		function() {
			if(typeof tep_parentFrameResize != "undefined"){
				tep_parentFrameResize();
			}
		}
	);
});
</script>

<%
   //if(writeableFlag && !"view".equals(view_type)){
   if(writeableFlag){
       if(StringUtil.isNotBlank(doc_mas_uid)){
%>
<div class="buttonlist">
    <script>
    function goMasModify(defDocMainUid, docMasUid) {
    	
    	airCommon.openDocUpdate(docMasUid,'<%=sol_mas_uid%>')
    	
//         var url = "/ServletController?AIR_ACTION=SYS_DOC_MAS&AIR_MODE=UPDATE_FORM_NOREV_EDIT&def_doc_main_uid="+defDocMainUid+"&doc_mas_uid="+docMasUid;
//         airCommon.openWindow(url, "1024", "600", "POPUP_WRITE_FORM", "yes", "yes", "");
    }
    </script>
    <!--  
    <span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goMasModify('E1D3B96398DA1A58DA24DB7CD330026E', '27738163F0883FFF9A7705281C08B14E');">수정</a></span>
    -->
    <span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goMasModify('<%=def_doc_main_uid%>', '<%=doc_mas_uid%>');">수정</a></span>
</div>
<%
		}
	}
%>