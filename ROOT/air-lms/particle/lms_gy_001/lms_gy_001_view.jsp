<%@page import="java.util.Map"%>
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
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
	String doc_mas_mode_code	= StringUtil.convertNull(request.getParameter("doc_mas_mode_code"));
	String doc_mas_uid			= StringUtil.convertNull(request.getParameter("doc_mas_uid"));
	String new_doc_mas_uid		= StringUtil.convertNull(request.getParameter("new_doc_mas_uid")); 
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();

	String lms_pati_gy_001_uid = jsonMap.getString("LMS_PATI_GY_001_UID");
	String if_damdang_empno = jsonMap.getString("IF_DAMDANG_EMPNO");
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	String gwanri_no = "";
	SQLResults masData = resultMap.getResult("MAS_INFO");
	if(masData != null && masData.getRowCount() > 0){
		gwanri_no = masData.getString(0,"GWANRI_NO");
	} 
		
	//String lms_pati_gy_001_uid = "";
	
	//계약유형
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GY_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //계약유형
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "");
	String GYEYAG_TONGHWA_COD_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("TONGHWA_CODE_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)));
	String INS_TYPE_STR = "new|" + StringUtil.getLocaleWord("L.신규2",siteLocale) + "^edit|" + StringUtil.getLocaleWord("L.수정2",siteLocale) + "^update|" + StringUtil.getLocaleWord("L.갱신2",siteLocale);
	//언어선택
	String EONEO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("PCODEID_GY_EONEO_LIST"), "CODE,LANG_CODE", ""); 
	String PYOJUNGYEYAGSEO_YN = "Y|" + StringUtil.getLocaleWord("L.사용",siteLocale) + "^N|" + StringUtil.getLocaleWord("L.미사용",siteLocale);
	//보안등급
	String LMS_BOANSTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMS_BOAN"), "CODE,LANG_CODE", "");
		
%>
<input type="hidden" name="lms_pati_gy_001_uid" id="lms_pati_gy_001_uid" value="<%=lms_pati_gy_001_uid%>" />
<input type="hidden" name="if_damdang_empno" id="if_damdang_empno" value="<%=if_damdang_empno%>" />
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.계약검토의뢰",siteLocale)%></caption>
	<tr>
	    <th class="th2"><%=StringUtil.getLocaleWord("L.계약명",siteLocale)%></th>
		<td class="td2" colspan ="3">
		    <%=StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_TIT"))%>
		<%--	<div class="telephone"><%if(!"".equals(gwanri_no)){%>[<%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%> : <%=gwanri_no %>]<%}%></div> --%>
        </td>
    </tr>
	<tr>			
 		<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4">
			<%=jsonMap.getString("LMS_PATI_HOESA_NAM").replace("C.", "") %>
		</td>
		 <th class="th4"><%=StringUtil.getLocaleWord("L.표준계약서_사용여부",siteLocale)%></th>
		<td class="td4"><%=HtmlUtil.getInputRadio(request, false, "lms_pati_pyojun_gyeyagseo_yn", PYOJUNGYEYAGSEO_YN, jsonMap.getString("LMS_PATI_PYOJUN_GYEYAGSEO_YN"), "", "") %></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰부서",siteLocale)%></th>
		<td class="td4"><%=jsonMap.getStringView("LMS_PATI_YOCHEONG_DPT_NAM") %></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
		<td class="td4">
			<%=jsonMap.getStringView("LMS_PATI_YOCHEONG_NAM_"+siteLocale) %> <%-- <%=jsonMap.getStringView("LMS_PATI_YOCHEONG_POS_NAM_"+siteLocale) %> <div class="telephone">[<%=StringUtil.getLocaleWord("L.사내",siteLocale)%> : <%=lms_pati_yocheong_telephone %>]</div> --%>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회신기한일",siteLocale)%></th>
		<td class="td4" ><%=HtmlUtil.getInputCalendar(request, false, "lms_pati_hoesin_gihan_dte", "lms_pati_hoesin_gihan_dte", jsonMap.getString("LMS_PATI_HOESIN_GIHAN_DTE"), "")%></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약기간",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_ST_DTE"))%>
			<%=("".equals(StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_ST_DTE"))) && "".equals(StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_ST_DTE")))) ? "" : "~"%>
			<%=StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_ED_DTE"))%>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th> 
		<td class="td4"><%=StringUtil.getCodestrValue(request,jsonMap.getString("LMS_PATI_YUHYEONG"), sYuhyeong_list)%></td> 
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약금액",siteLocale)%></th>		
		<td class="td4" style="text-align:left;">
			<%=(!"".equals(StringUtil.getFormatCurrency(jsonMap.get("LMS_PATI_GYEYAG_COST"),-1))) ? StringUtil.getCodestrValue(request,jsonMap.getString("LMS_PATI_TONGHWA_COD"),GYEYAG_TONGHWA_COD_CODESTR) : "" %>
			<%=StringUtil.getFormatCurrency(jsonMap.getString("LMS_PATI_GYEYAG_COST"),-1) %>
		</td>
	</tr>
	<%-- 
	<tr>
	    <th class="th4"><%=StringUtil.getLocaleWord("L.보안등급",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=StringUtil.getCodestrValue(request,jsonMap.getString("LMS_PATI_BOAN_DUNGGUB"),LMS_BOANSTR )%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.언어",siteLocale)%></th>
		<td class="td4">
			<input type="hidden" name="lms_pati_eoneo_nam" id="lms_pati_eoneo_nam" />
			<%=StringUtil.getCodestrValue(request,jsonMap.getString("LMS_PATI_EONEO_COD"), EONEO_CODESTR)%>
		</td>
	</tr>
	 --%>
    <tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_SANGDAEBANG_NAM"))%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.상대방",siteLocale)%> <%=StringUtil.getLocaleWord("L.상세",siteLocale)%></th>
		<td class="td4">
			<%=StringUtil.convertForView(jsonMap.get("LMS_PATI_GYEYAG_SANGDAEBANG_DETAIL"))%>
		</td>
	</tr>
	<tr>
	    <th class="th2"><%=StringUtil.getLocaleWord("L.사전협의자",siteLocale)%></th>
		<td class="td2" colspan ="3">
			<%="Y".equals(jsonMap.getString("LMS_PATI_PRIOR_YN"))? jsonMap.getString("LMS_PATI_PRIOR_CONS") : jsonMap.getString("LMS_PATI_PRIOR_YN") %>
        </td>
    </tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.신규_수정_갱신",siteLocale)%></th>
		<td class="td2" colspan="3">
			<div id="div_ins_type" style="float:left;width:80px;">
				<%=StringUtil.getCodestrValue(request,jsonMap.getString("LMS_PATI_RDO_INS_TYPE"), INS_TYPE_STR) %> 
			</div> 
			<div id="div_ins_type_add" style="float:left;display:<%if("".equals(jsonMap.getString("LMS_PATI_RDO_INS_TYPE")) || "new".equals(jsonMap.getString("LMS_PATI_RDO_INS_TYPE"))){%>none<%}%>;">
				<b>원계약<%-- <%=StringUtil.getLocaleWord("L.원_계약",siteLocale)%> --%></b> :
				<a href="javascript:void(0);" onclick="openOrgNo('LMS_GY_LIST_MAS','POPUP_INDEX','&sol_mas_uid=<%=jsonMap.getString("LMS_PATI_ORG_GY_UID") %>&view_type=view')"><%=jsonMap.getString("LMS_PATI_ORG_GY_NO") %></a> 
			</div>
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
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td4" colspan="3">
			<table class="list">
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
		<th class="th2"><%=StringUtil.getLocaleWord("L.계약배경_및_의뢰내용",siteLocale)%></th>
		<td class="td2" colspan="3">
			<div class="reset-this">
				<%=jsonMap.getString("LMS_PATI_GEOMTOYOCHEONG")%>
<%-- 				<%=StringUtil.convertForView(jsonMap.get("LMS_PATI_GEOMTOYOCHEONG")) %> --%>
			</div>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.검토대상계약서",siteLocale) %> </th>
		<td class="td4">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_RVW" name="typeCode" />
			</jsp:include>
		</td> 
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련자료",siteLocale) %> </th>
		<td class="td4">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_REF" name="typeCode" />
			</jsp:include>
		</td>
	</tr> 
	
	
</table>
<script type="text/javascript">
/**
 * 원계약번호 오픈창
 */
function openOrgNo(actionCode, modeCode, etcQStr){
	var url = "/ServletController?AIR_ACTION="+actionCode+"&AIR_MODE="+modeCode+etcQStr;
	
	airCommon.openWindow(url, "1024", "700", "pop_org_no", "yes", "yes", "");
}

/**
 * 관련 계약/자문/소송 오픈창
 */
function goGwanRyeonPopup(actionCode, modeCode, etcQStr) {	
	
	var url = "/ServletController";
	url += "?AIR_ACTION="+ actionCode;
	url += "&AIR_MODE="+ modeCode;
	
	if (etcQStr != undefined) url += etcQStr;
	airCommon.openWindow(url, "1024", "500", "POPUP_GWANRYEON_VIEW", "yes", "yes", "");		
}
</script>
