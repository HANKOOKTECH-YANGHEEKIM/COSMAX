<%@page import="java.util.Map"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
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
	
	
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults REL_LIST			= resultMap.getResult("REL_LIST");

	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	//검토결과 내용이 있는 경우 DDD-LMS-GY-003 없을 경우 DDD-LMS-GY-001 
	String content_type = (String)resultMap.get("CONTENT_TYPE");
	
	String lms_pati_gy_008_uid = jsonMap.getString("LMS_PATI_GY_008_UID");
	
	String hoesa_cd = "";
	String group_cd = "";
	String group_name = "";
	String group_name_ko= "";
	String group_name_en = "";
	
	String chamjojaCod = "";
    String chamjojaNam = "";
    //if (!"UPDATE_FORM_SAVE_INCLUDE".equals(doc_mas_mode_code)){
	    /* SQLResults rsChamjojaCod = resultMap.getResult("CHAMJOJA_COD_LIST");
	    if(rsChamjojaCod != null && rsChamjojaCod.getRowCount() > 0){
		    chamjojaCod	= StringUtil.convertNull(rsChamjojaCod.getString(0, "CHAMJOJA_COD"));
		    chamjojaNam	= StringUtil.convertNull(rsChamjojaCod.getString(0, "CHAMJOJA_NAM")); 
	    }  */ 
	//}
	
	String new_lms_pati_gy_008_uid = StringUtil.getRandomUUID();
	
	// 갱신일 경우 UID 생성
	if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || 
			"UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){
		lms_pati_gy_008_uid = new_lms_pati_gy_008_uid;
	}
	
	 
	String GUGNAEOE_COD_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUGNAEOE_CODE_LIST"), "CODE,LANG_CODE", ""));
	//계약유형
	String sYuhyeong_list = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GY_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)); 
	//언어선택
	String EONEO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("PCODEID_GY_EONEO_LIST"), "CODE,LANG_CODE", "");
	// 회사선택
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "");
	// 계약유형코드 - 국내/국제 선택에 따라 ajax로 조회
	String GYEYAG_YUHYEONG_CODESTR = "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	String SIGUBDO_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIGUBDO_CODE_LIST"), "CODE,LANG_CODE", ""));
	String GYEYAG_TONGHWA_COD_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("TONGHWA_CODE_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)));
	String INS_TYPE_STR = "new|" + StringUtil.getLocaleWord("L.신규2",siteLocale) + "^edit|" + StringUtil.getLocaleWord("L.수정2",siteLocale) + "^update|" + StringUtil.getLocaleWord("L.갱신2",siteLocale);
	String PYOJUNGYEYAGSEO_YN = "Y|" + StringUtil.getLocaleWord("L.사용",siteLocale) + "^N|" + StringUtil.getLocaleWord("L.미사용",siteLocale);
	
	//보안등급
	String LMS_BOANSTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMS_BOAN"), "CODE,LANG_CODE", "");
		
	
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
		//var comboHidden = $(".combo").find("input:hidden");
		var stday = frm.lms_pati_gyeyag_st_dte.value;  // 계약시작일자
		var edday = frm.lms_pati_gyeyag_ed_dte.value;  // 계약종료일자
		
		if("" == frm.lms_pati_gyeyag_tit.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약명", siteLocale))%>");
			frm.lms_pati_gyeyag_tit.focus();
		    return false;		 
		}
		if ("" == frm.lms_pati_yuhyeong.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.유형", siteLocale))%>");
			frm.lms_pati_yuhyeong.focus();
		    return false;
	    }
		if ($('input[name=lms_pati_pyojun_gyeyagseo_yn]:checked').length == 0) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.표준계약서_사용여부", siteLocale))%>");
			$('#lms_pati_pyojun_gyeyagseo_yn0').focus();
		    return false;
		}
		if ("" == frm.lms_pati_gyeyag_sangdaebang_nam.value ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약상대방", siteLocale))%>");
			frm.lms_pati_gyeyag_sangdaebang_nam.focus();
		    return false;
		}
		<%-- 
		if (0 == $("input:radio[name='lms_pati_boan_dunggub']:checked").length) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.보안등급", siteLocale))%>");
			$("input:radio[name='lms_pati_boan_dunggub']").eq(0).focus();
		    return false;
   		}
		if ("" == frm.lms_pati_hoesa_cod.value ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.회사", siteLocale))%>");
			frm.lms_pati_hoesa_cod.focus();
			return false;	 
		}
		
		if ("" == frm.lms_pati_gyeyag_sangdaebang_nam.value ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약상대방", siteLocale))%>");
			frm.lms_pati_gyeyag_sangdaebang_nam.focus();
		    return false;
		}
		
		if ("" !=stday && "" != edday ){
			if(stday > edday) {
			    alert ("<%=StringUtil.getScriptMessage("M.ALERT_WRONG",siteLocale,StringUtil.getLocaleWord("L.계약기간", siteLocale))%>");
			    frm.lms_pati_gyeyag_ed_dte.focus();
		        return false;	
			 }
		}else{
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약기간", siteLocale))%>");
		    frm.lms_pati_gyeyag_st_dte.focus();
	        return false;
		}
		
		if ("" == frm.lms_pati_gyeyag_cost.value ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약금액", siteLocale))%>");
			frm.lms_pati_gyeyag_cost.focus();
			return false;	 
		}
		if ($('input[name=lms_pati_eoneo_cod]:checked').length == 0) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.언어", siteLocale))%>");
			$('#lms_pati_eoneo_cod0').focus();
		    return false;
		}
		 --%>
		
		 
		<%-- 
		if ("" == frm.lms_pati_yuhyeong.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.유형", siteLocale))%>");
			frm.lms_pati_yuhyeong.focus();
		    return false;	
		}
		 --%>
		if($('input[name=lms_pati_rdo_ins_type]:checked').length == 0){
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.신규_수정_갱신", siteLocale))%>");
			$('#lms_pati_rdo_ins_type0').focus();
			return false;
		}
		
		if ("" == airCommon.getEditorValue('lms_pati_rvw_rsl', "<%=CommonProperties.load("system.editor")%>") ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.검토결과", siteLocale))%>");
			
			airCommon.getEditorFocus('lms_pati_rvw_rsl', "<%=CommonProperties.load("system.editor")%>");
			
			return false;
		}
		
        if(!airCommon.validateAttachFile("LMS/GY/CTR_END")){
			alert("<%=StringUtil.getScriptMessage("M.첨부해주세요",siteLocale, StringUtil.getLocaleWord("L.검토완료계약서", siteLocale))%>");
			return false;
		}
        
		<%-- 
		}else if (comboHidden.length == 0 ) {
			alert ("<%=StringUtil.getLocaleWord("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.회사", siteLocale))%>");
			$(".combo").find("input:text").focus();
			return false; 
		}
		 --%>


		frm.lms_pati_gyeyag_cost.value = frm.lms_pati_gyeyag_cost.value.replace(/,/g,"");
		
		return true;
	}
	
	function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
  		if ("" == frm.lms_pati_gyeyag_tit.value) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.계약명", siteLocale))%>");
			frm.lms_pati_gyeyag_tit.focus();
		    return false;	
		}
  		
  		frm.lms_pati_gyeyag_cost.value = frm.lms_pati_gyeyag_cost.value.replace(/,/g,"");
  		
  		return true;
  	}
	
	/**
	 * 관련계약서 선택 팝업
	 */  
	var popupRelSelect =  function(frm) {
		
		var sol_mas_uid = "<%=sol_mas_uid%>";
		var callbackFunction = "setRelMas";
		
		airLms.popupRelSelect(sol_mas_uid, "GY", callbackFunction);
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
	
	/* function Space_All(str)
	{
		var index, len;
	
		while(true)
		{
			index = str.indexOf(" ");
			// 공백이 없으면 종료합니다.
			if (index == -1) break;
			// 문자열 길이를 구합니다.
			len = str.length;
			// 공백을 잘라냅니다.
			str = str.substring(0, index) + str.substring((index+1),len);
		}
		$("#lms_pati_gyeyag_sangdaebang_nam").val(str);
	} */
	
 
	
	$(function(){
		$(".combo").find("input:text").attr("readonly","readonly");
	});
	
	
	
</script>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui-1.10.4.custom.js"></script>
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
<input type="hidden" name="lms_pati_gy_008_uid" value="<%=lms_pati_gy_008_uid%>" />
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.계약검토결과_등록",siteLocale)%> ( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale)%>)</caption>
	<%--  
	<tr>
	    <th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.보안등급",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<%=HtmlUtil.getInputRadio(request, true, "lms_pati_boan_dunggub", LMS_BOANSTR, jsonMap.getDefStr("LMS_PATI_BOAN_DUNGGUB","LMS_BOAN_IB_NOSHA"), "", "") %><br />
			<span style="color:red">
				<%=StringUtil.getLocaleMessage("M.보안등급_알림", siteLocale) %>
			</span>
		</td>
	</tr>	
	 --%>	
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.계약명",siteLocale)%></span></th>
		<td class="td4" colspan="3"><input type="text" class="text width_max" name="lms_pati_gyeyag_tit" id="lms_pati_gyeyag_tit" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_GYEYAG_TIT"))%>"  data-length="200" onblur="airCommon.validateMaxLength(this, 200);airCommon.validateSpecialChars(this);" /></td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></span></th>
		<td class="td4"><%=HtmlUtil.getSelect(request, true, "lms_pati_yuhyeong", "lms_pati_yuhyeong", sYuhyeong_list, jsonMap.getString("LMS_PATI_YUHYEONG"), "class=\"select width_max\"")%></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.표준계약서_사용여부",siteLocale)%></th>
		<td class="td4"><%=HtmlUtil.getInputRadio(request, true, "lms_pati_pyojun_gyeyagseo_yn", PYOJUNGYEYAGSEO_YN, jsonMap.getDefStr("LMS_PATI_PYOJUN_GYEYAGSEO_YN","N"), "", "") %></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.계약기간",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_st_dte", "lms_pati_gyeyag_st_dte", jsonMap.getString("LMS_PATI_GYEYAG_ST_DTE"), "") %> ~
			<%= HtmlUtil.getInputCalendar(request, true, "lms_pati_gyeyag_ed_dte", "lms_pati_gyeyag_ed_dte", jsonMap.getString("LMS_PATI_GYEYAG_ED_DTE"), "") %>
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
			<input type="text" class="text width_max" name="lms_pati_gyeyag_sangdaebang_nam" id="lms_pati_gyeyag_sangdaebang_nam" maxlength="50" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_NAM")%>" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);"/>
			<input type="hidden" name="lms_pati_gyeyag_sangdaebang_cod" id="lms_pati_gyeyag_sangdaebang_cod" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_COD") %>" />
			<%-- <input type="button" id="btn_sch_ctp" title="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>" class="btn_search" /> --%>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.상대방",siteLocale)%> <%=StringUtil.getLocaleWord("L.상세",siteLocale)%></th>
		<td class="td4">
			<input type="text" class="text width_max" name="lms_pati_gyeyag_sangdaebang_detail" id="lms_pati_gyeyag_sangdaebang_detail" maxlength="50" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_DETAIL")%>" />
		</td>
	</tr>
	<%-- 
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4">
			<input type="hidden" name="lms_pati_hoesa_cod" id="lms_pati_hoesa_cod" value="<%=jsonMap.getString("LMS_PATI_HOESA_COD")%>"/>
			<input type="text" style="border: 0px;" readonly="readonly" name="lms_pati_hoesa_nam" id="lms_pati_hoesa_nam" value="<%=jsonMap.getString("LMS_PATI_HOESA_NAM")%>"/>
		</td>
		<th class="th4"><!-- <span class="ui_icon required"></span> --><%=StringUtil.getLocaleWord("L.계약상대방",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "lms_pati_gyeyag_sangdaebang_sel_type", "lms_pati_gyeyag_sangdaebang_sel_type", "S|"+StringUtil.getLocaleWord("L.업체검색",siteLocale)+"^W|"+StringUtil.getLocaleWord("L.직접입력",siteLocale), lms_pati_gyeyag_sangdaebang_sel_type, "") %>
			<input type="text" class="text width_max" name="lms_pati_gyeyag_sangdaebang_nam" id="lms_pati_gyeyag_sangdaebang_nam" data-length="100"  value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_NAM")%>" onchange="Space_All(this.value);" onblur="airCommon.validateMaxLength(this, 100);airCommon.validateSpecialChars(this);"/>
			<input type="hidden" name="lms_pati_gyeyag_sangdaebang_cod" id="lms_pati_gyeyag_sangdaebang_cod" value="<%=jsonMap.getString("LMS_PATI_GYEYAG_SANGDAEBANG_COD") %>" />
			<input type="button" id="btn_sch_ctp" title="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>" class="btn_search" />
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.언어",siteLocale)%></span></th>
		<td class="td4">
			<input type="hidden" name="lms_pati_eoneo_nam" id="lms_pati_eoneo_nam" />
			<%=HtmlUtil.getInputRadio(request, true, "lms_pati_eoneo_cod", EONEO_CODESTR, jsonMap.getString("LMS_PATI_EONEO_COD"), "", "") %>
		</td>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.표준계약서_사용여부",siteLocale)%></span></th>
		<td class="td4"><%=HtmlUtil.getInputRadio(request, true, "lms_pati_pyojun_gyeyagseo_yn", PYOJUNGYEYAGSEO_YN, jsonMap.getString("LMS_PATI_PYOJUN_GYEYAGSEO_YN"), "", "") %></td>		
	</tr>
	 --%>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.신규_수정_갱신",siteLocale)%></span></th>
		<td class="td4" colspan="3">
<%-- 			<span style="color: red;"><%=StringUtil.getLocaleWord("L.신규_수정_갱신_입력_코멘트",siteLocale)%></span> --%>
			<div id="div_ins_type" style="float:left;width:180px;">
				<%=HtmlUtil.getInputRadio(request, true, "lms_pati_rdo_ins_type", INS_TYPE_STR, jsonMap.getDefStr("LMS_PATI_RDO_INS_TYPE","new"), "", "") %>
			</div>
			<div id="div_ins_type_add" style="float:left;display:none;">
				<%=StringUtil.getLocaleWord("L.원_계약",siteLocale)%>
				<input type="hidden" name="lms_pati_org_gy_uid" id="lms_pati_org_gy_uid" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_UID") %>" />
				<input type="hidden" name="lms_pati_org_gy_type" id="lms_pati_org_gy_type" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_TYPE") %>" size="20" readonly />
				<input type="text" class="text" name="lms_pati_org_gy_no" id="lms_pati_org_gy_no" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_NO") %>" size="20" readonly />
				<input type="button" id="btn_lms_pati_org_gy_no" title="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>" class="btn_search" />
			</div>
			
		</td>
	</tr>
	<tr>
		<th class="th4"><span><%=StringUtil.getLocaleWord("L.품목",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<input type="text" class="text width_max" name="lms_pati_item" id="lms_pati_item" style="width:40%" value="<%=jsonMap.getString("LMS_PATI_ITEM")%>" maxlength="200"/>
<%-- 		<span style="color: red;">* <%=StringUtil.getLocaleWord("M.품목_안내",siteLocale)%></span> --%>
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
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td4" colspan="3">
		    <span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="popupRelSelect();"><%=StringUtil.getLocaleWord("B.SELECT",siteLocale)%></a></span>
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
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.검토결과",siteLocale)%></span></th>
		<td class="td4" colspan="3">
			<%=HtmlUtil.getHtmlEditor(request,true, "lms_pati_rvw_rsl", "lms_pati_rvw_rsl", StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_RVW_RSL")), "")%>
<%-- 			<textarea class="memo width_max" name="lms_pati_rvw_rsl" id="lms_pati_rvw_rsl" onblur="airCommon.validateSpecialChars(this);airCommon.validateMaxLength(this, 4000);" style="height: 250px;"><%=StringUtil.convertForEditor(jsonMap.getString("LMS_PATI_RVW_RSL"))%></textarea> --%>
		</td>
	</tr> 
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.검토완료계약서",siteLocale) %></span></th>
		<td class="td4" colspan="3">
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/GY/CTR_END" name="typeCode" />
				<jsp:param value="Y" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>	
	</tr>		
</table>
<script type="text/javascript">

$(document).ready(function () {

<%	if("".equals(jsonMap.getString("LMS_PATI_RDO_INS_TYPE")) || "new".equals(jsonMap.getString("LMS_PATI_RDO_INS_TYPE"))){%>
		$('#div_ins_type_add').hide();
<%	}else{%>
		$('#div_ins_type_add').show();
<%	}	%>


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

/**
 * 신규/수정/갱신 선택
 */
$('input[name=lms_pati_rdo_ins_type]').click(function(){
	if($(this).val() == 'new'){
		$('#div_ins_type_add').hide();
	}else{
		$('#div_ins_type_add').show();
	}
});



/**
 * 원 계약번호 클릭
 */
$('#btn_lms_pati_org_gy_no').click(function(){
	var solUids = $('input[name=lms_pati_org_gy_no]').val();
	
// 	var url = '/ServletController';
<%-- 	url += '?<%=CommonConstants.ACTION_CODE%>=LMS_GY_LIST_MAS'; --%>
<%-- 	url += '&<%=CommonConstants.MODE_CODE%>=POPUP_ORGGY_GLIST'; --%>
// 	url += '&ORG_GY_UIDS='+solUids;
	
// 	airCommon.openWindow(url, 1024, 700, 'popOrgGyList', 'yes', 'yes' );
	
	var solUids = $('input[name=lms_pati_org_gy_no]').val();
	
	var url = '/ServletController';
	url += '?<%=CommonConstants.ACTION_CODE%>=LMS_GY_LIST_MAS';
	url += '&<%=CommonConstants.MODE_CODE%>=POPUP_ORGGY_GLIST';
	url += '&LMS_PATI_ORG_GY_UIDS='+solUids;
	
	airCommon.openWindow(url, 1024, 700, 'popOrgGyList', 'yes', 'yes' );
});

/**
 * 계약상대방 입력방식 변경시
 */
$('#lms_pati_gyeyag_sangdaebang_sel_type').change(function(){
	if($('#lms_pati_gyeyag_sangdaebang_sel_type option:selected').val() == "S"){
		$('#lms_pati_gyeyag_sangdaebang_cod').val('');
		$('#lms_pati_gyeyag_sangdaebang_nam').val('');
		$('#lms_pati_gyeyag_sangdaebang_nam').attr('readOnly',true);
		$('#btn_sch_ctp').show();
		
	}else if($('#lms_pati_gyeyag_sangdaebang_sel_type option:selected').val() == "W"){
		$('#lms_pati_gyeyag_sangdaebang_cod').val('');
		$('#lms_pati_gyeyag_sangdaebang_nam').val('');
		$('#lms_pati_gyeyag_sangdaebang_nam').attr('readOnly',false);
		$('#btn_sch_ctp').hide();
		
	}
});

/**
 * 계약상대방 오픈창
 */
$('#btn_sch_ctp').click(function(){
	var url = "/ServletController";
	url += "?<%=CommonConstants.ACTION_CODE%>=SYS_COMPANY";
	url += "&<%=CommonConstants.MODE_CODE%>=POPUP_SELECT";
	url += "&classCodes=VD";
	url += "&callbackFunction=" + escape("callbackCTP(\'[CODE]\',\'[NAME]\')");
	
	airCommon.openWindow(url, 1024, 500, 'popCTP', 'yes', 'no', '');
});

/**
 * 계약상대방 오픈창 callback function
 */
function callbackCTP(code, name){
	$('#lms_pati_gyeyag_sangdaebang_cod').val(code);
	$('#lms_pati_gyeyag_sangdaebang_nam').val(name);
}

/**
 * 자동갱신 여부 선택
 */
$("#lms_pati_jadong_ext_yn").on('change',function(){
	if($(this).val() == "Y"){
		$('#span_jadong_ext_dte').show();
	}else{
		$('#span_jadong_ext_dte').hide();
	}
});
</script>