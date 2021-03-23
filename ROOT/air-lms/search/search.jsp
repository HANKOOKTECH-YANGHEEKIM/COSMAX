<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<% request.setCharacterEncoding("UTF-8");%>
<%
//-- 로그인 사용자 정보 셋팅
SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale				= loginUser.getSiteLocale();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>통합검색</title>
<script type="text/javascript">
var goPopup = function(gwanri_mas_uid) {	
	
	var area = $("#"+gwanri_mas_uid);
	
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_REL_MAS";
	url += "&AIR_MODE=REL_TEP_INDEX";
	
	var param = "&sol_mas_uid=" + area.find("[data-meaning=sol_mas_uid]").val();
	param +="&org_action=" + area.find("[data-meaning=action_code]").val();
	param +="&org_mode=" + area.find("[data-meaning=mode_code]").val();
	param +="&gwanri_mas_uid="+gwanri_mas_uid;
	param +="&title_no=" + area.find("[data-meaning=gwanri_no]").val();
	param +="&UUID=" + gwanri_mas_uid;
	param +="&BOARD_CD=" + area.find("[data-meaning=gubun]").val();
	
	url += param;
	airCommon.openWindow(url, "1024", "800", "POPUP_VIEW_FORM", "yes", "yes", "");		
};

var page = function(pageNo) {	
	
	var area = $("#"+pageNo);
	
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_REL_MAS";
	url += "&AIR_MODE=REL_TEP_INDEX";
	
	var param = "&sol_mas_uid=" + area.find("[data-meaning=sol_mas_uid]").val();
	param +="&org_action=" + area.find("[data-meaning=action_code]").val();
	param +="&org_mode=" + area.find("[data-meaning=mode_code]").val();
	param +="&gwanri_mas_uid="+gwanri_mas_uid;
	param +="&title_no=" + area.find("[data-meaning=gwanri_no]").val();
	param +="&UUID=" + gwanri_mas_uid;
	param +="&BOARD_CD=" + area.find("[data-meaning=gubun]").val();
	
	url += param;
	airCommon.openWindow(url, "1024", "800", "POPUP_VIEW_FORM", "yes", "yes", "");		
};
</script>
<script type="text/javascript" src="/common/_lib/jquery/jquery.js"></script>
<script type="text/javascript" src="/common/_js/air-common.js"></script>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui.custom.js"></script>
<link rel="stylesheet" type="text/css" href="/common/_lib/jquery-ui/themes/default/jquery-ui.custom.css" />
<link rel="stylesheet" type="text/css" href="/air-lms/_css/themes/default/common.default.css" />
<style type="text/css">
	table.search td b.search {color:red;}
	
	table.search_page { margin-top:5px; }
	table.search_page a { cursor:pointer; }	
	
	div.div_search_left { margin-top:6px; float:left; width:50%; text-align:left; font-weight:700; font-size:14px; }
	div.div_search_left b.search {color:red; font-size:14px;}
	div.div_search_right { margin-top:6px; float:left; text-align:right; width:50%;}
	div.div_search_right span.span_search { color:#DDDDDD; }
	table.table_search_content { margin:7px 0px 14px 0px; float:left; width:100%; border-top:solid #CCCCCC 1px; }
	table.table_search_content th { width:35px; vertical-align:top; }
	table.table_search_content td b.search {color:red;}
</style>
</head>
<body style="margin:0;padding:0;text-align:left;" onload="window.focus();">
<div class="popup_content_name">
	<span class="name">통합검색</span>
	<span class="tools"><a href="javascript:self.close();" class="ui_icon close_popup" title="<%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%>"></a></span>
</div>
<div class="popup_content_body">
	<form name="search" id="search" onsubmit="return false;" method="post">

		<table class="box">
		<tr>
			<td class="corner_lt"></td>
			<td class="border_mt"></td>
			<td class="corner_rt"></td>
		</tr>
		<tr>
			<td class="border_lm"></td>
			<td class="body">
				<table>
						<colgroup>
							<col style="width:5%" />
							<col style="width:220px" />
							<col style="width:6%" />
							<col style="width:17%" />
							<col style="width:8%" />
							<col style="width:17%" />
							<col style="width:7%" />
							<col style="width:auto" />
							<col style="width:8%" />
						</colgroup>
						<tr>
							<th><%=StringUtil.getLang("L.일자",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_DTE__START", "DEPOSIT_DTE__START", "", "data-type=\"search\"")%> ~ <%=HtmlUtil.getInputCalendar(request, true, "DEPOSIT_DTE__END", "DEPOSIT_DTE__END", "", "data-type=\"search\"")%>
							</td>
							<th><%=StringUtil.getLang("L.구분",siteLocale) %></th>
							<td>
								<%=HtmlUtil.getSelect(request, true, "GUBUN", "GUBUN", "|"+StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^GY|계약^JM|자문^SS|소송^OLD_GY|(구)계약^OLD_JM|(구)자문", "", "class=\"select width_max_select\" data-type=\"search\" style='width:99%;'") %>
							</td>
							<th><%=StringUtil.getLang("L.현업부서", siteLocale) %></th>
							<td>
								<input type="text" name="SAGEON_NO" data-type="search" maxlength="20" class="text width_max" />
							</td>
							<th><%=StringUtil.getLang("L.의뢰자", siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SAGEON_NO" data-type="search" maxlength="20" />
							</td>
							<td rowspan="2" class="verticalContainer" style="text-align:right;">
								<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span><br />
								<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							</td>
						</tr>
						<tr>
							<th><%=StringUtil.getLang("L.제목",siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SAGEON_NO" data-type="search" maxlength="20" value="기지국" />
							</td>
							<th><%=StringUtil.getLang("L.내용",siteLocale) %></th>
							<td>
								<input type="text" class="text width_max" name="SAGEON_NO" data-type="search" maxlength="20" value="기지국" />
							</td>
							<th><%=StringUtil.getLang("L.첨부파일", siteLocale) %></th>
							<td>
								<input type="text" name="SAGEON_NO" data-type="search" maxlength="20" class="text width_max" value="용산" />
							</td>
							<th><%=StringUtil.getLang("L.담당자",siteLocale) %></th>
							<td>
								<input type="text" name="DEPOSIT_NO" data-type="search" maxlength="20" class="text width_max" />
							</td>
						</tr>
				</table>
				</td>
			<td class="border_rm"></td>
		</tr>
		<tr>
			<td class="corner_lb"></td>
			<td class="border_mb"></td>
			<td class="corner_rb"></td>
		</tr>							
		</table>
	</form>
	
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	Total : 99
    </div>
</div>	

<div class="div_search_left">
	용산 <b class="search">기지국</b> 설치에 관한 용역 계약 검토 요청..
</div>
<div class="div_search_right">
	구분 : 계약
	<span class="span_search">/</span>
	현업부서 : 영업팀
	<span class="span_search">/</span>
	의뢰자 : 김의뢰
	<span class="span_search">/</span>
	담당자 : 김담당
	<span class="span_search">/</span>
	일자 : 2018-01-01
</div>
<table class="table_search_content">
	<tr>
		<th>[내용]</th>
		<td>
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 
		.. <b class="search">기지국</b> 설치에 관한 용역 계약 검토를 요청합니다.
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용..
		</td>
	</tr>
	<tr>
		<th>[첨부]</th>
		<td>
		(<b class="search">용산</b> 기지국 설치.docx) 
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		<b class="search">용산</b> 기지국 설치에 관한 용역 계약 검토를 요청합니다.
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		</td>
	</tr>
</table>
	
<div class="div_search_left">
	용산 <b class="search">기지국</b> 설치에 관한 용역 계약 검토 요청..
</div>
<div class="div_search_right">
	구분 : 계약
	<span class="span_search">/</span>
	현업부서 : 영업팀
	<span class="span_search">/</span>
	의뢰자 : 김의뢰
	<span class="span_search">/</span>
	담당자 : 김담당
	<span class="span_search">/</span>
	일자 : 2018-01-01
</div>
<table class="table_search_content">
	<tr>
		<th>[내용]</th>
		<td>
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 
		.. <b class="search">기지국</b> 설치에 관한 용역 계약 검토를 요청합니다.
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용..
		</td>
	</tr>
	<tr>
		<th>[첨부]</th>
		<td>
		(<b class="search">용산</b> 기지국 설치.docx) 
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		<b class="search">용산</b> 기지국 설치에 관한 용역 계약 검토를 요청합니다.
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		</td>
	</tr>
</table>

<div class="div_search_left">
	용산 <b class="search">기지국</b> 설치에 관한 용역 계약 검토 요청..
</div>
<div class="div_search_right">
	구분 : 계약
	<span class="span_search">/</span>
	현업부서 : 영업팀
	<span class="span_search">/</span>
	의뢰자 : 김의뢰
	<span class="span_search">/</span>
	담당자 : 김담당
	<span class="span_search">/</span>
	일자 : 2018-01-01
</div>
<table class="table_search_content">
	<tr>
		<th>[내용]</th>
		<td>
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 
		.. <b class="search">기지국</b> 설치에 관한 용역 계약 검토를 요청합니다.
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용..
		</td>
	</tr>
	<tr>
		<th>[첨부]</th>
		<td>
		(<b class="search">용산</b> 기지국 설치.docx) 
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		<b class="search">용산</b> 기지국 설치에 관한 용역 계약 검토를 요청합니다.
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		</td>
	</tr>
</table>

<div class="div_search_left">
	용산 <b class="search">기지국</b> 설치에 관한 용역 계약 검토 요청..
</div>
<div class="div_search_right">
	구분 : 계약
	<span class="span_search">/</span>
	현업부서 : 영업팀
	<span class="span_search">/</span>
	의뢰자 : 김의뢰
	<span class="span_search">/</span>
	담당자 : 김담당
	<span class="span_search">/</span>
	일자 : 2018-01-01
</div>
<table class="table_search_content">
	<tr>
		<th>[내용]</th>
		<td>
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 
		.. <b class="search">기지국</b> 설치에 관한 용역 계약 검토를 요청합니다.
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용..
		</td>
	</tr>
	<tr>
		<th>[첨부]</th>
		<td>
		(<b class="search">용산</b> 기지국 설치.docx) 
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		<b class="search">용산</b> 기지국 설치에 관한 용역 계약 검토를 요청합니다.
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		</td>
	</tr>
</table>

<div class="div_search_left">
	용산 <b class="search">기지국</b> 설치에 관한 용역 계약 검토 요청..
</div>
<div class="div_search_right">
	구분 : 계약
	<span class="span_search">/</span>
	현업부서 : 영업팀
	<span class="span_search">/</span>
	의뢰자 : 김의뢰
	<span class="span_search">/</span>
	담당자 : 김담당
	<span class="span_search">/</span>
	일자 : 2018-01-01
</div>
<table class="table_search_content">
	<tr>
		<th>[내용]</th>
		<td>
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 
		.. <b class="search">기지국</b> 설치에 관한 용역 계약 검토를 요청합니다.
		내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용.. 내용..
		</td>
	</tr>
	<tr>
		<th>[첨부]</th>
		<td>
		(<b class="search">용산</b> 기지국 설치.docx) 
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		<b class="search">용산</b> 기지국 설치에 관한 용역 계약 검토를 요청합니다.
		첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 첨부파일 내용.. 
		</td>
	</tr>
</table>

<table class="basic search_page">
<tr>
	<td style="text-align:center; background-color:#EEEEEE;">
		<a onclick="page('1')">&nbsp;|◀&nbsp;</a> 
		&nbsp;&nbsp;
		<a onclick="page('1')">&nbsp;◀&nbsp;</a> 
		&nbsp;&nbsp;
		<a onclick="page('1')">&nbsp;1&nbsp;</a> 
		| 
		<a onclick="page('2')">&nbsp;2&nbsp;</a> 
		| 
		<a onclick="page('3')">&nbsp;3&nbsp;</a> 
		| 
		<a onclick="page('4')">&nbsp;4&nbsp;</a> 
		| 
		<a onclick="page('5')">&nbsp;5&nbsp;</a> 
		| 
		<a onclick="page('6')">&nbsp;6&nbsp;</a> 
		| 
		<a onclick="page('7')">&nbsp;7&nbsp;</a> 
		| 
		<a onclick="page('8')">&nbsp;8&nbsp;</a> 
		| 
		<a onclick="page('9')">&nbsp;9&nbsp;</a> 
		&nbsp;&nbsp;
		<a onclick="page('2')">&nbsp;▶&nbsp;</a> 
		&nbsp;&nbsp;
		<a onclick="page('9')">&nbsp;▶|&nbsp;</a> 
	</td>
</tr>
</table>	
	
</div>
</body>
</html>
<%
	/* if ( wnsearch != null ) {
		wnsearch.closeServer();
	} */
%>