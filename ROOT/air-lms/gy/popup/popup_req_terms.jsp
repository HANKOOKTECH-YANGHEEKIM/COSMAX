<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.emfrontier.air.common.config.CommonProperties"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>

<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");
	String initFunction			= requestMap.getString("INITFUNCTION");
	String mode					= requestMap.getString("MODE");
	/*
	* LGUPLUS 전용
	*  - 장비투자계약 관련 설문조사 파일.
	*  - /air-lms/gy/popup/terms 폴더 하위에 위치함.
	*  - xxxx_term.jsp => 반드시 _term.jsp로 끝나야 RequestFilter에 걸리 지 않습니다.(다음버전 파일 만들다 꼭 참고!!)
	*/
	String versionFileNm 	= CommonProperties.load("terms_file.name");
	boolean isNew				= false; //--신규 작성여부
	if(StringUtil.isNotBlank(requestMap.getString("LMS_PATI_VERSION_FILE_NM"))){
		versionFileNm		= requestMap.getString("LMS_PATI_VERSION_FILE_NM");
	}
	
	if("write".equals(mode)){
		isNew			= true;
	}
	//-- 결과값 셋팅
	BeanResultMap responseMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	//-- 파라메터 셋팅
	String actionCode 			= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= responseMap.getString(CommonConstants.MODE_CODE);
	
	String fullPath = "/air-lms/gy/popup/terms/"+versionFileNm;
%>
<script>
var doSubmit = function(){
	if(validation()){
		var json = {};
		json["lms_pati_version_file_nm"] = $("#lms_pati_version_file_nm").val();
		var headerTxt = "";
		var $radio = $("input:radio:checked");
		var radioJson = {};
		$($radio).each(function(i, e){
			if(i > 0)headerTxt += "/";
			headerTxt += $(e).data("term")+"-"+$(e).val();
			radioJson[$(e).attr("name")] =  $(e).val();
		});
		
		json["lms_pati_radios"] =  JSON.stringify(radioJson);
		json["lms_pati_terms_nm"] =  headerTxt;
		try{
			opener.<%=callbackFunction%>(JSON.stringify(json));
			window.close();
		}catch(e){
			alert("선택 적용에 문제 발생 하였습니다.\n관리자에게 문의 하세요.");	
		}
	}
		
}
<%
if(StringUtil.isNotBlank(initFunction)){
%>
$(function(){
	var init = opener.<%=initFunction%>();
	if(init){
		init  = JSON.parse(init);
		var radios = init["lms_pati_radios"];
		if(radios){
			radios = JSON.parse(radios);
			$.each(radios, function(k, v){
				k = k.toLowerCase();
				$("input:radio[name='"+k+"'][value='"+v+"']").prop("checked", true);
			});
		}
	}
	
});
<%
}
%>
</script>
<form id="termForm">

	<input type="hidden" name="lms_pati_version_file_nm" id="lms_pati_version_file_nm" value="<%=versionFileNm%>"/>
	<jsp:include page="<%=fullPath %>" />

</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    <%if(isNew){ %>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="doSubmit();"><%=StringUtil.getLocaleWord("B.선택완료",siteLocale)%></a></span>
    <%}else{ %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    <%} %>
    </div>
</div>	