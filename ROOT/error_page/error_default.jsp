<%@page import="com.emfrontier.air.common.controller.SysStaticDataController"%>
<%@page import="com.emfrontier.air.common.bean.BeanSysServlet"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
/*
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	if (loginUser != null)  siteLocale = loginUser.getSiteLocale();
 */
 
	String siteLocale = CommonProperties.getSystemDefaultLocale();
	String errorCode = StringUtil.convertNull(request.getAttribute("ERROR_CODE"));


	String actionCode = request.getParameter(CommonConstants.ACTION_CODE);
	String modeCode = request.getParameter(CommonConstants.MODE_CODE);
	
	System.out.println("[/error_page/error_default.jsp] ERROR_CODE => "+ errorCode);

	String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
	
	// 메뉴아이디와 모드에 해당하는 빈을 생성, 처리후 결과 페이지를 받아옴
	BeanSysServlet dataBean = (BeanSysServlet)SysStaticDataController.sysServlet.get(actionCode+"&"+modeCode);
	String tmpl = "";
	if(dataBean != null){
		tmpl = dataBean.getTemplatePath();
	}

	if(tmpl.indexOf("_json") < 0){
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="Progma" content="no-cache" />
	<title><%=CommonProperties.getSystemTitle(siteLocale)%></title>
	<link rel="stylesheet" href="<%=systemDefaultContentUrl %>/_css/style.default.css" />
</head>
<body class="pattern_body">
	<div class="Login_container">
		<div class="error_box" >
			<p class="big_title"> </p>
			<p class="small_title"> </p>
			<div id="prev-link" style="text-align: center;font-size: 16px;"></div>
		</div>
	</div>
<script type="text/javascript" src="/common/_lib/jquery/jquery.js"></script>
<script>
$(function(){
if(parent.opener){
	alert("정상적으로 처리할 수 없는 상태입니다.\n\n해당 관리번호와 진행상태를 Service Desk에 문의해주십시오.");
// 	parent.close();
}
var errcode = "<%=errorCode%>",
	locale = "<%=siteLocale%>",
	map = {
		'NOTLOGIN':{
			'EN':{
				'title':'<span>We are sorry.</span> ',
				'sub-title':'Requested internet address (URL) or the path can be accessed after login. <br /><br /> Please access after go to the login page and login.',
				'link': "<a href=\"javascript:window.top.location.href = '<%=CommonProperties.getSystemDefaultUrl()%>';\">Go to login page</a>"
			},
			'KO':{
				'title':' <span>죄송합니다.</span>',
				'sub-title':' 요청하신 인터넷 주소(URL) 또는 경로는 로그인 후  정상 접속할 수 있습니다.<br /><br />로그인 페이지로 이동하여 로그인하신 후 접속 바랍니다.',
				'link': "<a href=\"javascript:window.top.location.href = '<%=CommonProperties.getSystemDefaultUrl()%>';\">로그인페이지로 이동</a>"
			}
		},
		'NOPERMISSION':{
			'EN':{
				'title':'<span>We are sorry.</span>',
				'sub-title':'Requested internet address (URL) or the path does not have permission to access.<br /><br />If you need access rights, please contact the system administrator. ',
				'link': "<a href=\"javascript:history.back();\">Go to previous page</a>"
			},
			'KO':{
				'title':' <span>죄송합니다.</span> ',
				'sub-title':'요청하신 인터넷 주소(URL) 또는 경로에 접속할 수 있는 권한이 없습니다.<br /><br />접속 권한이 필요하실 경우 시스템 관리자에게 문의 바랍니다.',
				'link': "<a href=\"javascript:history.back();\">이전 페이지로 이동</a>"
			}
		}
	},
	t0 = (map[errcode] || {
	'EN':{
		'title':'<span>We are sorry.</span>',
		'sub-title':'Requested internet address(URL) or path can not be connected. <br /><br />If correct URL of the page itself, maybe the error or the page have been moved or deleted.',
		'link': "<a href=\"javascript:history.back();\">Go to previous page</a>"

	},
	'KO':{
		'title':' <span>죄송합니다.</span> ',
		'sub-title':'요청하신 인터넷 주소(URL) 또는 경로에 정상 접속할 수 없습니다.<br /><br />URL이 정확하다면 페이지 자체 에러 또는 페이지가 옮겨지거나 삭제 되었을 수 있습니다.',
		'link': "<a href=\"javascript:history.back();\">이전 페이지로 이동</a>"
	}
})[locale];

$(".big_title").html(t0['sub-title']);
//$(".small_title").html();
$("#prev-link").html(t0['link']);
});
</script>
</body>
</html>
<%}%>