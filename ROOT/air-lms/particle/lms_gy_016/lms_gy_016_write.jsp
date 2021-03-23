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
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid"));
	String new_doc_mas_uid		= StringUtil.convertNull(request.getParameter("new_doc_mas_uid"));
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	/* Code Start	
	String sampleField      = "";	
	*/
	String lms_pati_gy_016_uid 	= jsonMap.getString("LMS_PATI_GY_016_UID");
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
	
	String new_lms_pati_gy_016_uid   = StringUtil.getRandomUUID();
	
	
%>

<script type="text/javascript">
    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
    function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
  		
  		return true;
  	}
    function <%="Parti"+mng_pati_uid%>_dataCheck(){
		
// 		airCommon.showBackDrop();
		if(0 == $("input:radio[name='lms_pati_modi_cont_yn']:checked").length) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.법무팀_검토계약서_수정여부", siteLocale))%>");
			$("#lms_pati_modi_cont_yn0").focus();
		    return false;		 
		}
		
		
		var bool = true;
		//-- 수정여부가 Y인 경우 validation을 진행함.
		if($("input:radio[name='lms_pati_modi_cont_yn']:checked").val() == "Y"){
			
			if ("" == $("#lms_pati_modi_reason").val() ) {
				alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.수정내용및사유", siteLocale))%>");
				
				airCommon.getEditorFocus('lms_pati_modi_reason', "<%=CommonProperties.load("system.editor")%>");
				
				bool =  false;
				return false;
			}
			if(!airCommon.validateAttachFile("LMS/GY/CTR_MODI")){
				alert("<%=StringUtil.getScriptMessage("M.첨부해주세요",siteLocale, StringUtil.getScriptMessage("L.수정계약서", siteLocale))%>");
				bool = false;
				return false;
			}
			
		}
		if(!bool){
			return false;
		}
		if ("" == airCommon.getEditorValue('lms_pati_apr_opi', "<%=CommonProperties.load("system.editor")%>") ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.품의내용", siteLocale))%>");
			
			$("#lms_pati_apr_opi").focus();
			
			return false;
		}
		
		return true;
	}
	
	var modiYnClick = function(val){
		if("Y" == val){
			$("[data-meaning='modi_Y']").show();
			$("[data-meaning='modi_N']").hide();
			
		}else{
			$("[data-meaning='modi_Y']").hide();
			$("[data-meaning='modi_N']").show();
			
		}
	}
</script>
<!-- 여기서부터 코딩하세요. -->
<input type="hidden" name="lms_pati_gy_016_uid" value="<%=lms_pati_gy_016_uid%>">
<div id="div_PTC-LMS-GY-016">
	<table class="basic">
		<caption>
			<span class="left">
			<%=StringUtil.getLocaleWord("L.계약체결품의",siteLocale)%>
			</span>
		</caption>
		<tr>
			<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.법무팀_검토계약서_수정여부",siteLocale)%></th>
			<td class="td2">
				<span class="right" data-meaning="modi_Y" style="color:red;display: <%if("N".equals(jsonMap.getDefStr("LMS_PATI_MODI_CONT_YN", "N")))out.print("none;");%>;">
			    <%=StringUtil.getLocaleMessage("M.수정계약_알림", siteLocale) %><br />
				</span>
				<span class="right" data-meaning="modi_N" style="color:red;display: <%if("Y".equals(jsonMap.getDefStr("LMS_PATI_MODI_CONT_YN", "N")))out.print("none;");%>;">
			    <%=StringUtil.getLocaleMessage("M.수정계약_알림2", siteLocale) %><br />
				</span>
				<%=HtmlUtil.getInputRadio(request, true, "lms_pati_modi_cont_yn", "Y|Yes^N|No", jsonMap.getDefStr("LMS_PATI_MODI_CONT_YN", "N"), "onClick=\"modiYnClick(this.value)\"", "") %>
			</td>
		</tr>
		<tr data-meaning="modi_Y" style="display: <%if(!"Y".equals(jsonMap.getDefStr("LMS_PATI_MODI_CONT_YN", "N"))){%>none;<%}%>;">
			<th class="th2"><span class="ui_icon required" data-meaning="modi_Y"></span><%=StringUtil.getLocaleWord("L.수정내용및사유",siteLocale)%></th>
			<td class="td2">
				<textarea class="text width_max" rows="5" name="lms_pati_modi_reason" id="lms_pati_modi_reason" maxlength="4000"><%=jsonMap.getStringEditor("LMS_PATI_MODI_REASON") %></textarea>
<%-- 				<textarea class="text width_max" rows="5" name="lms_pati_modi_reason" id="lms_pati_modi_reason" maxlength="4000"><%=jsonMap.getStringEditor("LMS_PATI_MODI_REASON") %></textarea> --%>
			</td>
		</tr>
		<tr>
			<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.품의내용",siteLocale)%></th>
			<td class="td2">
				<%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_apr_opi", "lms_pati_apr_opi", StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_APR_OPI")), "")%>
			</td>
		</tr>
		<tr  data-meaning="modi_Y" style="display: <%if(!"Y".equals(jsonMap.getDefStr("LMS_PATI_MODI_CONT_YN", "N"))){%>none;<%}%>;">
			<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.수정계약서",siteLocale)%></th>
			<td class="td2">
				<jsp:include page="/ServletController" flush="true">
					<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
					<jsp:param value="FILE_WRITE" name="AIR_MODE" />
					<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
					<jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="LMS/GY/CTR_MODI" name="typeCode" />
					<jsp:param value="Y" name="requiredYn" />
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" /> 
					<jsp:param value="Y" name="pdfConvYn" />
				</jsp:include>
<%-- 					<jsp:param value="pdf;jpg;gif;bmp;png;psd;pdd;tif;" name="fileRFilter" /> --%>
				<span style="color:red;">
				※첨부 문서가 아래아 한글이면 2가지를 확인해 주시기 바랍니다.<br/>
				&nbsp;&nbsp;아래아 한글 상단 메뉴중<br/>
				&nbsp;&nbsp;&nbsp;(1) '검토' 탭의 '변경 내용 추적'아이콘 상단을 클릭하여 해당 기능 제거,<br/>
				&nbsp;&nbsp;&nbsp;(2) '파일' → '인쇄방식' → '기본 인쇄'로 설정 후 , 다른 이름으로 저장후 첨부
				</span>
			</td>
		</tr>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.관련자료",siteLocale)%></th>
			<td class="td2">
				<jsp:include page="/ServletController" flush="true">
					<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
					<jsp:param value="FILE_WRITE" name="AIR_MODE" />
					<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
					<jsp:param value="CMM" name="systemTypeCode" />
					<jsp:param value="CMM/CMM" name="typeCode" />
					<jsp:param value="N" name="requiredYn" />
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" /> 
				</jsp:include>
			</td>
		</tr>
	</table>

</div>