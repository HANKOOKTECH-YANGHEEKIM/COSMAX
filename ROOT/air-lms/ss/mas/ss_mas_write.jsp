<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField  	= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod 	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults YUHYEONG02_LIST = resultMap.getResult("YUHYEONG02_LIST");
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();

	String sol_mas_uid = requestMap.getString("SOL_MAS_UID");
	String ss_mas_uid = jsonMap.getString("SS_MAS_UID");
	String temp_ss_mas_uid = StringUtil.getRandomUUID();
	String doc_mas_uid = jsonMap.getString("DOC_MAS_UID");

	boolean isNew = false;
	if(StringUtil.isBlank(sol_mas_uid)){
		doc_mas_uid = StringUtil.getRandomUUID();
		sol_mas_uid = StringUtil.getRandomUUID();
		isNew = true;
	}
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	
	//첨부관련 셋팅
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	if(isNew){
		att_master_doc_id 			= temp_ss_mas_uid;
		att_default_master_doc_Ids 	= "";
	}else{
		att_master_doc_id 			= ss_mas_uid;
		att_default_master_doc_Ids 	= ss_mas_uid;
	}
	
	// 각종 코드정보문자열 셋팅
	String BANSO_YN_CODESTR = LmsUtil.getYnCodStr();
	String JUNGYO_YN_CODESTR = LmsUtil.getYnCodStr();
	
	String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));// + "^SJ/HJ|심급/확정종결";
	String GUBUN1_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN_LIST"), "CODE_ID,LANG_CODE", "");
	
	//String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	
	String DANGSAJA_JIWI_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DANGSAJA_JIWI_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String GYEOLGWA_COD_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_COD_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String YUHYEONG01_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("YUHYEONG01_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));	
	String YUHYEONG02_CODESTR = "";
	if(YUHYEONG02_LIST != null && YUHYEONG02_LIST.getRowCount() > 0){
		YUHYEONG02_CODESTR = StringUtil.getCodestrFromSQLResults(YUHYEONG02_LIST, "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	}else{
		YUHYEONG02_CODESTR = "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	}
	
%>
<form name="saveForm" id="saveForm" method="POST" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="ss_mas_uid" value="<%=ss_mas_uid%>" />
	<input type="hidden" name="temp_ss_mas_uid" value="<%=temp_ss_mas_uid%>" />
	<input type="hidden" name="doc_mas_uid" value="<%=doc_mas_uid%>" />
	<input type="hidden" name="is_new" value="<%=isNew%>" />
	<input type="hidden" name="stu_id_yn" value="" />
	
	
	<table class="basic">
		<caption><%=StringUtil.getLocaleWord("L.기본정보",siteLocale) %>( <input type="button" class="required" tabindex="-1" /><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale) %>)</caption>
		<tr>
			<th	class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.사건명", siteLocale) %></span></th>
			
			<%
				String langSetJePum 	= "["+StringUtil.getLocaleWord("L.제품명",siteLocale)+"]";
			  	String sagunNm 		= "["+StringUtil.getLocaleWord("L.사건명",siteLocale)+"]";
			%>
			<td	class="td2" colspan="3"><input type="text" name="lms_pati_sageon_tit" placeholder="<%= langSetJePum+sagunNm %>" id="lms_pati_sageon_tit" maxlength="100" class="text width_max" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_SAGEON_TIT")) %>" /></td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.회사", siteLocale) %></th>
			<td>
				<% if(loginUser.getAuthCodes().contains("CMM_SYS")){ %>
						<%=HtmlUtil.getSelect(request,true, "lms_pati_hoesa_cod", "lms_pati_hoesa_cod", HOESA_CODESTR, jsonMap.getString("LMS_PATI_HOESA_COD"), "onchange=\"$('#lms_pati_hoesa_nam').val($(this).find('option:selected').text())\" class=\"select width_max\"")%>
						<input type="hidden" name="lms_pati_hoesa_nam" id="lms_pati_hoesa_nam" value="<%=jsonMap.getString("LMS_PATI_HOESA_NAM")%>"/>
				<% }else{%>
						<%=HtmlUtil.getSelect(request, false, "lms_pati_hoesa_cod", "lms_pati_hoesa_cod", HOESA_CODESTR, loginUser.gethoesaCod(), "data-type=\"search\" class=\"select width_half\"").replace("C.", "")  %>
						<input type="hidden" name="lms_pati_hoesa_cod" id="lms_pati_hoesa_cod" value="<%=loginUser.gethoesaCod()%>"/>
						<input type="hidden" name="lms_pati_hoesa_nam" id="lms_pati_hoesa_nam" value="<%=loginUser.gethoesaNam()%>"/>
				<%} %>
				
			</td>
			<th><%=StringUtil.getLocaleWord("L.유형", siteLocale) %></th>
			<td>
				<script>
				//유형(1차) 변경 이벤트 처리  
				 function _changeYuhyeong01(targetId, val){
					var data = {};
					data["PARENT_CODE_ID"] = val;
					data["STAUS_CODE"] = "N";
					airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
						
						airCommon.initializeSelectJson(targetId, json, "|--<%=StringUtil.getLang("L.선택",siteLocale) %>--", "CODE_ID", "<%=siteLocale%>");
					});
					
					$('#LMS_PATI_YUHYEONG01_NAM').val( $('#lms_pati_yuhyeong01_cod').find('option:selected').text());
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
				
				<%=HtmlUtil.getSelect(request, true, "lms_pati_yuhyeong01_cod", "lms_pati_yuhyeong01_cod", YUHYEONG01_CODESTR, jsonMap.getString("LMS_PATI_YUHYEONG01_COD"), "onchange=\"_changeYuhyeong01('lms_pati_yuhyeong02_cod', this.value); setRecView(this.value)\" class=\"select width_half\"")%>
				<%=HtmlUtil.getSelect(request, true, "lms_pati_yuhyeong02_cod", "lms_pati_yuhyeong02_cod", YUHYEONG02_CODESTR, jsonMap.getString("LMS_PATI_YUHYEONG02_COD"), "onchange=\"$('#LMS_PATI_YUHYEONG02_NAM').val($(this).find('option:selected').text())\" class=\"select width_half\"")%>
				<input type="hidden" name="LMS_PATI_YUHYEONG01_NAM" id="LMS_PATI_YUHYEONG01_NAM" value="<%=jsonMap.getString("LMS_PATI_YUHYEONG01_NAM")%>"/>
				<input type="hidden" name="LMS_PATI_YUHYEONG02_NAM" id="LMS_PATI_YUHYEONG02_NAM" value="<%=jsonMap.getString("LMS_PATI_YUHYEONG02_NAM")%>"/>
				<input type="text" style="display:<%if(!jsonMap.getString("LMS_PATI_YUHYEONG01_COD").endsWith("ETC")){%>none<%} %>;" name="lms_pati_yuhyeong_etc" id="lms_pati_yuhyeong_etc" placeholder="<%=StringUtil.getLocaleWord("L.기타입력사항", siteLocale) %>" value="<%=jsonMap.getStringView("LMS_PATI_YUHYEONG_ETC")%>" maxlength="30" class="text width_max" />
			</td>
		</tr>
			
		<tr>
			<th><%=StringUtil.getLocaleWord("L.권리자", siteLocale) %></th>
			<td><input type="text" name="LMS_PATI_GWONRIJA" id="LMS_PATI_GWONRIJA" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_GWONRIJA"))%>" style="width:98%"  /></td>
			<th><%=StringUtil.getLocaleWord("L.출원번호", siteLocale) %></th>
			<td><input type="text" name="LMS_PATI_CHURWONBEONHO" id="LMS_PATI_CHURWONBEONHO" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CHURWONBEONHO"))%>" style="width:98%" /></td>
		</tr>	
			
		<tr>
			<th><%=StringUtil.getLocaleWord("L.원고", siteLocale) %></th>
			<td><input type="text" name="LMS_PATI_WEONGO_NM" id="LMS_PATI_WEONGO_NM" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_WEONGO_NM"))%>" style="width:98%"  /></td>
			
			<th><%=StringUtil.getLocaleWord("L.피고", siteLocale) %></th>
			<td><input type="text" name="LMS_PATI_PIGO_NM" id="LMS_PATI_PIGO_NM" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_PIGO_NM"))%>" style="width:98%"  /></td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.제품명", siteLocale) %></th>
			<td><input type="text" name="LMS_PATI_JEPUMMYEONG" id="LMS_PATI_JEPUMMYEONG" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_JEPUMMYEONG"))%>" style="width:98%"  /></td>
			
			<th><%=StringUtil.getLocaleWord("L.등록번호", siteLocale) %></th>
			<td><input type="text" name="LMS_PATI_DEUNGNOKBEONHO" id="LMS_PATI_DEUNGNOKBEONHO" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_DEUNGNOKBEONHO"))%>" style="width:98%"  /></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.분쟁",siteLocale) %><%=StringUtil.getLocaleWord("L.소송가액",siteLocale) %></th>
			<td class="td4">
				<input type="text" name="LMS_PATI_SOSONGGA_COST" id="LMS_PATI_SOSONGGA_COST" value="<%=StringUtil.getFormatCurrency(jsonMap.getString("LMS_PATI_SOSONGGA_COST"),-1) %>" maxlength="20" onKeyUp="airCommon.getFormatCurrency(this,2,true)" style="width:200px" />
				<%=HtmlUtil.getSelect(request,true, "LMS_PATI_SOSONGGA_GUBUN", "LMS_PATI_SOSONGGA_GUBUN", strCurGubunList, jsonMap.getDefStr("LMS_PATI_SOSONGGA_GUBUN","KRW"), "class=\"select \" ") %>
			</td>
			<th class="th4"></th>
			<td></td>
		</tr>
		
		<tr>
			<th><%=StringUtil.getLocaleWord("L.사건개요", siteLocale) %></th>
			<td colspan="3">
				<textarea rows="10" name="lms_pati_sageongaeyo" id="lms_pati_sageongaeyo" class="text width_max" style="width:99%; height:230px;"><%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_SAGEONGAEYO")) %></textarea>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    	
    	<% if("TRUE".equals(resultMap.getString("STU_ID_YN"))){ %>
			<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goEndSosong();"><%=StringUtil.getLocaleWord("B.소송종료",siteLocale)%></a></span>
		<% }%>
    </div>
</div>	
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
<script>
/*
관련계약건 삭제
*/
function doDelContItem(id){
	$("#"+id).remove();
};	
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

var goProc = function(){
	var frm = document.saveForm;
	//1. 소송/분쟁 기본정보 시작
	if ("" == frm.lms_pati_sageon_tit.value ) {
  		alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.사건명", siteLocale))%>");
		frm.lms_pati_sageon_tit.focus();
		return false;
	}

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "MAS_WRITE_PROC", $(frm).serialize() , function(json){
		
		<%if(!isNew){%>
			opener.location.href = opener.location.href;
		<%}%>
			try{
				try{
					opener.opener.doSearch();	//--리스트 대응
				} catch(e) {
				}
				opener.doSearch();
			}catch(e){
				try{
					opener.opener.initMain(); //--메인화면일때 대응
				}catch(e){
					
				}
			}
			
			window.close();
		});
	}
};


var goEndSosong = function(){
	var frm = document.saveForm;
	frm.stu_id_yn.value = "Y";
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.소송종료")%>")){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
			var data = $("#saveForm").serialize();
			airCommon.callAjax("<%=actionCode%>", "MAS_WRITE_PROC", $(frm).serialize() , function(json){
				opener.refreshWindow();
				window.close();
		});
	}
};

</script>