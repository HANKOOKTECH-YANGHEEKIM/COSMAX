<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>

<%@page import="com.emfrontier.air.lms.def.util.StuUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();


	//-- 결과값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	
	String sol_mas_uid		= requestMap.getString("SOL_MAS_UID");
	String doc_mas_uid		= requestMap.getString("DOC_MAS_UID");
	String update_type		= requestMap.getString("UPDATE_TYPE");
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	String munseo_seosig_no = requestMap.getString("MUNSEO_SEOSIG_NO");
	
	SQLResults DATA_LIST = resultMap.getResult("DATA_LIST");
	
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0)lmsMap.putAll(LMS_MAS.getRowResult(0));
	boolean isAuths = false;
	
	//해당 단계의 담당자 이거나 시스템관리자 이면...
	//if(loginUser.getLoginId().equals(lmsMap.getString("YOCHEONG_ID")) ||
	if(loginUser.getLoginId().equals(lmsMap.getString("DAMDANG_ID")) ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
	
	/* if(loginUser.isUserAuth("LMS_BJD")){
		isAuths = true;
	} */
	
	
	//한번이라도 결재 한 사람 이면
	if(!isAuths && update_type.equals("GYEOL")){
		SQLResults LINE_TODO = resultMap.getResult("LINE_TODO");
		if(LINE_TODO != null && LINE_TODO.getRowCount() > 0){
			if(loginUser.getLoginId().equals(LINE_TODO.getString(0, "APR_ID")) 
			){
				isAuths = true;
			}
		}
	}
	
	if(DATA_LIST != null && DATA_LIST.getRowCount() > 0){
		munseo_seosig_no = DATA_LIST.getString(0, "MUNSEO_SEOSIG_NO");
	}
%>
<script type="text/javascript">
$(function(){
	<%if(!isAuths){%>
	alert("<%=StringUtil.getLocaleWord("M.문서수정권한없음", siteLocale)%>");
	window.close();
	<%}%>
});
</script>
<%if(isAuths){ %>
<div style="border: 1px solid #dcdcdc; border-bottom:0px !important; padding:5px;">
<jsp:include page="/ServletController" flush="false">
	<jsp:param value="SYS_FORM" 	    name="AIR_ACTION"/>
	<jsp:param value="WRITE_FORM_INCLUDE" 	    name="AIR_MODE"/>
	<jsp:param value="<%=munseo_seosig_no%>" 	name="munseo_seosig_no"/>
	<jsp:param value="<%=sol_mas_uid%>" 		name="sol_mas_uid"/>
	<jsp:param value="<%=doc_mas_uid%>" 		name="doc_mas_uid"/>
</jsp:include>
</div>
<%} %>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="doUpdate<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>
<script>
var doUpdate<%=sol_mas_uid%> = function(mode, action_uuid){
	
	if(!chkVal<%=sol_mas_uid%>(mode)) return false;
	
	$("#doc_save_mode").val(mode);

	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm<%=sol_mas_uid%>").serialize()+"&update_type=<%=update_type%>";
		
		airCommon.callAjax("SYS_FORM", "UPDATE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>");
			//-- 최조장성인경우 메인거나 부모창이 리스트가 아닐경우를 위해 try catch로 묶음
			try{
				//--그리드 리스트 refresh
				opener.opener.doSearch(opener.document.form1);
			}catch(e){
				try{
					//-- 메인 화면 refresh
					opener.opener.initMain();
				}catch(e){
					
				}
			}
			try{
				opener.location.href = opener.location.href
			}catch(e){
			}
			window.close();
		});
	}
	
}

<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}


</script>
