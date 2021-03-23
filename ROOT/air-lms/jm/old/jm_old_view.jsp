<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}

//결과값 셋팅
BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

SQLResults viewResult = resultMap.getResult("VIEW");
String gwanriNo		 = viewResult.getString(0, "gwanri_no");

String defDocMainUid   = ""; 
String docMasUid	   = ""; 	  
String solMasUid 	   = "";
String jmMasUid 	   = "";
String gwanriMasUid    = "";
String munseoSeosigNo  = "";
String sysGbnCodeId    = "";
String eobmuGbnCodeId  = "";
String dangyeGbnCodeId = "";



if(viewResult != null && viewResult.getRowCount() > 0 ){
	defDocMainUid  	= viewResult.getString(0, "def_doc_main_uid");
	docMasUid 	  	= viewResult.getString(0, "doc_mas_uid");
	solMasUid 	  	= viewResult.getString(0, "sol_mas_uid");
	jmMasUid 	  	= viewResult.getString(0, "jm_mas_uid");
	gwanriMasUid  	= viewResult.getString(0, "gwanri_mas_uid");
	munseoSeosigNo 	= viewResult.getString(0, "munseo_seosig_no");
	sysGbnCodeId 	= viewResult.getString(0, "sys_gbn_code_id");
	eobmuGbnCodeId 	= viewResult.getString(0, "eobmu_gbn_code_id");
	dangyeGbnCodeId = viewResult.getString(0, "dangye_gbn_code_id");
}


//권한 셋팅
boolean isWritable = LmsUtil.isBeobmuTeamUser(loginUser);
%>
<jsp:include page="/ServletController">
	<jsp:param value="SYS_DOC_MAS" name="AIR_ACTION" />
	<jsp:param value="VIEW_INCLUDE" name="AIR_MODE" />	
	<jsp:param value="<%=defDocMainUid%>" name="def_doc_main_uid" />
	<jsp:param value="<%=docMasUid%>" name="doc_mas_uid" />
	<jsp:param value="N" name="showContentNameYn" />
	<jsp:param value="N" name="showHistoryYn" />	
</jsp:include>
<script type="text/javascript">
var m_resizingTepFrameCodes = new Object();
var m_isTepParentFrameResizing = false;
/**
 * 부모 프레임 리사이즈
 */
function tep_parentFrameResize() {      
    var code = "<%=gwanriNo%>";
            
    //console.log("[tep_parentFrameResize()] code : " + code);
    
	if (!m_isTepParentFrameResizing && code != "") {
		m_isTepParentFrameResizing = true;				
		
		setTimeout(
				function() {
					try {
						var scroll_top = $(parent.document).scrollTop();
						parent.airCommon.resizeIFrame("listTabsFrame-"+ code, "100%", "auto");
						$(parent.document).scrollTop(scroll_top);
						
						//console.log("parent document scrollTop is "+ $(parent.document).scrollTop());
						//console.log("parent document height is "+ $(parent.document).height());
					} catch (e) {
						//console.log("[tep_parentFrameResize()] 에러가 발생했습니다.\nError Message : " + e.message);			
					}
					
					m_isTepParentFrameResizing = false;		
					
					try{
						parent.tep_parentFrameResize();
					}catch(e){
						
					}
				},
				0	// 파일 업로드가 완료되고 나서 실행되도록 하기 위해 0 ---> 1000 으로 변경
		);
	}      
}
$(document).ready(function () {
	try{
		tep_parentFrameResize();
	}catch(e){
		
	}
	try{
		parent.tep_parentFrameResize();
	}catch(e){
		
	}
});
</script>
<%
// 권한이 있는 사용자일 경우에만 수정/삭제 버튼을 보여줌
if (isWritable) {
%>
<div class="buttonlist">
	<script>
	function goModify() {
// 		var callback_function = "opener.parent.location.reload();self.close();";
		var callback_function = "opener.doSearch(opener.document.form1);self.close();";
		
		var url = "/ServletController?AIR_ACTION=SYS_DOC_MAS&AIR_MODE=UPDATE_FORM_NOREV_EDIT";
		url += "&def_doc_main_uid=<%=defDocMainUid%>";
		url += "&doc_mas_uid=<%=docMasUid%>";
		url += "&callbackFunction="+ escape(callback_function);
		
		location.href = url;
// 		airCommon.openWindow(url, "1024", "600", "POPUP_WRITE_FORM", "yes", "yes", "");
	}	
	
	function goDelete() {		
		var callback_function = "opener.parent.listTabs_reload('LIST');self.close();";
		
		var url = "/ServletController?AIR_ACTION=SYS_DOC_MAS&AIR_MODE=UPDATE_PROC";
		url += "&doc_save_mode=REALSAGJE";
		url += "&sol_mas_uid=<%=solMasUid%>";
		url += "&gwanri_mas_uid=<%=gwanriMasUid%>";		
		url += "&doc_mas_uid=<%=docMasUid%>";
		url += "&munseo_seosig_no=<%=munseoSeosigNo%>";
		url += "&munseo_bunryu_gbn_sys_cod_id1=<%=sysGbnCodeId%>";
		url += "&munseo_bunryu_gbn_sys_cod_id2=<%=eobmuGbnCodeId%>";
		url += "&munseo_bunryu_gbn_sys_cod_id3=<%=dangyeGbnCodeId%>";
		url += "&callbackFunction="+ escape(callback_function);
	
		if (confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.삭제", siteLocale))%>")) {
			location.href = url;	
		}	
	}
	</script>
	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goModify();"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
	<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:goDelete();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
</div>
<%	
}
%>