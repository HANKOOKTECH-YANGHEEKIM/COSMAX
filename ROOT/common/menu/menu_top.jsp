<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>    
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	boolean is_admin			= loginUser.isCmmAdmin();

	String menuCode = StringUtil.convertNull(request.getParameter(CommonConstants.MENU_CODE));
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 					= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	SQLResults userAuthListResult 				= resultMap.getResult("USER_AUTH_LIST");
	SQLResults sysMunseoBunryuGbnListResult 	= resultMap.getResult("SYS_MUNSEO_BUNRYU_GBN_LIST");
	
	
	//-- 코드정보 문자열 셋팅
	String userAuthCodestr = StringUtil.getCodestrFromSQLResults(userAuthListResult, "CODE,LANG_CODE", "");
%>
    
<script type="text/javascript">    
//-- 현재 선택된 메뉴 코드
var m_currentMenuCode = "<%=menuCode%>";  

/**
 * 메뉴 변경 처리
 */
function MenuTopItem_Change(id, flag) {	
	var menuObj = $("#"+ id);	
	if (menuObj.is("a")) {		
		var menuCode	= getMenuCode(id);
		var subId		= "menu_top_sub-"+ menuCode;		
		var subObj		= $("#"+ subId);
		
		if (flag == "on" && !menuObj.hasClass("on")) {			
			menuObj.addClass("on");			
			if (subObj.is("li")) {			
				subObj.css("display", "");
				
				//-- 메뉴 on 상태일 경우 서브메뉴 슬라이딩 처리(jQuery 사용)
				var marginLeft = $("#"+ subId).css("marginLeft");
				if (marginLeft.indexOf("px") > -1) {
					$("#"+ subId).css("marginLeft", String(marginLeft.replace("px", "")-100) +"px");
					$("#"+ subId).animate({"marginLeft":marginLeft}, 700);
				}
			}			
		} else if (menuCode != m_currentMenuCode && menuObj.hasClass("on")) {			
			menuObj.removeClass("on");
			if (subObj.is("li")) {
				subObj.css("display", "none");
			}
		}		
	}	
}	

/**
 * 메뉴 초기화 처리
 */
function MenuTopItem_Init(id) {
	var menuCode = getMenuCode(id);	
	
	//현재 메뉴정보와 선택된 메뉴정보가 다를 경우에만 초기화 처리!
	if (menuCode != m_currentMenuCode) {
		//-- 선택된 메뉴 정보 변경
		m_currentMenuCode = menuCode;
		
		$(".menu_top_item").each(function() {								
			if (getMenuCode(this.id) != menuCode) {
				//-- 선택된 메뉴가 아니면 off 처리!
				MenuTopItem_Change(this.id, "off");
			} else {
				MenuTopItem_Change(this.id, "on");
			}			
		});						
	}	
}

/**
 * 메뉴 클릭시 선택된 메뉴 정보 변경 처리
 */
function MenuTopItem_Click(id) {
	var prevMenuCode	= m_currentMenuCode;
	m_currentMenuCode 	= getMenuCode(id);
	
	//-- 기존에 선택된 메뉴 off 처리!
	MenuTopItem_Change("menu_top_item-"+ prevMenuCode, "off");
}

/**
 * 메뉴 아이디로부터 메뉴 코드 값 반환
 */
function getMenuCode(id) {
	return id.substring(id.indexOf("-") + 1);
}

/**
 * 요청한 페이지로 이동
 */
function goMenuPage(actionCode, modeCode, etcQStr) {
	var url = "/ServletController";
	url += "?<%=CommonConstants.ACTION_CODE%>="+ actionCode;
	url += "&<%=CommonConstants.MODE_CODE%>="+ modeCode;
	
	if (etcQStr != undefined) url += etcQStr;		
	
	window.top.airFrameBody.location.href = url;
}

/**
 * 로그아웃
 */
function doLogout() {
	window.top.location.href 	= "/ServletController?<%=CommonConstants.ACTION_CODE%>=CMM_LOGIN&<%=CommonConstants.MODE_CODE%>=LOGOUT_PROC";
}

/**
 * 홈페이지로 이동
 */
function goHome() {
	window.top.location.href 	= "/";
}

/**
 * 권한변경
 */
function changeAuth(val) {
	window.top.location.href 	= "/ServletController?<%=CommonConstants.ACTION_CODE%>=CMM_LOGIN&<%=CommonConstants.MODE_CODE%>=CHANGE_AUTH&CAUTH=" + val;
}

/**
 * 사이트 로케일 변경
 */
function changeSiteLocale(val) {
	window.top.location.href 	= "/ServletController?<%=CommonConstants.ACTION_CODE%>=CMM_LOGIN&<%=CommonConstants.MODE_CODE%>=CHANGE_SITE_LOCALE&CLOCALE=" + val;
}
</script>

<!-- // 로고 // -->
	<div class="menu_top_logo">
		<a href="#" onclick="goHome();" title="<%=CommonProperties.getSystemTitle(loginUser.getSiteLocale())%>" onfocus="this.blur();"><span class="logo"></span></a>		
	</div>

	<div class="menu_top_user">		
	</div>

<!-- // 기타 메뉴 // -->	
	<div class="menu_top_etc">
		<span class="bul"></span>
		
		<%if("KO".equals(siteLocale)){%><%=loginUser.getGroupNameKo()%><%}else{%><%=loginUser.getGroupNameEn()%><%}%> <%if("KO".equals(siteLocale)){%><%=loginUser.getNameKo()%><%}else{%><%=loginUser.getNameEn()%><%}%> 		
		[ <%=StringUtil.getLocaleWord("L.최근접속",siteLocale)%> : <%=loginUser.getLastLoginIp() %> / <%=loginUser.getLastLoginDate() %> ]
		<a href="#" onclick="doLogout();"><%=StringUtil.getLocaleWord("L.로그아웃",siteLocale)%></a>		
		&nbsp;|&nbsp;
		<a href="#" onclick="goHome();">Home</a>		
	<%
	if("Y".equals(CommonProperties.load("fnc.multiAuthLogin"))){ 
	%>
		&nbsp;|&nbsp;
		<%=HtmlUtil.getSelect(request, true, "schUserAuth", "schUserAuth", userAuthCodestr, loginUser.getAuthCodes(), "onchange='changeAuth(this.options[this.selectedIndex].value);'")%>
	<%
	}
	%>
		&nbsp;|&nbsp;		
		<%=HtmlUtil.getSelect(request, true, "schSiteLocale", "schSiteLocale", "KO|한국어^EN|English", siteLocale, "onchange='changeSiteLocale(this.options[this.selectedIndex].value);'") %>
	</div>
	
<!-- // 주요 메뉴 // -->
	<%if("KO".equals(siteLocale)){%>
	<ul class="menu_top_list">		
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_SI', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-SI"><span>신청/보고</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_GEOM', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN|BO&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-GEOM"><span>검토</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_SU', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN|BO&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-SU"><span>확인</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_GYEOL', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN|BO&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-GYEOL"><span>결재</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('IPS_PROG_CONDI', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-PROG"><span>진행관리</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('CMM_COST', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-COST"><span>비용관리</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('IPS_FIELD_SEARCH', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-SEARCH"><span>검색/통계</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_USER', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-ADMIN"><span>운영관리</span></a></li>
<!-- 		<li><a href="javascript:goMenuPage('SYS_USER', 'GLIST');" onfocus="this.blur();"><img name="menu_top_item" id="ADMIN" src="/images/top/top_menu_off-ADMIN.gif" border="0" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" /></a></li>	 -->		
	</ul>
	<%}else{%>
	<ul class="menu_top_list_en">		
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_SI', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-SI"><span>Request<br>/Report</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_GEOM', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN|BO&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-GEOM"><span>Review</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_SU', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN|BO&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-SU"><span>Receive<br>/Confirm</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_GYEOL', '&menuParamMunseoBunryuGbnCod1=SYS_MUNSEO_BUNRYU_GBN_IPS&menuParamMunseoSeosikGbn=SIN|BO&schFlowCheoriYn=W');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-GYEOL"><span>Approval</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('IPS_PROG_CONDI', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-PROG"><span>Progress<br>Management</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('CMM_COST', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-COST"><span>Cost<br>Management</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('IPS_FIELD_SEARCH', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-SEARCH"><span>Search<br>/statistics</span></a></li>
		<li class="separ"></li>
		<li><a href="javascript:goMenuPage('SYS_USER', 'GLIST');" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" onfocus="this.blur();" class="menu_top_item" id="menu_top_item-ADMIN"><span>Admin</span></a></li>
<!-- 		<li><a href="javascript:goMenuPage('SYS_USER', 'GLIST');" onfocus="this.blur();"><img name="menu_top_item" id="ADMIN" src="/images/top/top_menu_off-ADMIN.gif" border="0" onmouseover="MenuTopItem_Init(this.id)" onclick="MenuTopItem_Click(this.id)" /></a></li>	 -->		
	</ul>
	<%}%>
		
<!-- // 서브 메뉴 // -->	
	<ul class="menu_top_sub_list">
		<li id="menu_top_sub-SI" style="display:none; margin-left:20px;">
			<%if(sysMunseoBunryuGbnListResult != null && sysMunseoBunryuGbnListResult.getRowCount() > 0){%>
				<%for(int i=0; i<sysMunseoBunryuGbnListResult.getRowCount(); i++){%>
			<a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_SI', '&menuParamMunseoBunryuGbnCod1=<%=sysMunseoBunryuGbnListResult.getString(i,"code_id")%>&menuParamMunseoSeosikGbn=SIN|BO');"><%=sysMunseoBunryuGbnListResult.getString(i,"name_"+loginUser.getSiteLocale())%></a>
					<%if(i != (sysMunseoBunryuGbnListResult.getRowCount()-1)){%>
					&nbsp;|&nbsp;
					<%}%>
				<%}%>
			<%}%>
		</li>	
		<li id="menu_top_sub-GEOM" style="display:none; margin-left:50px;">
			<%if(sysMunseoBunryuGbnListResult != null && sysMunseoBunryuGbnListResult.getRowCount() > 0){%>
				<%for(int i=0; i<sysMunseoBunryuGbnListResult.getRowCount(); i++){%>
			<a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_GEOM', '&menuParamMunseoBunryuGbnCod1=<%=sysMunseoBunryuGbnListResult.getString(i,"code_id")%>&menuParamMunseoSeosikGbn=SIN|BO');"><%=sysMunseoBunryuGbnListResult.getString(i,"name_"+loginUser.getSiteLocale())%></a>
					<%if(i != (sysMunseoBunryuGbnListResult.getRowCount()-1)){%>
					&nbsp;|&nbsp;
					<%}%>
				<%}%>
			<%}%>
		</li>	
		<li id="menu_top_sub-SU" style="display:none; margin-left:110px;">
			<%if(sysMunseoBunryuGbnListResult != null && sysMunseoBunryuGbnListResult.getRowCount() > 0){%>
				<%for(int i=0; i<sysMunseoBunryuGbnListResult.getRowCount(); i++){%>
			<a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_SU', '&menuParamMunseoBunryuGbnCod1=<%=sysMunseoBunryuGbnListResult.getString(i,"code_id")%>&menuParamMunseoSeosikGbn=SIN|BO');"><%=sysMunseoBunryuGbnListResult.getString(i,"name_"+loginUser.getSiteLocale())%></a>
					<%if(i != (sysMunseoBunryuGbnListResult.getRowCount()-1)){%>
					&nbsp;|&nbsp;
					<%}%>
				<%}%>
			<%}%>
		</li>		
		<li id="menu_top_sub-GYEOL" style="display:none; margin-left:180px;">
			<%if(sysMunseoBunryuGbnListResult != null && sysMunseoBunryuGbnListResult.getRowCount() > 0){%>
				<%for(int i=0; i<sysMunseoBunryuGbnListResult.getRowCount(); i++){%>
			<a href="javascript:goMenuPage('SYS_DOC_MAS', 'GLIST_GYEOL', '&menuParamMunseoBunryuGbnCod1=<%=sysMunseoBunryuGbnListResult.getString(i,"code_id")%>&menuParamMunseoSeosikGbn=SIN|BO');"><%=sysMunseoBunryuGbnListResult.getString(i,"name_"+loginUser.getSiteLocale())%></a>
					<%if(i != (sysMunseoBunryuGbnListResult.getRowCount()-1)){%>
					&nbsp;|&nbsp;
					<%}%>
				<%}%>
			<%}%>
		</li>		
		<li id="menu_top_sub-PROG" style="display:none; margin-left:320px;">
			<a href="javascript:goMenuPage('IPS_PROG_CONDI', 'GLIST');"><%=StringUtil.getLocaleWord("L.내IP현황",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('IPS_DOC_RUN_CONDI', 'GLIST');"><%=StringUtil.getLocaleWord("L.처리진행문서현황",siteLocale)%></a>
		</li>		
		<li id="menu_top_sub-COST" style="display:none; margin-left:350px;"></li>		
		<%
			if(is_admin == true){
		%>
		<li id="menu_top_sub-SEARCH" style="display:none; margin-left:675px;">
				<a href="javascript:goMenuPage('IPS_LAWOFFICE_SEARCH', 'GLIST');"><%=StringUtil.getLocaleWord("L.특허검색",siteLocale)%></a>
		</li>
		<%				
			}else{
		%>	
		<li id="menu_top_sub-SEARCH" style="display:none; margin-left:600px;">
			<a href="javascript:goMenuPage('IPS_FIELD_SEARCH', 'GLIST');"><%=StringUtil.getLocaleWord("L.필드검색",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('IPS_CROSS_STAT', 'LIST_NO_DATA');"><%=StringUtil.getLocaleWord("L.교차분석통계",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('IPS_RESULT_STAT', 'LIST_NO_DATA');"><%=StringUtil.getLocaleWord("L.실적통계",siteLocale)%></a>
		<%
			}
		%>
		</li>		
		<li id="menu_top_sub-ADMIN" style="display:none; margin-left:-53px;">
			<a href="javascript:goMenuPage('SYS_USER', 'GLIST');"><%=StringUtil.getLocaleWord("L.사용자관리",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('SYS_COMPANY', 'LIST');"><%=StringUtil.getLocaleWord("L.업체관리",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('SYS_CODE', 'LIST');"><%=StringUtil.getLocaleWord("L.코드관리",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('SYS_LOG_ACC', 'LIST');"><%=StringUtil.getLocaleWord("L.파일이력관리",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('CMM_MENU', 'QUICK_LIST');"><%=StringUtil.getLocaleWord("L.바로가기관리",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="javascript:goMenuPage('CMM_SITE_LINK', 'LIST');"><%=StringUtil.getLocaleWord("L.외부링크관리",siteLocale)%></a>
			&nbsp;|&nbsp;
			<a href="#" onclick="goMenuPage('SYS_MNG_PATI', 	    'LIST')"><%=StringUtil.getLocaleWord("L.파티클관리",siteLocale)%></a>
			&nbsp;|&nbsp;
		    <a href="#" onclick="goMenuPage('SYS_DEF_DOC_MAIN', 	'LIST')"><%=StringUtil.getLocaleWord("L.문서정의관리",siteLocale)%></a>
		    &nbsp;|&nbsp;
		    <a href="#" onclick="goMenuPage('SYS_DEF_DOC_FLOW', 	'LIST')"><%=StringUtil.getLocaleWord("L.문서Flow관리",siteLocale)%></a>
		    &nbsp;|&nbsp;
		    <a href="#" onclick="goMenuPage('SYS_DEF_DOC_REL', 	    'LIST')"><%=StringUtil.getLocaleWord("L.문서간관계관리",siteLocale)%></a>
		    &nbsp;|&nbsp;
		    <a href="#" onclick="goMenuPage('SYS_DEF_DOC_MAIL',	    'LIST')"><%=StringUtil.getLocaleWord("L.문서별메일수신",siteLocale)%></a>
		</li>
		
	</ul>