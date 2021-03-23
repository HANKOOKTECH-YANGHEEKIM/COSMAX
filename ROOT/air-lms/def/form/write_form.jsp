<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.lms.def.util.StuUtil" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 결과값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	
	String sol_mas_uid		= requestMap.getString("SOL_MAS_UID");
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	String munseo_seosig_no = requestMap.getString("MUNSEO_SEOSIG_NO");
	String stu_id = requestMap.getString("STU_ID");
	String next_stu_id = requestMap.getString("NEXT_STU_ID");
%>
<script type="text/javascript">
$(function(){
	
// 	var url = "/ServletController";
// 	url += "?AIR_ACTION=SYS_FORM";
// 	url += "&AIR_MODE=WRITE_FORM_INCLUDE";
<%-- url += "&munseo_seosig_no=<%=munseo_seosig_no%>"; --%>
	
// 	$("#nextWriteDiv").panel({
// 		href:url
// 		,width:'100%'		
// 	});
});
</script>
<%-- <div id="nextWriteDiv" title="" style="border:0px;"> --%>
<%-- </div> --%>
<jsp:include page="/ServletController" flush="false">
	<jsp:param value="SYS_FORM" name="AIR_ACTION"/>
	<jsp:param value="WRITE_FORM_INCLUDE" name="AIR_MODE"/>
	<jsp:param value="<%=munseo_seosig_no%>" name="munseo_seosig_no"/>
</jsp:include>
<script>
<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}

var doStuProc = function(uuid){
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.처리")%>";
	if(confirm(msg)){
		var data = {};
		
		data["action_uuid"]=uuid;
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#form1").serialize();
		airCommon.callAjax("SYS_FORM", "STU_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>")
		});
	}
}

//-- todo영역 refresh
var todoRefresh = function(){
	var url = "/ServletController?AIR_ACTION=SYS_FORM&AIR_MODE=FORM_TODO";
	url += "&stu_id=<%=requestMap.getString("STU_ID")%>";
	url += "&doc_cod=S";
	url += "&munseo_seosig_no=<%=requestMap.getString("MUNSEO_SEOSIG_NO")%>";
	$("#divTODO").panel({
		href:url
		,width:'100%'		
	});
}
$(function(){
// 	todoRefresh();
})
</script>
<%-- 투두영역 --%>
<div id="divTODO<%=sol_mas_uid%>" style="border:0px;"></div>