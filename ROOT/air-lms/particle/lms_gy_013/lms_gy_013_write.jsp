<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>

<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	String mng_pati_uid         = request.getParameter("AIR_PARTICLE");
	String doc_mas_mode_code	= request.getParameter("doc_mas_mode_code");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String new_doc_mas_uid		= request.getParameter("new_doc_mas_uid"); 
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid"));
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
 	
	/* Code Start	
	String sampleField      = "";	
	*/
	//계약유형
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GY_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); //계약유형
	//회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "");
	String GYEYAG_TONGHWA_COD_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("TONGHWA_CODE_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)));
	String LMS_GY_SKIP_REASON_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMS_GY_SKIP_REASON"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)));
	String INS_TYPE_STR = "new|" + StringUtil.getLocaleWord("L.신규2",siteLocale) + "^edit|" + StringUtil.getLocaleWord("L.수정2",siteLocale) + "^update|" + StringUtil.getLocaleWord("L.갱신2",siteLocale);
	String PYOJUNGYEYAGSEO_YN = "Y|" + StringUtil.getLocaleWord("L.사용",siteLocale) + "^N|" + StringUtil.getLocaleWord("L.미사용",siteLocale);
	
	String lms_pati_gy_013_uid 	= jsonMap.getString("LMS_PATI_GY_013_UID");	
	
	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
	
	if("".equals(lms_pati_gy_013_uid)){
		lms_pati_gy_013_uid = StringUtil.getRandomUUID();
	}
	/* if("".equals(jsonMap.getString("LMS_PATI_ALLAM_DTE"))){
		String[] arrDate = jsonMap.getString("LMS_PATI_GYEYAG_ED_DTE").split("-");
		
		Calendar cal = Calendar.getInstance();
		cal.set(cal.YEAR, Integer.parseInt(arrDate[0]));
		cal.set(cal.MONTH, Integer.parseInt(arrDate[1])-1);
		cal.set(cal.DAY_OF_MONTH, Integer.parseInt(arrDate[2]));
		
		cal.add(cal.MONTH, 3);
		
		int nYear = cal.get ( Calendar.YEAR );
		int nMonth = cal.get ( Calendar.MONTH ) + 1;
		int nDay = cal.get ( Calendar.DAY_OF_MONTH );
		
		String tmpDate = "";
		tmpDate += nYear;
		
		if ( nMonth < 10 ){
			tmpDate += "-0";
		}else{
			tmpDate += "-";
		}
		tmpDate += nMonth;
		
		if ( nDay < 10 ){
			tmpDate += "-0";
		}else{
			tmpDate += "-";
		}
		tmpDate += nDay;
		
		jsonMap.put("LMS_PATI_ALLAM_DTE", tmpDate);
	} */
	
	String new_lms_pati_gy_013_uid   = StringUtil.getRandomUUID();
	 
	// 갱신일 경우 UID 생성
    if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
            "UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
    	lms_pati_gy_013_uid = new_lms_pati_gy_013_uid;
    }
	
    
    
    String chamjojaCod = "";
    String chamjojaNam = "";
%>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui-1.10.4.custom.js"></script>
<script type="text/javascript">
    <%//Particle Data Field Check%>
    
    var frm = document.saveForm<%=sol_mas_uid%>;
	function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
		
		if ("" == frm.lms_pati_gyeyag_tit.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약명", siteLocale))%>");
			frm.lms_pati_gyeyag_tit.focus();
		    return false;
   		}
		<%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %>
		$("#lms_pati_hoesa_nam").val($("select[name='lms_pati_hoesa_cod']").val());
		<%} %>
		frm.lms_pati_gyeyag_cost.value = frm.lms_pati_gyeyag_cost.value.replace(/,/g,"");
        
		return true;	
	}
	function <%="Parti"+mng_pati_uid%>_dataCheck(){
		
		if ("" == frm.lms_pati_gyeyag_tit.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약명", siteLocale))%>");
			frm.lms_pati_gyeyag_tit.focus();
		    return false;
   		}
		
		<%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %>
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
  		if ("" == frm.lms_pati_gyeyag_sangdaebang_nam.value ) {
 			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약상대방", siteLocale))%>");
 			frm.lms_pati_gyeyag_sangdaebang_nam.focus();
 		    return false;	
 		}
  		if($('input[name=lms_pati_rdo_ins_type]:checked').length == 0){
 			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.신규_수정_갱신", siteLocale))%>");
 			$('#lms_pati_rdo_ins_type0').focus();
 			return false;
 		}else {
 			if ("edit" == $('input[name=lms_pati_rdo_ins_type]:checked').val() || "update" == $('input[name=lms_pati_rdo_ins_type]:checked').val() ){
 				if ("" == frm.lms_pati_org_gy_no.value ) {
 					alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.원_계약", siteLocale))%>");
 					frm.lms_pati_org_gy_no.focus();
 				    return false;	
 				}
 			}
 		}
		var reasonChck = function(){
			var bool = true;
			
			if ($("#lms_pati_skip_reason_cod").val() == "") {
				alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.법무검토_생략_사유", siteLocale))%>");
				$("input:radio[name='lms_pati_skip_reason_cod']").eq(0).focus();
				bool = false;
	   		}else if ($("#lms_pati_skip_reason_cod").val() == "SKIP_REASON_ETC") {
				if($("#lms_pati_skip_reason_etc").val() == ""){
					alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.법무검토_생략_사유", siteLocale))%>");
					$("#lms_pati_skip_reason_etc").focus();
					bool = false;
				}
	   		}
			
			return bool;
		}
		
		if(!reasonChck()){
			return false;
		}
		
	
		
		if ("" == airCommon.getEditorValue('lms_pati_geomtoyocheong', "<%=CommonProperties.load("system.editor")%>") ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.품의내용", siteLocale))%>");
			
			airCommon.getEditorFocus('lms_pati_geomtoyocheong', "<%=CommonProperties.load("system.editor")%>");
			
			return false;
		}
		
		
		if(!airCommon.validateAttachFile("LMS/GY/CTR_SIGN")){
			alert("<%=StringUtil.getScriptMessage("M.첨부해주세요",siteLocale, StringUtil.getLocaleWord("L.계약서", siteLocale))%>");
			return false;
		}
		frm.lms_pati_gyeyag_cost.value = frm.lms_pati_gyeyag_cost.value.replace(/,/g,"");
        
		return true;
	}
	
	
	function setSkipInput(val){
		
		if(val == "SKIP_REASON_ETC"){
			$("#lms_pati_skip_reason_etc").show();
		}else{
			$("#lms_pati_skip_reason_etc").val("");
			$("#lms_pati_skip_reason_etc").hide();
			
		}
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
	function doDelContItem(id){
		$("#"+id).remove();
	};	
	
	/* $(function(){
		$("input[name='_attachFileCtrlUuid']").each(function(i, e){
		    if($("input:hidden[name='_attachFileTypeCode']").eq(i).val() == "LMS/GY/CTR_MODI"){
				$("#_attachFileAddButton"+$(e).val()).on('click',function(){
					if(confirm("첨부 하시려면 임시저장을 먼저 하셔야 합니다.\n임시저장 하시겠습니까?")){
						$("a[data-meaning='TEMP']").trigger('click');
						return false;
					}else{
						return false;
					}
				})
			}
		});
	}); */
	$(function(){
		   $( '#lms_pati_hoesin_gihan_dte').datepicker({
			 minDate:+8
			 , beforeShowDay: noSundays
		   });		
		});
		
		
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
<input type="hidden" name="lms_pati_gy_013_uid" value="<%=lms_pati_gy_013_uid%>">
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.계약체결품의",siteLocale)%></caption>
	<tr>
	    <th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.계약명",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<input type="text" class="text width_max" name="lms_pati_gyeyag_tit" id="lms_pati_gyeyag_tit" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_TIT")%>" data-length="200" onblur="airCommon.validateMaxLength(this, 200);airCommon.validateSpecialChars(this);" />
		</td>
	</tr>
	<tr>
		<th class="th4"><%if(LmsUtil.isBeobmuTeamUser(loginUser)){ %><span class="ui_icon required"></span><%} %><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4"> 
			<%--if(LmsUtil.isBeobmuTeamUser(loginUser)){ --%>
			<%if(loginUser.getAuthCodes().contains("CMM_SYS")){ %>
			    <%=HtmlUtil.getSelect(request, true, "lms_pati_hoesa_cod", "lms_pati_hoesa_cod", HOESA_CODESTR, jsonMap.getDefStr("LMS_PATI_HOESA_COD",loginUser.gethoesaCod()), "class=\"select width_max\"")%>
				<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
			<%}else{ %>
				<%= loginUser.gethoesaNam() %>
				<input type="hidden" name="lms_pati_hoesa_cod" value="<%= loginUser.gethoesaCod() %>" />
				<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
			<%} %>
	 	</td>
	 	<th class="th4"><%=StringUtil.getLocaleWord("L.표준계약서_사용여부",siteLocale)%></th>
		<td class="td4"><%=HtmlUtil.getInputRadio(request, true, "lms_pati_pyojun_gyeyagseo_yn", PYOJUNGYEYAGSEO_YN, jsonMap.getDefStr("LMS_PATI_PYOJUN_GYEYAGSEO_YN","Y"), "", "") %></td>
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
	          <span id="lms_pati_yocheong_nam"><%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_KO", loginUser.getNameKo())) %></span>
            <input type="hidden" id="lms_pati_yocheong_id" name="lms_pati_yocheong_id" value="<%=StringUtil.convertForInput(jsonMap.getDefStr("LMS_PATI_YOCHEONG_ID", loginUser.getLoginId())) %>">
            <input type="hidden" name="lms_pati_yocheong_nam_ko" id="lms_pati_yocheong_nam_ko" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_KO", loginUser.getNameKo()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_en" id="lms_pati_yocheong_nam_en" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_EN", loginUser.getNameEn()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_zh" id="lms_pati_yocheong_nam_zh" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_ZH", loginUser.getNameZh()) %>" />
            <input type="hidden" name="lms_pati_yocheong_dpt_cod" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_COD", loginUser.getGroupCode()) %>" />
			<input type="hidden" name="lms_pati_yocheong_dpt_nam" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM_KO", loginUser.getGroupNameKo()) %>" />
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
		</td>
	</tr>
	<% }%>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></span></th>
		<td class="td4"><%=HtmlUtil.getSelect(request, true, "lms_pati_yuhyeong", "lms_pati_yuhyeong", sYuhyeong_list, jsonMap.getString("LMS_PATI_YUHYEONG"), "class=\"select width_max\"")%></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약기간",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_st_dte", "lms_pati_gyeyag_st_dte", jsonMap.getString("LMS_PATI_GYEYAG_ST_DTE"), "") %> ~
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_ed_dte", "lms_pati_gyeyag_ed_dte", jsonMap.getString("LMS_PATI_GYEYAG_ED_DTE"), "") %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약체결일자",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_chegyeol_dte", "lms_pati_chegyeol_dte", jsonMap.getString("LMS_PATI_CHEGYEOL_DTE"), "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약금액",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "lms_pati_tonghwa_cod", "lms_pati_tonghwa_cod", GYEYAG_TONGHWA_COD_CODESTR, jsonMap.getDefStr("LMS_PATI_TONGHWA_COD","KRW"), "class=\"select\"")%>
			<input type="text" name="lms_pati_gyeyag_cost" id="lms_pati_gyeyag_cost" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_COST") %>" maxlength="50" class="text cost"  style="text-align: right;"/>
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale)%></th>
		<td class="td4">
			<%-- <%=HtmlUtil.getSelect(request, true, "lms_pati_gyeyag_sangdaebang_sel_type", "lms_pati_gyeyag_sangdaebang_sel_type", "S|"+StringUtil.getLocaleWord("L.업체검색",siteLocale)+"^W|"+StringUtil.getLocaleWord("L.직접입력",siteLocale), lms_pati_gyeyag_sangdaebang_sel_type, "") %> --%>
			<input type="text" class="text width_max" name="lms_pati_gyeyag_sangdaebang_nam" id="lms_pati_gyeyag_sangdaebang_nam" maxlength="50" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_NAM")%>"  onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);"/>
			<input type="hidden" name="lms_pati_gyeyag_sangdaebang_cod" id="lms_pati_gyeyag_sangdaebang_cod" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_COD") %>" />
			<%-- <input type="button" id="btn_sch_ctp" title="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>" class="btn_search" /> --%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.상대방",siteLocale)%> <%=StringUtil.getLocaleWord("L.상세",siteLocale)%></th>
		<td class="td4">
			<input type="text" class="text width_max" name="lms_pati_gyeyag_sangdaebang_detail" id="lms_pati_gyeyag_sangdaebang_detail" maxlength="50" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_DETAIL")%>" />
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.신규_수정_갱신",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<div style="position:static;">
				<div id="div_ins_type" style="position:static;">
					<table style="border:0;">
						<tr>
							<td>
					<%=HtmlUtil.getInputRadio(request, true, "lms_pati_rdo_ins_type", INS_TYPE_STR, jsonMap.getDefStr("LMS_PATI_RDO_INS_TYPE","new"), "", "style='float:left;'") %> 
							</td>
							<td>
					<div id="div_ins_type_add" style="float:left;display:none;">
						<%=StringUtil.getLocaleWord("L.원계약",siteLocale)%>
						<input type="hidden" name="lms_pati_org_gy_uid" id="lms_pati_org_gy_uid" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_UID") %>" />
						<input type="hidden" name="lms_pati_org_gy_type" id="lms_pati_org_gy_type" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_TYPE") %>" size="20" readonly />
						<input type="text" class="text" name="lms_pati_org_gy_no" id="lms_pati_org_gy_no" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_NO") %>" size="20" readonly />
						<input type="button" id="btn_lms_pati_org_gy_no" title="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>" class="btn_search" />
					</div>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id="div_ins_type_add_msg" style="position:static; display:none;"><span style="color:red;"><%=StringUtil.getLocaleWord("M.신규_변경갱신_입력_코멘트",siteLocale)%></span></div>
			<div style="position:relative; color: red;">* <%=StringUtil.getLocaleWord("M.신규_수정_입력_코멘트",siteLocale)%></div>
			<div style="position:relative; color: red;">* <%=StringUtil.getLocaleWord("M.신규_갱신_입력_코멘트",siteLocale)%></div>		 
		</td>
	</tr>
	<tr>
		<th class="th4"><span><%=StringUtil.getLocaleWord("L.품목",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<input type="text" class="text" name="lms_pati_item" id="lms_pati_item" style="width:40%" value="<%=jsonMap.getString("LMS_PATI_ITEM")%>" maxlength="200"/>
		<span style="color: red;">* <%=StringUtil.getLocaleWord("M.계약품목_안내",siteLocale)%></span>
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.법무검토_생략_사유",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, true, "lms_pati_skip_reason_cod", "lms_pati_skip_reason_cod", LMS_GY_SKIP_REASON_CODESTR,jsonMap.getString("LMS_PATI_SKIP_REASON_COD") ,  "onChange=\"setSkipInput(this.value);\" class=\"select\"")%>
			<input type="text" class="text" name="lms_pati_skip_reason_etc" id="lms_pati_skip_reason_etc" style="width:60%;display: <%="SKIP_REASON_ETC".equals(jsonMap.getString("LMS_PATI_SKIP_REASON_COD"))?"":"none" %>" value="<%=jsonMap.getString("LMS_PATI_SKIP_REASON_ETC")%>"/>
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
		<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.품의내용",siteLocale)%></th>
		<td class="td2" colspan="3"><%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_geomtoyocheong", "lms_pati_geomtoyocheong", StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_GEOMTOYOCHEONG")), "")%></td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.계약서",siteLocale) %></span><br></th>
		<td class="td4">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_SIGN" name="typeCode" />
				<jsp:param value="Y" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids %>" name="defaultMasterDocIds" />
			</jsp:include>
				<%-- <jsp:param value="pdf;jpg;gif;bmp;png;psd;pdd;tif;" name="fileRFilter" /> --%>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련자료",siteLocale) %></th>
		<td class="td4">
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
<script>
$(document).ready(function () {
<%	if("".equals(jsonMap.getString("LMS_PATI_RDO_INS_TYPE")) || "new".equals(jsonMap.getString("LMS_PATI_RDO_INS_TYPE"))){%>
		$('#div_ins_type_add').hide();
		$('#div_ins_type_add_msg').hide();
<%	}else{%>
		$('#div_ins_type_add').show();
		$('#div_ins_type_add_msg').show();
<%	}	%>

});

/**
 * 신규/수정/갱신 선택
 */
$('input[name=lms_pati_rdo_ins_type]').click(function(){
	if($(this).val() == 'new'){
		$('#div_ins_type_add').hide();
		$('#div_ins_type_add_msg').hide();
	}else{
		$('#div_ins_type_add').show();
		$('#div_ins_type_add_msg').show();
	}
});

/**
 * 원 계약번호 클릭
 */
$('#btn_lms_pati_org_gy_no').click(function(){
	var solUids = $('input[name=lms_pati_org_gy_no]').val();
	
	var url = '/ServletController';
	url += '?<%=CommonConstants.ACTION_CODE%>=LMS_GY_LIST_MAS';
	url += '&<%=CommonConstants.MODE_CODE%>=POPUP_ORGGY_GLIST';
	url += '&LMS_PATI_ORG_GY_UIDS='+solUids;
	
	airCommon.openWindow(url, 1024, 700, 'popOrgGyList', 'yes', 'yes' );
});

$(function(){
	//-- 최초 작성 임시저장일떄는 TODO 영역을 가리기 위함
	//-- 그 이유는 삭제 처리가 있어 서로 햇갈리기 때문
	//-- 주석하고 테스트 해보면 알수 있음
	try{
		todoHide<%=sol_mas_uid%>();
	}catch(e){}
	
	$("#lms_pati_gyeyag_sangdaebang_nam").autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			$.ajax({
				url:"/ServletController?AIR_ACTION=LMS_GY_LIST_MAS&AIR_MODE=GYEYAG_SANGDAEBANG_JSON",
				type: "POST",
				dataType:"json",
				data:{
					"GYEYAG_SANGDAEBANG_NAM":$("#lms_pati_gyeyag_sangdaebang_nam").val()
				},
				 success: function( data ) {
					 response( jQuery.map( data, function( item ) {
			              return {
			                //id: item.id,
			            	  value: item.GYEYAG_SANGDAEBANG_NAM,
				                label: item.GYEYAG_SANGDAEBANG_NAM
			              }
			          }));
				 }
			})
	        .fail(function() {
	            //승인처리 도중 에러가 발생했습니다.
	            alert("<%=StringUtil.getLocaleWord("M.처리중오류발생관리자문의하세요",siteLocale, StringUtil.getLocaleWord("L.승인처리", siteLocale))%>");
	        });
		},
		select:function(e, u){
			var data = u.item;
			$("#lms_pati_gyeyag_sangdaebang_nam").val(data.value);
		}
	});
});
</script>