<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>    
<%
  	//-- 로그인 사용자 정보 셋팅
    SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
    String siteLocale			= loginUser.getSiteLocale();

    //-- 검색값 셋팅
    BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
    String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
    	
    //-- 결과값 셋팅
    BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
    SQLResults viewResult 		= resultMap.getResult("VIEW");
    	
    //-- 파라메터 셋팅
    String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
    String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
    
    String notiTermCdStr 		= "Y|"+StringUtil.getLocaleWord("L.YES",siteLocale)+"^N|"+StringUtil.getLocaleWord("L.NO",siteLocale);
    	
    //-- 상세보기 값 셋팅
    String scdl_uid 				= viewResult.getString(0, "scdl_uid");
    String scdl_stat_code			= viewResult.getString(0, "scdl_stat_code");
    String scdl_type_code			= viewResult.getString(0, "scdl_type_code");
    String scdl_type_name			= viewResult.getString(0, "scdl_type_name");
    String scdl_tit					= viewResult.getString(0, "scdl_tit");
    String scdl_plce				= viewResult.getString(0, "scdl_plce");		
    String scdl_memo				= viewResult.getString(0, "scdl_memo");
    String scdl_bgn_date			= viewResult.getString(0, "scdl_bgn_date");
    String scdl_bgn_time			= viewResult.getString(0, "scdl_bgn_time");
    String scdl_end_date			= viewResult.getString(0, "scdl_end_date");
    String scdl_end_time			= viewResult.getString(0, "scdl_end_time");
    String scdl_noti_yn				= viewResult.getString(0, "scdl_noti_yn");
    String scdl_noti_term			= viewResult.getString(0, "scdl_noti_term");
    String scdl_ins_grp_name		= viewResult.getString(0, "scdl_ins_grp_name");
    String scdl_ins_user_id			= viewResult.getString(0, "scdl_ins_user_id");
    String scdl_ins_user_name		= viewResult.getString(0, "scdl_ins_user_name");
    String scdl_ins_date			= viewResult.getString(0, "scdl_ins_date");
    	
    //-- 권한 설정
    boolean isAdmin		= LmsUtil.isSysAdminUser(loginUser);
    boolean isWriteUser	= resultMap.getBoolean("IS_WRITE_USER");	//작성자 권한
    if(isWriteUser && loginUser.getLoginId().equals(scdl_ins_user_id)){
    	isWriteUser = true;
    }else{
    	isWriteUser = false;
    	
    }
    
    
    
    String 삭제 = StringUtil.getLocaleWord("L.삭제",siteLocale);
    
    String 제목 = StringUtil.getLocaleWord("L.제목",siteLocale);
	String 등록자 = StringUtil.getLocaleWord("L.등록자",siteLocale);
	String 등록일 = StringUtil.getLocaleWord("L.등록일",siteLocale);
	String 기간 = StringUtil.getLocaleWord("L.기간",siteLocale);
	String 유형 = StringUtil.getLocaleWord("L.유형",siteLocale);
	String 알람 = StringUtil.getLocaleWord("L.알람",siteLocale);
	String 일전알람 = StringUtil.getLocaleWord("L.일전알람",siteLocale);
    String 장소 = StringUtil.getLocaleWord("L.장소",siteLocale);
	String 메모 = StringUtil.getLocaleWord("L.메모",siteLocale);
    
%>
<script type="text/javascript">
/**
 * 목록 페이지로 이동
 */	
function goList(frm) {		
	
	frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();	
}

/**
 * 수정등록 페이지로 이동
 */
function goModify(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
}

/**
 * 삭제 처리
 */
function doDelete(frm) {
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
	if(confirm(msg)){
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $(frm).serialize();
		airCommon.callAjax("<%=actionCode%>", "DELETE",data, function(json){
			
			var url = "/ServletController?AIR_ACTION=<%=actionCode%>&AIR_MODE=LIST";
			location.href = url;
			
		});
	}	
	
}
</script>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="scdl_uid" value="<%=scdl_uid%>" />
	
	<table class="basic">	
	<tr>
		<th class="th2"><%=제목 %></th>
		<td class="td2" colspan="3"><%=StringUtil.convertForView(scdl_tit)%></td>
	</tr>
	
	<tr>
		<th class="th4"><%=등록자 %></th>
		<td class="td4"><%=StringUtil.convertForView(scdl_ins_grp_name +" "+ scdl_ins_user_name)%></td>
		<th class="th4"><%=등록일 %></th>
		<td class="td4"><%=StringUtil.convertForView(scdl_ins_date)%></td>
	</tr>
	<tr>
		<th class="th2"><%=기간 %></th>
		<td class="td2" colspan="3">
			<%=StringUtil.convertForView(scdl_bgn_date +" "+ scdl_bgn_time)%>
			~
			<%=StringUtil.convertForView(scdl_end_date +" "+ scdl_end_time)%>
		</td>		
	</tr>
	<tr>
		<th class="th4"><%=유형 %></th>
		<td class="td4"><%=StringUtil.convertForView(scdl_type_name)%></td>
		<th class="th4"><%=알람 %></th>
		<td class="th4"><%=StringUtil.getCodestrValue(request,scdl_noti_yn, notiTermCdStr) + ("Y".equals(scdl_noti_yn) ? "&nbsp;(" + StringUtil.convertForView(scdl_noti_term) + 일전알람+")" : "")%></td>
	</tr>
	<tr>
		<th class="th2"><%=장소 %></th>
		<td class="td2" colspan="3"><%=StringUtil.convertForView(scdl_plce)%></td>
	</tr>
	<tr style="height:220px;">
		<th class="th2"><%=메모 %></th>
		<td class="td2" colspan="3" style="vertical-align:top;"><%=StringUtil.convertForView(scdl_memo)%></td>
	</tr>		
	</table>

	<div class="buttonlist">
<% if ( (isAdmin || isWriteUser) && !"R".equals(scdl_stat_code)) { //읽기전용 일정이 아닐 경우에만 수정/삭제 가능! %>
		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goModify(document.form1);"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
		<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="doDelete(document.form1);"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>		
<% } %>
<% if ( modeCode.indexOf("POPUP") > -1) { //읽기전용 일정이 아닐 경우에만 수정/삭제 가능! %>
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
<% }else{ %>
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0)" onclick="goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
<% } %>
	</div>  

</form>