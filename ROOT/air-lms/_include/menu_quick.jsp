<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = loginUser.getSiteLocale();

String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();

String 바로가기 = StringUtil.getLocaleWord("L.바로가기",siteLocale);
String 결재문서함2 = StringUtil.getLocaleWord("L.결재문서함2",siteLocale);
String 일정 = StringUtil.getLocaleWord("L.일정",siteLocale);
String 통계 = StringUtil.getLocaleWord("L.통계",siteLocale);
String 사외변호사 = StringUtil.getLocaleWord("L.사외변호사",siteLocale);
String 매뉴얼 = StringUtil.getLocaleWord("L.매뉴얼",siteLocale);
String 다운로드 = StringUtil.getLocaleWord("L.다운로드",siteLocale);
String 사용자 = StringUtil.getLocaleWord("L.사용자",siteLocale);
String 관리자 = StringUtil.getLocaleWord("L.관리자",siteLocale);
%>
<script type="text/javascript">
/**
 * 일정 바로가기
 */
function menuQuick_openScdl() {
	airCommon.popupScdlList("", "", "");
}

/**
 * 결재문서함 바로가기
 */
function menuQuick_openGyeol() {
//     airCommon.openWindow('/ServletController?AIR_ACTION=LMS_MAIN&AIR_MODE=POPUP_GYEOL_LIST', 1024, 490, 'winGyeolPopUp', 'yes', 'yes');
    airCommon.openWindow('/ServletController?AIR_ACTION=SYS_APR&AIR_MODE=POPUP_APR_LIST', 1024, 490, '결재문서', 'yes', 'yes');
}

/**
 * 통계 바로가기
 */
function menuQuick_openStats() {
	airCommon.openWindow('/ServletController?AIR_ACTION=LMS_TG&AIR_MODE=POPUP_INDEX', 1120, 680, 'winStatsPopUp', 'yes', 'yes');
}

/**
 * 사외변호사 정보 바로가기
 */
function menuQuick_openByeonhosa() {
	airCommon.openWindow('/ServletController?AIR_ACTION=LMS_BYEONHOSA&AIR_MODE=POPUP_GLIST', 1024, 660, 'winByeonhosaPopUp', 'yes', 'yes');
}
</script>
<style type="text/css">
#quick1 {position:absolute; top:0px; right:-120px; width:100px; border:1px solid #cdcdcd; margin:0; padding:0;}
#quick1 h2 {width:100px; font-size:13px;  background:#4c4c4c; padding:7px 0; color:#ffffff; text-align:center; font-weight:normal; argin:0; margin:0;}
#quick1 ul { margin:0; padding:0; }
#quick1 ul li {border-bottom:1px solid #e5e5e5; padding:12px 0; text-align:center; background:#ffffff; argin:0; margin:0; list-style:none;}
#quick1 ul li p.img {margin:0; padding:0;}
#quick1 ul li p.txt {margin:0; padding:0;}
#quick1 ul li:last-child {border-bottom:none; }

#quick2 {position:absolute; top:200px; right:-120px; width:100px; border:1px solid #cdcdcd;}
#quick2 h2 {width:100px; font-size:13px; line-height:16px; background:#909090; padding:7px 0; color:#ffffff; text-align:center; font-weight:normal; margin:0;}
#quick2 ul { margin:0; padding:0; }
#quick2 ul li {border-bottom:1px solid #e5e5e5; padding:12px 0; text-align:center; background:#ffffff; argin:0; margin:0; list-style:none; }
#quick2 ul li p.img {margin:0; padding:0;}
#quick2 ul li p.txt {margin:0; padding:0;}
#quick2 ul li:last-child {border-bottom:none;}
</style>
 <!--quick 시작-->
		<div class="quick_menu2">
			<p>QUICK MENU</p>
			<a href="javascript:void(0)" onclick="menuQuick_openGyeol()"><img src="air-lms/_images/img_quick01_.png"> 결재문서함</a>
			<a href="javascript:void(0)" onclick="menuQuick_openScdl()"><img src="air-lms/_images/img_quick02_.png"> 일정</a>
			<a href="javascript:void(0)" onclick="airLms.popupLegalTeamManualDownload('<%=loginUser.gethoesaCod()%>')"><img src="air-lms/_images/img_quick03_.png"> 법무팀 매뉴얼</a>
			<a href="javascript:void(0)" onclick="airLms.popupUserManualDownload('<%=loginUser.gethoesaCod()%>')"><img src="air-lms/_images/img_quick03_.png"> 현업팀 매뉴얼</a>
<%--
				<a href="javascript:void(0)" onclick="menuQuick_openStats()"><img src="air-lms/_images/img_quick03.png"> 통계</a>
 --%>				
		</div>
<%--	
	<div id="quick2">
		<h2>Manual<br />Download</h2>
		<ul>
			<li>
				<a href="javascript:void(0)" onClick="airLms.popupLegalTeamManualDownload();">
					<p class="img"><img src="/air-lms/_css/themes/default/images/menu_quick/qu4.jpg" alt="법무팀 매뉴얼 다운로드" /></p>
					<p class="txt">법무</p>
				</a>
			</li>
			<li>
				<a href="javascript:void(0)" onClick="airLms.popupUserManualDownload();">
					<p class="img"><img src="/air-lms/_css/themes/default/images/main/ic5.jpg" alt="사용자 매뉴얼 다운로드" /></p>
					<p class="txt">사용자</p>
				</a>
			</li>
		</ul>
	</div>
--%>
<!--quick 끝-->