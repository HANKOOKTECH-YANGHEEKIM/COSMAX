<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	String mng_pati_uid         = StringUtil.convertNull(request.getParameter("AIR_PARTICLE"));
	String doc_mas_mode_code	= StringUtil.convertNull(request.getParameter("doc_mas_mode_code"));
	String doc_mas_uid			= StringUtil.convertNull(request.getParameter("doc_mas_uid"));
	String new_doc_mas_uid		= StringUtil.convertNull(request.getParameter("new_doc_mas_uid"));
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid"));
	
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	String lms_pati_jm_001_uid = jsonMap.getString("LMS_PATI_JM_001_UID");
	
	if("".equals(lms_pati_jm_001_uid)){
		lms_pati_jm_001_uid = StringUtil.getRandomUUID();
	}
	
	String new_lms_pati_jm_001_uid = StringUtil.getRandomUUID();
	
	// 갱신일 경우 UID 생성
	if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
			"UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
		lms_pati_jm_001_uid = new_lms_pati_jm_001_uid;
	}
	
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "");
	//언어선택
	String EONEO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("EONEO_LIST"), "CODE,LANG_CODE", "");
	// 유형코드
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(resultMap.getResult("JM_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //자문유형
	SQLResults YUHYEONG02_LIST = resultMap.getResult("YUHYEONG02_LIST");
	
	String YUHYEONG02_CODESTR = "";
	if(YUHYEONG02_LIST != null && YUHYEONG02_LIST.getRowCount() > 0){
		YUHYEONG02_CODESTR = StringUtil.getCodestrFromSQLResults(YUHYEONG02_LIST, "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	}else{
		YUHYEONG02_CODESTR = "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	}
	
	String group_cd = "";
	String group_name = "";
	String group_name_ko= "";
	String group_name_en = "";
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
    
   String chamjojaCod = "";
   String chamjojaNam = "";
   String hoesinGihanDte = DateUtil.addDays(DateUtil.getCurrentDate(), 8);
  
   int dayOfWeek = DateUtil.whichDay(hoesinGihanDte, "yyyy-MM-dd");
    
   if (dayOfWeek == java.util.Calendar.SUNDAY){ 
	   hoesinGihanDte = DateUtil.addDays(DateUtil.getCurrentDate(), 9);
   }

   if (dayOfWeek == java.util.Calendar.SATURDAY){ 
	    hoesinGihanDte = DateUtil.addDays(DateUtil.getCurrentDate(), 10);	
   }
%>
<script type="text/javascript">
	function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
		if ("" == frm.lms_pati_jamun_tit.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.제목", siteLocale))%>");
			frm.lms_pati_jamun_tit.focus();
		    return false;
   		}
		<%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %>
		$("#lms_pati_hoesa_nam").val($("select[name='lms_pati_hoesa_cod']").val());
		<%} %>
		
		return true;
   	}

    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
  	
   	function <%="Parti"+mng_pati_uid%>_dataCheck(){
   		
   		if ("" == frm.lms_pati_jamun_tit.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.제목", siteLocale))%>");
			frm.lms_pati_jamun_tit.focus();
		    return false;
   		}
   		<%if(loginUser.isUserAuth("CMM_SYS")){ %>
  		 if ("" == frm.lms_pati_hoesa_cod.value ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.회사", siteLocale))%>");
			frm.lms_pati_hoesa_cod.focus();
			return false;	 
		 }else{
			 $("#lms_pati_hoesa_nam").val($("select[name='lms_pati_hoesa_cod']").val());
		 }
  		 if ("" == frm.lms_pati_yocheong_id.value ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.의뢰자", siteLocale))%>");
			frm.lms_pati_yocheong_id.focus();
			return false;	 
		 }
  		<%} %>
   		if ("" == frm.lms_pati_yuhyeong.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.유형", siteLocale))%>");
			frm.lms_pati_yuhyeong.focus();
		    return false;
	    } 
   		
   	 	if ("" == airCommon.getEditorValue('lms_pati_geomtoyocheong', "<%=CommonProperties.load("system.editor")%>") ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약배경_및_의뢰내용", siteLocale))%>");
			
			airCommon.getEditorFocus('lms_pati_geomtoyocheong', "<%=CommonProperties.load("system.editor")%>");
			
			return false;
		}
        <%-- 
        
        if ("" == frm.lms_pati_hoesa_cod.value ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.회사", siteLocale))%>");
			frm.lms_pati_hoesa_cod.focus();
			return false;	 
		}
        
		var txt = $(".combo").find("input:text");
		$("#lms_pati_hoesa_nam").val(txt.val());
  		
        if ($('input[name=lms_pati_eoneo_cod]:checked').length == 0) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.언어", siteLocale))%>");
			$('#lms_pati_eoneo_cod0').focus();
		    return false;
		}
        --%>
        
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
	};
	
	/*
	관련계약건 삭제
	*/
	function doDelContItem(id){
		$("#"+id).remove();
	};	
	
	/**
	*	회신기한인 5일 이전 날짜는 선택 못하도록 한다.
	*/
	var requestDateCke = function(val){
		if(val != ""){
			var d = new Date();
			d.setDate(d.getDate()+7);
			var month = (d.getMonth()+1);
			var day = d.getDate();
			var Year = d.getFullYear();
			if(10>month){
				month = "0"+month;
			}
			if(10>day){
				day = "0"+day;
			}
			var tarDate = Year+"-"+month+"-"+day;
			
			if(val <= tarDate){
				alert ("<%=StringUtil.getScriptMessage("M.ALERT_WRONG",siteLocale,StringUtil.getLocaleWord("L.회신기한일", siteLocale))%>");
				$("#lms_pati_hoesin_gihan_dte").val("");
				setTimeout(function(){
					$("#lms_pati_hoesin_gihan_dte_btn").trigger("click");
				},500);
			}
		}
	};
	
// 	$(function(){
// 	   $( '#lms_pati_hoesin_gihan_dte').datepicker({
// 		 minDate:+8
// 		 , beforeShowDay: noSundays
// 	   });		
// 	});
	
	function noSundays(date) {	
		day = date.getDay();
	    return [(day != 0 && day != 6),''];
	}
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
<br />
<input type="hidden" name="lms_pati_jm_001_uid" value="<%=lms_pati_jm_001_uid%>" />
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("D.법률자문요청",siteLocale)%> ( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale)%>)</caption>
	<tr>
	    <th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<input type="text" class="text width_max" name="lms_pati_jamun_tit" id="lms_pati_jamun_tit" value="<%=jsonMap.getString("LMS_PATI_JAMUN_TIT")%>" data-length="200" onblur="airCommon.validateMaxLength(this, 200);airCommon.validateSpecialChars(this);" />
		</td>
	</tr>
	<tr>
		<th class="th2"><%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %><span class="ui_icon required"></span><%} %><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td2" colspan="3"> 
			<%--if(LmsUtil.isBeobmuTeamUser(loginUser)){ --%>
<%-- 		<%if(loginUser.getAuthCodes().contains("CMM_SYS")){ %> --%>
			<%if(loginUser.isUserAuth("CMM_SYS")){ %>
			    <%=HtmlUtil.getSelect(request, true, "lms_pati_hoesa_cod", "lms_pati_hoesa_cod", HOESA_CODESTR, jsonMap.getDefStr("LMS_PATI_HOESA_COD",loginUser.gethoesaCod()), "class=\"select\"")%>
				<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
			<%}else{ %>
				<%= loginUser.gethoesaNam() %>
				<input type="hidden" name="lms_pati_hoesa_cod" value="<%= loginUser.gethoesaCod() %>" />
				<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
			<%} %>
	 	</td>
	</tr>
	<% if(LmsUtil.isBeobmuTeamUser(loginUser)){ %>
	<tr> 
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale) %></span></th>
		<td class="td2" colspan="3">
			 <script type="text/javascript"> 
	            function popupReqSel(callback) {
	            	var defaultUser = $("#lms_pati_yocheong_id").val();
// 	            	var callback = "changesetYocheong";
	            	//airCommon.popupUserSelect(callback,'DTREE','','IG','LMS');
	            	var url = "/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=POPUP_USER_SELECT";
	            	url += "&callbackFunction="+ escape(callback); //XSS필터링 통과를 위해 escape 적용!
	            	url += "&defaultUser="+defaultUser
	            	url += "&groupTypeCodes=IG"
	            	url += "&userType=chamjo"
	            	url += "&multiSelect=N"
	                    	
	            	airCommon.openWindow(url, 850, 700, "popupGroupSelects", "no", "no", "");
	            }
	            function setReq(data){
	            	if(data){
	            		console.log(data);
	            		data = JSON.parse(data);
	            		$("#lms_pati_yocheong_nam").text(data[0].NAME_KO);
	            		$("#lms_pati_yocheong_nam_ko").val(data[0].NAME_KO);
	            		$("#lms_pati_yocheong_nam_en").val(data[0].NAME_EN);
	            		$("#lms_pati_yocheong_nam_zh").val(data[0].NAME_ZH);
	            		$("#lms_pati_yocheong_id").val(data[0].LOGIN_ID);
	            		$("#lms_pati_yocheong_dpt_cod").val(data[0].GROUP_CODE);
	            		$("#lms_pati_yocheong_dpt_nam").val(data[0].GROUP_NAME_KO);
	            	}
	            }
	            function resetReq(){
	            	$("#lms_pati_yocheong_nam").text("");
            		$("#lms_pati_yocheong_id").val("");
            		$("#lms_pati_yocheong_dpt_cod").val("");
            		$("#lms_pati_yocheong_dpt_nam").val("");
	            }
	          </script>
	          <span id="lms_pati_yocheong_nam"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_"+siteLocale, loginUser.getNameKo())) %></span>
            <input type="hidden" id="lms_pati_yocheong_id" name="lms_pati_yocheong_id" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_YOCHEONG_ID", loginUser.getLoginId())) %>">
            <input type="hidden" name="lms_pati_yocheong_nam_ko" id="lms_pati_yocheong_nam_ko" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_KO", loginUser.getNameKo()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_en" id="lms_pati_yocheong_nam_en" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_EN", loginUser.getNameEn()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_zh" id="lms_pati_yocheong_nam_zh" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_ZH", loginUser.getNameZh()) %>" />
            <input type="hidden" name="lms_pati_yocheong_dpt_cod" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_COD", loginUser.getGroupCode()) %>" />
			<input type="hidden" name="lms_pati_yocheong_dpt_nam" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM_KO", loginUser.getGroupNameKo()) %>" />
			
			<input type="hidden" name="lms_pati_site_locale" value="<%=jsonMap.getDefStr("LMS_PATI_SITE_LOCALE", loginUser.getSiteLocale()) %>" />
			
			<span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="resetReq()"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
            <span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="popupReqSel('setReq')"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
        </td>
    </tr> 
	<% }else{ %>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰부서",siteLocale)%></th>
		<td class="td4" id="LMS_PATI_YOCHEONG_DPT_NAM">
			<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM", jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM", loginUser.getGroupNameKo())) %>
			<input type="hidden" name="lms_pati_yocheong_dpt_cod" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_COD", loginUser.getGroupCode()) %>" />
			<input type="hidden" name="lms_pati_yocheong_dpt_nam" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM_KO", loginUser.getGroupNameKo()) %>" />
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
		<td class="td4" id="LMS_PATI_YOCHEONG_NAM">
			<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_"+siteLocale , jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_"+siteLocale, loginUser.getName()) ) %>  
			<input type="hidden" name="lms_pati_yocheong_id" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_ID", loginUser.getLoginId()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_ko" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_KO", loginUser.getNameKo()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_en" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_EN", loginUser.getNameEn()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_zh" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_ZH", loginUser.getNameZh()) %>" />
			
			<input type="hidden" name="lms_pati_site_locale" value="<%=jsonMap.getDefStr("LMS_PATI_SITE_LOCALE", loginUser.getSiteLocale()) %>" />
			
		</td>
	</tr>
	<% }%>
	<tr>
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
		
		
		
		<th class="th4"><%=StringUtil.getLocaleWord("L.회신기한일",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getInputCalendar(request, true, "lms_pati_hoesin_gihan_dte", "lms_pati_hoesin_gihan_dte", jsonMap.getString("LMS_PATI_HOESIN_GIHAN_DTE"), "")%>
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
            <input type="hidden" name="lms_pati_chamjobuseo_cod" id="lms_pati_chamjobuseo_cod" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_COD",group_cd)) %>"  />            
            <input type="hidden" name="lms_pati_chamjobuseo_nam_ko" id="lms_pati_chamjobuseo_nam_ko" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_KO",group_name_ko)) %>"  />
            <input type="hidden" name="lms_pati_chamjobuseo_nam_en" id="lms_pati_chamjobuseo_nam_en" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_EN",group_name_en)) %>"  />
    		<span style="float:left;">
                <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="setChamjobuseo(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
				<span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjobuseo()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
			</span>	
    		<textarea name="lms_pati_chamjobuseo_nam" id="lms_pati_chamjobuseo_nam" readonly="readonly" class="width_max" rows="5"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOBUSEO_NAM_"+siteLocale,group_name)) %></textarea>
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
            <input type="hidden" id="lms_pati_chamjoja_cod" name="lms_pati_chamjoja_cod" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOJA_COD",chamjojaCod)) %>">
            <input type="hidden" id="lms_pati_chamjoja_nam_ko" name="lms_pati_chamjoja_nam_ko" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM_KO")) %>">
            <input type="hidden" id="lms_pati_chamjoja_nam_en" name="lms_pati_chamjoja_nam_en" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHAMJOJA_NAM_EN")) %>">
            <span style="float:left;"> 
			    <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="initChamjoja(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
			    <span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjoja()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
             </span>	
            <textarea name="lms_pati_chamjoja_nam" id="lms_pati_chamjoja_nam" readonly="readonly"  class="width_max"  rows="5"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_CHAMJOJA_NAM",chamjojaNam)) %></textarea>
<%--             <br/><span style="color: red"><%=StringUtil.getLocaleWord("M.참조자_선택_알림",siteLocale) %></span> --%>
        </td>
    </tr>
    <tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td4" colspan="3">
		    <span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="popupRelSelect('GY');"><%=StringUtil.getLocaleWord("B.SELECT",siteLocale)%></a></span>
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
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰내용",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_geomtoyocheong", "lms_pati_geomtoyocheong", StringUtil.convertForEditor(jsonMap.getDefStr("LMS_PATI_GEOMTOYOCHEONG",HtmlUtil.getDefContent("lms_jm_01.html"))), "", null, "280px", null)%>
		</td>
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
<script>
$(function(){
	//-- 최초 작성 임시저장일떄는 TODO 영역을 가리기 위함
	//-- 그 이유는 삭제 처리가 있어 서로 햇갈리기 때문
	//-- 주석하고 테스트 해보면 알수 있음
	try{
		todoHide<%=sol_mas_uid%>();
	}catch(e){}
});
</script>