<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);

if (loginUser == null) loginUser = new SysLoginModel();

System.out.println("#loginUser.ID = " + loginUser.getLoginId());

if ("".equals(loginUser.getUUID())) {
	// SSO 처리에 필요한 필수 파라미터
	// I-mobis에서 호출하는 URL은 https://gls.mobis.co.kr
	String user_id = StringUtil.convertNull(request.getParameter("USERID"));
	String random_num = StringUtil.convertNull(request.getParameter("RandomNum"));

	if (!"".equals(user_id)) {
		//-- SSO_PROC
		//response.sendRedirect(CommonProperties.getSystemSecurityUrl() + "/ServletController?AIR_ACTION=LMS_LOGIN&AIR_MODE=SSO_PROC&USERID="+ user_id +"&RandomNum="+ random_num);			
		response.sendRedirect(CommonProperties.getSystemSecurityUrl() + "/ServletController?AIR_ACTION=LMS_LOGIN&AIR_MODE=LOGIN_FORM&USERID="+ user_id +"&RandomNum="+ random_num);
	} else {
		//-- 그밖의 경우에는 로그인 페이지로 이동
		response.sendRedirect(CommonProperties.getSystemSecurityUrl() + "/ServletController?AIR_ACTION=LMS_LOGIN&AIR_MODE=LOGIN_FORM");					
	}
} else {	
	//-- 바로가기 주소값 가져오기
	String redirect_url = StringUtil.unescape(StringUtil.convertNull(request.getParameter("REDIRECT_URL")));
	if ("".equals(redirect_url)) {
		//-- 바로가기 주소값이 없으면 기본 메인 페이지로 이동
		if (LmsUtil.isBeobmuOfiUser(loginUser)) {
			redirect_url = CommonProperties.getSystemDefaultUrl() + "/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=CHR_INDEX";
			String sol_mas_uid			= StringUtil.convertNull(request.getParameter("SOL_MAS_UID"));
			String apr_no				= StringUtil.convertNull(request.getParameter("APR_NO"));
			String view_doc_mas_uid		= StringUtil.convertNull(request.getParameter("VIEW_DOC_MAS_UID"));
			if(StringUtil.isNotBlank(sol_mas_uid)){
				redirect_url +="&SOL_MAS_UID="+sol_mas_uid;
			}
			if(StringUtil.isNotBlank(apr_no)){
				redirect_url +="&APR_NO="+apr_no;
			}
			if(StringUtil.isNotBlank(view_doc_mas_uid)){
				redirect_url +="&VIEW_DOC_MAS_UID="+view_doc_mas_uid;
			}
			
		} else {
			redirect_url = CommonProperties.getSystemDefaultUrl() + "/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=USR_INDEX";
			String sol_mas_uid			= StringUtil.convertNull(request.getParameter("SOL_MAS_UID"));
			String apr_no				= StringUtil.convertNull(request.getParameter("APR_NO"));
			String view_doc_mas_uid		= StringUtil.convertNull(request.getParameter("VIEW_DOC_MAS_UID"));
			if(StringUtil.isNotBlank(sol_mas_uid)){
				redirect_url +="&SOL_MAS_UID="+sol_mas_uid;
			}
			if(StringUtil.isNotBlank(apr_no)){
				redirect_url +="&APR_NO="+apr_no;
			}
			if(StringUtil.isNotBlank(view_doc_mas_uid)){
				redirect_url +="&VIEW_DOC_MAS_UID="+view_doc_mas_uid;
			}
			
		}
	}
	
	response.sendRedirect(redirect_url);
}
%>