<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String page_no 			= requestMap.getString(CommonConstants.PAGE_NO);
	
	String mng_pati_uid         = request.getParameter("AIR_PARTICLE");
	String doc_mas_mode_code	= request.getParameter("doc_mas_mode_code");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String new_doc_mas_uid		= request.getParameter("new_doc_mas_uid");
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults listResult 		= resultMap.getResult("gyOldInfo");
	
	Map<String, Object> jsonMap = (Map<String, Object>)request.getAttribute(CommonConstants._JSON_DATA);
	
	String action_code	= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code	= resultMap.getString(CommonConstants.MODE_CODE);
	
	/* Code Start	
	String sampleField      = "";	
	*/
	String gy_old_uid				= StringUtil.getRandomUUID();
	
	String gyeyag_tit				= "";
	String gwanri_no				= "";
	String hoesa_cod				= loginUser.gethoesaCod();
	String hoesa_name				= "";//loginUser.gethoesaNam();
	String damdang_dpt_cod			= "";
	String damdang_dpt_nam			= "";
	String gyeyag_sangdaebang_nam	= "";
	String chegyeol_dte 			= "";
	String gyeyag_st_dte 			= "";
	String gyeyag_ed_dte 			= "";
	String bogwanwichi				= "";
	String gyeyag_mogjeog			= "";
	String bubmu_damdangja_nam = "";
	String hyunup_damdangja_nam = "";
	String bigo = "";
	
	if ("POPUP_UPDATE_FORM".equals(mode_code)) {
		if(listResult != null && listResult.getRowCount()>0){
			gy_old_uid				= listResult.getString(0, "gy_old_uid");
			gwanri_no				= listResult.getString(0, "gwanri_no");
			gyeyag_tit				= listResult.getString(0, "gyeyag_tit");
			hoesa_cod				= listResult.getString(0, "hoesa_cod");		
			hoesa_name			= listResult.getString(0, "hoesa_name");		
			damdang_dpt_cod	= listResult.getString(0, "damdang_dpt_cod");		
			damdang_dpt_nam	= listResult.getString(0, "damdang_dpt_nam");		
			gyeyag_sangdaebang_nam	= listResult.getString(0, "gyeyag_sangdaebang_nam");
			chegyeol_dte 			= listResult.getString(0, "chegyeol_dte");
			gyeyag_st_dte      	= listResult.getString(0, "gyeyag_st_dte");
			gyeyag_ed_dte      	= listResult.getString(0, "gyeyag_ed_dte");
			bogwanwichi			= listResult.getString(0, "bogwanwichi");	
			gyeyag_mogjeog		= listResult.getString(0, "gyeyag_mogjeog");
			bubmu_damdangja_nam	= listResult.getString(0, "bubmu_damdangja_nam");
			hyunup_damdangja_nam = listResult.getString(0, "hyunup_damdangja_nam");
			bigo = listResult.getString(0, "bigo");
		}
	}
	
	//-- 회사
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE,LANG_CODE", "");
%>
<script type="text/javascript">
/**
 * 저장
 */	
	function doSubmit(frm) {	
		var stday = frm.gyeyag_st_dte.value;
		var edday = frm.gyeyag_ed_dte.value;
		var comboHidden = $(".combo").find("input:hidden");
 		if (frm.gyeyag_tit != undefined && frm.gyeyag_tit.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale, StringUtil.getLocaleWord("L.계약명", siteLocale))%>");
			frm.gyeyag_tit.focus();
			return;
		}
    	if(comboHidden.length == 0 ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.회사", siteLocale))%>");
		$(".combo").find("input:text").focus();
		return false; 
    	}
		if (frm.gyeyag_sangdaebang_nam != undefined && frm.gyeyag_sangdaebang_nam.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약상대방", siteLocale))%>");
			frm.gyeyag_sangdaebang_nam.focus();
			return;
		}
		if ((stday != '' || edday != '') && (stday >= edday)) {
			alert ("<%=StringUtil.getScriptMessage("M.ALERT_WRONG",siteLocale,StringUtil.getLocaleWord("L.계약기간", siteLocale))%>");
			frm.gyeyag_ed_dte.focus();
			return;
		} 
		<%-- if (frm.chegyeol_dte != undefined && frm.chegyeol_dte.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.체결일", siteLocale))%>");
			frm.chegyeol_dte.focus();
			return;
		} --%>
		
		// 첨부 체크
		var filechk = airCommon.validateAttachFile("LMS/GY_OLD/CTR_SIGN");
		if(filechk == false){
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.첨부파일", siteLocale))%>");
			return;
		}
		
		var txt = $(".combo").find("input:text");
		$("#hoesa_name").val(txt.val());
	

		if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.저장", siteLocale))%>")) {
			//--에디터 서브밋 처리
			airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
			
			if (frm.current_mode_code.value == "POPUP_UPDATE_FORM") {
				frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_PROC";
			}else{
				frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_PROC";
			} 
			
			frm.action = "/ServletController";
			frm.target = "_self";
			frm.submit();		
		}
	}
	
	$(function(){
		$(".combo").find("input:text").attr("readonly","readonly");
	});
</script>
<!-- 날짜입력 예시 -->
<!--input type="text" name="sampleField" id="sampleField" value="< %=StringUtil.convertForInput(sampleField) % >" class="date" onfocus="this.select()" onblur="airCommon.validateDateObject(this);"  /> <input type="button" value=" " onclick="javascript:airCommon.openInputCalendar('sampleField');" class="btn_calendar" /-->

<!-- 텍스트 필드 입력 예시 -->
<!--input type="text" class="text width_max" name="sampleField" id="sampleField" size="2" value="< %=sampleField % >" /-->

<!-- 텍스트(숫자전용) 필드 입력 예시 -->
<!--input type="text" name="sampleField" id="sampleField" size="2" value="< %=sampleField % >" onblur="airCommon.validateNumber(this, this.value)" /-->

<!-- 텍스트 영역 입력 예시 -->
<!--textarea class="memo width_max" name="sampleField" id="content" onkeyup="airCommon.validateMaxLength(this, 2000)">< %=sampleField % ></textarea-->

<!-- 시스템 코드 항목으로 라디오 만들기 -->
<!--%=HtmlUtil.getSelect(request, true, "sample_sys_cod_id", "sample_sys_cod_id", SampleCodStr, sample_sys_cod_id, "") %-->

<!-- 파일첨부하기 -->
<!-- ips_cw_004_write.jsp 참조 -->

<!-- 필수값 * 마크 추가 -->
<!-- Input type="button" class="required" tabindex="-1"-->

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=page_no%>" />
	<input type="hidden" name="gy_old_uid" value="<%=gy_old_uid%>" />
	<input type="hidden" name="gwanri_no" value="<%=gwanri_no%>"/>
	<input type="hidden" name="current_mode_code" value="<%=mode_code%>" />
	<table class="basic">
		<caption><%=StringUtil.getLocaleWord("L.구계약_등록",siteLocale) %> ( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale) %>)</caption>
		<tr>
			<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.계약명",siteLocale)%></span></th>
			<td class="td2" colspan="3"><input type="text" class="text width_max" name="gyeyag_tit" id="gyeyag_tit" value="<%=StringUtil.convertForInput(gyeyag_tit)%>" onblur="airCommon.validateMaxLength(this, 200);airCommon.validateSpecialChars(this);" /></td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></span></th>
			<td class="td4" colspan="3">
				<input type="hidden" name="hoesa_name" id="hoesa_name" value="<%=hoesa_name%>"/>
			    <%=HtmlUtil.getSelect(request, true, "hoesa_cod", "hoesa_cod", HOESA_CODESTR, hoesa_cod, "class=\"easyui-combobox\" data-options=\"multiple:false,multiline:false\" style=\"height:40px;width:330px\"")%>
			</td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale)%></span></th>
			<td class="td4"><input type="text" class="text width_max" name="gyeyag_sangdaebang_nam" id="gyeyag_sangdaebang_nam" value="<%=StringUtil.convertForInput(gyeyag_sangdaebang_nam)%>" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);"/></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.법무담당자",siteLocale)%></th>
			<td class="td4"><input type="text" class="text width_max" name="bubmu_damdangja_nam" id="bubmu_damdangja_nam" value="<%=StringUtil.convertForInput(bubmu_damdangja_nam)%>" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);"/></td>
		</tr>
		<tr>
	        <th class="th4"><%=StringUtil.getLocaleWord("L.담당부서",siteLocale)%>(열람불가)</th>
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
            	if($("#damdang_dpt_cod").val() != "" ){ 
    	        	var codes = $("#damdang_dpt_cod").val().split(",");
    	        	var groups_ko = $("#damdang_dpt_nam").val().split("\n");
    	        	var arrJson = [];
    	        	var i = 0;
    	        	for(i=0; i< codes.length; i++){
    	        		arrJson.push({
    		        			 UUID: ""
    		        			 ,CODE: codes[i]
    		        			 ,PARENT_CODE: ""
    		        			 ,NAME_KO: groups_ko[i]
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
           			init_name += jsonData[i].NAME_<%=siteLocale %>;
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
    			document.getElementById("damdang_dpt_cod").value = code;
    			document.getElementById("damdang_dpt_nam").value = name;
    			$("#damdang_dpt_nam").val().replace("\n", '<br>');
    		}
            </script>
            <input type="hidden" name="damdang_dpt_cod" id="damdang_dpt_cod" value="<%=StringUtil.convertForInput(damdang_dpt_cod)%>"  />            
			<span style="float:left;">
                <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="setChamjobuseo(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
				<span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjobuseo()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
			</span>	
			<textarea name="damdang_dpt_nam" id="damdang_dpt_nam" readonly="readonly" style="width: 100%" rows="5"><%=StringUtil.convertForInput(damdang_dpt_nam) %></textarea>
        
        </td>
        <th class="th4"><%=StringUtil.getLocaleWord("L.현업담당자",siteLocale)%>(열람불가)</th>
		<td class="td4"><input type="text" class="text width_max" name="hyunup_damdangja_nam" id="hyunup_damdangja_nam" value="<%=StringUtil.convertForInput(hyunup_damdangja_nam)%>" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);"/></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.계약기간",siteLocale)%></th>
			<td class="td4">
				<%= HtmlUtil.getInputCalendar(request, true, "gyeyag_st_dte", "gyeyag_st_dte", gyeyag_st_dte, "") %> ~
				<%= HtmlUtil.getInputCalendar(request, true, "gyeyag_ed_dte", "gyeyag_ed_dte", gyeyag_ed_dte, "") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.체결일",siteLocale)%></th>
			<td class="td4">
				<%= HtmlUtil.getInputCalendar(request, true, "chegyeol_dte", "chegyeol_dte", chegyeol_dte, "") %>
			</td>		
		</tr>
		<%-- <tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.계약목적",siteLocale)%></th>
			<td class="td4"><input type="text" class="text width_max" name="gyeyag_mogjeog" id="gyeyag_mogjeog" value="<%=StringUtil.convertForInput(gyeyag_mogjeog)%>" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);" /></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.보관위치",siteLocale)%></th>
			<td class="td4"><input type="text" class="text width_max" name="bogwanwichi" id="bogwanwichi" value="<%=StringUtil.convertForInput(bogwanwichi)%>" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);" /></td>
		</tr> --%>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.비고",siteLocale) %></th>
			<td class="td2" colspan="3">
				<%=HtmlUtil.getHtmlEditor(request,true, "bigo", "bigo", StringUtil.convertForEditor(bigo), "") %>
			</td>
		</tr>
		<tr>
			<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %></span></th>
			<td class="td2" colspan="3">
				<jsp:include page="/ServletController" flush="true">
					<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
					<jsp:param value="FILE_WRITE" name="AIR_MODE" />
					<jsp:param value="<%=gy_old_uid%>" name="masterDocId" />
					<jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="LMS/GY_OLD/CTR_SIGN" name="typeCode" />
					<jsp:param value="Y" name="requiredYn" />
				</jsp:include>
			</td>
		</tr>				
	</table>
<p></p>
<div align="right">
<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:doSubmit(document.form1);"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
</div>
</form>