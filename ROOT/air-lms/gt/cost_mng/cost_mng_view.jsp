<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);


	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String gbn	=	requestMap.getString("GBN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		costMng = resultMap.getResult("MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(costMng != null && costMng.getRowCount()> 0){
		masMap.putAll(costMng.getRowResult(0));
	}
	
	String gt_cost_mng_uid	= masMap.getString("GT_COST_MNG_UID");
	
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO,SIM_CHA_NM", "");
	String GUBUN_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GUBUN"), "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String JIGEUB_DAESANG_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("JIGEUB_DAESANG_CODESTR"), "SOSOG_COD,SOSOG_NAM", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale))+"^COM-000000_ZZ|"+StringUtil.getLocaleWord("L.기타",siteLocale);
	
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0)lmsMap.putAll(LMS_MAS.getRowResult(0));
	boolean isAuths = false;
	if(loginUser.getLoginId().equals(lmsMap.getString("DAMDANG_ID")) ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
	
	if("SS".equals(gbn) && loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	
	}else if(loginUser.isUserAuth("LMS_BCD")){
		isAuths = true;
		
	}
%>
<br />
	<table class="basic">
		<%if("SS".equals(gbn)){ %>
	    <tr>
			<th><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></th>
			<td colspan="3">
				<%=HtmlUtil.getSelect(request, false, "sim_cha_no", "sim_cha_no", SIM_CODESTR, masMap.getString("SIM_CHA_NO"), "class=\"select\"")%>
			</td>
		</tr> 
	  <%} %>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.지급구분", siteLocale) %></th>
			<td class="td4">
				<%= masMap.getString("JIGEUB_GUBUN").endsWith("_ZZ") ? "기타<br />("+masMap.getString("JIGEUB_GUBUN_NAME")+")" : masMap.getString("JIGEUB_GUBUN_NAME") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.지급대상", siteLocale) %></th>
			<td class="td4">
				<%= masMap.getString("JIGEUB_DAESANG_COD").endsWith("_ZZ") ? "기타<br />("+masMap.getString("JIGEUB_DAESANG_NAM")+")" : masMap.getString("JIGEUB_DAESANG_NAM") %>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.지급품의연월", siteLocale) %></th> 
			<td class="td4">
				<%=masMap.getString("JIGEUB_YYYY")%><%=StringUtil.getLocaleWord("L.년", siteLocale) %>
				&nbsp;<%=masMap.getString("JIGEUB_MM")%><%=StringUtil.getLocaleWord("L.월", siteLocale) %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.지급금액", siteLocale) %></th>
			<td class="td4" style="text-align:left;">
				<%if(StringUtil.isNotBlank(masMap.getString("JIGEUB_BIYONG"))){ %>
				(KRW)
				<%=StringUtil.getFormatCurrency(masMap.getString("JIGEUB_BIYONG"),-1)%>
				<%} %>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td colspan="3">
				<%=masMap.getStringView("WIN_WHERE")%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=gt_cost_mng_uid%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/BIYONG" name="typeCode" />
                </jsp:include>
			</td>
		</tr>
	</table>
<div class="buttonlist">
    <div class="left">
    </div>
   <div class="rigth">
   <%if(isAuths){ %>
    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goUpdate();"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
   <%} %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<%if(isAuths){ %>
<script>
var goUpdate = function(){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_cost_mng_uid'>").val("<%=gt_cost_mng_uid%>"));
	imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
}
</script>
<%}%>