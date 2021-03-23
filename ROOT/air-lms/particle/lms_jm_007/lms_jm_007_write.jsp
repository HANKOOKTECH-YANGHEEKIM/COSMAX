<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
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
	
	String mng_pati_uid         = request.getParameter("AIR_PARTICLE");
	String doc_mas_mode_code	= request.getParameter("doc_mas_mode_code");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String sol_mas_uid			= request.getParameter("sol_mas_uid");
	String new_doc_mas_uid		= request.getParameter("new_doc_mas_uid");
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults LMS_BJD			= resultMap.getResult("LMS_BJD");
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	String lms_pati_jm_007_uid = jsonMap.getString("LMS_PATI_JM_007_UID");
	
	if("".equals(lms_pati_jm_007_uid)){
		lms_pati_jm_007_uid = StringUtil.getRandomUUID();
	}
	
	String new_lms_pati_jm_007_uid   = StringUtil.getRandomUUID();

	
	// 갱신일 경우 UID 생성
	if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
			"UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
		lms_pati_jm_007_uid = new_lms_pati_jm_007_uid;
	}
	
	// 유형코드
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(resultMap.getResult("JM_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //자문유형
	SQLResults YUHYEONG02_LIST = resultMap.getResult("YUHYEONG02_LIST");
	
	String YUHYEONG02_CODESTR = "";
	if(YUHYEONG02_LIST != null && YUHYEONG02_LIST.getRowCount() > 0){
		YUHYEONG02_CODESTR = StringUtil.getCodestrFromSQLResults(YUHYEONG02_LIST, "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	}else{
		YUHYEONG02_CODESTR = "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	}
	
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "");
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");

  	//-- 추가검토결과 다시 작성시 자동으로 채워지는 것중 검토결과와 첨부파일은 제외 시키는 로직
  	/*20190621*/
	if(!doc_mas_uid.equals(jsonMap.getString("DOC_MAS_UID"))){
	   jsonMap.remove("LMS_PATI_RVW_RSL");
	   att_default_master_doc_Ids = "";
	}
%>

<script type="text/javascript">
	
    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
    
	function <%="Parti"+mng_pati_uid%>_dataCheck(){
		var comboHidden = $(".combo").find("input:hidden");
		if("" == $("#lms_pati_jamun_tit").val()){
			alert ("<%=StringUtil.getLocaleWord("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.제목",siteLocale))%>");
			$("#lms_pati_jamun_tit").focus();
		    return false;	
		}
<%-- 	<%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %> --%>
<%-- 	<%if(loginUser.getAuthCodes().contains("CMM_SYS")){ %> --%>
		<%if(loginUser.isUserAuth("CMM_SYS")){ %>
 		 if ("" == frm.lms_pati_hoesa_cod.value ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.회사", siteLocale))%>");
			frm.lms_pati_hoesa_cod.focus();
			return false;	 
		 }else{
			 $("#lms_pati_hoesa_nam").val($("select[name='lms_pati_hoesa_cod']").val());
		 }
 		<%} %>
		if("" == frm.lms_pati_yuhyeong.value){
			alert ("<%=StringUtil.getLocaleWord("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.유형",siteLocale))%>");
			frm.lms_pati_yuhyeong.focus();
		    return false;	
    	}
		 
		 if ("" == airCommon.getEditorValue('lms_pati_rvw_rsl', "<%=CommonProperties.load("system.editor")%>") ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.검토결과", siteLocale))%>");
			
			airCommon.getEditorFocus('lms_pati_rvw_rsl', "<%=CommonProperties.load("system.editor")%>");
			
			return false;
		}
		 
  		return true;
	}
	
	function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
		
		if("" == $("#lms_pati_jamun_tit").val()){
			alert ("<%=StringUtil.getLocaleWord("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.제목",siteLocale))%>");
			$("#lms_pati_jamun_tit").focus();
		    return false;	
		}
		<%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %>
		$("#lms_pati_hoesa_nam").val($("select[name='lms_pati_hoesa_cod']").val());
		<%} %>
		return true;
  	} 
	
	/**
	 * 관련계약서 선택 팝업
	 */  
	var popupRelSelect =  function(gubun) {
		
		var sol_mas_uid = "<%=sol_mas_uid%>";
		var callbackFunction = "setRelMas";
		
		airLms.popupRelSelect(sol_mas_uid, gubun, callbackFunction);
	}

	/**
	 * 관련계약건 설정
	 */
	var setRelMas =  function(data){
		
		var rows = data.rows;
		var totCnt = 0;
		// 기존 데이터 삭제
		$("#gwanryon_geyagseo_list tr").remove();
		
		var arrData = JSON.parse(data);
	   	//jquery-tmpl
	   	var tgTbl = $("#gwanryon_geyagseo_list");
		$("#addRelHeaderTmpl").tmpl().appendTo(tgTbl);
		$("#addRelRowTmpl").tmpl(arrData).appendTo(tgTbl);	 
	}
    
	/*
	관련계약건 삭제
	*/
	/*
	관련계약건 삭제
	*/
	function doDelContItem(id){
		$("#"+id).remove();
	};

	
</script>
<script id="addRelHeaderTmpl" type="text/html">
    <tr>
        <th style="width:8%; text-align:center;"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
        <th style="width:12%; text-align:center;"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
        <th style="width:auto; text-align:center;"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
<%--         <th style="width:12%; text-align:center;"><%=StringUtil.getLocaleWord("L.의뢰일_작성일",siteLocale)%></th> --%>
<%--         <th style="width:8%; text-align:center;"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th> --%>
<%--         <th style="width:12%; text-align:center;"><%=StringUtil.getLocaleWord("L.진행상태",siteLocale)%></th> --%>
		<th style="width:7%; text-align:center;"></th>
    </tr>
</script>
<script id="addRelRowTmpl" type="text/html">
    <tr id="\${SOL_MAS_UID}">
        <td align="center" name="gubunName">
            \${GUBUN_NAME}
			<input type="hidden" name="lms_pati_rel_sol_mas" id="lms_pati_rel_sol_mas" value="\${SOL_MAS_UID}"/>
			<input type="hidden" name="lms_pati_rel_gubun" id="lms_pati_rel_gubun" value="\${GUBUN}"/>
			<input type="hidden" name="lms_pati_rel_gubun_name" id="lms_pati_rel_gubun_name" value="\${GUBUN_NAME}"/>
			<input type="hidden" name="lms_pati_rel_title_no" id="lms_pati_rel_title_no" value="\${TITLE_NO}"/>
			<input type="hidden" name="lms_pati_rel_title" id="lms_pati_rel_title" value="\${TITLE}"/>
        </td>
        <td align="center" name="titleNo">\${TITLE_NO}</td>
        <td align="left" name="title">\${TITLE}</td>
<%--        <td align="center" name="reg_dte">\${REG_DTE}</td>
        <td align="center" name="damdang_nam">\${DAMDANG_NAM}</td>
        <td align="center" name="sangtae_nam">\${SANGTAE_NAM}</td>
--%>
		<td>
		<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="doDelContItem('\${SOL_MAS_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
		</td>		
    </tr>
</script>
<input type="hidden" name="lms_pati_jm_007_uid" value="<%=lms_pati_jm_007_uid%>">
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.법률자문검토결과",siteLocale)%> <%=StringUtil.getLocaleWord("L.등록",siteLocale)%> ( <input type="button" class="required" tabindex="-1" /><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale)%>)</caption>
	<tr>
	    <th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<input type="text" class="text width_max" name="lms_pati_jamun_tit" id="lms_pati_jamun_tit" value="<%=jsonMap.getString("LMS_PATI_JAMUN_TIT")%>" data-length="200" onblur="airCommon.validateMaxLength(this, 200);airCommon.validateSpecialChars(this);" />
		</td>
	</tr>
	<tr>
		<th class="th4"><%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %><span class="ui_icon required"></span><%} %><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4"> 
			<%--if(LmsUtil.isBeobmuTeamUser(loginUser)){ --%>
			<%if(loginUser.isUserAuth("CMM_SYS")){ %>
			    <%=HtmlUtil.getSelect(request, true, "lms_pati_hoesa_cod", "lms_pati_hoesa_cod", HOESA_CODESTR, jsonMap.getDefStr("LMS_PATI_HOESA_COD",""), "class=\"select\"").replace("C.", "")%>
				<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
			<%}else{ %>
				<%= loginUser.gethoesaNam() %>
				<input type="hidden" name="lms_pati_hoesa_cod" value="<%= loginUser.gethoesaCod() %>" />
				<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
			<%} %>
	 	</td>
		
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th>
		
		<td class="td4">
			<script>
				//유형(1차) 변경 이벤트 처리  
				 function _changeYuhyeong01(targetId, val){
					var data = {};
					data["PARENT_CODE_ID"] = val;
					data["STAUS_CODE"] = "N";
					airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
						
						airCommon.initializeSelectJson(targetId, json, "|--<%=StringUtil.getLang("L.선택",siteLocale) %>--", "CODE_ID", "<%=siteLocale%>");
					});
					
					$('#LMS_PATI_YUHYEONG01_NAM').val( $('#lms_pati_yuhyeong').find('option:selected').text());
					$('#LMS_PATI_YUHYEONG02_NAM').val("");
				}
				
				var setRecView = function(val){
					 if(val.endsWith("ETC")){
						 $("#lms_pati_yuhyeong_etc").val("");
						 $("#lms_pati_yuhyeong_etc").show();
					 }else {
						 $("#lms_pati_yuhyeong_etc").val("");
						 $("#lms_pati_yuhyeong_etc").hide();
					 }
				 }
				</script>
			<%=HtmlUtil.getSelect(request, true, "lms_pati_yuhyeong", "lms_pati_yuhyeong", sYuhyeong_list, jsonMap.getString("LMS_PATI_YUHYEONG"), "onchange=\"_changeYuhyeong01('lms_pati_yuhyeong02_cod', this.value); setRecView(this.value)\" class=\"select width_half\"")%>
			<%=HtmlUtil.getSelect(request, true, "lms_pati_yuhyeong02_cod", "lms_pati_yuhyeong02_cod", YUHYEONG02_CODESTR, jsonMap.getString("LMS_PATI_YUHYEONG02_COD"), "onchange=\"$('#LMS_PATI_YUHYEONG02_NAM').val($(this).find('option:selected').text())\" class=\"select width_half\"")%>
			<input type="hidden" name="LMS_PATI_YUHYEONG01_NAM" id="LMS_PATI_YUHYEONG01_NAM" value="<%=jsonMap.getString("LMS_PATI_YUHYEONG01_NAM")%>"/>
			<input type="hidden" name="LMS_PATI_YUHYEONG02_NAM" id="LMS_PATI_YUHYEONG02_NAM" value="<%=jsonMap.getString("LMS_PATI_YUHYEONG02_NAM")%>"/>
		</td>
		
	</tr>
	<tr>
		<th class="th4"><span><%=StringUtil.getLocaleWord("L.품목",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<input type="text" class="text" name="lms_pati_item" id="lms_pati_item" style="width:40%" value="<%=jsonMap.getString("LMS_PATI_ITEM")%>" maxlength="200"/>
		<span style="color: red;">* <%=StringUtil.getLocaleWord("M.자문품목_안내",siteLocale)%></span>
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
		<th class="th2"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td2"colspan="3">
		    <span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="popupRelSelect('JM');"><%=StringUtil.getLocaleWord("B.SELECT",siteLocale)%></a></span>
            <table id="gwanryon_geyagseo_list" class="basic">
		     <%
			String[] REL_SOL = jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS");
			if(REL_SOL != null && REL_SOL.length > 0){
		 	%>
    	    <tr>
		        <th width="12%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
		        <th width="13%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
		        <th width="75%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
		        <th></th>
		    </tr>
   		   	<%
				for(int i=0; i< REL_SOL.length; i++){
			%>
			<tr id="<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i]%>">
		        <td align="center">
		            <%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN_NAME")[i]%>
		            <input type="hidden" name="lms_pati_rel_sol_mas" id="lms_pati_rel_sol_mas" value="<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i]%>"/>
					<input type="hidden" name="lms_pati_rel_gubun_name" id="lms_pati_rel_gubun_name" value="<%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN_NAME")[i]%>"/>
		            <input type="hidden" name="lms_pati_rel_gubun" id="lms_pati_rel_gubun" value="<%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN")[i]%>"/>
		            <input type="hidden" name="lms_pati_rel_title_no" id="lms_pati_rel_title_no" value="<%=jsonMap.getArrStr("LMS_PATI_REL_TITLE_NO")[i]%>"/>
		            <input type="hidden" name="lms_pati_rel_title" id="lms_pati_rel_title" value="<%=jsonMap.getArrStr("LMS_PATI_REL_TITLE")[i]%>"/>
		        </td>
		        <td align="center"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE_NO")[i]%></td>
		        <td align="left"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE")[i]%></td>
				<td>
				<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="doDelContItem('<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i]%>');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
				</td>		
		    </tr>
		    
			<%
				}
			}
			%>
            </table>
       </td>
	</tr>
    <tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.검토결과",siteLocale)%></span></th>
		<td class="td2" colspan="3"><%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_rvw_rsl", "lms_pati_rvw_rsl", StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_RVW_RSL")), "")%></td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %></th>
		<td class="td2" colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/JM/GONGMUN" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>	
	</tr>
</table>
<p>
