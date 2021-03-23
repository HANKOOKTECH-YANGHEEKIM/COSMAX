<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@page import="java.util.Map"%>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	String mng_pati_uid         = request.getParameter("AIR_PARTICLE");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String new_doc_mas_uid		= request.getParameter("new_doc_mas_uid");
	String sol_mas_uid			= request.getParameter("sol_mas_uid");

	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);


	
	
	String PAPER_YH_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("PAPER_YH_CODE_LIST"), "CODE_ID,LANG_CODE", ""));
	String IJ_RECEIVE_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("IJ_RECEIVE_CODE"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)));

%>
<!-- 파일첨부보여주기 -->
<!-- ips_cw_004_view.jsp 참조 -->
	
	
<!-- Code Start -->

<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.법인인감날인신청",siteLocale) %></caption>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.서류제목",siteLocale)%></th>
		<td>
			<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_INJANG_TIT"))%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.서류유형",siteLocale)%></th>
		<td class="td4">
			<%if(jsonMap.getString("LMS_PATI_SEORYU_TYPE_COD").indexOf("IJ_SEORYU_01") > -1){ %>
				<div>계약서 : <a href="javascript:void(0);" style="color:darkblue;text-decoration: underline;" onclick="openOrgNo('LMS_GY_LIST_MAS','POPUP_INDEX','&sol_mas_uid=<%=jsonMap.getString("LMS_PATI_ORG_GY_UID") %>&view_type=view')">
					[<%=jsonMap.getString("LMS_PATI_ORG_GY_NO") %>] <%=jsonMap.getString("LMS_PATI_ORG_GY_TITLE") %>
					</a></div>
			<%} %>
			<%if(jsonMap.getString("LMS_PATI_SEORYU_TYPE_COD").indexOf("IJ_SEORYU_02") > -1){ %>
				<div>공문 </div>
			<%} %>
			<%if(jsonMap.getString("LMS_PATI_SEORYU_TYPE_COD").indexOf("IJ_SEORYU_03") > -1){ %>
				<div>위임장 </div>
			<%} %>
			<%if(jsonMap.getString("LMS_PATI_SEORYU_TYPE_COD").indexOf("IJ_SEORYU_04") > -1){ %>
				<div>사용인감계 </div>
			<%} %>
			<%if(jsonMap.getString("LMS_PATI_SEORYU_TYPE_COD").indexOf("IJ_SEORYU_09") > -1){ %>
				<div>기타 : <%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_SEORYU_TYPE_NAM"))%></div>
			<%} %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td colspan="3">
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_HOESA_NAM"))%>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰부서",siteLocale)%></th>
		<td class="td4"><%=jsonMap.getStringView("LMS_PATI_YOCHEONG_DPT_NAM_"+siteLocale) %></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
		<td class="td4">
			<%=jsonMap.getStringView("LMS_PATI_YOCHEONG_NAM_"+siteLocale) %> <%-- <%=jsonMap.getStringView("LMS_PATI_YOCHEONG_POS_NAM_"+siteLocale) %> <div class="telephone">[<%=StringUtil.getLocaleWord("L.사내",siteLocale)%> : <%=lms_pati_yocheong_telephone %>]</div> --%>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.제출처",siteLocale)%></th>
		<td colspan="3">
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_JECHULCHEO"))%>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td4" colspan="3">
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
		<th class="th4"><%=StringUtil.getLocaleWord("L.날인수",siteLocale)%></th>
		<td colspan="3">
			<%=StringUtil.convertForView(jsonMap.getString("LMS_PATI_NALINSU"))%>
		</td>
	</tr>
	
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.서류수령방법",siteLocale)%></th>
		<td colspan="3" class="td2">
			<%=StringUtil.getCodestrValue(request,jsonMap.getString("LMS_PATI_SEORYU_REC_COD"), IJ_RECEIVE_CODESTR) %>
			<%if(StringUtil.isNotBlank(jsonMap.getString("LMS_PATI_REC_COM_NAME"))){ %>
				<br/><%=jsonMap.getStringView("LMS_PATI_REC_COM_NAME") %>
			<%} %>
			<%if(StringUtil.isNotBlank(jsonMap.getString("LMS_PATI_REC_ADDR"))){ %>
				<br/><%=jsonMap.getStringView("LMS_PATI_REC_ADDR") %>
			<%} %>
			
		</td>
	</tr>		
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.목적", siteLocale) %></th>
		<td class="td2" colspan="3">
				<%=jsonMap.getStringView("LMS_PATI_CONTENTS") %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.날인대상서류",siteLocale) %> </th>
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/IJ/NALIN" name="typeCode" />
			</jsp:include>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %> </th>
		<td class="td4" >
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=doc_mas_uid%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/IJ/REQ" name="typeCode" />
			</jsp:include>
		</td>	
	</tr>
</table>
<p></p>
<script type="text/javascript">
/**
 * 원계약번호 오픈창
 */
function openOrgNo(actionCode, modeCode, etcQStr){
	var url = "/ServletController?AIR_ACTION="+actionCode+"&AIR_MODE="+modeCode+etcQStr;
	
	airCommon.openWindow(url, "1024", "700", "pop_org_no", "yes", "yes", "");
}
$(document).ready(function () {
	<%-- 
    $.ajax({
        url:'/ServletController?<%=CommonConstants.ACTION_CODE%>=LMS_IJ_TEP&<%=CommonConstants.MODE_CODE%>=GRGY_JSON_LIST',
        type : 'POST',
        async : true,
        cache : false,
        data : {'PARTICLE':'IJ','DOC_MAS_UID':'<%=doc_mas_uid%>'},
        dataType : 'json',
        error : function(data){
            // NONE
            //alert("error");
        },
        success : function(data){
            var rows = data.rows;
            
            // 기존 데이터 삭제
            $("#gwanryon_geyagseo_list tr").remove();

            if(rows.length > 0){
                // 신규 데이터 추가
                var tgTbl = $("#gwanryon_geyagseo_list");
                
                $("#addRelGYHeaderTmplGy001").tmpl().appendTo(tgTbl);
                $("#addRelGYTmplGy001").tmpl(rows).appendTo(tgTbl);
            }else{
            	$("#gwanryon_geyagseo_list").remove();
            }
        } 
    }); --%>
});


function goGwanRyeonPopup(actionCode, modeCode, etcQStr) {	
	
	var url = "/ServletController";
	url += "?AIR_ACTION="+ actionCode;
	url += "&AIR_MODE="+ modeCode;
	
	if (etcQStr != undefined) url += etcQStr;
	airCommon.openWindow(url, "1024", "500", "POPUP_GWANRYEON_VIEW", "yes", "yes", "");		
}

</script>