<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%
	//-- 로그인 사용자 정보
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String page_no 			= requestMap.getString(CommonConstants.PAGE_NO); 

	//-- 결과값 셋팅
	BeanResultMap resultMap  		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults menuResult 	 		= resultMap.getResult("MENU_DATA");	

	SQLResults viewResult 	 		= resultMap.getResult("VIEW");
	
	//-- 파라메터 셋팅
	String action_code	= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code	= resultMap.getString(CommonConstants.MODE_CODE);

	String saveMode		= "WRITE_PROC";
	
	String uuid 		= requestMap.getString("UUID");
	String parent_uuid 	= requestMap.getString("PARENT_UUID");
	String title		= "";
	String content		= "";
	String type_code		= "";
	String reg_date		= DateUtil.getCurrentDate();
	String reg_name_ko	= loginUser.getName();
	
	if(viewResult != null && viewResult.getRowCount() > 0){
		content			= viewResult.getString(0, "CONTENT");
		title			= viewResult.getString(0, "TITLE");
		uuid			= viewResult.getString(0, "UUID");
		parent_uuid 	= viewResult.getString(0, "PARENT_UUID");
		type_code		= viewResult.getString(0, "TYPE_CODE");
		reg_date		= viewResult.getString(0, "REG_DATE");
		reg_name_ko		= viewResult.getString(0, "REG_NAME_KO");
		
		
		saveMode 	= "UPDATE_PROC";
	}else{
		uuid = StringUtil.getRandomUUID();
		parent_uuid = uuid;
	}
	//-- 개정 모드일경우 새로운 내용 출력
	if ("UPDATE_VER_FORM".equals(mode_code)) {
		saveMode		= "WRITE_PROC";
		uuid 			= StringUtil.getRandomUUID();
	}
	
	
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	if("UPDATE_VER_FORM".equals(mode_code) ){
		att_master_doc_id 			= uuid;
		att_default_master_doc_Ids 	= requestMap.getString("UUID");
	}else{
		att_master_doc_id 			= uuid;
		att_default_master_doc_Ids 	= "";
	}
	
	
	//-- 코드정보 문자열 셋팅
	
	String GY_YUHYEONG_LIST_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("FAQ_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
%>
<script type="text/javascript">
var setBunryu = function(){ 
	$("#bunryu_nam").val($("#bunryu_cod :selected").text()); 
}

	/**
	 * 목록 페이지로 이동
	 */	
	function goList(frm) {	
		if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_GOLIST",siteLocale)%>")) {
			frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
			frm.action = "/ServletController";
			frm.target = "_self";
			frm.submit();
		}
	}

	/**
	 * 저장
	 */	
	function doSubmit(frm) {		
		if (frm.TITLE.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale, StringUtil.getLocaleWord("L.질문", siteLocale))%>");
			frm.TITLE.focus();
			return;
		}
			
		if (frm.TYPE_CODE.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getLocaleWord("L.유형", siteLocale))%>");
			frm.TYPE_CODE.focus();
			return;
		} 
			 
		
		if ("" == airCommon.getEditorValue('CONTENT', "<%=CommonProperties.load("system.editor")%>") ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.답변", siteLocale))%>");
			
			airCommon.getEditorFocus('CONTENT', "<%=CommonProperties.load("system.editor")%>");
			
			return false;
		}
		
		
		if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.저장", siteLocale))%>")) {
			
			//--에디터 서브밋 처리
			airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
			
				
			frm.<%=CommonConstants.MODE_CODE%>.value = "<%=saveMode%>";
			
			$.ajax({
				url: "/ServletController"
				, type: "POST"
				, async: true
				, cache: false
				, data: $(frm).serialize()
				, dataType: "json"
			}).done(function(){
				alert ("<%=StringUtil.getScriptMessage("M.ALERT_DONE",siteLocale,StringUtil.getLocaleWord("L.처리", siteLocale))%>");

				try {
					opener.doSearch(opener.document.form1);
				} catch(e) {
				}
				window.close();
			}).fail(function(){
				alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
			});		
			
		}
	}
	$(function(){
		
	});
</script>
		<form name="form1" method="post" onSubmit="return false;">
			<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
			<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=mode_code%>"/>
			<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=page_no%>" />
			<input type="hidden" name="UUID" value="<%=uuid%>" />
			<input type="hidden" name="PARENT_UUID" value="<%=parent_uuid%>" />
			
			<table class="basic">
				<caption>자주하는 질문( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale)%>)</caption>
				<tr>
					<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.질문",siteLocale) %></span></th>
					<td class="td2" colspan="3"><input type="text" name="TITLE" id="TITLE" value="<%=StringUtil.convertFor(title, "INPUT")%>" data-length="1000" class="text width_max" /></td>
				</tr>
				<tr>
					<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></span></th>
					<td class="td2" colspan="3">
						<%=HtmlUtil.getSelect(request, true, "TYPE_CODE", "TYPE_CODE", GY_YUHYEONG_LIST_STR, type_code, "class=\"select\"")%>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
					<td class="td4"><%=reg_date%></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
					<td class="td4"><%=reg_name_ko%></td>
				</tr>	
				<tr>
					<th><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.답변", siteLocale) %></span></th>
					<td class="td2" colspan="3"><%=HtmlUtil.getHtmlEditor(request,true, "CONTENT", "CONTENT", content, "" ,"","250", "" )%></td>
				</tr>		
				<tr>
					<th class="th2"><span class="ui_icon"><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></span></th>
					<td class="td2" colspan="3">
						<jsp:include page="/ServletController">
							<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
							<jsp:param value="FILE_WRITE" name="AIR_MODE" />
							<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
							<jsp:param value="LMS" name="systemTypeCode" />
							<jsp:param value="LMS/GY/STD" name="typeCode" />
							<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
							<jsp:param value="Y" name="requiredYn" />
						</jsp:include>
					</td>
				</tr>	
			</table>
		
		<%-- 버튼 목록 --%>
			<div class="buttonlist">
				<div class="right">
					<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:doSubmit(document.form1);"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
				</div>
			</div>  
		</form>