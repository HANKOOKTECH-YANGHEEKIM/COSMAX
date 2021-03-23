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
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	 
	/* Code Start	
	String sampleField      = "";	
	*/
	String lms_pati_gy_002_uid 	= jsonMap.getString("LMS_PATI_GY_002_UID");
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
	
	if("".equals(lms_pati_gy_002_uid)){
		lms_pati_gy_002_uid = StringUtil.getRandomUUID();
	}
	
	String new_lms_pati_gy_002_uid   = StringUtil.getRandomUUID();
	 
	// 갱신일 경우 UID 생성
    if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
            "UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
    	lms_pati_gy_002_uid = new_lms_pati_gy_002_uid;
    }
%>

<script type="text/javascript">
    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
    var ctr_sign_file_cnt = 0; //체결 계약서 첨부파일 수
    
	function <%="Parti"+mng_pati_uid%>_dataCheck(){
		var stday = $('#lms_pati_gyeyag_st_dte').val();  // 계약시작일자
		var edday = $('#lms_pati_gyeyag_ed_dte').val();  // 계약종료일자
		
		if($('#lms_pati_chegyeol_dte').val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.체결일자", siteLocale))%>");
			frm.lms_pati_chegyeol_dte.focus();
			return false;
		}
		
		if(!airCommon.validateAttachFile("LMS/GY/CTR_SIGN")){
			alert("<%=StringUtil.getScriptMessage("M.첨부해주세요",siteLocale, StringUtil.getLocaleWord("L.체결계약서", siteLocale))%>");
			return false;
		}
		<%-- 
		if($('#lms_pati_gyeyag_st_dte').val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.계약기간_시작일", siteLocale))%>");
			frm.lms_pati_gyeyag_st_dte.focus();
			return false;
		}
		if($('#lms_pati_gyeyag_ed_dte').val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.계약기간_종료일", siteLocale))%>");
			frm.lms_pati_gyeyag_ed_dte.focus();
			return false;
		} 
		 --%>	
		
		if ("" !=stday && "" != edday ){
		    if (stday > edday) {
			    alert ("<%=StringUtil.getScriptMessage("M.ALERT_WRONG",siteLocale,StringUtil.getLocaleWord("L.계약기간", siteLocale))%>");
			    frm.lms_pati_gyeyag_ed_dte.focus();
		        return false;	
		    }
		}
		
		if(!airCommon.validateAttachFile("LMS/GY/CTR_SIGN")){
			alert("<%=StringUtil.getScriptMessage("M.첨부해주세요",siteLocale, StringUtil.getLocaleWord("L.체결계약서", siteLocale))%>");
			return false;
		}
<%--
 		if($('#lms_pati_gyeyag_st_dte').val() == ""){
			alert("<%=StringUtil.getLocaleWord("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약기간_시작일", siteLocale))%>");
			frm.lms_pati_gyeyag_st_dte.focus();
			return false;
		}
		
		if($('#lms_pati_gyeyag_ed_dte').val() == ""){
			alert("<%=StringUtil.getLocaleWord("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약기간_종료일", siteLocale))%>");
			frm.lms_pati_gyeyag_ed_dte.focus();
			return false;
		} 
--%>
		return true;
	}
	
	function setDateResult(val){
		alert(val);
	}
// 	var date1 = document.getElementById("lms_pati_gyeyag_ed_dte");
// 	var startDate = 
// 	$(function(){
// 		airCommon.setCalendarAddMonth(document.form1.targetDte,"lms_pati_allam_dte", 3);
// 	});
</script>

<%-- <input type="hidden" name="targetDte" value="<%=lms_pati_gyeyag_ed_dte%>"> --%>
<input type="hidden" name="lms_pati_gy_002_uid" value="<%=lms_pati_gy_002_uid%>">
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.체결계약서",siteLocale)%></caption>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.계약체결일자",siteLocale)%></span></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_chegyeol_dte", "lms_pati_chegyeol_dte", jsonMap.getString("LMS_PATI_CHEGYEOL_DTE"), "") %>
		</td>
		<th class="th4"><!-- <span class="ui_icon required"></span> --><%=StringUtil.getLocaleWord("L.계약기간",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_st_dte", "lms_pati_gyeyag_st_dte", jsonMap.getString("LMS_PATI_GYEYAG_ST_DTE"), "") %> ~
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_ed_dte", "lms_pati_gyeyag_ed_dte", jsonMap.getString("LMS_PATI_GYEYAG_ED_DTE"), "") %>
		</td>
	</tr>
	<tr>
        <th class="th4"><%=StringUtil.getLocaleWord("L.계약_갱신일",siteLocale)%></th>
        <td class="td4">
        	<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_gs_dte", "lms_pati_gyeyag_gs_dte", jsonMap.getString("LMS_PATI_GYEYAG_GS_DTE"), "") %>
        </td>
        <th class="th4"><%=StringUtil.getLocaleWord("L.알람",siteLocale)%></th>
        <td class="td4">
        	<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_allam_dte", "lms_pati_allam_dte", jsonMap.getString("LMS_PATI_ALLAM_DTE"), "") %>
        	<span style="color:red;"><%=StringUtil.getLocaleMessage("M.알람_알림", siteLocale) %></span>
        </td>
    </tr> 
	<tr>
        <th class="th4"><%=StringUtil.getLocaleWord("L.참조부서_열람가능",siteLocale)%></th>
        <td class="td4">
            <script type="text/javascript"> 
            function searchChamjobuseo() {
            	var groupCodestr = "";
            	var param ={};
            	
            	param["groupTypeCodes"]= "IG";
            	param["groupCodestr"]= groupCodestr;
            	param["initFunction"]= "initChamjobuseo";
            	
            	airCommon.popupGroupSelects("changeChamjobuseo", param);
            }
            var initChamjobuseo = function(){
            	if($("#lms_pati_chamjobuseo_cod").val() != "" ){ 
    	        	var codes = $("#lms_pati_chamjobuseo_cod").val().split(",");
    	        	var groups_ko = $("#lms_pati_chamjobuseo_nam_ko").val().split("\n");
    	        	var groups_en = $("#lms_pati_chamjobuseo_nam_en").val().split("\n");
    	        	var arrJson = [];
    	        	var i = 0;
    	        	for(i=0; i< codes.length; i++){
    	        		arrJson.push({
    		        			 UUID: ""
    		        			 ,CODE: codes[i]
    		        			 ,PARENT_CODE: ""
    		        			 ,NAME_KO: groups_ko[i]
    		        			 ,NAME_EN: groups_en[i]
    		        			 ,PARENT_NAME_KO: ""
    		        			 ,PARENT_NAME_EN: ""
    		        			 ,NAME_PATH_KO: ""
    		        			 ,NAME_PATH_EN: ""
    		        	});
    	        	}
    	        	return JSON.stringify(arrJson);
            	}else{
	           		return "";
            	}
            }
            function changeChamjobuseo(data) {
            	var jsonData = JSON.parse(data);
            	console.log(data);
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
            		init_code += jsonData[i].CODE;
           			init_name += jsonData[i].NAME_KO;
           			init_name_ko += jsonData[i].NAME_KO;
           			init_name_en += jsonData[i].NAME_EN;
            	}
            	setChamjobuseo(true, init_code, init_name, init_name_ko, init_name_en);
            }
    		/**
    		 * 관련부서 초기화
    		 */
    		function setChamjobuseo(isForceInit, code, name, name_ko, name_en) {
    			code = (code == undefined ? "" : code);
    			name = (name == undefined ? "" : name);
    			name_ko = (name_ko == undefined ? "" : name_ko);
    			name_en = (name_en == undefined ? "" : name_en);
    			
    			if (!isForceInit && !confirm("<%=StringUtil.getScriptMessage("M.관련부서정보를초기화하시겠습니까",siteLocale)%>")) {
    				return false;
    			}
    			document.getElementById("lms_pati_chamjobuseo_cod").value = code;
    			document.getElementById("lms_pati_chamjobuseo_nam").value = name;
    			document.getElementById("lms_pati_chamjobuseo_nam_ko").value = name_ko;
    			document.getElementById("lms_pati_chamjobuseo_nam_en").value = name_en;
    			$("#lms_pati_chamjobuseo_nam").val().replace("\n", '<br>');
    			$("#lms_pati_chamjobuseo_nam_ko").val().replace("\n", '<br>');
    			$("#lms_pati_chamjobuseo_nam_en").val().replace("\n", '<br>');
    		}
            </script>
            <input type="hidden" name="lms_pati_chamjobuseo_cod" id="lms_pati_chamjobuseo_cod" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_COD","")) %>"  />            
            <input type="hidden" name="lms_pati_chamjobuseo_nam_ko" id="lms_pati_chamjobuseo_nam_ko" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_KO","")) %>"  />
            <input type="hidden" name="lms_pati_chamjobuseo_nam_en" id="lms_pati_chamjobuseo_nam_en" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_EN","")) %>"  />
    		<span style="float:left;">
                <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="setChamjobuseo(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
				<span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjobuseo()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
			</span>	
    		<textarea name="lms_pati_chamjobuseo_nam" id="lms_pati_chamjobuseo_nam" readonly="readonly" class="width_max" rows="5"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_"+siteLocale,"")) %></textarea>
        </td>
        <th class="th4"><%=StringUtil.getLocaleWord("L.참조자_열람가능",siteLocale)%></th>
        <td class="td4">
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
           			init_name += jsonData[i].GROUP_NAME_KO+" "+jsonData[i].NAME_KO +" "+jsonData[i].POSITION_NAME_KO;
           			init_name_ko += jsonData[i].GROUP_NAME_KO +" "+jsonData[i].NAME_KO;
           			init_name_en += jsonData[i].GROUP_NAME_EN +" "+jsonData[i].NAME_EN; 
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
<%--             <br/><span style="color: red"><%=StringUtil.getLocaleWord("M.참조자_선택_알림",siteLocale) %></span> --%>
        </td>
    </tr>
    <tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.내용",siteLocale)%></th>
		<td class="td2" colspan="3"><%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_chegyeol_naeyong", "lms_pati_chegyeol_naeyong", StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_CHEGYEOL_NAEYONG")), "")%></td>
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.계약서",siteLocale) %></br><span style="color:red;"><%=StringUtil.getLocaleWord("M.날인한계약서",siteLocale) %></span></th>
		<td class="td2" colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_SIGN" name="typeCode" />
				<jsp:param value="Y" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>	
	</tr>	
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.관련자료",siteLocale) %></th>
		<td class="td2" colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_SIGN_ETC" name="typeCode" />
				<jsp:param value="N" name="requiredYn" /> 				
				<jsp:param value="<%=att_default_master_doc_Ids %>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>	
	</tr>	
</table>