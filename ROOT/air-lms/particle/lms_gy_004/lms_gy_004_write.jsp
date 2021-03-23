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
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid")); 
	String munseo_seosig_no		= StringUtil.convertNull(request.getParameter("munseo_seosig_no")); 
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	 
	/* Code Start	
	String sampleField      = "";	
	*/
	String lms_pati_gy_004_uid 	= jsonMap.getString("LMS_PATI_GY_004_UID");
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
	
	if("".equals(lms_pati_gy_004_uid)){
		lms_pati_gy_004_uid = StringUtil.getRandomUUID();
	}
	
	String new_lms_pati_gy_004_uid   = StringUtil.getRandomUUID();
	 
	// 갱신일 경우 UID 생성
    if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
            "UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
    	lms_pati_gy_004_uid = new_lms_pati_gy_004_uid;
    }
	
	String caption = StringUtil.getLocaleWord("L.계약재검토요청", siteLocale);
	String title = StringUtil.getLocaleWord("L.내용", siteLocale);
	
	if("DDD-LMS-GY-012".equals(munseo_seosig_no) || "DDD-LMS-GY-019".equals(munseo_seosig_no)){
		caption = StringUtil.getLocaleWord("L.계약체결중단", siteLocale);
		title = StringUtil.getLocaleWord("L.체결중단사유", siteLocale);
	}else if("DDD-LMS-JM-017".equals(munseo_seosig_no)){
		caption = StringUtil.getLocaleWord("L.추가검토_요청", siteLocale);
		
	}
%>

<script type="text/javascript">
    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
	function <%="Parti"+mng_pati_uid%>_dataCheck(){
		
		return true;
	}
	
	function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
		
		return true;
	}
</script>
<input type="hidden" name="lms_pati_gy_004_uid" value="<%=lms_pati_gy_004_uid%>">
<table class="basic">
	<caption><%=caption%></caption>
	<tr>
		<th class="th2"><%=title%></th>
		<td class="td2">
			<%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_content", "lms_pati_content", StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_CONTENT")), "")%>
		</td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.첨부",siteLocale)%></th>
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
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.참조자_열람가능",siteLocale)%></th>
        <td class="td2" >
           <script type="text/javascript"> 
            function searchChamjoja() {
            	var defaultUser = $("#lms_pati_chamjoja_cod").val();
				var param ={};
            	
            	param["groupTypeCodes"]= "IG";
            	param["defaultUser"]= defaultUser;
            	param["userType"]= "chamjo";
            	
            	airCommon.popupUserSelect("changeChamjoja", param);
            }
            
            function changeChamjoja(data) {
            	
            	var jsonData = JSON.parse(data);
            	var init_code = "";
            	var init_name = "";
            	var init_name_ko = "";
            	var init_name_en = "";
            	
            	for(var i = 0; i< jsonData.length; i++){
            		if(i > 0){
            			init_code += ",";
            			init_name += "\n";
            			init_name_ko += "\n";
            			init_name_en += "\n";
            		}
            		init_code += jsonData[i].LOGIN_ID;
           			init_name += jsonData[i].GROUP_NAME_KO+"/"+jsonData[i].NAME_KO;
           			init_name_ko += jsonData[i].GROUP_NAME_KO +"/"+jsonData[i].NAME_KO;
           			init_name_en += jsonData[i].GROUP_NAME_EN +"/"+jsonData[i].NAME_EN; 
            	}
            	initChamjoja(true, init_code, init_name, init_name_ko, init_name_en);
            	
            }
            
            function initChamjoja(isForceInit, code, name, name_ko, name_en) {
            	code = (code == undefined ? "" : code);
            	name = (name == undefined ? "" : name);
            	name_ko = (name_ko == undefined ? "" : name_ko);
            	name_en = (name_en == undefined ? "" : name_en);
            	
            	if (!isForceInit && !confirm("<%=StringUtil.getScriptMessage("M.참조자정보를초기화하시겠습니까",siteLocale)%>")) {
            		return false;
            	}
            		
            	document.getElementById("lms_pati_chamjoja_cod").value = code;
            	document.getElementById("lms_pati_chamjoja_nam").value = name;
            	document.getElementById("lms_pati_chamjoja_nam_ko").value = name_ko;
            	document.getElementById("lms_pati_chamjoja_nam_en").value = name_en;
            	 
            	$("#lms_pati_chamjoja_nam").val().replace("\n", '<br>');
            	$("#lms_pati_chamjoja_nam_ko").val().replace("\n", '<br>');
            	$("#lms_pati_chamjoja_nam_en").val().replace("\n", '<br>');
            }                        
            </script>
            <input type="hidden" id="lms_pati_chamjoja_cod" name="lms_pati_chamjoja_cod" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOJA_COD","")) %>">
            <input type="hidden" id="lms_pati_chamjoja_nam_ko" name="lms_pati_chamjoja_nam_ko" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM_KO")) %>">
            <input type="hidden" id="lms_pati_chamjoja_nam_en" name="lms_pati_chamjoja_nam_en" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM_EN")) %>">
            <span style="float:left;"> 
			    <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="initChamjoja(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
			    <span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjoja()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
             </span>	
            <textarea name="lms_pati_chamjoja_nam" id="lms_pati_chamjoja_nam" readonly="readonly"  class="width_max"  rows="5"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOJA_NAM","")) %></textarea>
        </td>
    </tr>  
</table>
